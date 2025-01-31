//
//  MIDIManager addOutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

extension MIDIManager {
    /// Creates a new managed output connection in the system and adds it to the ``MIDIManager/managedOutputConnections``
    /// dictionary of the ``MIDIManager``.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can
    /// also be instanced without providing any initial inputs and then inputs can be added or
    /// removed later.
    ///
    /// - Parameters:
    ///   - inputs: Criteria for identifying target MIDI endpoint(s). These may be added or
    ///     removed later.
    ///   - tag: Internal unique tag to reference the managed item in the ``MIDIManager``.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to
    ///     the connection.
    ///
    /// - Throws: ``MIDIIOError``
    public func addOutputConnection(
        to inputs: MIDIOutputConnectionMode,
        tag: String,
        filter: MIDIEndpointFilter = .default()
    ) throws {
        try managementQueue.sync {
            let newCS = MIDIOutputConnection(
                mode: inputs,
                filter: filter,
                midiManager: self,
                midiManagerManagedInputs: managedInputs,
                api: preferredAPI
            )
            
            // store the connection object in the manager,
            // even if subsequent operations fail
            managedOutputConnections[tag] = newCS
            
            try newCS.setupOutput(in: self)
            try newCS.resolveEndpoints(in: self)
        }
    }
}

#endif
