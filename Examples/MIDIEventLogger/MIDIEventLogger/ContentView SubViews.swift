//
//  ContentView SubViews.swift
//  MIDIEventLogger
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import OTCore
import SwiftRadix
import MIDIKit

// MARK: - MIDISubsystemStatusView

extension ContentView {
    
    func MIDISubsystemStatusView() -> some View {
        
        GroupBox(label: Text("MIDI Subsystem Status")) {
            
            Text("Using " + midiManager.preferredAPI.description)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }
        .frame(idealHeight: 50, maxHeight: 50,
               alignment: .center)
        
    }
    
}

// MARK: - SendMIDIEventsView

extension ContentView {
    
    struct SendMIDIEventsView: View {
        
        @EnvironmentObject var midiManager: MIDI.IO.Manager
        
        @Binding var midiGroup: MIDI.UInt4
        var sendEvent: (MIDI.Event) -> Void
        
        @State var midiChannel: MIDI.UInt4 = 0
        
        var body: some View {
            
            GroupBox(label: Text("Send MIDI Events")) {
                
                VStack(alignment: .center, spacing: 8) {
                    
                    HStack {
                        Picker("UMP Group", selection: $midiGroup) {
                            ForEach(0..<15+1, id: \.self) {
                                let groupNum = $0 + 1
                                let groupNumHex = $0.hex.stringValue(padTo: 1, prefix: true)
                                
                                Text("\(groupNum) (\(groupNumHex))")
                                    .tag(MIDI.UInt4($0))
                            }
                        }
                        .frame(maxWidth: 200)
                        
                        if midiManager.preferredAPI == .legacyCoreMIDI {
                            Text("(Universal MIDI Packet not usable with old API)")
                        }
                    }
                    .disabled(midiManager.preferredAPI == .legacyCoreMIDI)
                    
                    HStack(alignment: .top) {
                        GroupBox(label: Text("Channel Voice")) {
                            Picker("Channel", selection: $midiChannel) {
                                ForEach(0..<15+1, id: \.self) {
                                    let channelNum = $0 + 1
                                    let channelNumHex = $0.hex.stringValue(padTo: 1, prefix: true)
                                    
                                    Text("\(channelNum) (\(channelNumHex))")
                                        .tag(MIDI.UInt4($0))
                                }
                            }
                            .frame(maxWidth: 200)
                            
                            Spacer()
                                .frame(height: 10)
                            
                            HStack {
                                SendMIDIEventsChannelVoiceView(midiGroup: $midiGroup,
                                                               midiChannel: $midiChannel) {
                                    sendEvent($0)
                                }
                                SendMIDIEventsMIDI2ChannelVoiceView(midiGroup: $midiGroup,
                                                                    midiChannel: $midiChannel) {
                                    sendEvent($0)
                                }
                            }
                        }
                        .frame(width: 280 + 280 + 40, height: 270)
                        
                        SendMIDIEventsSystemExclusiveView(midiGroup: $midiGroup) {
                            sendEvent($0)
                        }
                        SendMIDIEventsSystemCommonView(midiGroup: $midiGroup) {
                            sendEvent($0)
                        }
                        SendMIDIEventsSystemRealTimeView(midiGroup: $midiGroup) {
                            sendEvent($0)
                        }
                    }
                    .frame(width: 1270, height: 320)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(idealHeight: 400, maxHeight: 600)
            
        }
        
    }
    
    struct SendMIDIEventsChannelVoiceView: View {
        
        @Binding var midiGroup: MIDI.UInt4
        @Binding var midiChannel: MIDI.UInt4
        var sendEvent: (MIDI.Event) -> Void
        
        @State var chanVoiceCC: MIDI.Event.CC.Controller = .modWheel
        
        var body: some View {
            
            GroupBox(label: Text("MIDI 1.0 and MIDI 2.0")) {
                
                VStack(alignment: .center, spacing: 8) {
                    
                    Button {
                        sendEvent(.noteOn(60,
                                          velocity: .unitInterval(0.5),
                                          channel: midiChannel,
                                          group: midiGroup))
                    } label: { Text("Note On") }
                    
                    Button {
                        sendEvent(.noteOff(60,
                                           velocity: .unitInterval(0.0),
                                           channel: midiChannel,
                                           group: midiGroup))
                    } label: { Text("Note Off") }
                    
                    Button {
                        sendEvent(.notePressure(note: 60,
                                                amount: .midi1(64),
                                                channel: midiChannel,
                                                group: midiGroup))
                    } label: { Text("Note Pressure") }
                    
                    HStack(alignment: .center, spacing: 4) {
                        Button {
                            sendEvent(.cc(chanVoiceCC,
                                          value: .midi1(64),
                                          channel: midiChannel,
                                          group: midiGroup))
                        } label: { Text("CC") }
                        
                        Picker("", selection: $chanVoiceCC) {
                            ForEach(MIDI.Event.CC.Controller.allCases, id: \.self) {
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
                            sendEvent(.programChange(program: 10,
                                                     bank: .noBankSelect,
                                                     channel: midiChannel,
                                                     group: midiGroup))
                        } label: { Text("Program Change") }
                        
                        Button {
                            sendEvent(.programChange(program: 10,
                                                     bank: .bankSelect(123),
                                                     channel: midiChannel,
                                                     group: midiGroup))
                        } label: { Text("with Bank Select") }
                    }
                    
                    Button {
                        sendEvent(.pressure(amount: .midi1(64),
                                            channel: midiChannel,
                                            group: midiGroup))
                    } label: { Text("Channel Pressure") }
                    
                    Button {
                        sendEvent(.pitchBend(value: .midi1(.midpoint),
                                             channel: midiChannel,
                                             group: midiGroup))
                    } label: { Text("PitchBend") }
                    
                }
                .padding()
                .frame(width: 280, height: 200)
                
            }
            
        }
        
    }
    
    struct SendMIDIEventsMIDI2ChannelVoiceView: View {
        
        @Binding var midiGroup: MIDI.UInt4
        @Binding var midiChannel: MIDI.UInt4
        var sendEvent: (MIDI.Event) -> Void
        
        @State var chanVoiceCC: MIDI.Event.CC.Controller = .modWheel
        
        var body: some View {
            
            GroupBox(label: Text("MIDI 2.0 Only")) {
                
                VStack(alignment: .center, spacing: 8) {
                    
                    Button {
                        sendEvent(.noteOn(60,
                                          velocity: .unitInterval(0.5),
                                          attribute: .pitch7_9(coarse: 2, fine: 0b1_0000_0000),
                                          channel: midiChannel,
                                          group: midiGroup))
                    } label: { Text("Note On with Attribute") }
                    
                    Button {
                        sendEvent(.noteOff(60,
                                           velocity: .unitInterval(0.0),
                                           attribute: .pitch7_9(coarse: 2, fine: 0b1_0000_0000),
                                           channel: midiChannel,
                                           group: midiGroup))
                    } label: { Text("Note Off with Attribute") }
                    
                    Button {
                        sendEvent(.noteCC(note: 60,
                                          controller: .registered(.modWheel),
                                          value: 0x8000_0000, // UInt32 "midpoint" value
                                          channel: midiChannel,
                                          group: midiGroup))
                    } label: { Text("Note CC (Registered)") }
                    
                    Button {
                        sendEvent(.noteCC(note: 60,
                                          controller: .assignable(2),
                                          value: 0x8000_0000, // UInt32 "midpoint" value
                                          channel: midiChannel,
                                          group: midiGroup))
                    } label: { Text("Note CC (Assignable)") }
                    
                    Button {
                        sendEvent(.notePitchBend(note: 60,
                                                 value: .midi2(0x8000_0000),
                                                 channel: midiChannel,
                                                 group: midiGroup))
                    } label: { Text("Note PitchBend") }
                    
                    HStack {
                        Button {
                            sendEvent(.noteManagement(60,
                                                      flags: [],
                                                      channel: midiChannel,
                                                      group: midiGroup))
                        } label: { Text("Note Management") }
                        
                        Button {
                            sendEvent(.noteManagement(60,
                                                      flags: [.detachPerNoteControllers],
                                                      channel: midiChannel,
                                                      group: midiGroup))
                        } label: { Text("D") }
                        
                        Button {
                            sendEvent(.noteManagement(60,
                                                      flags: [.resetPerNoteControllers],
                                                      channel: midiChannel,
                                                      group: midiGroup))
                        } label: { Text("S") }
                        
                        Button {
                            sendEvent(.noteManagement(60,
                                                      flags: [.detachPerNoteControllers,
                                                              .resetPerNoteControllers],
                                                      channel: midiChannel,
                                                      group: midiGroup))
                        } label: { Text("DS") }
                    }
                    
                }
                .padding()
                .frame(width: 280, height: 200)
                
            }
            
        }
        
    }
    
    struct SendMIDIEventsSystemExclusiveView: View {
        
        @Binding var midiGroup: MIDI.UInt4
        var sendEvent: (MIDI.Event) -> Void
        
        var body: some View {
            
            GroupBox(label: Text("System Exclusive")) {
                
                VStack(alignment: .center, spacing: 8) {
                    
                    Button {
                        sendEvent(.sysEx7(manufacturer: .educational(),
                                          data: [],
                                          group: midiGroup))
                    } label: { Text("SysEx7 (0 Data, 1 Total)") }
                    
                    Button {
                        sendEvent(.sysEx7(manufacturer: .educational(),
                                          data: [0x01, 0x02],
                                          group: midiGroup))
                    } label: { Text("SysEx7 (2 Data, 3 Total)") }
                    
                    Button {
                        sendEvent(.sysEx7(manufacturer: .educational(),
                                          data: [0x01, 0x02, 0x03, 0x04, 0x05],
                                          group: midiGroup))
                    } label: { Text("SysEx7 (5 Data, 6 Total)") }
                    
                    Button {
                        sendEvent(.sysEx7(manufacturer: .educational(),
                                          data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                                 0x07],
                                          group: midiGroup))
                    } label: { Text("SysEx7 (7 Data, 8 Total)") }
                    
                    Button {
                        sendEvent(.sysEx7(manufacturer: .educational(),
                                          data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                                 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                                                 0x0D],
                                          group: midiGroup))
                    } label: { Text("SysEx7 (13 Data, 14 Total)") }
                    
                    Button {
                        sendEvent(.universalSysEx7(universalType: .realTime,
                                                   deviceID: 0x7F,
                                                   subID1: 0x7F,
                                                   subID2: 0x7F,
                                                   data: [],
                                                   group: midiGroup))
                    } label: { Text("Universal SysEx7 (0 Data, 4 Total)") }
                    
                    Button {
                        sendEvent(.universalSysEx7(universalType: .nonRealTime,
                                                   deviceID: 0x7F,
                                                   subID1: 0x7F,
                                                   subID2: 0x7F,
                                                   data: [0x01, 0x02],
                                                   group: midiGroup))
                    } label: { Text("Universal SysEx7 (2 Data, 6 Total)") }
                    
                    Button {
                        sendEvent(.universalSysEx7(universalType: .realTime,
                                                   deviceID: 0x7F,
                                                   subID1: 0x7F,
                                                   subID2: 0x7F,
                                                   data: [0x01, 0x02, 0x03, 0x04],
                                                   group: midiGroup))
                    } label: { Text("Universal SysEx7 (4 Data, 8 Total)") }
                    
                    Button {
                        sendEvent(.universalSysEx7(universalType: .nonRealTime,
                                                   deviceID: 0x7F,
                                                   subID1: 0x7F,
                                                   subID2: 0x7F,
                                                   data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                                          0x07, 0x08, 0x09, 0x0A],
                                                   group: midiGroup))
                    } label: { Text("Universal SysEx7 (10 Data, 14 Total)") }
                    
                }
                .padding()
                .frame(height: 270)
                
            }
            
        }
        
    }
    
    struct SendMIDIEventsSystemCommonView: View {
        
        @Binding var midiGroup: MIDI.UInt4
        var sendEvent: (MIDI.Event) -> Void
        
        var body: some View {
            
            GroupBox(label: Text("System Common")) {
                
                VStack(alignment: .center, spacing: 8) {
                    
                    Button {
                        sendEvent(.timecodeQuarterFrame(dataByte: 0x00,
                                                        group: midiGroup))
                    } label: { Text("Timecode Quarter-Frame") }
                    
                    Button {
                        sendEvent(.songPositionPointer(midiBeat: 8,
                                                       group: midiGroup))
                    } label: { Text("Song Position Pointer") }
                    
                    Button {
                        sendEvent(.songSelect(number: 4,
                                              group: midiGroup))
                    } label: { Text("Song Select") }
                    
                    Button {
                        sendEvent(.unofficialBusSelect(bus: 2,
                                                       group: midiGroup))
                    } label: { Text("Bus Select (Unofficial)") }
                    
                    Button {
                        sendEvent(.tuneRequest(group: midiGroup))
                    } label: { Text("Tune Request") }
                    
                }
                .padding()
                .frame(height: 270)
                
            }
            
        }
        
    }
    
    struct SendMIDIEventsSystemRealTimeView: View {
        
        @Binding var midiGroup: MIDI.UInt4
        var sendEvent: (MIDI.Event) -> Void
        
        var body: some View {
            
            GroupBox(label: Text("System Real Time")) {
                
                VStack(alignment: .center, spacing: 8) {
                    
                    Button {
                        sendEvent(.timingClock(group: midiGroup))
                    } label: { Text("Timing Clock") }
                    
                    Button {
                        sendEvent(.start(group: midiGroup))
                    } label: { Text("Start") }
                    
                    Button {
                        sendEvent(.continue(group: midiGroup))
                    } label: { Text("Continue") }
                    
                    Button {
                        sendEvent(.stop(group: midiGroup))
                    } label: { Text("Stop") }
                    
                    Button {
                        sendEvent(.activeSensing(group: midiGroup))
                    } label: { Text("Active Sensing") }
                    
                    Button {
                        sendEvent(.systemReset(group: midiGroup))
                    } label: { Text("System Reset") }
                    
                }
                .padding()
                .frame(height: 270)
                
            }
            
        }
        
    }
    
}

// MARK: - ReceiveMIDIEventsView

extension ContentView {
    
    func ReceiveMIDIEventsView() -> some View {
        
        ZStack(alignment: .center) {
            
            GroupBox(label: Text("Receive MIDI Events")) {
                
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack {
                        Group {
                            GroupBox(label: Text("Source: Virtual")) {
                                Text("🎹 " + kInputName)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            }
                            
                            GroupBox(label: Text("Source: Connection")) {
                                Picker("", selection: $midiInputConnectionEndpoint) {
                                    Text("None")
                                        .tag(MIDI.IO.OutputEndpoint?.none)
                                    
                                    VStack { Divider().padding(.leading) }
                                    
                                    ForEach(midiManager.endpoints.outputs) {
                                        Text("🎹 " + ($0.getDisplayName() ?? $0.name))
                                            .tag(MIDI.IO.OutputEndpoint?.some($0))
                                    }
                                }
                                .padding()
                                .frame(maxWidth: 400)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    .frame(height: 80)
                    
                    Text("MIDI Events received will be logged to the console in a debug build.")
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                }
                
            }
            .frame(idealHeight: 100, maxHeight: 150, alignment: .center)
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
}
