//
//  Manager addOutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Adds a new managed connected output to the `managedOutputConnections` dictionary of the `Manager`.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toInputs: Criteria for identifying a MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addOutputConnection(
        toInputs: Set<MIDI.IO.InputEndpointIDCriteria>,
        tag: String
    ) throws {
        
        try eventQueue.sync {
            
            let newCS = MIDI.IO.OutputConnection(
                toInputs: toInputs,
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
    
    /// Adds a new managed connected output to the `managedOutputConnections` dictionary of the `Manager`.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toInputs: Criteria for identifying a MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addOutputConnection(
        toInputs: [MIDI.IO.InputEndpointIDCriteria],
        tag: String
    ) throws {
        
        try addOutputConnection(
            toInputs: Set(toInputs),
            tag: tag
        )
        
    }
    
    /// Adds a new managed connected output to the `managedOutputConnections` dictionary of the `Manager`.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Parameters:
    ///   - toInputs: Criteria for identifying a MIDI endpoint(s) in the system to connect to.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    @_disfavoredOverload
    public func addOutputConnection(
        toInputs: [MIDI.IO.InputEndpoint],
        tag: String
    ) throws {
        
        try addOutputConnection(
            toInputs: toInputs.map { .uniqueID($0.uniqueID) },
            tag: tag
        )
        
    }
    
}
