//
//  EventParsingApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct EventParsingApp: App {
    @State var midiHelper = MIDIHelper(start: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(midiHelper)
    }
}
