//
//  MIDIInputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI
import MIDIKitCore

/// A managed MIDI input connection created in the system by the MIDI I/O ``MIDIManager``.
///
/// This connects to one or more outputs in the system and subscribes to receive their MIDI events.
/// It can also be instanced without providing any initial outputs and then outputs can be added or
/// removed later.
///
/// > Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible
/// > call it by accessing the ``MIDIManager/managedInputConnections`` collection. The
/// > ``MIDIManager`` owns this object and maintains its lifecycle.
/// >
/// > Ensure that it is only stored weakly and only passed by reference temporarily in order to
/// > execute an operation. If it absolutely must be stored strongly, ensure it is stored for no
/// > longer than the lifecycle of the managed input connection (which is either at such time the
/// > ``MIDIManager`` is de-initialized, or when calling ``MIDIManager/remove(_:_:)`` with
/// > ``MIDIManager/ManagedType/inputConnection`` or ``MIDIManager/removeAll()`` to destroy the
/// > managed connection.)
public final class MIDIInputConnection: MIDIManaged, @unchecked Sendable { // @unchecked required for @ThreadSafeAccess use
    nonisolated(unsafe) weak var midiManager: MIDIManager?
    
    // MIDIManaged
    
    public private(set) nonisolated(unsafe) var api: CoreMIDIAPIVersion
    
    // MIDIManagedReceivesMessages
    
    public var midiProtocol: MIDIProtocolVersion { api.midiProtocol }
    
    // class-specific
    
    @ThreadSafeAccess
    public private(set) var outputsCriteria: Set<MIDIEndpointIdentity> = []
    
    /// Stores criteria after applying any filters that have been set in the ``filter`` property.
    /// Passing nil will re-use existing criteria, re-applying the filters.
    private func updateCriteria(
        _ criteria: Set<MIDIEndpointIdentity>? = nil
    ) {
        var newCriteria = criteria ?? outputsCriteria
    
        if filter.owned,
           let midiManager
        {
            let managedOutputs: [MIDIEndpointIdentity] = midiManager.managedOutputs
                .compactMap { $0.value.uniqueID }
                .map { .uniqueID($0) }
    
            newCriteria = newCriteria
                .filter { !managedOutputs.contains($0) }
        }
    
        if !filter.criteria.isEmpty {
            newCriteria = newCriteria
                .filter { !filter.criteria.contains($0) }
        }
    
        outputsCriteria = newCriteria
    }
    
    /// The Core MIDI input port reference.
    @ThreadSafeAccess
    public private(set) var coreMIDIInputPortRef: CoreMIDIPortRef?
    
    /// The Core MIDI output endpoint(s) reference(s).
    @ThreadSafeAccess
    public private(set) var coreMIDIOutputEndpointRefs: Set<CoreMIDIEndpointRef> = []
    
    /// Internal:
    /// The Core MIDI output endpoint(s) reference(s) stored as `NSNumber` classes.
    /// This is only so that `MIDIPortConnectSource()` can take stable pointer references.
    @ThreadSafeAccess
    var coreMIDIOutputEndpointRefCons: Set<NSNumber> = []
    
    /// Operating mode.
    ///
    /// Changes take effect immediately.
    @ThreadSafeAccess
    public var mode: MIDIInputConnectionMode {
        didSet {
            guard mode != oldValue else { return }
            guard let midiManager else { return }
            updateCriteriaFromMode()
            try? refreshConnection(in: midiManager)
        }
    }
    
    /// Reads the ``mode`` property and applies it to the stored criteria.
    private func updateCriteriaFromMode() {
        switch mode {
        case .outputs:
            updateCriteria()
    
        case .allOutputs:
            updateCriteria(.currentOutputs())
        }
    }
    
    /// Endpoint filter.
    ///
    /// Changes take effect immediately.
    @ThreadSafeAccess
    public var filter: MIDIEndpointFilter {
        didSet {
            guard filter != oldValue else { return }
            guard let midiManager else { return }
            updateCriteria()
            try? refreshConnection(in: midiManager)
        }
    }
    
    /// Receive handler for inbound MIDI events.
    @ThreadSafeAccess
    var receiveHandler: MIDIReceiverProtocol
    
    // init
    
    /// Internal init.
    /// This object is not meant to be instanced by the user. This object is automatically created
    /// and managed by the MIDI I/O ``MIDIManager`` instance when calling
    /// ``MIDIManager/addInputConnection(to:tag:filter:receiver:)-5xxyz``, and destroyed
    /// when calling ``MIDIManager/remove(_:_:)`` with ``MIDIManager/ManagedType/inputConnection``
    /// or ``MIDIManager/removeAll()``.
    ///
    /// - Parameters:
    ///   - criteria: Output(s) to connect to.
    ///   - mode: Operation mode.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to
    ///     the connection.
    ///   - receiver: Receive handler to use for incoming MIDI messages.
    ///   - midiManager: Reference to parent ``MIDIManager`` object.
    ///   - api: Core MIDI API version.
    init(
        mode: MIDIInputConnectionMode,
        filter: MIDIEndpointFilter,
        receiver: MIDIReceiver,
        midiManager: MIDIManager,
        api: CoreMIDIAPIVersion = .bestForPlatform()
    ) {
        self.midiManager = midiManager
        self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
        self.mode = mode
        self.filter = filter
        receiveHandler = receiver.create()
        
        switch mode {
        case let .outputs(criteria):
            updateCriteria(criteria)
        case .allOutputs:
            updateCriteriaFromMode()
        }
    }
    
    deinit {
        try? disconnect()
        try? stopListening()
    }
}

extension MIDIInputConnection {
    /// Sets a new receiver.
    public func setReceiver(_ receiver: MIDIReceiver) {
        midiManager?.managementQueue.sync {
            receiveHandler = receiver.create()
        }
    }
}

extension MIDIInputConnection {
    /// Returns the output endpoint(s) this connection is connected to.
    public var endpoints: [MIDIOutputEndpoint] {
        coreMIDIOutputEndpointRefs.map { MIDIOutputEndpoint(from: $0) }
    }
}

extension MIDIInputConnection {
    /// Create a MIDI Input port with which to subsequently connect to MIDI Output(s).
    ///
    /// - Parameter manager: `MIDIManager` instance by reference
    ///
    /// - Throws: ``MIDIIOError``
    func listen(in manager: MIDIManager) throws {
        guard coreMIDIInputPortRef == nil else {
            // if we're already listening, it's not really an error condition
            // so just return; don't throw an error
            return
        }
        
        var newInputPortRef = MIDIPortRef()
        
        // connection name must be unique, otherwise process might hang (?)
        
        switch api {
        case .legacyCoreMIDI:
            // MIDIInputPortCreateWithBlock is deprecated after macOS 11 / iOS 14
            try MIDIInputPortCreateWithBlock(
                manager.coreMIDIClientRef,
                UUID().uuidString as CFString,
                &newInputPortRef,
                { [weak self, weak queue = midiManager?.managementQueue] packetListPtr, srcConnRefCon in
                    let packets = packetListPtr.packets(
                        refCon: srcConnRefCon,
                        refConKnown: true
                    )
                    
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
            
            try MIDIInputPortCreateWithProtocol(
                manager.coreMIDIClientRef,
                UUID().uuidString as CFString,
                api.midiProtocol.coreMIDIProtocol,
                &newInputPortRef,
                { [weak self, weak queue = midiManager?.managementQueue] eventListPtr, srcConnRefCon in
                    let packets = eventListPtr.packets(
                        refCon: srcConnRefCon,
                        refConKnown: true
                    )
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
        
        coreMIDIInputPortRef = newInputPortRef
    }
    
    /// Disposes of the listening port if it exists.
    func stopListening() throws {
        guard let coreMIDIInputPortRef else { return }
    
        defer { self.coreMIDIInputPortRef = nil }
    
        try MIDIPortDispose(coreMIDIInputPortRef)
            .throwIfOSStatusErr()
    }
    
    /// Connect to MIDI Output(s).
    ///
    /// - Parameters:
    ///   - manager: `MIDIManager` instance by reference.
    ///   - disconnectStale: Disconnects stale connections that no longer match criteria.
    ///
    /// - Throws: ``MIDIIOError``
    func connect(
        in manager: MIDIManager
    ) throws {
        // if not already listening, start listening
        if coreMIDIInputPortRef == nil {
            try listen(in: manager)
        }
        
        guard let coreMIDIInputPortRef else {
            throw MIDIIOError.connectionError(
                "Not in a listening state; can't connect to endpoints."
            )
        }
        
        // if previously connected, clean the old connections. ignore errors.
        try? disconnect()
        
        // resolve criteria to endpoints in the system
        let getOutputEndpointRefs = outputsCriteria
            .compactMap {
                $0.locate(in: manager.endpoints.outputs)?
                    .coreMIDIObjectRef
            }
        
        coreMIDIOutputEndpointRefs = Set(getOutputEndpointRefs)
        
        coreMIDIOutputEndpointRefCons = Set(coreMIDIOutputEndpointRefs.map {
            NSNumber(value: $0)
        })
        
        for nsNumRef in coreMIDIOutputEndpointRefCons {
            // supply the endpoint object ref
            // FYI: this method does not hold a strong reference to refCon. you MUST have a strong stable reference even for value types. or we get lovely crashes.
            try? MIDIPortConnectSource(
                coreMIDIInputPortRef,
                nsNumRef.uint32Value,
                Unmanaged.passUnretained(nsNumRef).toOpaque()
            )
            .throwIfOSStatusErr()
        }
    }
    
    /// Disconnects connections if any are currently connected.
    /// If nil is passed, the all of the connection's endpoint refs will be disconnected.
    ///
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    func disconnect(
        endpointRefs: Set<MIDIEndpointRef>? = nil
    ) throws {
        guard let coreMIDIInputPortRef else {
            throw MIDIIOError.connectionError(
                "Attempted to disconnect outputs but was not in a listening state; nothing to disconnect."
            )
        }
        
        let refs = endpointRefs ?? coreMIDIOutputEndpointRefs
        
        for outputEndpointRef in refs {
            do {
                try MIDIPortDisconnectSource(
                    coreMIDIInputPortRef,
                    outputEndpointRef
                )
                .throwIfOSStatusErr()
            } catch {
                // ignore errors
            }
        }
    }
    
    /// Refresh the connection.
    /// This is typically called after receiving a Core MIDI notification that system port
    /// configuration has changed or endpoints were added/removed.
    func refreshConnection(in manager: MIDIManager) throws {
        // call (re-)connect only if at least one matching endpoint exists in the system
        
        let getSystemOutputs = manager.endpoints.outputs
        
        var matchedEndpointCount = 0
        
        for criteria in outputsCriteria {
            if criteria.locate(in: getSystemOutputs) != nil { matchedEndpointCount += 1 }
        }
        
        try connect(in: manager)
    }
}

extension MIDIInputConnection {
    // MARK: Add Endpoints
    
    /// Add output endpoints to the connection.
    /// Endpoint filters are respected.
    public func add(
        outputs: [MIDIEndpointIdentity]
    ) {
        let combined = outputsCriteria.union(outputs)
        updateCriteria(combined)
        
        if let midiManager {
            // this will re-generate coreMIDIOutputEndpointRefs and call connect()
            try? refreshConnection(in: midiManager)
        }
    }
    
    /// Add output endpoints to the connection.
    /// Endpoint filters are respected.
    @_disfavoredOverload
    public func add(
        outputs: [MIDIOutputEndpoint]
    ) {
        add(outputs: outputs.asIdentities())
    }
    
    // MARK: Remove Endpoints
    
    /// Remove output endpoints to the connection.
    public func remove(
        outputs: [MIDIEndpointIdentity]
    ) {
        let removed = outputsCriteria.subtracting(outputs)
        updateCriteria(removed)
        
        if let midiManager {
            let refs = outputs
                .compactMap {
                    $0.locate(in: midiManager.endpoints.outputs)?
                        .coreMIDIObjectRef
                }
            
            // disconnect removed endpoints first
            try? disconnect(endpointRefs: Set(refs))
            
            // this will regenerate cached refs
            try? refreshConnection(in: midiManager)
        }
    }
    
    /// Remove output endpoints to the connection.
    @_disfavoredOverload
    public func remove(
        outputs: [MIDIOutputEndpoint]
    ) {
        remove(outputs: outputs.asIdentities())
    }
    
    public func removeAllOutputs() {
        let outputsToDisconnect = outputsCriteria
        updateCriteria([])
        remove(outputs: Array(outputsToDisconnect))
    }
}

extension MIDIInputConnection {
    func notification(_ internalNotification: MIDIIOInternalNotification) {
        if mode == .allOutputs,
           let notif = MIDIIONotification(internalNotification, cache: nil),
           case .added(object: let object, parent: _) = notif,
           case let .outputEndpoint(newOutput) = object
        {
            add(outputs: [newOutput])
            return
        }
    
        switch internalNotification {
        case .setupChanged, .added, .removed:
            if let midiManager {
                try? refreshConnection(in: midiManager)
            }
            
        default:
            break
        }
    }
}

extension MIDIInputConnection: CustomStringConvertible {
    public var description: String {
        let outputEndpointsString: [String] = coreMIDIOutputEndpointRefs.map {
            // ref
            var str = "\($0):"
            
            // name
            if let getName = try? getName(of: $0) {
                str += "\(getName)".quoted
            } else {
                str += "nil"
            }
            
            return str
        }
    
        var inputPortRefString = "nil"
        if let coreMIDIInputPortRef {
            inputPortRefString = "\(coreMIDIInputPortRef)"
        }
        
        return "MIDIInputConnection(criteria: \(outputsCriteria), outputEndpointRefs: \(outputEndpointsString), inputPortRef: \(inputPortRefString))"
    }
}

extension MIDIInputConnection: MIDIManagedReceivesMessages {
    // empty
}

#endif
