//
//  SendMIDIEventsMIDI2ChannelVoiceView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import OTCore
import SwiftRadix
import SwiftUI

extension ContentView {
    struct SendMIDIEventsMIDI2ChannelVoiceView: View {
        @Binding var midiGroup: UInt4
        @Binding var midiChannel: UInt4
        var sendEvent: (MIDIEvent) -> Void
        
        @State var chanVoiceCC: MIDIEvent.CC.Controller = .modWheel
        
        var body: some View {
            GroupBox(label: Text("MIDI 2.0")) {
                VStack(alignment: .center, spacing: 8) {
                    Button {
                        sendEvent(.noteOn(
                            60,
                            velocity: .unitInterval(0.5),
                            attribute: .pitch7_9(coarse: 2, fine: 0b1_00000000),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Note On with Attribute") }
                    
                    Button {
                        sendEvent(.noteOff(
                            60,
                            velocity: .unitInterval(0.0),
                            attribute: .pitch7_9(coarse: 2, fine: 0b1_00000000),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Note Off with Attribute") }
                    
                    Button {
                        sendEvent(.noteCC(
                            note: 60,
                            controller: .registered(.modWheel),
                            value: .midi2(0x8000_0000), // UInt32 "midpoint" value
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Per-Note CC (Registered)") }
                    
                    Button {
                        sendEvent(.noteCC(
                            note: 60,
                            controller: .assignable(2),
                            value: .midi2(0x8000_0000), // UInt32 "midpoint" value
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Per-Note CC (Assignable)") }
                    
                    Button {
                        sendEvent(.notePitchBend(
                            note: 60,
                            value: .midi2(0x8000_0000),
                            channel: midiChannel,
                            group: midiGroup
                        ))
                    } label: { Text("Per-Note PitchBend") }
                    
                    HStack {
                        Button {
                            sendEvent(.noteManagement(
                                note: 60,
                                flags: [],
                                channel: midiChannel,
                                group: midiGroup
                            ))
                        } label: { Text("Note Management") }
                        
                        Button {
                            sendEvent(.noteManagement(
                                note: 60,
                                flags: [.detachPerNoteControllers],
                                channel: midiChannel,
                                group: midiGroup
                            ))
                        } label: { Text("D") }
                        
                        Button {
                            sendEvent(.noteManagement(
                                note: 60,
                                flags: [.resetPerNoteControllers],
                                channel: midiChannel,
                                group: midiGroup
                            ))
                        } label: { Text("S") }
                        
                        Button {
                            sendEvent(.noteManagement(
                                note: 60,
                                flags: [
                                    .detachPerNoteControllers,
                                    .resetPerNoteControllers
                                ],
                                channel: midiChannel,
                                group: midiGroup
                            ))
                        } label: { Text("DS") }
                    }
                }
                .padding()
                .frame(width: 280, height: 200)
            }
        }
    }
}
