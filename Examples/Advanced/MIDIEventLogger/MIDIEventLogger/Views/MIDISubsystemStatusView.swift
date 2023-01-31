//
//  MIDISubsystemStatusView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTCore
import SwiftRadix
import MIDIKit

extension ContentView {
    struct MIDISubsystemStatusView: View {
        @EnvironmentObject var midiManager: MIDIManager
        
        var body: some View {
            GroupBox(label: Text("MIDI Subsystem")) {
                Text("Using " + midiManager.preferredAPI.description)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(idealHeight: 50, maxHeight: 50, alignment: .center)
        }
    }
}
