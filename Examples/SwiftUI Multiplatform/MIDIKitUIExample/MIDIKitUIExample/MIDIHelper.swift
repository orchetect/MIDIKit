//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Object responsible for managing MIDI services, managing connections, and sending/receiving events.
///
/// Marking the class as `@Observable` allows us to install an instance of the class in a SwiftUI App or View
/// and propagate it through the environment.
///
/// Properties that may result in UI changes are bound to `@MainActor` to ensure they are updated on the main thread.
@Observable final class MIDIHelper: Sendable {
    public let midiManager = ObservableMIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    @MainActor public private(set) var isVirtualEndpointsExist: Bool = false
    
    public init(start: Bool = false) {
        if start { self.start() }
    }
}

// MARK: - Static

extension MIDIHelper {
    var virtualInputName: String { "TestApp Input" }
    
    var virtualInputTags: [String] {
        [
            "Test Input 1",
            "Test Input 2",
            "Test Input 3",
            "Test Input 4"
        ]
    }
    
    var virtualOutputTags: [String] {
        [
            "Test Output 1",
            "Test Output 2",
            "Test Output 3",
            "Test Output 4"
        ]
    }
    
    enum PrefKeys {
        static let midiInID = "midiInput"
        static let midiInName = "midiInputName"
        
        static let midiOutID = "midiOutput"
        static let midiOutName = "midiOutputName"
    }
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
    }
    
    public func stop() {
        removeVirtualEndpoints()
    }
}

// MARK: - I/O

extension MIDIHelper {
    public func createVirtualEndpoints() {
        for tag in virtualInputTags {
            guard midiManager.managedInputs[tag] == nil else { continue }
            try? midiManager.addInput(
                name: tag,
                tag: tag,
                uniqueID: .userDefaultsManaged(key: tag),
                receiver: .eventsLogging(options: [
                    .bundleRPNAndNRPNDataEntryLSB,
                    .filterActiveSensingAndClock
                ]) { eventString in
                    print("Received on \(tag): \(eventString)")
                }
            )
        }
        for tag in virtualOutputTags {
            guard midiManager.managedOutputs[tag] == nil else { continue }
            try? midiManager.addOutput(
                name: tag,
                tag: tag,
                uniqueID: .userDefaultsManaged(key: tag)
            )
        }
        
        Task { @MainActor in isVirtualEndpointsExist = true }
    }
    
    public func removeVirtualEndpoints() {
        for tag in virtualInputTags {
            midiManager.remove(.input, .withTag(tag))
        }
        for tag in virtualOutputTags {
            midiManager.remove(.output, .withTag(tag))
        }
        
        Task { @MainActor in isVirtualEndpointsExist = false }
    }
}
