//
//  EndpointPickersApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

@main
struct EndpointPickersApp: App {
    var midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    var midiHelper = MIDIHelper()
    
    @AppStorage(MIDIHelper.PrefKeys.midiInID)
    var midiInSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
    
    @AppStorage(MIDIHelper.PrefKeys.midiInDisplayName)
    var midiInSelectedDisplayName: String = "None"
    
    @AppStorage(MIDIHelper.PrefKeys.midiOutID)
    var midiOutSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
    
    @AppStorage(MIDIHelper.PrefKeys.midiOutDisplayName)
    var midiOutSelectedDisplayName: String = "None"
    
    init() {
        midiHelper.setup(midiManager: midiManager)
        // restore saved MIDI endpoint selections and connections
        midiHelper.midiInUpdateConnection(selectedUniqueID: midiInSelectedID)
        midiHelper.midiOutUpdateConnection(selectedUniqueID: midiOutSelectedID)
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
        .onChange(of: midiInSelectedID) { uid in
            // cache endpoint name persistently so we can show it in the event the endpoint disappears
            if uid == .invalidMIDIIdentifier {
                midiInSelectedDisplayName = "None"
            } else if let found = midiManager.endpoints.outputs.first(whereUniqueID: uid) {
                midiInSelectedDisplayName = found.displayName
            }
    
            midiHelper.midiInUpdateConnection(selectedUniqueID: uid)
        }
        .onChange(of: midiOutSelectedID) { uid in
            // cache endpoint name persistently so we can show it in the event the endpoint disappears
            if uid == .invalidMIDIIdentifier {
                midiOutSelectedDisplayName = "None"
            } else if let found = midiManager.endpoints.inputs.first(whereUniqueID: uid) {
                midiOutSelectedDisplayName = found.displayName
            }
    
            midiHelper.midiOutUpdateConnection(selectedUniqueID: uid)
        }
    }
}
