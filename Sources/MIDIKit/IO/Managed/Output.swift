//
//  Output.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

extension MIDI.IO {
    
    /// A managed virtual MIDI output endpoint created in the system by the `Manager`.
    public class Output: MIDIIOManagedProtocol {
        
        // MIDIIOManagedProtocol
        public weak var midiManager: Manager?
        public private(set) var api: APIVersion
        public var midiProtocol: MIDI.IO.ProtocolVersion { api.midiProtocol }
        
        /// The port name as displayed in the system.
        public private(set) var endpointName: String = ""
        
        /// The port's unique ID in the system.
        public private(set) var uniqueID: MIDI.IO.OutputEndpoint.UniqueID? = nil
        
        public private(set) var portRef: MIDIPortRef? = nil
        
        internal init(name: String,
                      uniqueID: MIDI.IO.OutputEndpoint.UniqueID? = nil,
                      midiManager: MIDI.IO.Manager,
                      api: APIVersion = .bestForPlatform()) {
            
            self.endpointName = name
            self.uniqueID = uniqueID
            self.midiManager = midiManager
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
            
        }
        
        deinit {
            
            _ = try? dispose()
            
        }
        
    }
    
}

extension MIDI.IO.Output {
    
    /// Queries the system and returns true if the endpoint exists (by matching port name and unique ID)
    public var uniqueIDExistsInSystem: MIDIEndpointRef? {
        
        guard let unwrappedUniqueID = self.uniqueID else {
            return nil
        }
        
        if let endpoint = MIDI.IO.getSystemSourceEndpoint(matching: unwrappedUniqueID.coreMIDIUniqueID) {
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
        
        switch api {
        case .legacyCoreMIDI:
            // MIDISourceCreate is deprecated after macOS 11 / iOS 14
            try MIDISourceCreate(
                manager.clientRef,
                endpointName as CFString,
                &newPortRef
            )
            .throwIfOSStatusErr()
            
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *) else {
                throw MIDI.IO.MIDIError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
            
            try MIDISourceCreateWithProtocol(
                manager.clientRef,
                endpointName as CFString,
                self.api.midiProtocol.coreMIDIProtocol,
                &newPortRef
            )
            .throwIfOSStatusErr()
            
        }
        
        portRef = newPortRef
        
        // set meta data properties; ignore errors in case of failure
        _ = try? MIDI.IO.setModel(of: newPortRef, to: manager.model)
        _ = try? MIDI.IO.setManufacturer(of: newPortRef, to: manager.manufacturer)
        
        if let unwrappedUniqueID = self.uniqueID {
            // inject previously-stored unique ID into port
            try MIDI.IO.setUniqueID(of: newPortRef,
                                    to: unwrappedUniqueID.coreMIDIUniqueID)
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
        
        guard let unwrappedPortRef = self.portRef else { return }
        
        defer { self.portRef = nil }
        
        try MIDIEndpointDispose(unwrappedPortRef)
            .throwIfOSStatusErr()
        
    }
    
}

extension MIDI.IO.Output: CustomStringConvertible {
    
    public var description: String {
        
        var uniqueIDString: String = "nil"
        if let unwrappedUniqueID = uniqueID {
            uniqueIDString = "\(unwrappedUniqueID)"
        }
        
        return "Output(name: \(endpointName.quoted), uniqueID: \(uniqueIDString))"
        
    }
    
}

extension MIDI.IO.Output: MIDIIOSendsMIDIMessagesProtocol {
    
    public func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        
        guard let unwrappedPortRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Port reference is nil."
            )
        }
        
        try MIDIReceived(unwrappedPortRef, packetList)
            .throwIfOSStatusErr()
        
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    public func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        
        guard let unwrappedPortRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Port reference is nil."
            )
        }
        
        try MIDIReceivedEventList(unwrappedPortRef, eventList)
            .throwIfOSStatusErr()
        
    }
    
}
