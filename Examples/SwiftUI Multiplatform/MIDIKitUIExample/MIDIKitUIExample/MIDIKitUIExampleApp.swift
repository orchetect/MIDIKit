//
//  MIDIKitUIExampleApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO

@main
struct MIDIKitUIExampleApp: App {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    let midiHelper = MIDIHelper()
    
    init() {
        midiHelper.setup(midiManager: midiManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(midiManager)
                .environmentObject(midiHelper)
#if os(macOS)
                .toolbar { Spacer() } // coax unified titlebar to show
                .frame(minHeight: 600)
#endif
        }
    }
}
