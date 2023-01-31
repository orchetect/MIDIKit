//
//  VirtualInputApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

@main
struct VirtualInputApp: App {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    static let virtualInputName = "TestApp Input"
    
    init() {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    
        do {
            print("Creating virtual MIDI input.")
            try midiManager.addInput(
                name: Self.virtualInputName,
                tag: Self.virtualInputName,
                uniqueID: .userDefaultsManaged(key: Self.virtualInputName),
                receiver: .eventsLogging(filterActiveSensingAndClock: true)
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
