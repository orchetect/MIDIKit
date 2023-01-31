//
//  AppDelegate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import MIDIKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    let virtualOutputName = "TestApp Output"
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    
        setupVirtualOutput()
    }
    
    private func setupVirtualOutput() {
        do {
            print("Creating virtual output port.")
            try midiManager.addOutput(
                name: virtualOutputName,
                tag: virtualOutputName,
                uniqueID: .userDefaultsManaged(key: virtualOutputName)
            )
        } catch {
            print("Error creating virtual MIDI output:", error.localizedDescription)
        }
    }
    
    /// Convenience accessor for created virtual MIDI Output.
    var virtualOutput: MIDIOutput? {
        midiManager.managedOutputs[virtualOutputName]
    }
    
    @IBAction
    func sendNoteOn(_ sender: Any) {
        try? virtualOutput?.send(event: .noteOn(
            60,
            velocity: .midi1(127),
            channel: 0
        ))
    }
    
    @IBAction
    func sendNoteOff(_ sender: Any) {
        try? virtualOutput?.send(event: .noteOff(
            60,
            velocity: .midi1(0),
            channel: 0
        ))
    }
    
    @IBAction
    func sendCC1(_ sender: Any) {
        try? virtualOutput?.send(event: .cc(
            1,
            value: .midi1(64),
            channel: 0
        ))
    }
}
