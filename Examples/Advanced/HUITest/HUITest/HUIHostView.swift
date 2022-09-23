//
//  HUIHostView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import MIDIKitControlSurfaces
import SwiftUI

class HUIHostHelper: ObservableObject {
    weak var midiManager: MIDIManager?
    
    static let kHUIInputConnectionTag = "HUIHostInputConnection"
    static let kHUIOutputConnectionTag = "HUIHostOutputConnection"
    
    var huiHost: HUIHost
    @Published var isRemotePresent: Bool = false
    
    @Published var bank0Ch0Solo: Bool = false
    @Published var bank0Ch0Mute: Bool = false
    
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
                Logger.debug("Host received: \(event)")
                
                DispatchQueue.main.async {
                    switch event {
                    case let .switch(huiSwitch, state):
                        switch huiSwitch {
                        case .channelStrip(0, .solo):
                            if state {
                                self?.bank0Ch0Solo.toggle()
                            }
                        case .channelStrip(0, .mute):
                            if state {
                                self?.bank0Ch0Mute.toggle()
                            }
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

struct HUIHostView: View {
    weak var midiManager: MIDIManager?
    
    @ObservedObject var huiHostHelper: HUIHostHelper
    
    /// Convenience accessor for first HUI bank.
    private var huiBank0: HUIHostBank? { huiHostHelper.huiHost.banks.first }
    
    init(midiManager: MIDIManager?) {
        self.midiManager = midiManager
        
        // set up HUI Host object
        huiHostHelper = HUIHostHelper(midiManager: midiManager)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This window acts as a HUI host (ie: a DAW) and connects to the HUI surface.")
            Text(
                "To test the HUI surface with an actual DAW instead (such as Pro Tools, Logic, Cubase, etc.), close this window and the HUI Surface window can be used as a standalone HUI device with the DAW."
            )
            
            Text((huiHostHelper.isRemotePresent ? "🟢" : "🔴") + " Surface")
            
            GroupBox(label: Text("Channel Strip 1")) {
                VStack {
                    Button("Set Channel Name") {
                        huiBank0?.transmitSmallDisplay(
                            .channel(0),
                            text: .init(lossy: "TEXT")
                        )
                    }
                    Toggle("Solo", isOn: $huiHostHelper.bank0Ch0Solo)
                        .onChange(of: huiHostHelper.bank0Ch0Solo) { newValue in
                            huiBank0?.transmitSwitch(.channelStrip(0, .solo), state: newValue)
                        }
                    Toggle("Mute", isOn: $huiHostHelper.bank0Ch0Mute)
                        .onChange(of: huiHostHelper.bank0Ch0Mute) { newValue in
                            huiBank0?.transmitSwitch(.channelStrip(0, .mute), state: newValue)
                        }
                    Button("Fader to midpoint") {
                        huiBank0?.transmitFader(level: .midpoint, channel: 0)
                    }
                }
                .frame(width: 180, height: 100)
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
