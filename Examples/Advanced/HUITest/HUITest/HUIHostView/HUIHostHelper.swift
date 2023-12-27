//
//  HUIHostHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import MIDIKitInternals // only for utils
import MIDIKitIO
import SwiftUI

class HUIHostHelper: ObservableObject {
    // MARK: MIDI
    @EnvironmentObject var midiManager: ObservableMIDIManager
    
    static let kHUIInputConnectionTag = "HUIHostInputConnection"
    static let kHUIOutputConnectionTag = "HUIHostOutputConnection"
    
    @Published var logPing: Bool = true
    
    var huiHost: HUIHost
    @Published var isRemotePresent: Bool = false
    
    @Published var model: HUIHostModel = .init()
    
    init(midiManager: ObservableMIDIManager) {
        huiHost = HUIHost()
        
        setupSingleBank(midiManager: midiManager)
        
        // set up MIDI connections
        do {
            try midiManager.addInputConnection(
                to: .outputs(matching: [.name(HUIClientView.kHUIOutputName)]),
                tag: Self.kHUIInputConnectionTag,
                receiver: .object(huiHost.banks[0], held: .weakly)
            )
            
            try midiManager.addOutputConnection(
                to: .inputs(matching: [.name(HUIClientView.kHUIInputName)]),
                tag: Self.kHUIOutputConnectionTag
            )
        } catch {
            Logger.debug("Error setting up MIDI.")
        }
    }
    
    func setupSingleBank(midiManager: ObservableMIDIManager) {
        guard huiHost.banks.isEmpty else { return }
        
        huiHost.addBank(
            huiEventHandler: { [weak self] event in
                guard let self else { return }
                if !(event == .ping && !self.logPing) {
                    Logger.debug("Host received: \(event)")
                }
                
                // update host state model
                DispatchQueue.main.async {
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
                DispatchQueue.main.async {
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
struct HUIHostModel {
    public var bank0 = Bank()
}

extension HUIHostModel {
    struct Bank {
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
    struct ChannelStrip {
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
