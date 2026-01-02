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
    @State var midiHelper = MIDIHelper(start: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(midiHelper)
    }
}
