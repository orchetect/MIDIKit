//
//  OutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// A managed MIDI output connection created in the system by the MIDI I/O `Manager`.
    ///
    /// This connects to one or more inputs in the system and outputs MIDI events to them. It can also be instanced without providing any initial inputs and then inputs can be added or removed later.
    ///
    /// - Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible call it by accessing the `Manager`'s `managedOutputConnections` collection.
    ///
    /// Ensure that it is only stored weakly and only passed by reference temporarily in order to execute an operation. If it absolutely must be stored strongly, ensure it is stored for no longer than the lifecycle of the managed output connection (which is either at such time the `Manager` is de-initialized, or when calling `.remove(.outputConnection, ...)` or `.removeAll` on the `Manager` to destroy the managed output connection.)
    public class OutputConnection: _MIDIIOManagedProtocol {
        
        // _MIDIIOManagedProtocol
        internal weak var midiManager: MIDI.IO.Manager?
        
        // MIDIIOManagedProtocol
        public private(set) var api: MIDI.IO.APIVersion
        public var midiProtocol: MIDI.IO.ProtocolVersion { api.midiProtocol }
        
        // MIDIIOSendsMIDIMessagesProtocol
        
        /// The Core MIDI output port reference.
        public private(set) var coreMIDIOutputPortRef: MIDI.IO.CoreMIDIPortRef? = nil
        
        // class-specific
        
        public private(set) var inputsCriteria: Set<MIDI.IO.InputEndpointIDCriteria> = []
        
        /// Stores criteria after applying any filters that have been set in the `filter` property.
        /// Passing nil will re-use existing criteria, re-applying the filters.
        private func updateCriteria(_ criteria: Set<MIDI.IO.InputEndpointIDCriteria>? = nil) {
            
            var newCriteria = criteria ?? inputsCriteria
            
            if filter.owned,
               let midiManager = midiManager
            {
                let managedInputs: [MIDI.IO.InputEndpointIDCriteria] = midiManager.managedInputs
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
        public private(set) var coreMIDIInputEndpointRefs: Set<MIDI.IO.CoreMIDIEndpointRef> = []
        
        /// Operating mode.
        ///
        /// Changes take effect immediately.
        public var mode: MIDI.IO.ConnectionMode {
            didSet {
                guard oldValue != mode else { return }
                guard let midiManager = midiManager else { return }
                updateCriteriaFromMode()
                try? refreshConnection(in: midiManager)
            }
        }
        
        /// Reads the `mode` property and applies it to the stored criteria.
        private func updateCriteriaFromMode() {
            
            switch mode {
            case .allEndpoints:
                updateCriteria(.current())
                
            case .definedEndpoints:
                updateCriteria()
                
            }
            
        }
        
        /// Endpoint filter.
        ///
        /// Changes take effect immediately.
        public var filter: MIDI.IO.EndpointFilter<MIDI.IO.InputEndpoint> {
            didSet {
                guard oldValue != filter else { return }
                guard let midiManager = midiManager else { return }
                updateCriteria()
                try? refreshConnection(in: midiManager)
            }
        }
        
        // init
        
        /// Internal init.
        /// This object is not meant to be instanced by the user. This object is automatically created and managed by the MIDI I/O `Manager` instance when calling `.addOutputConnection()`, and destroyed when calling `.remove(.outputConnection, ...)` or `.removeAll()`.
        ///
        /// - Parameters:
        ///   - criteria: Input(s) to connect to.
        ///   - mode: Operation mode. Note that `allEndpoints` mode overrides `criteria`.
        ///   - filter: Optional filter allowing or disallowing certain endpoints from being added to the connection.
        ///   - midiManager: Reference to I/O Manager object.
        ///   - api: Core MIDI API version.
        internal init(
            criteria: Set<MIDI.IO.InputEndpointIDCriteria>,
            mode: MIDI.IO.ConnectionMode,
            filter: MIDI.IO.InputEndpointFilter,
            midiManager: MIDI.IO.Manager,
            api: MIDI.IO.APIVersion = .bestForPlatform()
        ) {
            
            self.midiManager = midiManager
            self.mode = mode
            self.filter = filter
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
            
            // relies on midiManager, mode, and filter being set first
            if mode == .allEndpoints {
                updateCriteriaFromMode()
            } else {
                updateCriteria(criteria)
            }
            
        }
        
        deinit {
            
            try? closeOutput()
            
        }
        
    }
    
}

extension MIDI.IO.OutputConnection {
    
    /// Returns the input endpoint(s) this connection is connected to.
    public var endpoints: [MIDI.IO.InputEndpoint] {
        
        coreMIDIInputEndpointRefs.map { MIDI.IO.InputEndpoint($0) }
        
    }
    
}

extension MIDI.IO.OutputConnection {
    
    /// Set up a single "invisible" output port which can send events to all inputs.
    ///
    /// - Parameter manager: MIDI manager instance by reference
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal func setupOutput(in manager: MIDI.IO.Manager) throws {
        
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
    internal func closeOutput() throws {
        
        guard let unwrappedOutputPortRef = coreMIDIOutputPortRef else { return }
        
        defer { self.coreMIDIOutputPortRef = nil }
        
        try MIDIPortDispose(unwrappedOutputPortRef)
            .throwIfOSStatusErr()
        
    }
    
    /// Resolve MIDI Input(s) criteria to concrete reference IDs and cache them.
    /// 
    /// - Parameter manager: MIDI manager instance by reference
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal func resolveEndpoints(in manager: MIDI.IO.Manager) throws {
        
        // resolve criteria to endpoints in the system
        let getInputEndpointRefs = inputsCriteria
            .compactMap {
                $0.locate(in: manager.endpoints.inputs)?
                    .coreMIDIObjectRef
            }
        
        coreMIDIInputEndpointRefs = Set(getInputEndpointRefs)
        
    }
    
    /// Refresh the connection.
    /// This is typically called after receiving a Core MIDI notification that system port configuration has changed or endpoints were added/removed.
    internal func refreshConnection(in manager: MIDI.IO.Manager) throws {
        
        // re-resolve endpoints only if at least one matching endpoint exists in the system
        
        let getSystemInputs = manager.endpoints.inputs
        
        var matchedEndpointCount = 0
        
        for criteria in inputsCriteria {
            if criteria.locate(in: getSystemInputs) != nil { matchedEndpointCount += 1 }
        }
        
        try resolveEndpoints(in: manager)
        
    }
    
}

extension MIDI.IO.OutputConnection {
    
    // MARK: Add Endpoints
    
    /// Add input endpoints from the connection.
    /// Endpoint filters are respected.
    public func add(
        inputs: [MIDI.IO.InputEndpointIDCriteria]
    ) {
        
        let combined = inputsCriteria.union(inputs)
        updateCriteria(combined)
        
        if let midiManager = midiManager {
            // this will re-generate coreMIDIInputEndpointRefs
            try? refreshConnection(in: midiManager)
        }
        
    }
    
    /// Add input endpoints from the connection.
    /// Endpoint filters are respected.
    @_disfavoredOverload
    public func add(
        inputs: [MIDI.IO.InputEndpoint]
    ) {
        
        add(inputs: inputs.map { .uniqueID($0.uniqueID) })
        
    }
    
    // MARK: Remove Endpoints
    
    /// Remove input endpoints from the connection.
    public func remove(
        inputs: [MIDI.IO.InputEndpointIDCriteria]
    ) {
        
        let removed = inputsCriteria.subtracting(inputs)
        updateCriteria(removed)
        
        if let midiManager = midiManager {
            // this will re-generate coreMIDIInputEndpointRefs
            try? refreshConnection(in: midiManager)
        }
        
    }
    
    /// Remove input endpoints from the connection.
    @_disfavoredOverload
    public func remove(
        inputs: [MIDI.IO.InputEndpoint]
    ) {
        
        remove(inputs: inputs.map { .uniqueID($0.uniqueID) })
        
    }
    
    /// Remove all input endpoints from the connection.
    public func removeAllInputs() {
        
        let inputsToDisconnect = inputsCriteria
        updateCriteria([])
        remove(inputs: Array(inputsToDisconnect))
        
    }
    
}

extension MIDI.IO.OutputConnection {
    
    internal func notification(_ internalNotification: MIDI.IO.InternalNotification) {
        
        if mode == .allEndpoints,
           let notif = MIDI.IO.SystemNotification(internalNotification, cache: nil),
           case .added(parent: _,
                       child: let child) = notif,
           case .inputEndpoint(let newInput) = child
        {
            add(inputs: [newInput])
            return
        }
        
        switch internalNotification {
        case .setupChanged, .added, .removed:
            if let midiManager = midiManager {
                try? refreshConnection(in: midiManager)
            }
            
        default:
            break
        }
        
    }
    
}

extension MIDI.IO.OutputConnection: CustomStringConvertible {
    
    public var description: String {
        
        let inputEndpointsString: [String] = coreMIDIInputEndpointRefs
            .map {
                // ref
                var str = "\($0):"
                
                // name
                if let getName = try? MIDI.IO.getName(of: $0) {
                    str += "\(getName)".quoted
                } else {
                    str += "nil"
                }
                
                return str
            }
        
        var outputPortRefString: String = "nil"
        if let unwrappedOutputPortRef = coreMIDIOutputPortRef {
            outputPortRefString = "\(unwrappedOutputPortRef)"
        }
        
        return "OutputConnection(criteria: \(inputsCriteria), inputEndpointRefs: \(inputEndpointsString), outputPortRef: \(outputPortRefString))"
        
    }
    
}

extension MIDI.IO.OutputConnection: MIDIIOSendsMIDIMessagesProtocol {
    
    // empty
    
}

extension MIDI.IO.OutputConnection: _MIDIIOSendsMIDIMessagesProtocol {
    
    internal func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        
        guard let unwrappedOutputPortRef = self.coreMIDIOutputPortRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Output port reference is nil."
            )
        }
        
        // dispatch the packetlist to each input independently
        // but we can use the same output port
        
        for inputEndpointRef in coreMIDIInputEndpointRefs {
            
            // ignore errors with try? since we don't want to return early in the event that sending to subsequent inputs may succeed
            try? MIDISend(unwrappedOutputPortRef,
                          inputEndpointRef,
                          packetList)
                .throwIfOSStatusErr()
            
        }
        
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    internal func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        
        guard let unwrappedOutputPortRef = self.coreMIDIOutputPortRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Output port reference is nil."
            )
        }
        
        // dispatch the eventlist to each input independently
        // but we can use the same output port
        
        for inputEndpointRef in coreMIDIInputEndpointRefs {
            
            // ignore errors with try? since we don't want to return early in the event that sending to subsequent inputs may succeed
            try? MIDISendEventList(unwrappedOutputPortRef,
                                   inputEndpointRef,
                                   eventList)
                .throwIfOSStatusErr()
            
        }
        
    }
    
}
