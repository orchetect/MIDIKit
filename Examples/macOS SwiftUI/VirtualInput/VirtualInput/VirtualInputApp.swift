//
//  VirtualInputApp.swift
//  VirtualInput
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit

@main
struct VirtualInputApp: App {
    
    let midiManager = MIDI.IO.Manager(clientName: "TestAppMIDIManager",
                                      model: "TestApp",
                                      manufacturer: "MyCompany")
    
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
                receiveHandler: .eventsLogging(filterActiveSensingAndClock: true)
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