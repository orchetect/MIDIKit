//
//  VirtualOutputApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

@main
struct VirtualOutputApp: App {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    static let virtualOutputName = "TestApp Output"
    
    init() {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    
        do {
            print("Creating virtual MIDI output.")
            try midiManager.addOutput(
                name: Self.virtualOutputName,
                tag: Self.virtualOutputName,
                uniqueID: .userDefaultsManaged(key: Self.virtualOutputName)
            )
        } catch {
            print("Error creating virtual MIDI output:", error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(midiManager)
        }
    }
}
