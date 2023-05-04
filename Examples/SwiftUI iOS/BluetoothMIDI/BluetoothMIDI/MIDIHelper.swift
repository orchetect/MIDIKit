//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

/// Receiving MIDI happens as an asynchronous background callback. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class that conforms to
/// `ObservableObject` which contains `@Published` properties that SwiftUI can use to update views.
final class MIDIHelper: ObservableObject {
    private weak var midiManager: MIDIManager?
    
    public init() { }
    
    public func setup(midiManager: MIDIManager) {
        self.midiManager = midiManager
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        setupConnections()
    }
    
    // MARK: - Connections
    
    private func setupConnections() {
        guard let midiManager = midiManager else { return }
        
        // set up a listener that automatically connects to all MIDI outputs
        // and prints the events to the console
        
        do {
            try midiManager.addInputConnection(
                toOutputs: [], // no need to specify if we're using .allEndpoints
                tag: "Listener",
                mode: .allEndpoints, // auto-connect to all outputs that may appear
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
                toInputs: [], // no need to specify if we're using .allEndpoints
                tag: "Broadcaster",
                mode: .allEndpoints, // auto-connect to all inputs that may appear
                filter: .owned() // don't allow self-created virtual endpoints
            )
        } catch {
            print(
                "Error setting up managed MIDI all-listener connection:",
                error.localizedDescription
            )
        }
    }
    
    func sendTestMIDIEvent() {
        let conn = midiManager?.managedOutputConnections["Broadcaster"]
        try? conn?.send(event: .cc(.expression, value: .midi1(64), channel: 0))
    }
}
