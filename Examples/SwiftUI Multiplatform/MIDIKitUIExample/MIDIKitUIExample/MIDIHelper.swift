//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Receiving MIDI happens as an asynchronous background callback. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class that conforms to
/// `ObservableObject` which contains `@Published` properties that SwiftUI can use to update views.
final class MIDIHelper: ObservableObject {
    private weak var midiManager: ObservableMIDIManager?
    
    let virtualInputName = "TestApp Input"
    
    public init() { }
    
    public func setup(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
    
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    }
    
    // MARK: - Virtual Endpoints
    
    let virtualInputTags: [String] = [
        "Test Input 1",
        "Test Input 2",
        "Test Input 3",
        "Test Input 4"
    ]
    
    let virtualOutputTags: [String] = [
        "Test Output 1",
        "Test Output 2",
        "Test Output 3",
        "Test Output 4"
    ]
    
    @Published
    public private(set) var virtualsExist: Bool = false
    
    public func createVirtuals() throws {
        for tag in virtualInputTags {
            guard midiManager?.managedInputs[tag] == nil else { continue }
            try midiManager?.addInput(
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
            guard midiManager?.managedOutputs[tag] == nil else { continue }
            try midiManager?.addOutput(
                name: tag,
                tag: tag,
                uniqueID: .userDefaultsManaged(key: tag)
            )
        }
        virtualsExist = true
    }
    
    public func destroyVirtuals() throws {
        for tag in virtualInputTags {
            midiManager?.remove(.input, .withTag(tag))
        }
        for tag in virtualOutputTags {
            midiManager?.remove(.output, .withTag(tag))
        }
        virtualsExist = false
    }
}

// MARK: - String Constants

extension MIDIHelper {
    enum PrefKeys {
        static let midiInID = "midiInput"
        static let midiInName = "midiInputName"
        
        static let midiOutID = "midiOutput"
        static let midiOutName = "midiOutputName"
    }
}
