//
//  SendMIDIEventsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import OTCore
import SwiftRadix
import SwiftUI

extension ContentView {
    struct SendMIDIEventsView: View {
        @EnvironmentObject var midiManager: ObservableMIDIManager
        
        @Binding var midiGroup: UInt4
        var sendEvent: (MIDIEvent) -> Void
        
        @State var midiChannel: UInt4 = 0
        
        var body: some View {
            GroupBox(label: Text("Send MIDI Events")) {
                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        Picker("UMP Group", selection: $midiGroup) {
                            ForEach(0 ..< 15 + 1, id: \.self) {
                                let groupNum = $0 + 1
                                let groupNumHex = $0.hex.stringValue(padTo: 1, prefix: true)
                                
                                Text("\(groupNum) (\(groupNumHex))")
                                    .tag(UInt4($0))
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
                            VStack {
                                Picker("Channel", selection: $midiChannel) {
                                    ForEach(0 ..< 15 + 1, id: \.self) {
                                        let channelNum = $0 + 1
                                        let channelNumHex = $0.hex.stringValue(
                                            padTo: 1,
                                            prefix: true
                                        )
                                        
                                        Text("\(channelNum) (\(channelNumHex))")
                                            .tag(UInt4($0))
                                    }
                                }
                                .frame(maxWidth: 200)
                                
                                Spacer()
                                    .frame(height: 10)
                                
                                HStack {
                                    SendMIDIEventsChannelVoiceView(
                                        midiGroup: $midiGroup,
                                        midiChannel: $midiChannel
                                    ) {
                                        sendEvent($0)
                                    }
                                    SendMIDIEventsMIDI2ChannelVoiceView(
                                        midiGroup: $midiGroup,
                                        midiChannel: $midiChannel
                                    ) {
                                        sendEvent($0)
                                    }
                                }
                            }
                            .frame(width: 280 + 280 + 40, height: 270)
                        }
                        
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
}
