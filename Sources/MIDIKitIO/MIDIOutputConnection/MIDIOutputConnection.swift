//
//  MIDIOutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI
import MIDIKitCore

/// A managed MIDI output connection created in the system by the MIDI I/O ``MIDIManager``.
///
/// This connects to one or more inputs in the system and outputs MIDI events to them. It can also
/// be instanced without providing any initial inputs and then inputs can be added or removed later.
///
/// > Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible
/// > call it by accessing the ``MIDIManager/managedOutputConnections`` collection. The
/// > ``MIDIManager`` owns this object and maintains its lifecycle.
/// >
/// > Ensure that it is only stored weakly and only passed by reference temporarily in order to
/// > execute an operation. If it absolutely must be stored strongly, ensure it is stored for no
/// > longer than the lifecycle of the managed output connection (which is either at such time the
/// > ``MIDIManager`` is de-initialized, or when calling ``MIDIManager/remove(_:_:)`` with
/// > ``MIDIManager/ManagedType/outputConnection`` or ``MIDIManager/removeAll()`` to destroy the
/// > managed connection.)
public final class MIDIOutputConnection: MIDIManaged, @unchecked Sendable { // @unchecked required for @ThreadSafeAccess use
    weak nonisolated(unsafe) var midiManager: MIDIManager?
    
    // MIDIManaged
    
    public private(set) nonisolated(unsafe) var api: CoreMIDIAPIVersion
    
    // MIDIManagedSendsMessages
    
    public var midiProtocol: MIDIProtocolVersion { api.midiProtocol }
    
    /// The Core MIDI output port reference.
    @ThreadSafeAccess
    public private(set) var coreMIDIOutputPortRef: CoreMIDIPortRef?
    
    // class-specific
    
    @ThreadSafeAccess
    public private(set) var inputsCriteria: Set<MIDIEndpointIdentity> = []
    
    /// Stores criteria after applying any filters that have been set in the ``filter`` property.
    /// Passing nil will re-use existing criteria, re-applying the filters.
    private func updateCriteria(
        _ criteria: Set<MIDIEndpointIdentity>? = nil
    ) {
        var newCriteria = criteria ?? inputsCriteria
    
        if filter.owned,
           let midiManager
        {
            let managedInputs: [MIDIEndpointIdentity] = midiManager.managedInputs
                .compactMap { $0.value.uniqueID }
                .map { .uniqueID($0) }
    
            newCriteria = newCriteria
                .filter { !managedInputs.contains($0) }
        }
    
        if !filter.criteria.isEmpty {
            newCriteria = newCriteria
                .filter { !filter.criteria.contains($0) }
        }
    
        inputsCriteria = newCriteria
    }
    
    /// The Core MIDI input endpoint(s) reference(s).
    @ThreadSafeAccess
    public private(set) var coreMIDIInputEndpointRefs: Set<CoreMIDIEndpointRef> = []
    
    /// Operating mode.
    ///
    /// Changes take effect immediately.
    @ThreadSafeAccess
    public var mode: MIDIOutputConnectionMode {
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
        case .inputs:
            updateCriteria()
    
        case .allInputs:
            updateCriteria(.currentInputs())
        }
    }
    
    /// Endpoint filter.
    ///
    /// Changes take effect immediately.
    public var filter: MIDIEndpointFilter {
        didSet {
            guard filter != oldValue else { return }
            guard let midiManager else { return }
            updateCriteria()
            try? refreshConnection(in: midiManager)
        }
    }
    
    // init
    
    /// Internal init.
    /// This object is not meant to be instanced by the user. This object is automatically created
    /// and managed by the MIDI I/O ``MIDIManager`` instance when calling
    /// ``MIDIManager/addOutputConnection(to:tag:filter:)-3a56s``, and destroyed when
    /// calling ``MIDIManager/remove(_:_:)`` with ``MIDIManager/ManagedType/outputConnection`` or
    /// ``MIDIManager/removeAll()`` to destroy the managed connection.)
    ///
    /// - Parameters:
    ///   - criteria: Input(s) to connect to.
    ///   - mode: Operation mode.
    ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to
    ///     the connection.
    ///   - midiManager: Reference to parent ``MIDIManager`` object.
    ///   - api: Core MIDI API version.
    init(
        mode: MIDIOutputConnectionMode,
        filter: MIDIEndpointFilter,
        midiManager: MIDIManager,
        api: CoreMIDIAPIVersion = .bestForPlatform()
    ) {
        self.midiManager = midiManager
        self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
        self.mode = mode
        self.filter = filter
    
        // relies on midiManager, mode, and filter being set first
        switch mode {
        case let .inputs(criteria):
            updateCriteria(criteria)
        case .allInputs:
            updateCriteriaFromMode()
        }
    }
    
    deinit {
        try? closeOutput()
    }
}

extension MIDIOutputConnection {
    /// Returns the input endpoint(s) this connection is connected to.
    public var endpoints: [MIDIInputEndpoint] {
        coreMIDIInputEndpointRefs.map { MIDIInputEndpoint(from: $0) }
    }
}

extension MIDIOutputConnection {
    /// Set up a single "invisible" output port which can send events to all inputs.
    ///
    /// - Parameter manager: ``MIDIManager`` instance by reference
    ///
    /// - Throws: ``MIDIIOError``
    func setupOutput(in manager: MIDIManager) throws {
        guard coreMIDIOutputPortRef == nil else {
            // if we already set the output port up, it's not really an error condition
            // so just return; don't throw an error
            return
        }
    
        var newOutputPortRef = MIDIPortRef()
    
        // connection name must be unique, otherwise process might hang (?)
        try? MIDIOutputPortCreate(
            manager.coreMIDIClientRef,
            UUID().uuidString as CFString,
            &newOutputPortRef
        )
        .throwIfOSStatusErr()
    
        coreMIDIOutputPortRef = newOutputPortRef
    }
    
    /// Disposes of the output port if it exists.
    func closeOutput() throws {
        guard let coreMIDIOutputPortRef else { return }
    
        defer { self.coreMIDIOutputPortRef = nil }
    
        try MIDIPortDispose(coreMIDIOutputPortRef)
            .throwIfOSStatusErr()
    }
    
    /// Resolve MIDI Input(s) criteria to concrete reference IDs and cache them.
    ///
    /// - Parameter manager: ``MIDIManager`` instance by reference
    ///
    /// - Throws: ``MIDIIOError``
    func resolveEndpoints(in manager: MIDIManager) throws {
        // resolve criteria to endpoints in the system
        let getInputEndpointRefs = inputsCriteria
            .compactMap {
                $0.locate(in: manager.endpoints.inputs)?
                    .coreMIDIObjectRef
            }
    
        coreMIDIInputEndpointRefs = Set(getInputEndpointRefs)
    }
    
    /// Refresh the connection.
    /// This is typically called after receiving a Core MIDI notification that system port
    /// configuration has changed or endpoints were added/removed.
    func refreshConnection(in manager: MIDIManager) throws {
        // re-resolve endpoints only if at least one matching endpoint exists in the system
    
        let getSystemInputs = manager.endpoints.inputs
    
        var matchedEndpointCount = 0
    
        for criteria in inputsCriteria {
            if criteria.locate(in: getSystemInputs) != nil { matchedEndpointCount += 1 }
        }
    
        try resolveEndpoints(in: manager)
    }
}

extension MIDIOutputConnection {
    // MARK: Add Endpoints
    
    /// Add input endpoints from the connection.
    /// Endpoint filters are respected.
    public func add(
        inputs: [MIDIEndpointIdentity]
    ) {
        let combined = inputsCriteria.union(inputs)
        updateCriteria(combined)
    
        if let midiManager {
            // this will re-generate coreMIDIInputEndpointRefs
            try? refreshConnection(in: midiManager)
        }
    }
    
    /// Add input endpoints from the connection.
    /// Endpoint filters are respected.
    @_disfavoredOverload
    public func add(
        inputs: [MIDIInputEndpoint]
    ) {
        add(inputs: inputs.asIdentities())
    }
    
    // MARK: Remove Endpoints
    
    /// Remove input endpoints from the connection.
    public func remove(
        inputs: [MIDIEndpointIdentity]
    ) {
        let removed = inputsCriteria.subtracting(inputs)
        updateCriteria(removed)
    
        if let midiManager {
            // this will re-generate coreMIDIInputEndpointRefs
            try? refreshConnection(in: midiManager)
        }
    }
    
    /// Remove input endpoints from the connection.
    @_disfavoredOverload
    public func remove(
        inputs: [MIDIInputEndpoint]
    ) {
        remove(inputs: inputs.asIdentities())
    }
    
    /// Remove all input endpoints from the connection.
    public func removeAllInputs() {
        let inputsToDisconnect = inputsCriteria
        updateCriteria([])
        remove(inputs: Array(inputsToDisconnect))
    }
}

extension MIDIOutputConnection {
    func notification(_ internalNotification: MIDIIOInternalNotification) {
        if mode == .allInputs,
           let notif = MIDIIONotification(internalNotification, cache: nil),
           case .added(object: let object, parent: _) = notif,
           case let .inputEndpoint(newInput) = object
        {
            add(inputs: [newInput])
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

extension MIDIOutputConnection: CustomStringConvertible {
    public var description: String {
        let inputEndpointsString: [String] = coreMIDIInputEndpointRefs
            .map {
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
    
        var outputPortRefString = "nil"
        if let coreMIDIOutputPortRef {
            outputPortRefString = "\(coreMIDIOutputPortRef)"
        }
    
        return "MIDIOutputConnection(criteria: \(inputsCriteria), inputEndpointRefs: \(inputEndpointsString), outputPortRef: \(outputPortRefString))"
    }
}

extension MIDIOutputConnection: MIDIManagedSendsMessages {
    // empty
}

extension MIDIOutputConnection: _MIDIManagedSendsMessages {
    func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        guard let coreMIDIOutputPortRef else {
            throw MIDIIOError.internalInconsistency(
                "Output port reference is nil."
            )
        }
    
        // dispatch the packetlist to each input independently
        // but we can use the same output port
    
        for inputEndpointRef in coreMIDIInputEndpointRefs {
            // ignore errors with try? since we don't want to return early in the event that sending
            // to subsequent inputs may succeed
            try? MIDISend(
                coreMIDIOutputPortRef,
                inputEndpointRef,
                packetList
            )
            .throwIfOSStatusErr()
        }
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        guard let coreMIDIOutputPortRef else {
            throw MIDIIOError.internalInconsistency(
                "Output port reference is nil."
            )
        }
    
        // dispatch the eventlist to each input independently
        // but we can use the same output port
    
        for inputEndpointRef in coreMIDIInputEndpointRefs {
            // ignore errors with try? since we don't want to return early in the event that sending
            // to subsequent inputs may succeed
            try? MIDISendEventList(
                coreMIDIOutputPortRef,
                inputEndpointRef,
                eventList
            )
            .throwIfOSStatusErr()
        }
    }
}

#endif
