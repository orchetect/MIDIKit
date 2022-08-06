//
//  Output.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    /// A managed virtual MIDI output endpoint created in the system by the MIDI I/O `Manager`.
    ///
    /// - Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible call it by accessing the `Manager`'s `managedOutputs` collection.
    ///
    /// Ensure that it is only stored weakly and only passed by reference temporarily in order to execute an operation. If it absolutely must be stored strongly, ensure it is stored for no longer than the lifecycle of the endpoint (which is either at such time the `Manager` is de-initialized, or when calling `.remove(.output, ...)` or `.removeAll` on the `Manager` to destroy the managed output.)
    public class Output: _MIDIIOManagedProtocol {
        // _MIDIIOManagedProtocol
        internal weak var midiManager: MIDI.IO.Manager?
        
        // MIDIIOManagedProtocol
        public private(set) var api: APIVersion
        public var midiProtocol: MIDI.IO.ProtocolVersion { api.midiProtocol }
        
        // MIDIIOSendsMIDIMessagesProtocol
        
        /// The Core MIDI output port reference.
        public private(set) var coreMIDIOutputPortRef: MIDI.IO.PortRef?
        
        // class-specific
        
        /// The port name as displayed in the system.
        public private(set) var endpointName: String = ""
        
        /// The port's unique ID in the system.
        public private(set) var uniqueID: MIDI.IO.UniqueID?
        
        // init
        
        /// Internal init.
        /// This object is not meant to be instanced by the user. This object is automatically created and managed by the MIDI I/O `Manager` instance when calling `.addOutput()`, and destroyed when calling `.remove(.output, ...)` or `.removeAll()`.
        ///
        /// - Parameters:
        ///   - name: The port name as displayed in the system.
        ///   - uniqueID: The port's unique ID in the system.
        ///   - midiManager: Reference to I/O Manager object.
        ///   - api: Core MIDI API version.
        internal init(
            name: String,
            uniqueID: MIDI.IO.UniqueID? = nil,
            midiManager: MIDI.IO.Manager,
            api: MIDI.IO.APIVersion = .bestForPlatform()
        ) {
            endpointName = name
            self.uniqueID = uniqueID
            self.midiManager = midiManager
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
        }
        
        deinit {
            try? dispose()
        }
    }
}

extension MIDI.IO.Output {
    /// Returns the output's endpoint in the system.
    public var endpoint: MIDI.IO.OutputEndpoint {
        .init(coreMIDIOutputPortRef ?? 0)
    }
    
    /// Queries the system and returns the endpoint ref if the endpoint exists (by matching port name and unique ID)
    internal var uniqueIDExistsInSystem: MIDIEndpointRef? {
        guard let unwrappedUniqueID = uniqueID else {
            return nil
        }
        
        if let endpoint = MIDI.IO.getSystemSourceEndpoint(matching: unwrappedUniqueID) {
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
                manager.coreMIDIClientRef,
                endpointName as CFString,
                &newPortRef
            )
            .throwIfOSStatusErr()
            
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, *) else {
                throw MIDI.IO.MIDIError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
            
            try MIDISourceCreateWithProtocol(
                manager.coreMIDIClientRef,
                endpointName as CFString,
                api.midiProtocol.coreMIDIProtocol,
                &newPortRef
            )
            .throwIfOSStatusErr()
        }
        
        coreMIDIOutputPortRef = newPortRef
        
        // set meta data properties; ignore errors in case of failure
        try? MIDI.IO.setModel(of: newPortRef, to: manager.model)
        try? MIDI.IO.setManufacturer(of: newPortRef, to: manager.manufacturer)
        
        if let unwrappedUniqueID = uniqueID {
            // inject previously-stored unique ID into port
            try MIDI.IO.setUniqueID(
                of: newPortRef,
                to: unwrappedUniqueID
            )
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
        guard let unwrappedOutputPortRef = coreMIDIOutputPortRef else { return }
        
        defer { self.coreMIDIOutputPortRef = nil }
        
        try MIDIEndpointDispose(unwrappedOutputPortRef)
            .throwIfOSStatusErr()
    }
}

extension MIDI.IO.Output: CustomStringConvertible {
    public var description: String {
        var uniqueIDString = "nil"
        if let unwrappedUniqueID = uniqueID {
            uniqueIDString = "\(unwrappedUniqueID)"
        }
        
        return "Output(name: \(endpointName.quoted), uniqueID: \(uniqueIDString))"
    }
}

extension MIDI.IO.Output: MIDIIOSendsMIDIMessagesProtocol {
    // empty
}

extension MIDI.IO.Output: _MIDIIOSendsMIDIMessagesProtocol {
    internal func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        guard let unwrappedOutputPortRef = coreMIDIOutputPortRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Port reference is nil."
            )
        }
        
        try MIDIReceived(unwrappedOutputPortRef, packetList)
            .throwIfOSStatusErr()
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    internal func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        guard let unwrappedOutputPortRef = coreMIDIOutputPortRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Port reference is nil."
            )
        }
        
        try MIDIReceivedEventList(unwrappedOutputPortRef, eventList)
            .throwIfOSStatusErr()
    }
}

#endif
