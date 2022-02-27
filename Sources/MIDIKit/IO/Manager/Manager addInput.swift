//
//  Manager addInput.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Adds a new managed virtual input to the `managedInputs` dictionary of the `Manager` and creates the MIDI port in the system.
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
    ///   - receiveHandler: Event handler for received MIDI packets.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public func addInput(
        name: String,
        tag: String,
        uniqueID: MIDI.IO.UniqueIDPersistence<MIDI.IO.InputEndpoint.UniqueID>,
        receiveHandler: MIDI.IO.ReceiveHandler.Definition
    ) throws {
        
        try eventQueue.sync {
            
            let newVD = MIDI.IO.Input(
                name: name,
                uniqueID: uniqueID.readID(),
                receiveHandler: receiveHandler,
                midiManager: self,
                api: preferredAPI
            )
            
            managedInputs[tag] = newVD
            
            try newVD.create(in: self)
            
            guard let successfulID = newVD.uniqueID else {
                throw MIDI.IO.MIDIError.connectionError(
                    "Could not read virtual MIDI endpoint unique ID."
                )
            }
            
            uniqueID.writeID(successfulID)
            
        }
        
    }
    
}
