//
//  ReceiveMIDIEventsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import MIDIKitUI
import SwiftRadix
import SwiftUI

extension ContentView {
    struct ReceiveMIDIEventsView: View {
        @Environment(ObservableMIDIManager.self) private var midiManager
        
        var inputName: String
        @Binding var midiInputConnectionID: MIDIIdentifier?
        @Binding var midiInputConnectionDisplayName: String?
        
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
                                    MIDIOutputsPicker(
                                        title: "",
                                        selectionID: $midiInputConnectionID,
                                        selectionDisplayName: $midiInputConnectionDisplayName,
                                        showIcons: true,
                                        hideOwned: false
                                    )
                                    .updatingInputConnection(withTag: ConnectionTags.inputConnectionTag)
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
