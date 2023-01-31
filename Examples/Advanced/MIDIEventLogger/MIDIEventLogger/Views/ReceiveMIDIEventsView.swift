//
//  ReceiveMIDIEventsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTCore
import SwiftRadix
import MIDIKit

extension ContentView {
    struct ReceiveMIDIEventsView: View {
        @EnvironmentObject var midiManager: MIDIManager
        
        var inputName: String
        @Binding var midiInputConnectionEndpoint: MIDIOutputEndpoint?
        
        var body: some View {
            ZStack(alignment: .center) {
                GroupBox(label: Text("Receive MIDI Events")) {
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Group {
                                GroupBox(label: Text("Source: Virtual")) {
                                    Text("🎹 " + inputName)
                                        .frame(
                                            maxWidth: .infinity,
                                            maxHeight: .infinity,
                                            alignment: .center
                                        )
                                }
                                
                                GroupBox(label: Text("Source: Connection")) {
                                    Picker("", selection: $midiInputConnectionEndpoint) {
                                        Text("None")
                                            .tag(MIDIOutputEndpoint?.none)
                                        
                                        VStack { Divider().padding(.leading) }
                                        
                                        ForEach(midiManager.endpoints.outputs) {
                                            Text("🎹 " + ($0.displayName))
                                                .tag(MIDIOutputEndpoint?.some($0))
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: 400)
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity,
                                        alignment: .center
                                    )
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
}
