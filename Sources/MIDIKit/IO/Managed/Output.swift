//
//  Output.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

extension MIDI.IO {
    
    /// A managed virtual MIDI output endpoint created in the system by the `Manager`.
    public class Output {
        
        /// The port name as displayed in the system.
        public private(set) var endpointName: String = ""
        
        /// The port's unique ID in the system.
        public private(set) var uniqueID: MIDI.IO.OutputEndpoint.UniqueID? = nil
        
        public private(set) var portRef: MIDIPortRef? = nil
        
        internal init(name: String,
                      uniqueID: MIDI.IO.OutputEndpoint.UniqueID? = nil) {
            
            self.endpointName = name
            self.uniqueID = uniqueID
            
        }
        
        deinit {
            
            _ = try? dispose()
            
        }
        
    }
    
}

extension MIDI.IO.Output {
    
    /// Queries the system and returns true if the endpoint exists (by matching port name and unique ID)
    public var uniqueIDExistsInSystem: MIDIEndpointRef? {
        
        guard let uniqueID = self.uniqueID else {
            return nil
        }
        
        if let endpoint = MIDI.IO.getSystemSourceEndpoint(matching: uniqueID.coreMIDIUniqueID) {
            return endpoint
        }
        
        return nil
        
    }
    
}

extension MIDI.IO.Output {
    
    internal func create(in manager: MIDI.IO.Manager) throws {
        
        if uniqueIDExistsInSystem != nil {
            // if uniqueID is already in use, set it to nil here
            // so MIDISourceCreate can return a new unused ID;
            // this should prevent errors thrown due to ID collisions in the system
            uniqueID = nil
        }
        
        var newPortRef = MIDIPortRef()
        
        if #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *) {
            try MIDISourceCreateWithProtocol(
                manager.clientRef,
                endpointName as CFString,
                ._1_0,
                &newPortRef
            )
            .throwIfOSStatusErr()
        } else {
            // MIDISourceCreate is deprecated after macOS 11 / iOS 14
            
            try MIDISourceCreate(
                manager.clientRef,
                endpointName as CFString,
                &newPortRef
            )
            .throwIfOSStatusErr()
        }
        
        portRef = newPortRef
        
        // set meta data properties; ignore errors in case of failure
        try? MIDI.IO.setModel(of: newPortRef, to: manager.model)
        try? MIDI.IO.setManufacturer(of: newPortRef, to: manager.manufacturer)
        
        if let uniqueID = self.uniqueID {
            // inject previously-stored unique ID into port
            try MIDI.IO.setUniqueID(of: newPortRef,
                                    to: uniqueID.coreMIDIUniqueID)
        } else {
            // if managed ID is nil, either it was not supplied or it was already in use
            // so fetch the new ID from the port we just created
            uniqueID = .init(MIDI.IO.getUniqueID(of: newPortRef))
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

extension MIDI.IO.Output: CustomStringConvertible {
    
    public var description: String {
        
        var uniqueIDString: String = "nil"
        if let uniqueID = uniqueID {
            uniqueIDString = "\(uniqueID)"
        }
        
        return "Output(name: \(endpointName.quoted), uniqueID: \(uniqueIDString))"
        
    }
    
}

extension MIDI.IO.Output: MIDIIOSendsMIDIMessagesProtocol {
    
    public func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        
        guard let portRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Port reference is nil."
            )
        }
        
        try MIDIReceived(portRef, packetList)
            .throwIfOSStatusErr()
        
    }
    
    @available(macOS 11, iOS 15, macCatalyst 15, *)
    public func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        
        guard let portRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Port reference is nil."
            )
        }
        
        try MIDIReceivedEventList(portRef, eventList)
            .throwIfOSStatusErr()
        
    }
    
}
