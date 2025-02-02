//
//  HUIHostHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import MIDIKitInternals // only for utils
import MIDIKitIO
import SwiftUI

@Observable final class HUIHostHelper {
    // MARK: MIDI
    @ObservationIgnored
    weak var midiManager: ObservableMIDIManager?
    
    static let kHUIInputConnectionTag = "HUIHostInputConnection"
    static let kHUIOutputConnectionTag = "HUIHostOutputConnection"
    
    var logPing: Bool = false
    
    var huiHost: HUIHost
    
    var isRemotePresent: Bool = false
    
    var model = HUIHostModel()
    
    init(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
        
        huiHost = HUIHost()
        
        setupSingleBank(midiManager: midiManager)
    }
    
    deinit {
        stopConnections()
    }
    
    func startConnections() {
        guard let midiManager else { return }
        
        do {
            if midiManager.managedInputConnections.isEmpty {
                try midiManager.addInputConnection(
                    to: .outputs(matching: [.name(HUIClientView.kHUIOutputName)]),
                    tag: Self.kHUIInputConnectionTag,
                    receiver: .weak(huiHost.banks[0])
                )
            }
            if midiManager.managedOutputConnections.isEmpty {
                try midiManager.addOutputConnection(
                    to: .inputs(matching: [.name(HUIClientView.kHUIInputName)]),
                    tag: Self.kHUIOutputConnectionTag
                )
            }
        } catch {
            Logger.debug("Error setting up MIDI.")
        }
    }
    
    func stopConnections() {
        midiManager?.remove(.inputConnection, .withTag(Self.kHUIInputConnectionTag))
        midiManager?.remove(.outputConnection, .withTag(Self.kHUIOutputConnectionTag))
    }
    
    func setupSingleBank(midiManager: ObservableMIDIManager) {
        guard huiHost.banks.isEmpty else { return }
        
        huiHost.addBank(
            huiEventHandler: { [weak self] event in
                guard let self else { return }
                switch event {
                case .ping:
                    if logPing {
                        Logger.debug("Host received ping")
                    }
                default:
                    Logger.debug("Host received: \(event)")
                }
                
                // update host state model on main
                Task { @MainActor in
                    self.handle(inboundEvent: event)
                }
            },
            midiOutHandler: { [weak midiManager] events in
                guard let midiManager else { return }
                let conn = midiManager.managedOutputConnections[Self.kHUIOutputConnectionTag]
                
                try? conn?.send(events: events)
            },
            remotePresenceChangedHandler: { [weak self] isPresent in
                Logger.debug("Surface presence is now \(isPresent)")
                // update host state model on main
                Task { @MainActor in
                    self?.isRemotePresent = isPresent
                }
            }
        )
    }
    
    func handle(inboundEvent event: HUISurfaceEvent) {
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

/// Host model. Can contain one or more banks.
/// Each bank corresponds to an entire HUI device (remote control surface).
@Observable class HUIHostModel {
    public var bank0 = Bank()
}

extension HUIHostModel {
    @Observable class Bank {
        public var channel0: ChannelStrip = .init()
        public var channel1: ChannelStrip = .init()
        public var channel2: ChannelStrip = .init()
        public var channel3: ChannelStrip = .init()
        public var channel4: ChannelStrip = .init()
        public var channel5: ChannelStrip = .init()
        public var channel6: ChannelStrip = .init()
        public var channel7: ChannelStrip = .init()
    }
}

extension HUIHostModel.Bank {
    @Observable class ChannelStrip {
        public var pan: Float = 0.5
        public var vPotLowerLED: Bool = false
        public var solo: Bool = false
        public var mute: Bool = false
        public var name: String = ""
        public var selected: Bool = false
        public var faderTouched: Bool = false
        public var faderLevel: Float = 0.0
    }
}
