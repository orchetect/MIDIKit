//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
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
    
    let virtualOutputName = "TestApp Output"
    
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
            print("Creating virtual MIDI output.")
            try midiManager.addOutput(
                name: virtualOutputName,
                tag: virtualOutputName,
                uniqueID: .userDefaultsManaged(key: virtualOutputName)
            )
        } catch {
            print("Error creating virtual MIDI output:", error.localizedDescription)
        }
        
        return true
    }
    
    @IBAction
    func sendNoteOn(_ sender: Any) {
        guard let output = midiManager.managedOutputs[virtualOutputName] else { return }
        
        try? output.send(
            event: .noteOn(
                60,
                velocity: .midi1(127),
                channel: 0
            )
        )
    }
    
    @IBAction
    func sendNoteOff(_ sender: Any) {
        guard let output = midiManager.managedOutputs[virtualOutputName] else { return }
        
        try? output.send(
            event: .noteOff(
                60,
                velocity: .midi1(0),
                channel: 0
            )
        )
    }
    
    @IBAction
    func sendCC1(_ sender: Any) {
        guard let output = midiManager.managedOutputs[virtualOutputName] else { return }
        
        try? output.send(
            event: .cc(
                1,
                value: .midi1(64),
                channel: 0
            )
        )
    }
}
