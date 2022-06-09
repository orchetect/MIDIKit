//
//  MIDIEndpointSelectionView.swift
//  EndpointPickers
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

struct MIDIEndpointSelectionView: View {
    
    @EnvironmentObject var midiManager: MIDI.IO.Manager
    
    @Binding var midiInSelectedID: MIDI.IO.CoreMIDIUniqueID
    @Binding var midiInSelectedDisplayName: String
    
    @Binding var midiOutSelectedID: MIDI.IO.CoreMIDIUniqueID
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        
        Picker("MIDI In", selection: $midiInSelectedID) {
            Text("None")
                .tag(0 as MIDI.IO.CoreMIDIUniqueID)
            
            Divider()
            
            if midiInSelectedID != 0,
               !midiManager.endpoints.outputs.contains(where: { $0.uniqueID.coreMIDIUniqueID == midiInSelectedID }) {
                Text("⚠️ " + midiInSelectedDisplayName)
                    .tag(midiInSelectedID)
            }
            
            ForEach(midiManager.endpoints.outputs) {
                Text($0.displayName)
                    .tag($0.uniqueID.coreMIDIUniqueID)
            }
        }
        
        Picker("MIDI Out", selection: $midiOutSelectedID) {
            Text("None")
                .tag(0 as MIDI.IO.CoreMIDIUniqueID)
            
            Divider()
            
            if midiOutSelectedID != 0,
               !midiManager.endpoints.inputs.contains(where: { $0.uniqueID.coreMIDIUniqueID == midiOutSelectedID }) {
                Text("⚠️ " + midiOutSelectedDisplayName)
                    .tag(midiOutSelectedID)
            }
            
            ForEach(midiManager.endpoints.inputs) {
                Text($0.displayName)
                    .tag($0.uniqueID.coreMIDIUniqueID)
            }
        }
        
    }
    
}
