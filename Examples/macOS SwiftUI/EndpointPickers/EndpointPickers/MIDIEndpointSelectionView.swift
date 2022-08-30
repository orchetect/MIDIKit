//
//  MIDIEndpointSelectionView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct MIDIInSelectionView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDIIdentifier
    @Binding var midiInSelectedDisplayName: String
    
    var body: some View {
        Picker("MIDI In", selection: $midiInSelectedID) {
            Text("None")
                .tag(0 as MIDIIdentifier)
    
            if midiInSelectedID != .invalidMIDIIdentifier,
               !midiHelper.isOutputPresentInSystem(uniqueID: midiInSelectedID)
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
    }
}

struct MIDIOutSelectionView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiOutSelectedID: MIDIIdentifier
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        Picker("MIDI Out", selection: $midiOutSelectedID) {
            Text("None")
                .tag(0 as MIDIIdentifier)
    
            if midiOutSelectedID != .invalidMIDIIdentifier,
               !midiHelper.isInputPresentInSystem(uniqueID: midiOutSelectedID)
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
