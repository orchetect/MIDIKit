//
//  EndpointPickersApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import SwiftUI
import Combine

@main
struct EndpointPickersApp: App {
    @ObservedObject var midiManager = ObservableMIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    @ObservedObject var midiHelper = MIDIHelper()
    
    @AppStorage(MIDIHelper.PrefKeys.midiInID)
    var midiInSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
    
    @AppStorage(MIDIHelper.PrefKeys.midiInDisplayName)
    var midiInSelectedDisplayName: String = MIDIHelper.Defaults.selectedDisplayName
    
    @AppStorage(MIDIHelper.PrefKeys.midiOutID)
    var midiOutSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
    
    @AppStorage(MIDIHelper.PrefKeys.midiOutDisplayName)
    var midiOutSelectedDisplayName: String = MIDIHelper.Defaults.selectedDisplayName
    
    init() {
        midiHelper.setup(midiManager: midiManager)
        
        // restore saved MIDI endpoint selections and connections
        midiHelper.midiInUpdateConnection(
            selectedUniqueID: midiInSelectedID,
            selectedDisplayName: midiInSelectedDisplayName
        )
        midiHelper.midiOutUpdateConnection(
            selectedUniqueID: midiOutSelectedID,
            selectedDisplayName: midiOutSelectedDisplayName
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                midiInSelectedID: $midiInSelectedID,
                midiInSelectedDisplayName: $midiInSelectedDisplayName,
                midiOutSelectedID: $midiOutSelectedID,
                midiOutSelectedDisplayName: $midiOutSelectedDisplayName
            )
            .environmentObject(midiManager)
            .environmentObject(midiHelper)
        }
        .onChange(of: midiManager.observableEndpoints.inputs) { _ in
            print("Inputs changed in system")
            midiOutSelectedIDChanged(to: midiOutSelectedID)
        }
        .onChange(of: midiManager.observableEndpoints.outputs) { _ in
            print("Outputs changed in system")
            midiInSelectedIDChanged(to: midiInSelectedID)
        }
        .onChange(of: midiInSelectedID) { midiInSelectedIDChanged(to: $0) }
        .onChange(of: midiOutSelectedID) { midiOutSelectedIDChanged(to: $0) }
    }
}

// MARK: - Helpers

extension EndpointPickersApp {
    private func midiInSelectedIDChanged(to newOutputEndpointID: MIDIIdentifier) {
        // cache endpoint details persistently so we can show it in the event the endpoint disappears
        if newOutputEndpointID == .invalidMIDIIdentifier {
            midiInSelectedDisplayName = MIDIHelper.Defaults.selectedDisplayName
        } else if let found = midiManager.observableEndpoints.outputs.first(
            whereUniqueID: newOutputEndpointID,
            fallbackDisplayName: midiInSelectedDisplayName
        ) {
            midiInSelectedDisplayName = found.displayName
            // update ID in case it changed
            if midiInSelectedID != found.uniqueID { midiInSelectedID = found.uniqueID }
        }
        
        // update the connection
        midiHelper.midiInUpdateConnection(
            selectedUniqueID: newOutputEndpointID,
            selectedDisplayName: midiInSelectedDisplayName
        )
    }
    
    private func midiOutSelectedIDChanged(to newInputEndpointID: MIDIIdentifier) {
        // cache endpoint details persistently so we can show it in the event the endpoint disappears
        if newInputEndpointID == .invalidMIDIIdentifier {
            midiOutSelectedDisplayName = MIDIHelper.Defaults.selectedDisplayName
        } else if let found = midiManager.observableEndpoints.inputs.first(
            whereUniqueID: newInputEndpointID,
            fallbackDisplayName: midiOutSelectedDisplayName
        ) {
            midiOutSelectedDisplayName = found.displayName
            // update ID in case it changed
            if midiOutSelectedID != found.uniqueID { midiOutSelectedID = found.uniqueID }
        }
        
        // update the connection
        midiHelper.midiOutUpdateConnection(
            selectedUniqueID: newInputEndpointID,
            selectedDisplayName: midiOutSelectedDisplayName
        )
    }
}
