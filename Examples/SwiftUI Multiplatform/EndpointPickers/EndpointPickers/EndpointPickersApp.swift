//
//  EndpointPickersApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
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
    var midiInSelectedID: MIDIIdentifier?
    
    @AppStorage(MIDIHelper.PrefKeys.midiInDisplayName)
    var midiInSelectedDisplayName: String?
    
    @AppStorage(MIDIHelper.PrefKeys.midiOutID)
    var midiOutSelectedID: MIDIIdentifier?
    
    @AppStorage(MIDIHelper.PrefKeys.midiOutDisplayName)
    var midiOutSelectedDisplayName: String?
    
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
        .onChange(of: midiInSelectedID) { midiInSelectedIDChanged(to: $0) }
        .onChange(of: midiOutSelectedID) { midiOutSelectedIDChanged(to: $0) }
    }
}

// MARK: - Helpers

extension EndpointPickersApp {
    private func midiInSelectedIDChanged(to newOutputEndpointID: MIDIIdentifier?) {
        midiHelper.midiInUpdateConnection(
            selectedUniqueID: newOutputEndpointID,
            selectedDisplayName: midiInSelectedDisplayName
        )
    }
    
    private func midiOutSelectedIDChanged(to newInputEndpointID: MIDIIdentifier?) {
        midiHelper.midiOutUpdateConnection(
            selectedUniqueID: newInputEndpointID,
            selectedDisplayName: midiOutSelectedDisplayName
        )
    }
}
