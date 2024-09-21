//
//  MIDIEndpointSelectionView-iOS.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if os(iOS)

import MIDIKit
import SwiftUI

struct MIDIEndpointSelectionView: View {
    @EnvironmentObject var midiManager: ObservableMIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    
    @Binding var midiOutSelectedID: MIDIIdentifier
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        Picker("MIDI In", selection: $midiInSelectedID) {
            Text("None")
                .tag(MIDIIdentifier.invalidMIDIIdentifier)
    
            if isSelectedInputMissing {
                Text("⚠️ " + midiInSelectedDisplayName)
                    .tag(midiInSelectedID)
                    .foregroundColor(.secondary)
            }
    
            ForEach(midiManager.observableEndpoints.outputs) {
                Text($0.displayName)
                    .tag($0.uniqueID)
            }
        }
    
        Picker("MIDI Out", selection: $midiOutSelectedID) {
            Text("None")
                .tag(MIDIIdentifier.invalidMIDIIdentifier)
    
            if isSelectedOutputMissing {
                Text("⚠️ " + midiOutSelectedDisplayName)
                    .tag(midiOutSelectedID)
                    .foregroundColor(.secondary)
            }
    
            ForEach(midiManager.observableEndpoints.inputs) {
                Text($0.displayName)
                    .tag($0.uniqueID)
            }
        }
    }
    
    private var isSelectedInputMissing: Bool {
        midiInSelectedID != .invalidMIDIIdentifier &&
            !midiManager.observableEndpoints.outputs.contains(
                whereUniqueID: midiInSelectedID,
                fallbackDisplayName: midiInSelectedDisplayName
            )
    }
    
    private var isSelectedOutputMissing: Bool {
        midiOutSelectedID != .invalidMIDIIdentifier &&
            !midiManager.observableEndpoints.inputs.contains(
                whereUniqueID: midiOutSelectedID,
                fallbackDisplayName: midiOutSelectedDisplayName
            )
    }
}

#endif
