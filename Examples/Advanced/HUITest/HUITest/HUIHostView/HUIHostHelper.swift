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
    weak var midiManager: MIDIManager?
    
    static let kHUIInputConnectionTag = "HUIHostInputConnection"
    static let kHUIOutputConnectionTag = "HUIHostOutputConnection"
    
    @Published var logPing: Bool = true
    
    var huiHost: HUIHost
    @Published var isRemotePresent: Bool = false
    
    @Published var bank0VPotValue: Float = 0.5
    @Published var bank0VPotLowerLED: Bool = false
    @Published var bank0Ch0Solo: Bool = false
    @Published var bank0Ch0Mute: Bool = false
    @Published var bank0Ch0Name: String = ""
    @Published var bank0Ch0Select: Bool = false
    @Published var bank0Ch0FaderTouched: Bool = false
    @Published var bank0FaderLevel: Float = 0.0
    
    init(midiManager: MIDIManager?) {
        self.midiManager = midiManager
        
        huiHost = HUIHost()
        
        addBank()
        
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
    
    func addBank() {
        guard huiHost.banks.isEmpty else { return }
        
        huiHost.addBank(
            huiEventHandler: { [weak self] event in
                guard let self = self else { return }
                if !(event == .ping && !self.logPing) {
                    Logger.debug("Host received: \(event)")
                }
                
                DispatchQueue.main.async {
                    switch event {
                    case let .faderLevel(channelStrip: 0, level):
                        let scaledValue = Float(level) / Float(UInt14.max)
                        self.bank0FaderLevel = scaledValue
                        
                    case let .switch(huiSwitch, state):
                        switch huiSwitch {
                        case let .channelStrip(0, channelItem):
                            switch channelItem {
                            case .solo:
                                if state {
                                    self.bank0Ch0Solo.toggle()
                                }
                            case .mute:
                                if state {
                                    self.bank0Ch0Mute.toggle()
                                }
                            case .select:
                                if state {
                                    self.bank0Ch0Select.toggle()
                                }
                            case .faderTouched:
                                self.bank0Ch0FaderTouched = state
                            default:
                                break
                            }
                        default:
                            break
                        }
                        
                    case let .vPot(vPot: vPot, delta: delta):
                        switch vPot {
                        case .channel(0):
                            self.bank0VPotValue = (self.bank0VPotValue + Float(delta.intValue) / 100)
                                .clamped(to: 0.0 ... 1.0)
                        default:
                            break
                        }
                        
                    default:
                        break
                    }
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
}
