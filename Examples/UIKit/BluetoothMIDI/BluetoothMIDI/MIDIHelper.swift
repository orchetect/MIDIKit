//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitIO

/// Object responsible for managing MIDI services, managing connections, and sending/receiving events.
public final class MIDIHelper: Sendable {
    private let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    public init(start: Bool = false) {
        if start { self.start() }
    }
}

// MARK: - Static

extension MIDIHelper {
    public var listenerTag: String { "Listener" }
    public var broadcasterTag: String { "Broadcaster" }
}

// MARK: - Lifecycle

extension MIDIHelper {
    public func start() {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        createConnections()
    }
    
    public func stop() {
        removeConnections()
    }
}

// MARK: - I/O

extension MIDIHelper {
    public var outputConnection: MIDIOutputConnection? {
        midiManager.managedOutputConnections[broadcasterTag]
    }
    
    private func createConnections() {
        // set up a listener that automatically connects to all MIDI outputs
        // and prints the events to the console
        do {
            try midiManager.addInputConnection(
                to: .allOutputs, // auto-connect to all outputs that may appear
                tag: listenerTag,
                filter: .owned(), // don't allow self-created virtual endpoints
                receiver: .eventsLogging(options: [
                    .bundleRPNAndNRPNDataEntryLSB,
                    .filterActiveSensingAndClock
                ])
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
                tag: broadcasterTag,
                filter: .owned() // don't allow self-created virtual endpoints
            )
        } catch {
            print(
                "Error setting up managed MIDI all-listener connection:",
                error.localizedDescription
            )
        }
    }
    
    private func removeConnections() {
        midiManager.remove(.inputConnection, .withTag(listenerTag))
        midiManager.remove(.outputConnection, .withTag(broadcasterTag))
    }
}
