//
//  BluetoothMIDIApp.swift
//  BluetoothMIDI
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

@main
struct BluetoothMIDIApp: App {
    let midiManager = MIDI.IO.Manager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    init() {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        // set up a listener that automatically connects to all MIDI outputs
        // and prints the events to the console
        
        do {
            try midiManager.addInputConnection(
                toOutputs: [], // no need to specify if we're using .allEndpoints
                tag: "Listener",
                mode: .allEndpoints, // auto-connect to all outputs that may appear
                filter: .owned(), // don't allow self-created virtual
                receiveHandler: .eventsLogging(filterActiveSensingAndClock: false)
            )
        } catch {
            print(
                "Error setting up managed MIDI all-listener connection:",
                error.localizedDescription
            )
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
