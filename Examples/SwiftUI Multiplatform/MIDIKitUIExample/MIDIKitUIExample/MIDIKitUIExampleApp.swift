//
//  MIDIKitUIExampleApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

@main
struct MIDIKitUIExampleApp: App {
    @State var midiManager = ObservableMIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    @State var midiHelper = MIDIHelper()
    
    init() {
        midiHelper.setup(midiManager: midiManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(midiManager)
                .environment(midiHelper)
            #if os(macOS)
                .toolbar { Spacer() } // coax unified titlebar to show
                .frame(minHeight: 600)
            #endif
        }
    }
}
