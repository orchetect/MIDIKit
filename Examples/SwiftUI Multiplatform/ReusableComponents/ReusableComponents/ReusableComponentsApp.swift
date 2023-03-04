//
//  ReusableComponentsApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO

@main
struct ReusableComponentsApp: App {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    var midiHelper = MIDIHelper()
    
    init() {
        midiHelper.midiManager = midiManager
        midiHelper.initialSetup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(midiManager)
                .environmentObject(midiHelper)
#if os(macOS)
                .toolbar { Spacer() }
                .frame(minHeight: 600)
#endif
        }
    }
}
