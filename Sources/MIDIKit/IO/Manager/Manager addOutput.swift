//
//  Manager addOutput.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    /// Adds new a managed virtual output to the `managedOutputs` dictionary of the `Manager`.
    ///
    /// The lifecycle of the MIDI port exists for as long as the `Manager` instance exists, or until `.remove(::)` is called.
    ///
    /// A note on `uniqueID`:
    ///
    /// It is best practise that the `uniqueID` be stored persistently in a data store of your choosing, and supplied when recreating the same port. This allows other applications to identify the port and reconnect to it, as the port name is not used to identify a MIDI port since MIDI ports are allowed to have the same name, but must have unique IDs.
    ///
    /// It is best practise to re-store the `uniqueID` every time this method is called, since these IDs are temporal and not registered or permanently reserved in the system. Since ID collisions are possible, a new available random ID will be obtained and used if that happens, and that updated ID should be stored in-place of the old one in your data store.
    ///
    /// Do not generate the ID number yourself - it is always system-generated and then we should store and persist it. `UniqueIDPersistence` offers mechanisms to simplify this.
    ///
    /// - Parameters:
    ///   - name: Name of the endpoint as seen in the system.
    ///   - tag: Internal unique tag to reference the managed item in the `Manager`.
    ///   - uniqueID: System-global unique identifier for the port.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addOutput(
        name: String,
        tag: String,
        uniqueID: MIDI.IO.UniqueIDPersistence
    ) throws {
        try eventQueue.sync {
            let newVS = MIDI.IO.Output(
                name: name,
                uniqueID: uniqueID.readID(),
                midiManager: self,
                api: preferredAPI
            )
            
            managedOutputs[tag] = newVS
            
            try newVS.create(in: self)
            
            guard let successfulID = newVS.uniqueID else {
                throw MIDI.IO.MIDIError.connectionError(
                    "Could not read virtual MIDI endpoint unique ID."
                )
            }
            
            uniqueID.writeID(successfulID)
        }
    }
}

#endif
