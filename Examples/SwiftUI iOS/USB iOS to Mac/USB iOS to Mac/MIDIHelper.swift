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
@Observable public final class MIDIHelper {
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
    /// "IDAM MIDI Host" is the name of the MIDI input and output that iOS creates
    /// on the iOS device once a user has clicked 'Enable' in Audio MIDI Setup on the Mac
    /// to establish the USB audio/MIDI connection to the iOS device.
    public static let usbMIDIEndpointName = "IDAM MIDI Host"
    
    public static let inputConnectionTag = "TestApp Input Connection"
    public static let outputConnectionTag = "TestApp Output Connection"
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
        midiManager.managedOutputConnections[Self.outputConnectionTag]
    }
    
    private func createConnections() {
        
        do {
            print("Creating MIDI input connection.")
            try midiManager.addInputConnection(
                to: .outputs(matching: [.name(Self.usbMIDIEndpointName)]),
                tag: Self.inputConnectionTag,
                receiver: .eventsLogging(
                    options: [.bundleRPNAndNRPNDataEntryLSB, .filterActiveSensingAndClock]
                )
            )
        } catch {
            print("Error creating MIDI output connection:", error.localizedDescription)
        }
        
        do {
            print("Creating MIDI output connection.")
            try midiManager.addOutputConnection(
                to: .inputs(matching: [.name(Self.usbMIDIEndpointName)]),
                tag: Self.outputConnectionTag
            )
        } catch {
            print("Error creating MIDI output connection:", error.localizedDescription)
        }
    }
    
   
    
    private func removeConnections() {
        midiManager.remove(.inputConnection, .withTag(Self.inputConnectionTag))
        midiManager.remove(.outputConnection, .withTag(Self.outputConnectionTag))
    }
}
