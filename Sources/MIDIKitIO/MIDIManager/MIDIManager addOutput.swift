//
//  MIDIManager addOutput.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

extension MIDIManager {
    /// Creates a new managed virtual output in the system and adds it to the ``MIDIManager/managedOutputs``
    /// dictionary of the ``MIDIManager``.
    ///
    /// The lifecycle of the MIDI port exists for as long as the ``MIDIManager`` instance exists, or
    /// until ``MIDIManager/remove(_:_:)`` is called.
    ///
    /// > A note on `uniqueID`:
    /// >
    /// > It is best practise that the `uniqueID` be stored persistently in a data store of your
    /// > choosing, and supplied when recreating the same port. This allows other applications to
    /// > identify the port and reconnect to it, as the port name is not used to identify a MIDI
    /// > port since MIDI ports are allowed to have the same name, but must have unique IDs.
    /// >
    /// > It is best practise to re-store the `uniqueID` every time this method is called, since
    /// > these IDs are temporal and not registered or permanently reserved in the system. Since ID
    /// > collisions are possible, a new available random ID will be obtained and used if that
    /// > happens, and that updated ID should be stored in-place of the old one in your data store.
    /// >
    /// > Do not generate the ID number yourself - it is always system-generated and then we should
    /// > store and persist it. ``MIDIIdentifierPersistence`` offers mechanisms to simplify this.
    ///
    /// - Parameters:
    ///   - name: Name of the endpoint as seen in the system.
    ///   - tag: Internal unique tag to reference the managed item in the ``MIDIManager``.
    ///   - uniqueID: System-global unique identifier for the port.
    ///
    /// - Throws: ``MIDIIOError``
    public func addOutput(
        name: String,
        tag: String,
        uniqueID: MIDIIdentifierPersistence
    ) throws {
        try managementQueue.sync {
            let newVS = MIDIOutput(
                name: name,
                uniqueID: uniqueID.readID(),
                midiManager: self,
                api: preferredAPI
            )
            
            managedOutputs[tag] = newVS
            
            try newVS.create(in: self)
            
            guard let successfulID = newVS.uniqueID else {
                throw MIDIIOError.connectionError(
                    "Could not read virtual MIDI endpoint unique ID."
                )
            }
            
            uniqueID.writeID(successfulID)
        }
    }
}

#endif
