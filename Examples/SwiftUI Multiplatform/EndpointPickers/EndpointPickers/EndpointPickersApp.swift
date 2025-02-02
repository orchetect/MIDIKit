//
//  EndpointPickersApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import SwiftUI

@main
struct EndpointPickersApp: App {
    @State var midiManager = ObservableMIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    @State var midiHelper = MIDIHelper()
    
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
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                midiInSelectedID: $midiInSelectedID,
                midiInSelectedDisplayName: $midiInSelectedDisplayName,
                midiOutSelectedID: $midiOutSelectedID,
                midiOutSelectedDisplayName: $midiOutSelectedDisplayName
            )
            .environment(midiManager)
            .environment(midiHelper)
        }
    }
}
