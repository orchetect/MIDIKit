//
//  EventParsingApp.swift
//  EventParsing
//  MIDIKit • https://github.com/orchetect/MIDIKit
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
                .frame(width: 500, height: 350, alignment: .center)
        }
    }
}
