//
//  Input.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDI.IO {
    
    /// A managed virtual MIDI input endpoint created in the system by the `Manager`.
    public class Input {
        
        /// The port name as displayed in the system.
        public private(set) var endpointName: String = ""
        
        /// The port's unique ID in the system.
        public private(set) var uniqueID: MIDI.IO.UniqueID? = nil
        
        public private(set) var portRef: MIDIPortRef? = nil
        
        internal var receiveHandler: ReceiveHandler
        
        internal init(name: String,
                      uniqueID: MIDI.IO.UniqueID? = nil,
                      receiveHandler: ReceiveHandler) {
            
            self.endpointName = name
            self.uniqueID = uniqueID
            self.receiveHandler = receiveHandler
            
        }
        
        deinit {
            
            _ = try? dispose()
            
        }
        
    }
    
}

extension MIDI.IO.Input {
    
    /// Queries the system and returns true if the endpoint exists (by matching port name and unique ID)
    internal var uniqueIDExistsInSystem: MIDIEndpointRef? {
        
        guard let uniqueID = self.uniqueID else {
            return nil
        }
        
        if let endpoint = MIDI.IO.getSystemDestinationEndpoint(matching: uniqueID.id) {
            return endpoint
        }
        
        return nil
        
    }
    
}

extension MIDI.IO.Input {
    
    internal func create(in manager: MIDI.IO.Manager) throws {
        
        if uniqueIDExistsInSystem != nil {
            // if uniqueID is already in use, set it to nil here
            // so MIDIDestinationCreateWithBlock can return a new unused ID;
            // this should prevent errors thrown due to ID collisions in the system
            uniqueID = nil
        }
        
        var newPortRef = MIDIPortRef()
        
        try MIDIDestinationCreateWithBlock(
            manager.clientRef,
            endpointName as CFString,
            &newPortRef,
            receiveHandler.midiReadBlock
        )
        .throwIfOSStatusErr()
        
        portRef = newPortRef
        
        // set meta data properties; ignore errors in case of failure
        try? MIDI.IO.setModel(of: newPortRef, to: manager.model)
        try? MIDI.IO.setManufacturer(of: newPortRef, to: manager.manufacturer)
        
        if let uniqueID = self.uniqueID {
            // inject previously-stored unique ID into port
            try MIDI.IO.setUniqueID(of: newPortRef,
                                    to: uniqueID)
        } else {
            // if managed ID is nil, either it was not supplied or it was already in use
            // so fetch the new ID from the port we just created
            uniqueID = MIDI.IO.getUniqueID(of: newPortRef)
        }
        
    }
    
    /// Disposes of the the virtual port if it's already been created in the system via the `create()` method.
    ///
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    internal func dispose() throws {
        
        guard let portRef = self.portRef else { return }
        
        defer { self.portRef = nil }
        
        try MIDIEndpointDispose(portRef)
            .throwIfOSStatusErr()
        
    }
    
}

extension MIDI.IO.Input: CustomStringConvertible {
    
    public var description: String {
        
        let uniqueID = "\(self.uniqueID, ifNil: "nil")"
        
        return "Input(name: \(endpointName.quoted), uniqueID: \(uniqueID))"
        
    }
    
}
