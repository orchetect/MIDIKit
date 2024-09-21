//
//  SendMIDIEventsChannelVoiceView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import OTCore
import SwiftRadix
import SwiftUI

extension ContentView {
    struct SendMIDIEventsChannelVoiceView: View {
        @Binding var midiGroup: UInt4
        @Binding var midiChannel: UInt4
        var sendEvent: (MIDIEvent) -> Void
        
        @State var chanVoiceCC: MIDIEvent.CC.Controller = .modWheel
        
        var body: some View {
            GroupBox(label: Text("MIDI 1.0 and MIDI 2.0")) {
                VStack(alignment: .center, spacing: 8) {
                    Button {
                        sendEvent(.noteOn(
                            60,
                            velocity: .unitInterval(0.5),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Note On") }
                    
                    Button {
                        sendEvent(.noteOff(
                            60,
                            velocity: .unitInterval(0.0),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Note Off") }
                    
                    Button {
                        sendEvent(.notePressure(
                            note: 60,
                            amount: .midi1(64),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Note Pressure") }
                    
                    HStack(alignment: .center, spacing: 4) {
                        Button {
                            sendEvent(.cc(
                                chanVoiceCC,
                                value: .midi1(64),
                                channel: midiChannel,
                                group: midiGroup
                            ))
                        } label: { Text("CC") }
                        
                        Picker("", selection: $chanVoiceCC) {
                            ForEach(MIDIEvent.CC.Controller.allCases, id: \.self) {
                                let ccInt = $0.number.intValue
                                let ccName = "\($0.name)"
                                let ccHex = ccInt.hex.stringValue(padTo: 2, prefix: true)
                                
                                Text("\(ccInt) - \(ccName) (\(ccHex))")
                                    .tag($0)
                            }
                        }
                        .frame(width: 200)
                    }
                    
                    HStack {
                        Button {
                            sendEvent(.programChange(
                                program: 10,
                                bank: .noBankSelect,
                                channel: midiChannel,
                                group: midiGroup
                            ))
                        } label: { Text("Program Change") }
                        
                        Button {
                            sendEvent(.programChange(
                                program: 10,
                                bank: .bankSelect(123),
                                channel: midiChannel,
                                group: midiGroup
                            ))
                        } label: { Text("with Bank Select") }
                    }
                    
                    Button {
                        sendEvent(.pressure(
                            amount: .midi1(64),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Channel Pressure") }
                    
                    Button {
                        sendEvent(.pitchBend(
                            value: .midi1(.midpoint),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("PitchBend") }
                }
                .padding()
                .frame(width: 280, height: 200)
            }
        }
    }
}
