//
//  HUIHostHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitControlSurfaces
import MIDIKitInternals // only for utils
import MIDIKitIO

@Observable final class HUIHostHelper: Sendable {
    @ObservationIgnored nonisolated(unsafe) weak var midiManager: ObservableMIDIManager? = nil
    @HUIHostActor var huiHost: HUIHost = HUIHost()
    
    // MARK: Observable Properties
    @MainActor var model = HUIHostModel()
    @MainActor var logEvents: Bool = false
    @MainActor var logPing: Bool = false
    @MainActor private(set) var isRemotePresent: Bool = false
    
    init() { }
    
    deinit {
        stopConnections()
    }
}

// MARK: - Static

extension HUIHostHelper {
    nonisolated static let kHUIInputConnectionTag = "HUIHostInputConnection"
    nonisolated static let kHUIOutputConnectionTag = "HUIHostOutputConnection"
}

// MARK: - Lifecycle

extension HUIHostHelper {
    @HUIHostActor func setup(midiManager: ObservableMIDIManager?) {
        guard let midiManager else { return }
        
        self.midiManager = midiManager
        huiHost = HUIHost()
        setupSingleBank(midiManager: midiManager)
    }
    
    @HUIHostActor private func setupSingleBank(midiManager: ObservableMIDIManager) {
        guard huiHost.banks.isEmpty else { return }
        
        huiHost.addBank(
            huiEventHandler: { [weak self] event in
                guard let self else { return }
                
                Task { @MainActor in
                    self.handle(inboundEvent: event)
                }
                
                Task { @MainActor in
                    switch event {
                    case .ping:
                        if self.logPing {
                            logger.debug("Host received ping")
                        }
                    default:
                        if self.logEvents {
                            logger.debug("Host received: \(event)")
                        }
                    }
                }
            },
            midiOutHandler: { [weak midiManager] events in
                guard let midiManager else { return }
                let conn = midiManager.managedOutputConnections[Self.kHUIOutputConnectionTag]
                
                try? conn?.send(events: events)
            },
            remotePresenceChangedHandler: { [weak self] isPresent in
                // update host state model on main
                Task { @MainActor in
                    self?.isRemotePresent = isPresent
                    logger.debug("Surface presence is now \(isPresent)")
                }
            }
        )
    }
    
    /// Changes to observable properties in this class must be pushed from main actor/thread if UI updates may happen as a result.
    @MainActor private func handle(inboundEvent event: HUISurfaceEvent) {
        switch event {
        case let .faderLevel(channelStrip: 0, level):
            let scaledValue = Float(level) / Float(UInt14.max)
            model.bank0.channel0.faderLevel = scaledValue
            
        case let .switch(huiSwitch, state):
            switch huiSwitch {
            case let .channelStrip(0, channelItem):
                switch channelItem {
                case .solo:
                    if state { model.bank0.channel0.solo.toggle() }
                case .mute:
                    if state { model.bank0.channel0.mute.toggle() }
                case .select:
                    if state { model.bank0.channel0.selected.toggle() }
                case .faderTouched:
                    model.bank0.channel0.faderTouched = state
                default:
                    break
                }
            default:
                break
            }
            
        case let .vPot(vPot: vPot, delta: delta):
            switch vPot {
            case .channel(0):
                model.bank0.channel0.pan = (
                    model.bank0.channel0.pan + Float(delta.intValue) / 100
                ).clamped(to: 0.0 ... 1.0)
            default:
                break
            }
            
        default:
            break
        }
    }
}

// MARK: - MIDI I/O

extension HUIHostHelper {
    func startConnections() async {
        guard let midiManager else { return }
        
        let bank0 = await huiHost.banks[0]
        
        do {
            if midiManager.managedInputConnections.isEmpty {
                try midiManager.addInputConnection(
                    to: .outputs(matching: [.name(HUIClientHelper.kHUIOutputName)]),
                    tag: Self.kHUIInputConnectionTag,
                    receiver: .weak(bank0)
                )
            }
            if midiManager.managedOutputConnections.isEmpty {
                try midiManager.addOutputConnection(
                    to: .inputs(matching: [.name(HUIClientHelper.kHUIInputName)]),
                    tag: Self.kHUIOutputConnectionTag
                )
            }
        } catch {
            logger.debug("Error setting up MIDI.")
        }
    }
    
    nonisolated func stopConnections() {
        guard let midiManager else { return }
        midiManager.remove(.inputConnection, .withTag(Self.kHUIInputConnectionTag))
        midiManager.remove(.outputConnection, .withTag(Self.kHUIOutputConnectionTag))
    }
}
