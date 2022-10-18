//
//  VirtualInputApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
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
    
    let virtualInputName = "TestApp Input"
    
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
                name: virtualInputName,
                tag: virtualInputName,
                uniqueID: .userDefaultsManaged(key: virtualInputName),
                receiver: .eventsLogging(filterActiveSensingAndClock: true)
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 500, height: 350, alignment: .center)
        }
    }
}
