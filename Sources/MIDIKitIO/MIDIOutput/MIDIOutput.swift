//
//  MIDIOutput.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

/// A managed virtual MIDI output endpoint created in the system by the MIDI I/O ``MIDIManager``.
///
/// > Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible
/// call it by accessing the ``MIDIManager/managedOutputs`` collection. The ``MIDIManager`` owns
/// this object and maintains its lifecycle.
/// >
/// > Ensure that it is only stored weakly and only passed by reference temporarily in order to
/// execute an operation. If it absolutely must be stored strongly, ensure it is stored for no
/// longer than the lifecycle of the endpoint (which is either at such time the ``MIDIManager`` is
/// de-initialized, or when calling ``MIDIManager/remove(_:_:)`` with
/// ``MIDIManager/ManagedType/output`` or ``MIDIManager/removeAll()`` to destroy the managed
/// endpoint.)
public final class MIDIOutput: _MIDIManaged {
    // _MIDIManaged
    internal weak var midiManager: MIDIManager?
    
    // MIDIManaged
    public private(set) var api: CoreMIDIAPIVersion
    public var midiProtocol: MIDIProtocolVersion { api.midiProtocol }
    
    // MIDIManagedSendsMessages
    
    /// The Core MIDI output port reference.
    public private(set) var coreMIDIOutputPortRef: CoreMIDIPortRef?
    
    // class-specific
    
    /// The port name as displayed in the system.
    public private(set) var endpointName: String = ""
    
    /// The port's unique ID in the system.
    public private(set) var uniqueID: MIDIIdentifier?
    
    // init
    
    /// Internal init.
    /// This object is not meant to be instanced by the user. This object is automatically created
    /// and managed by the MIDI I/O ``MIDIManager`` instance when calling
    /// ``MIDIManager/addOutput(name:tag:uniqueID:)`` , and destroyed when calling
    /// ``MIDIManager/remove(_:_:)`` with ``MIDIManager/ManagedType/output`` or
    /// ``MIDIManager/removeAll()``.
    ///
    /// - Parameters:
    ///   - name: The port name as displayed in the system.
    ///   - uniqueID: The port's unique ID in the system.
    ///   - midiManager: Reference to parent ``MIDIManager`` object.
    ///   - api: Core MIDI API version.
    internal init(
        name: String,
        uniqueID: MIDIUniqueID? = nil,
        midiManager: MIDIManager,
        api: CoreMIDIAPIVersion = .bestForPlatform()
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

extension MIDIOutput {
    /// Returns the output's endpoint in the system.
    public var endpoint: MIDIOutputEndpoint {
        .init(from: coreMIDIOutputPortRef ?? 0)
    }
    
    /// Queries the system and returns the endpoint ref if the endpoint exists (by matching port
    /// name and unique ID)
    internal var uniqueIDExistsInSystem: MIDIEndpointRef? {
        guard let unwrappedUniqueID = uniqueID else {
            return nil
        }
    
        if let endpoint = getSystemSourceEndpoint(matching: unwrappedUniqueID) {
            return endpoint
        }
    
        return nil
    }
}

extension MIDIOutput {
    internal func create(in manager: MIDIManager) throws {
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
                throw MIDIIOError.internalInconsistency(
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
        try? setModel(of: newPortRef, to: manager.model)
        try? setManufacturer(of: newPortRef, to: manager.manufacturer)
    
        if let unwrappedUniqueID = uniqueID {
            // inject previously-stored unique ID into port
            try setUniqueID(
                of: newPortRef,
                to: unwrappedUniqueID
            )
        } else {
            // if managed ID is nil, either it was not supplied or it was already in use
            // so fetch the new ID from the port we just created
            uniqueID = .init(getUniqueID(of: newPortRef))
        }
    }
    
    /// Disposes of the the virtual port if it's already been created in the system via the
    /// `create()` method.
    ///
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    internal func dispose() throws {
        guard let unwrappedOutputPortRef = coreMIDIOutputPortRef else { return }
    
        defer { self.coreMIDIOutputPortRef = nil }
    
        try MIDIEndpointDispose(unwrappedOutputPortRef)
            .throwIfOSStatusErr()
    }
}

extension MIDIOutput: CustomStringConvertible {
    public var description: String {
        var uniqueIDString = "nil"
        if let unwrappedUniqueID = uniqueID {
            uniqueIDString = "\(unwrappedUniqueID)"
        }
    
        return "MIDIOutput(name: \(endpointName.quoted), uniqueID: \(uniqueIDString))"
    }
}

extension MIDIOutput: MIDIManagedSendsMessages {
    // empty
}

extension MIDIOutput: _MIDIManagedSendsMessages {
    internal func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        guard let unwrappedOutputPortRef = coreMIDIOutputPortRef else {
            throw MIDIIOError.internalInconsistency(
                "Port reference is nil."
            )
        }
    
        try MIDIReceived(unwrappedOutputPortRef, packetList)
            .throwIfOSStatusErr()
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    internal func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        guard let unwrappedOutputPortRef = coreMIDIOutputPortRef else {
            throw MIDIIOError.internalInconsistency(
                "Port reference is nil."
            )
        }
    
        try MIDIReceivedEventList(unwrappedOutputPortRef, eventList)
            .throwIfOSStatusErr()
    }
}

#endif
