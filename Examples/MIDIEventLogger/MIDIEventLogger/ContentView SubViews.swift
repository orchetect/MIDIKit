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
            
            Text("Using \(midiManager.preferredAPI)"
            )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }
        .frame(idealHeight: 50, maxHeight: 50,
               alignment: .center)
        
    }
    
}

// MARK: - SendMIDIEventsView

extension ContentView {
    
    func SendMIDIEventsView() -> some View {
        
        GroupBox(label: Text("Send MIDI Events")) {
            
            VStack(alignment: .center, spacing: 8) {
                
                Picker("UMP Group", selection: $midiGroup) {
                    ForEach(0..<15+1, id: \.self) {
                        let groupNum = $0 + 1
                        let groupNumHex = $0.hex.stringValue(padTo: 1, prefix: true)
                        
                        Text("\(groupNum) (\(groupNumHex))")
                            .tag(MIDI.UInt4($0))
                    }
                }
                .frame(maxWidth: 200)
                .disabled(midiManager.preferredAPI == .legacyCoreMIDI)
                
                Spacer()
                    .frame(height: 10)
                
                HStack(alignment: .top) {
                    SendMIDIEventsChannelVoiceView()
                    SendMIDIEventsSystemExclusiveView()
                    SendMIDIEventsSystemCommonView()
                    SendMIDIEventsSystemRealTimeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }
        .frame(idealHeight: 400, maxHeight: 600,
               alignment: .center)
        
    }
    
    func SendMIDIEventsChannelVoiceView() -> some View {
        
        GroupBox(label: Text("Channel Voice")) {
            
            VStack(alignment: .center, spacing: 8) {
                
                Picker("Channel", selection: $midiChannel) {
                    ForEach(0..<15+1, id: \.self) {
                        let channelNum = $0 + 1
                        let channelNumHex = $0.hex.stringValue(padTo: 1, prefix: true)
                        
                        Text("\(channelNum) (\(channelNumHex))")
                            .tag(MIDI.UInt4($0))
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                Button {
                    sendEvent(.noteOn(note: 60,
                                      velocity: 64,
                                      channel: midiChannel,
                                      group: midiGroup))
                } label: { Text("Note On") }
                
                Button {
                    sendEvent(.noteOff(note: 60,
                                       velocity: 0,
                                       channel: midiChannel,
                                       group: midiGroup))
                } label: { Text("Note Off") }
                
                Button {
                    sendEvent(.polyAftertouch(note: 60,
                                              pressure: 64,
                                              channel: midiChannel,
                                              group: midiGroup))
                } label: { Text("Poly Aftertouch") }
                
                HStack(alignment: .center, spacing: 4) {
                    Button {
                        sendEvent(.cc(controller: chanVoiceCC,
                                      value: 64,
                                      channel: midiChannel,
                                      group: midiGroup))
                    } label: { Text("CC") }
                    
                    Picker("", selection: $chanVoiceCC) {
                        ForEach(MIDI.Event.CC.allCases, id: \.self) {
                            let ccInt = $0.controller.intValue
                            let ccName = "\($0.name)"
                            let ccHex = ccInt.hex.stringValue(padTo: 2, prefix: true)
                            
                            Text("\(ccInt) - \(ccName) (\(ccHex))")
                                .tag($0)
                        }
                    }
                    .frame(minWidth: 200, maxWidth: 350)
                }
                
                Button {
                    sendEvent(.programChange(program: 10,
                                             channel: midiChannel,
                                             group: midiGroup))
                } label: { Text("Program Change") }
                
                Button {
                    sendEvent(.chanAftertouch(pressure: 64,
                                              channel: midiChannel,
                                              group: midiGroup))
                } label: { Text("Channel Aftertouch") }
                
                Button {
                    sendEvent(.pitchBend(value: .midpoint,
                                         channel: midiChannel,
                                         group: midiGroup))
                } label: { Text("PitchBend") }
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
    }
    
    func SendMIDIEventsSystemExclusiveView() -> some View {
        
        GroupBox(label: Text("System Exclusive")) {
            
            VStack(alignment: .center, spacing: 8) {
                
                Button {
                    sendEvent(.sysEx(manufacturer: .educational(),
                                     data: [],
                                     group: midiGroup))
                } label: { Text("SysEx with 0 Bytes") }
                
                Button {
                    sendEvent(.sysEx(manufacturer: .educational(),
                                     data: [0x01, 0x02],
                                     group: midiGroup))
                } label: { Text("SysEx with 2 Bytes") }
                
                Button {
                    sendEvent(.sysEx(manufacturer: .educational(),
                                     data: [0x01, 0x02, 0x03, 0x04],
                                     group: midiGroup))
                } label: { Text("SysEx with 4 Bytes") }
                
                Button {
                    sendEvent(.sysEx(manufacturer: .educational(),
                                     data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08],
                                     group: midiGroup))
                } label: { Text("SysEx with 8 Bytes") }
                
                Button {
                    sendEvent(.sysExUniversal(universalType: .realTime,
                                              deviceID: 0x7F,
                                              subID1: 0x7F,
                                              subID2: 0x7F,
                                              data: [],
                                              group: midiGroup))
                } label: { Text("Universal SysEx with 0 Bytes") }
                
                Button {
                    sendEvent(.sysExUniversal(universalType: .realTime,
                                              deviceID: 0x7F,
                                              subID1: 0x7F,
                                              subID2: 0x7F,
                                              data: [0x01, 0x02],
                                              group: midiGroup))
                } label: { Text("Universal SysEx with 2 Bytes") }
                
                Button {
                    sendEvent(.sysExUniversal(universalType: .realTime,
                                              deviceID: 0x7F,
                                              subID1: 0x7F,
                                              subID2: 0x7F,
                                              data: [0x01, 0x02, 0x03, 0x04],
                                              group: midiGroup))
                } label: { Text("Universal SysEx with 4 Bytes") }
                
                Button {
                    sendEvent(.sysExUniversal(universalType: .realTime,
                                              deviceID: 0x7F,
                                              subID1: 0x7F,
                                              subID2: 0x7F,
                                              data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08],
                                              group: midiGroup))
                } label: { Text("Universal SysEx with 8 Bytes") }
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
    }
    
    func SendMIDIEventsSystemCommonView() -> some View {
        
        GroupBox(label: Text("System Common")) {
            
            VStack(alignment: .center, spacing: 8) {
                
                Button {
                    sendEvent(.timecodeQuarterFrame(byte: 0x00,
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
                    sendEvent(.unofficialBusSelect(group: midiGroup))
                } label: { Text("Bus Select (Unofficial)") }
                
                Button {
                    sendEvent(.tuneRequest(group: midiGroup))
                } label: { Text("Tune Request") }
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
    }
    
    func SendMIDIEventsSystemRealTimeView() -> some View {
        
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
            .frame(maxWidth: .infinity, alignment: .center)
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
                                Picker("", selection: $midiInputConnection) {
                                    Text("None")
                                        .tag(MIDI.IO.OutputEndpoint?.none)
                                    
                                    VStack { Divider().padding(.leading) }
                                    
                                    ForEach(midiManager.endpoints.outputs) {
                                        Text("🎹 " + ($0.getDisplayName ?? $0.name))
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
            
            Text({
                // this is a stupid SwiftUI workaround because we
                // can't use .onChange{} in Catalina and didSet{}
                // is not reliable on a @State var, so this works
                // fine for our purposes
                let _ = midiInputConnection
                
                updateInputConnection()
                
                return ""
            }())
                .opacity(0.0)
                .frame(width: 0, height: 0)
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
}
