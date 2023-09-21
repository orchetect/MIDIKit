//
//  MIDIEndpointSelectionView-iOS.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if os(iOS)

import MIDIKit
import SwiftUI

struct MIDIEndpointSelectionView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    
    @Binding var midiOutSelectedID: MIDIIdentifier
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        Picker("MIDI In", selection: $midiInSelectedID) {
            Text("None")
                .tag(MIDIIdentifier.invalidMIDIIdentifier)
    
            if midiInSelectedID != .invalidMIDIIdentifier,
               !midiManager.endpoints.outputs.contains(whereUniqueID: midiInSelectedID)
            {
                Text("⚠️ " + midiInSelectedDisplayName)
                    .tag(midiInSelectedID)
                    .foregroundColor(.secondary)
            }
    
            ForEach(midiManager.endpoints.outputs) {
                Text($0.displayName)
                    .tag($0.uniqueID)
            }
        }
    
        Picker("MIDI Out", selection: $midiOutSelectedID) {
            Text("None")
                .tag(MIDIIdentifier.invalidMIDIIdentifier)
    
            if midiOutSelectedID != .invalidMIDIIdentifier,
               !midiManager.endpoints.inputs.contains(whereUniqueID: midiOutSelectedID)
            {
                Text("⚠️ " + midiOutSelectedDisplayName)
                    .tag(midiOutSelectedID)
                    .foregroundColor(.secondary)
            }
    
            ForEach(midiManager.endpoints.inputs) {
                Text($0.displayName)
                    .tag($0.uniqueID)
            }
        }
    }
}

#endif
