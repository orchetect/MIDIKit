//
//  Manager addThruConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Creates a new MIDI play-through (thru) connection.
    ///
    /// ⚠️ **Note** ⚠️
    /// - Due to a Swift Core MIDI bug, all thru connections are created as persistent.
    /// - If `.nonPersistent` is passed, the connection will be created as persistent with an empty ownerID of "". Use this feature with caution.
    /// - ([Radar FB9836833](https://openradar.appspot.com/radar?id=5043482339049472))
    ///
    /// If the connection is non-persistent, a managed thru connection will be added to the `managedThruConnections` dictionary of the `Manager` and its lifecycle will be that of the `Manager` or until removeThruConnection is called for the connection.
    ///
    /// If the connection is persistent, it is instead stored persistently by the system and references will not be directly held in the `Manager`. To access persistent connections, the `unmanagedPersistentThruConnections` property will retrieve a list of connections from the system, if any match the owner ID passed as argument.
    ///
    /// For every persistent thru connection your app creates, they should be assigned the same persistent ID (domain) so they can be managed or removed in future.
    ///
    /// - Warning: Be careful when creating persistent thru connections, as they can become stale and orphaned if the endpoints used to create them cease to be relevant at any point in time.
    ///
    /// - Note: Max 8 outputs and max 8 inputs are allowed when forming a thru connection.
    ///
    /// - Parameters:
    ///   - outputs: Maximum of 8 `Endpoint`s.
    ///   - inputs: Maximum of 8 `Endpoint`s.
    ///   - tag: Unique `String` key to refer to the new object that gets added to `managedThruConnections` collection dictionary.
    ///   - lifecycle: If `false`, thru connection will expire when the app terminates. If `true`, the connection persists in the system indefinitely (even after system reboots) until explicitly removed.
    ///   - params: Optionally define custom `MIDIThruConnectionParams`.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addThruConnection(
        outputs: [MIDI.IO.OutputEndpoint],
        inputs: [MIDI.IO.InputEndpoint],
        tag: String,
        lifecycle: MIDI.IO.ThruConnection.Lifecycle = .nonPersistent,
        params: MIDI.IO.ThruConnection.Parameters = .init()
    ) throws {
        
        try eventQueue.sync {
            
            let newCT = MIDI.IO.ThruConnection(
                outputs: outputs,
                inputs: inputs,
                lifecycle: lifecycle,
                params: params,
                midiManager: self,
                api: preferredAPI
            )
            
            // if non-persistent, add to managed array
            if lifecycle == .nonPersistent {
                // store the connection object in the manager,
                // even if subsequent connection fails
                managedThruConnections[tag] = newCT
            }
            
            // otherwise, we won't store a reference to a persistent thru connection
            // persistent connections are stored by the system
            // to analyze or delete a persistent connection,
            // access the `unmanagedPersistentThruConnections(ownerID:)` method.
            
            try newCT.create(in: self)
            
        }
        
    }
    
}
