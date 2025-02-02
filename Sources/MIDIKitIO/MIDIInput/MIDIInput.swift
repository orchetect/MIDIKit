//
//  MIDIInput.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI
import MIDIKitCore

/// A managed virtual MIDI input endpoint created in the system by the MIDI I/O ``MIDIManager``.
///
/// > Note: Avoid storing or caching this object unless it is unavoidable. Instead, whenever
/// > possible access it via the ``MIDIManager/managedInputs`` collection. The ``MIDIManager`` owns
/// > this object and maintains its lifecycle.
/// >
/// > Ensure that it is only stored weakly and only passed by reference temporarily in order to
/// > execute an operation. If it absolutely must be stored strongly, ensure it is stored for no
/// > longer than the lifecycle of the managed thru connection (which is either at such time the
/// > ``MIDIManager`` is de-initialized, or when calling ``MIDIManager/remove(_:_:)`` with
/// > ``MIDIManager/ManagedType/input`` or ``MIDIManager/removeAll()`` to destroy the managed
/// > endpoint.)
public final class MIDIInput: MIDIManaged, @unchecked Sendable { // @unchecked required for @ThreadSafeAccess use
    weak nonisolated(unsafe) var midiManager: MIDIManager?
    
    // MIDIManaged
    public private(set) nonisolated(unsafe) var api: CoreMIDIAPIVersion
    
    // MIDIManagedReceivesMessages
    
    public var midiProtocol: MIDIProtocolVersion { api.midiProtocol }
    
    // class-specific
    
    /// The port name as displayed in the system.
    @ThreadSafeAccess
    public var name: String {
        didSet { setNameInSystem() }
    }
    
    /// Updates the endpoint's `name` property with Core MIDI.
    /// Core MIDI automatically updates the `displayName` property as well.
    private func setNameInSystem() {
        guard let ref = coreMIDIInputPortRef else { return }
        try? setString(forProperty: kMIDIPropertyName, of: ref, to: name)
    }
    
    /// The port's unique ID in the system.
    @ThreadSafeAccess
    public private(set) var uniqueID: MIDIIdentifier?
    
    /// The Core MIDI port reference.
    @ThreadSafeAccess
    public private(set) var coreMIDIInputPortRef: CoreMIDIPortRef?
    
    /// Receive handler for inbound MIDI events.
    @ThreadSafeAccess
    var receiveHandler: MIDIReceiverProtocol
    
    // init
    
    /// Internal init.
    /// This object is not meant to be instanced by the user. This object is automatically created
    /// and managed by the MIDI I/O ``MIDIManager`` instance when calling
    /// ``MIDIManager/addInputConnection(to:tag:filter:receiver:)-5xxyz``, and destroyed
    /// when calling ``MIDIManager/remove(_:_:)`` with ``MIDIManager/ManagedType/input`` or
    /// ``MIDIManager/removeAll()``.
    ///
    /// - Parameters:
    ///   - name: The port name as displayed in the system.
    ///   - uniqueID: The port's unique ID in the system.
    ///   - receiver: Receive handler to use for incoming MIDI messages.
    ///   - midiManager: Reference to parent ``MIDIManager`` object.
    ///   - api: Core MIDI API version.
    init(
        name: String,
        uniqueID: MIDIUniqueID? = nil,
        receiver: MIDIReceiver,
        midiManager: MIDIManager,
        api: CoreMIDIAPIVersion = .bestForPlatform()
    ) {
        self.midiManager = midiManager
        self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
        self.name = name
        self.uniqueID = uniqueID
        receiveHandler = receiver.create()
    }
    
    deinit {
        try? dispose()
    }
}

extension MIDIInput {
    /// Sets a new receiver.
    public func setReceiver(_ receiver: MIDIReceiver) {
        receiveHandler = receiver.create()
    }
}

extension MIDIInput {
    /// Returns the input's endpoint in the system.
    public var endpoint: MIDIInputEndpoint {
        .init(from: coreMIDIInputPortRef ?? 0)
    }
    
    /// Queries the system and returns true if the endpoint exists
    /// (by matching port name and unique ID)
    var uniqueIDExistsInSystem: MIDIEndpointRef? {
        guard let uniqueID else {
            return nil
        }
        
        if let endpoint = getSystemDestinationEndpoint(matching: uniqueID) {
            return endpoint
        }
        
        return nil
    }
}

extension MIDIInput {
    func create(in manager: MIDIManager) throws {
        if uniqueIDExistsInSystem != nil {
            // if uniqueID is already in use, set it to nil here
            // so MIDIDestinationCreateWithBlock can return a new unused ID;
            // this should prevent errors thrown due to ID collisions in the system
            uniqueID = nil
        }
        
        var newPortRef = MIDIPortRef()
        
        switch api {
        case .legacyCoreMIDI:
            // MIDIDestinationCreateWithBlock is deprecated after macOS 11 / iOS 14
            try MIDIDestinationCreateWithBlock(
                manager.coreMIDIClientRef,
                name as CFString,
                &newPortRef,
                { [weak self, weak queue = midiManager?.managementQueue] packetListPtr, srcConnRefCon in
                    let packets = packetListPtr.packets(refCon: srcConnRefCon, refConKnown: false)
                    
                    // we need to read the `receiveHandler` on the same queue that it was created on
                    // to satisfy the thread sanitizer.
                    let receiveHandler = queue?.sync { self?.receiveHandler }
                    receiveHandler?.packetListReceived(packets)
                }
            )
            .throwIfOSStatusErr()
            
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, *) else {
                throw MIDIIOError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
            
            try MIDIDestinationCreateWithProtocol(
                manager.coreMIDIClientRef,
                name as CFString,
                api.midiProtocol.coreMIDIProtocol,
                &newPortRef,
                { [weak self, weak queue = midiManager?.managementQueue] eventListPtr, srcConnRefCon in
                    let packets = eventListPtr.packets(refCon: srcConnRefCon, refConKnown: false)
                    let midiProtocol = MIDIProtocolVersion(eventListPtr.pointee.protocol)
                    
                    // we need to read the `receiveHandler` on the same queue that it was created on
                    // to satisfy the thread sanitizer.
                    let receiveHandler = queue?.sync { self?.receiveHandler }
                    receiveHandler?.eventListReceived(
                        packets,
                        protocol: midiProtocol
                    )
                }
            )
            .throwIfOSStatusErr()
        }
        
        coreMIDIInputPortRef = newPortRef
        
        // set meta data properties; ignore errors in case of failure
        try? setModel(of: newPortRef, to: manager.model)
        try? setManufacturer(of: newPortRef, to: manager.manufacturer)
        
        if let uniqueID {
            // inject previously-stored unique ID into port
            try setUniqueID(
                of: newPortRef,
                to: uniqueID
            )
        } else {
            // if managed ID is nil, either it was not supplied or it was already in use
            // so fetch the new ID from the port we just created
            uniqueID = .init(getUniqueID(of: newPortRef))
        }
    }
    
    /// Disposes of the the virtual port if it's already been created in the system via the
    /// ``create(in:)`` method.
    ///
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    func dispose() throws {
        guard let coreMIDIInputPortRef else { return }
    
        defer { self.coreMIDIInputPortRef = nil }
    
        try MIDIEndpointDispose(coreMIDIInputPortRef)
            .throwIfOSStatusErr()
    }
}

extension MIDIInput {
    /// Makes the virtual endpoint in the system invisible to the user.
    public func hide() throws {
        try endpoint.hide()
    }
    
    /// Makes the virtual endpoint in the system visible to the user.
    public func show() throws {
        try endpoint.show()
    }
}

extension MIDIInput: CustomStringConvertible {
    public var description: String {
        var uniqueIDString = "nil"
        if let uniqueID {
            uniqueIDString = "\(uniqueID)"
        }
        
        return "MIDIInput(name: \(name.quoted), uniqueID: \(uniqueIDString))"
    }
}

extension MIDIInput: MIDIManagedReceivesMessages { }

#endif
