//
//  MTCVideoPlayerApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import SwiftUI

@main
struct MTCVideoPlayerApp: App {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    let midiHelper = MIDIHelper()
    
    init() {
        midiHelper.midiManager = midiManager
        midiHelper.initialSetup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(midiManager)
                .environmentObject(midiHelper)
        }
    }
}
