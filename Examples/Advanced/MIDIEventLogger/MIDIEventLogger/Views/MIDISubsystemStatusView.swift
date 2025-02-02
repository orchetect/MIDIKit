//
//  MIDISubsystemStatusView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftRadix
import SwiftUI

extension ContentView {
    struct MIDISubsystemStatusView: View {
        @Environment(ObservableMIDIManager.self) private var midiManager
        
        var body: some View {
            GroupBox(label: Text("MIDI Subsystem")) {
                Text("Using " + midiManager.preferredAPI.description)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(idealHeight: 50, maxHeight: 50, alignment: .center)
        }
    }
}
