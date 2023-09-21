//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import UIKit
import MIDIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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
                to: .allOutputs, // auto-connect to all outputs that may appear
                tag: "Listener",
                filter: .owned(), // don't allow self-created virtual endpoints
                receiver: .eventsLogging(filterActiveSensingAndClock: false)
            )
        } catch {
            print(
                "Error setting up managed MIDI all-listener connection:",
                error.localizedDescription
            )
        }
    
        // set up a broadcaster that can send events to all MIDI inputs
    
        do {
            try midiManager.addOutputConnection(
                to: .allInputs, // auto-connect to all inputs that may appear
                tag: "Broadcaster",
                filter: .owned() // don't allow self-created virtual endpoints
            )
        } catch {
            print(
                "Error setting up managed MIDI all-listener connection:",
                error.localizedDescription
            )
        }
    
        return true
    }
}
