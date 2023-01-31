//
//  USBiOStoMacApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

@main
struct USBiOStoMacApp: App {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    static let inputConnectionName = "TestApp Input Connection"
    static let outputConnectionName = "TestApp Output Connection"
    
    init() {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    
        do {
            // "IDAM MIDI Host" is the name of the MIDI input and output that iOS creates
            // on the iOS device once a user has clicked 'Enable' in Audio MIDI Setup on the Mac
            // to establish the USB audio/MIDI connection to the iOS device.
            
            print("Creating MIDI input connection.")
            try midiManager.addInputConnection(
                toOutputs: [.name("IDAM MIDI Host")],
                tag: Self.inputConnectionName,
                receiver: .eventsLogging()
            )
            
            print("Creating MIDI output connection.")
            try midiManager.addOutputConnection(
                toInputs: [.name("IDAM MIDI Host")],
                tag: Self.outputConnectionName
            )
        } catch {
            print("Error creating MIDI output connection:", error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(midiManager)
        }
    }
}
