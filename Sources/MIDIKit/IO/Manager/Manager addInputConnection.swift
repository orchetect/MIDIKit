//
//  Manager addInputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Adds a new managed connected input to the `managedInputConnections` dictionary of the `Manager`.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - automaticallyAddNewOutputs: When new outputs appear in the system, automatically add them to the connection.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addInputConnection(
        toOutputs: Set<MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint>>,
        tag: String,
        automaticallyAddNewOutputs: Bool = false,
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try eventQueue.sync {
            
            let newCD = MIDI.IO.InputConnection(
                toOutputs: toOutputs,
                automaticallyAddNewOutputs: automaticallyAddNewOutputs,
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
    
    /// Adds a new managed connected input to the `managedInputConnections` dictionary of the `Manager`.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addInputConnection(
        toOutputs: [MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint>],
        tag: String,
        automaticallyAddNewOutputs: Bool = false,
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try addInputConnection(
            toOutputs: Set(toOutputs),
            tag: tag,
            automaticallyAddNewOutputs: automaticallyAddNewOutputs,
            receiveHandler: receiveHandler
        )
        
    }
    
    /// Adds a new managed connected input to the `managedInputConnections` dictionary of the `Manager`.
    ///
    /// - Parameters:
    ///   - toOutputs: Criteria for identifying MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    @_disfavoredOverload
    public func addInputConnection(
        toOutputs: [MIDI.IO.OutputEndpoint],
        tag: String,
        automaticallyAddNewOutputs: Bool = false,
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try addInputConnection(
            toOutputs: toOutputs.map { .uniqueID($0.uniqueID) },
            tag: tag,
            automaticallyAddNewOutputs: automaticallyAddNewOutputs,
            receiveHandler: receiveHandler
        )
        
    }
    
}
