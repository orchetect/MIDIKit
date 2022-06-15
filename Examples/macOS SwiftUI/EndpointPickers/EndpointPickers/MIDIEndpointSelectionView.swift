//
//  MIDIEndpointSelectionView.swift
//  EndpointPickers
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

struct MIDIInSelectionView: View {
    
    @EnvironmentObject var midiManager: MIDI.IO.Manager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiInSelectedID: MIDI.IO.CoreMIDIUniqueID
    @Binding var midiInSelectedDisplayName: String
    
    var body: some View {
        
        Picker("MIDI In", selection: $midiInSelectedID) {
            Text("None")
                .tag(0 as MIDI.IO.CoreMIDIUniqueID)
            
            if midiInSelectedID != 0,
               !midiHelper.isOutputPresentInSystem(uniqueID: midiInSelectedID)
            {
                Text("⚠️ " + midiInSelectedDisplayName)
                    .tag(midiInSelectedID)
                    .foregroundColor(.secondary)
            }
            
            ForEach(midiManager.endpoints.outputs) {
                Text($0.displayName)
                    .tag($0.uniqueID.coreMIDIUniqueID)
            }
        }
        
    }
    
}

struct MIDIOutSelectionView: View {
    
    @EnvironmentObject var midiManager: MIDI.IO.Manager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @Binding var midiOutSelectedID: MIDI.IO.CoreMIDIUniqueID
    @Binding var midiOutSelectedDisplayName: String
    
    var body: some View {
        
        Picker("MIDI Out", selection: $midiOutSelectedID) {
            Text("None")
                .tag(0 as MIDI.IO.CoreMIDIUniqueID)
            
            if midiOutSelectedID != 0,
               !midiHelper.isInputPresentInSystem(uniqueID: midiOutSelectedID)
            {
                Text("⚠️ " + midiOutSelectedDisplayName)
                    .tag(midiOutSelectedID)
                    .foregroundColor(.secondary)
            }
            
            ForEach(midiManager.endpoints.inputs) {
                Text($0.displayName)
                    .tag($0.uniqueID.coreMIDIUniqueID)
            }
        }
        
    }
    
}
