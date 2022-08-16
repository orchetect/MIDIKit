//
//  MIDIManager addOutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDIManager {
    /// Adds a new managed connected output to the `managedOutputConnections` dictionary of the `MIDIManager`.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toInputs: Criteria for identifying target MIDI endpoint(s). These may be added or removed later.
    ///   - tag: Internal unique tag to reference the managed item in the `MIDIManager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///
    /// - Throws: `MIDIIOError`
    public func addOutputConnection(
        toInputs: Set<MIDIEndpointIdentity>,
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default()
    ) throws {
        try eventQueue.sync {
            let newCS = MIDIOutputConnection(
                criteria: toInputs,
                mode: mode,
                filter: filter,
                midiManager: self,
                api: preferredAPI
            )
    
            // store the connection object in the manager,
            // even if subsequent operations fail
            managedOutputConnections[tag] = newCS
    
            try newCS.setupOutput(in: self)
            try newCS.resolveEndpoints(in: self)
        }
    }
    
    /// Adds a new managed connected output to the `managedOutputConnections` dictionary of the `MIDIManager`.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toInputs: Criteria for identifying target MIDI endpoint(s). These may be added or removed later.
    ///   - tag: Internal unique tag to reference the managed item in the `MIDIManager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///
    /// - Throws: `MIDIIOError`
    public func addOutputConnection(
        toInputs: [MIDIEndpointIdentity],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default()
    ) throws {
        try addOutputConnection(
            toInputs: Set(toInputs),
            tag: tag,
            mode: mode,
            filter: filter
        )
    }
    
    /// Adds a new managed connected output to the `managedOutputConnections` dictionary of the `MIDIManager`.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toInputs: Target MIDI endpoint(s). These may be added or removed later.
    ///   - tag: Internal unique tag to reference the managed item in the `MIDIManager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///
    /// - Throws: `MIDIIOError`
    @_disfavoredOverload
    public func addOutputConnection(
        toInputs: [MIDIInputEndpoint],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default()
    ) throws {
        try addOutputConnection(
            toInputs: toInputs.asIdentities(),
            tag: tag,
            mode: mode,
            filter: filter
        )
    }
}

#endif
