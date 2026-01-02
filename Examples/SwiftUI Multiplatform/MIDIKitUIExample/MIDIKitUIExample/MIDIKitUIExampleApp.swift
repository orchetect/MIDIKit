//
//  MIDIKitUIExampleApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct MIDIKitUIExampleApp: App {
    @State var midiHelper = MIDIHelper(start: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(macOS)
                .toolbar { Spacer() } // coax unified titlebar to show
                .frame(minHeight: 600)
                #endif
        }
        .environment(midiHelper)
    }
}
