//
//  HUIHostHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO
import MIDIKitControlSurfaces
import Controls

class HUIHostHelper: ObservableObject {
    // MARK: MIDI
    weak var midiManager: MIDIManager?
    
    static let kHUIInputConnectionTag = "HUIHostInputConnection"
    static let kHUIOutputConnectionTag = "HUIHostOutputConnection"
    
    @Published var logPing: Bool = true
    
    var huiHost: HUIHost
    @Published var isRemotePresent: Bool = false
    
    @Published var model: HUIHostModel = .init()
    
    init(midiManager: MIDIManager?) {
        self.midiManager = midiManager
        
        huiHost = HUIHost()
        
        setupSingleBank()
        
        // set up MIDI connections
        do {
            try midiManager?.addInputConnection(
                toOutputs: [.name(HUIClientView.kHUIOutputName)],
                tag: Self.kHUIInputConnectionTag,
                receiver: .object(
                    huiHost.banks[0],
                    held: .weakly,
                    translateMIDI1NoteOnZeroVelocityToNoteOff: false
                )
            )
            
            try midiManager?.addOutputConnection(
                toInputs: [.name(HUIClientView.kHUIInputName)],
                tag: Self.kHUIOutputConnectionTag
            )
        } catch {
            Logger.debug("Error setting up MIDI.")
        }
    }
    
    func setupSingleBank() {
        guard huiHost.banks.isEmpty else { return }
        
        huiHost.addBank(
            huiEventHandler: { [weak self] event in
                guard let self = self else { return }
                if !(event == .ping && !self.logPing) {
                    Logger.debug("Host received: \(event)")
                }
                
                // update host state model
                DispatchQueue.main.async {
                    self.handle(inboundEvent: event)
                }
            },
            midiOutHandler: { [weak midiManager] events in
                guard let midiManager = midiManager else { return }
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
            self.model.bank0.channel0.faderLevel = scaledValue
            
        case let .switch(huiSwitch, state):
            switch huiSwitch {
            case let .channelStrip(0, channelItem):
                switch channelItem {
                case .solo:
                    if state { self.model.bank0.channel0.solo.toggle() }
                case .mute:
                    if state { self.model.bank0.channel0.mute.toggle() }
                case .select:
                    if state { self.model.bank0.channel0.selected.toggle() }
                case .faderTouched:
                    self.model.bank0.channel0.faderTouched = state
                default:
                    break
                }
            default:
                break
            }
            
        case let .vPot(vPot: vPot, delta: delta):
            switch vPot {
            case .channel(0):
                self.model.bank0.channel0.pan = (
                    self.model.bank0.channel0.pan + Float(delta.intValue) / 100
                ).clamped(to: 0.0 ... 1.0)
            default:
                break
            }
            
        default:
            break
        }
    }
}

/// Host model. Can contain one or more banks. Each bank corresponds to an entire HUI device (remote control surface).
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
