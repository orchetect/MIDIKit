//
//  AppDelegate.swift
//  VirtualOutput
//  MIDIKit • https://github.com/orchetect/MIDIKit
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
                uniqueID: .userDefaults(key: virtualOutputName)
            )
        } catch {
            print("Error creating virtual MIDI output:", error.localizedDescription)
        }
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
