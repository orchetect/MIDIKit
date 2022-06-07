//
//  Manager addInputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Adds a new managed input connection to the `managedInputConnections` dictionary of the `Manager`.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI events. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addInputConnection(
        toOutputs: Set<MIDI.IO.OutputEndpointIDCriteria>,
        tag: String,
        mode: MIDI.IO.ConnectionMode = .definedEndpoints,
        filter: MIDI.IO.OutputEndpointFilter = .default(),
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try eventQueue.sync {
            
            let newCD = MIDI.IO.InputConnection(
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
    
    /// Adds a new managed input connection to the `managedInputConnections` dictionary of the `Manager`.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI events. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addInputConnection(
        toOutputs: [MIDI.IO.OutputEndpointIDCriteria],
        tag: String,
        mode: MIDI.IO.ConnectionMode = .definedEndpoints,
        filter: MIDI.IO.OutputEndpointFilter = .default(),
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try addInputConnection(
            toOutputs: Set(toOutputs),
            tag: tag,
            mode: mode,
            filter: filter,
            receiveHandler: receiveHandler
        )
        
    }
    
    /// Adds a new managed input connection to the `managedInputConnections` dictionary of the `Manager`.
    ///
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI events. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    @_disfavoredOverload
    public func addInputConnection(
        toOutputs: [MIDI.IO.OutputEndpoint],
        tag: String,
        mode: MIDI.IO.ConnectionMode = .definedEndpoints,
        filter: MIDI.IO.OutputEndpointFilter = .default(),
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try addInputConnection(
            toOutputs: toOutputs.map { .uniqueID($0.uniqueID) },
            tag: tag,
            mode: mode,
            filter: filter,
            receiveHandler: receiveHandler
        )
        
    }
    
}
