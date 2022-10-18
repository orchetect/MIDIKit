//
//  EventParsingApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

@main
struct EventParsingApp: App {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    @ObservedObject var midiHelper = MIDIHelper()
    
    init() {
        midiHelper.midiManager = midiManager
        midiHelper.initialSetup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
