//
//  MIDIManager addInputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDIManager {
    /// Adds a new managed input connection to the `managedInputConnections` dictionary of the `MIDIManager`.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI events. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying target MIDI endpoint(s). These may be added or removed later.
    ///   - tag: Internal unique tag to reference the managed item in the `MIDIManager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDIIOError`
    public func addInputConnection(
        toOutputs: Set<MIDIEndpointIdentity>,
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiveHandler: MIDIIOReceiveHandler.Definition
    ) throws {
        try eventQueue.sync {
            let newCD = MIDIInputConnection(
                criteria: toOutputs,
                mode: mode,
                filter: filter,
                receiveHandler: receiveHandler,
                midiManager: self,
                api: preferredAPI
            )
            
            // store the connection object in the manager,
            // even if subsequent connection fails
            managedInputConnections[tag] = newCD
            
            try newCD.listen(in: self)
            try newCD.connect(in: self)
        }
    }
    
    /// Adds a new managed input connection to the `managedInputConnections` dictionary of the `MIDIManager`.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI events. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying target MIDI endpoint(s). These may be added or removed later.
    ///   - tag: Internal unique tag to reference the managed item in the `MIDIManager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDIIOError`
    public func addInputConnection(
        toOutputs: [MIDIEndpointIdentity],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiveHandler: MIDIIOReceiveHandler.Definition
    ) throws {
        try addInputConnection(
            toOutputs: Set(toOutputs),
            tag: tag,
            mode: mode,
            filter: filter,
            receiveHandler: receiveHandler
        )
    }
    
    /// Adds a new managed input connection to the `managedInputConnections` dictionary of the `MIDIManager`.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI events. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Target MIDI endpoint(s). These may be added or removed later.
    ///   - tag: Internal unique tag to reference the managed item in the `MIDIManager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDIIOError`
    @_disfavoredOverload
    public func addInputConnection(
        toOutputs: [MIDIOutputEndpoint],
        tag: String,
        mode: MIDIConnectionMode = .definedEndpoints,
        filter: MIDIEndpointFilter = .default(),
        receiveHandler: MIDIIOReceiveHandler.Definition
    ) throws {
        try addInputConnection(
            toOutputs: toOutputs.asIdentities(),
            tag: tag,
            mode: mode,
            filter: filter,
            receiveHandler: receiveHandler
        )
    }
}

#endif
