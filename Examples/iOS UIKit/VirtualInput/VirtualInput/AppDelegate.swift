//
//  AppDelegate.swift
//  VirtualInput
//  MIDIKit • https://github.com/orchetect/MIDIKit
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
    
    let virtualInputName = "TestApp Input"
    
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
        
        do {
            print("Creating virtual MIDI input.")
            try midiManager.addInput(
                name: virtualInputName,
                tag: virtualInputName,
                uniqueID: .userDefaults(key: virtualInputName),
                receiveHandler: .eventsLogging(filterActiveSensingAndClock: true)
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
        
        return true
    }
}
