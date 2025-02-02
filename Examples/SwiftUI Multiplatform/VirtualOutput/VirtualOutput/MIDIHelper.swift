//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Receiving MIDI happens on an asynchronous background thread. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class marked with `@Observable`
/// which contains properties that SwiftUI can use to update views.
@Observable final class MIDIHelper {
    private weak var midiManager: ObservableMIDIManager?
    
    public init() { }
    
    public func setup(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        addVirtualOutput()
    }
    
    // MARK: - Virtual Endpoints
    
    static let virtualOutputName = "TestApp Output"
    
    /// Convenience accessor for created virtual MIDI Output.
    var virtualOutput: MIDIOutput? {
        midiManager?.managedOutputs[MIDIHelper.virtualOutputName]
    }
    
    func addVirtualOutput() {
        guard let midiManager else { return }
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
    
    // MARK: - Send
    
    func sendNoteOn() {
        try? virtualOutput?.send(event: .noteOn(
            60,
            velocity: .midi1(127),
            channel: 0
        ))
    }
    
    func sendNoteOff() {
        try? virtualOutput?.send(event: .noteOff(
            60,
            velocity: .midi1(0),
            channel: 0
        ))
    }
    
    func sendCC1() {
        try? virtualOutput?.send(event: .cc(
            1,
            value: .midi1(64),
            channel: 0
        ))
    }
}
