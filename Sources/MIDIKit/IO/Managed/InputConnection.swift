//
//  InputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// A managed MIDI input connection created in the system by the MIDI I/O `Manager`.
    /// This connects to one or more outputs in the system and subscribes to receive their MIDI events.
    ///
    /// - Note: Do not store or cache this object unless it is unavoidable. Instead, whenever possible call it by accessing the `Manager`'s `managedInputConnections` collection.
    ///
    /// Ensure that it is only stored weakly and only passed by reference temporarily in order to execute an operation. If it absolutely must be stored strongly, ensure it is stored for no longer than the lifecycle of the managed input connection (which is either at such time the `Manager` is de-initialized, or when calling `.remove(.inputConnection, ...)` or `.removeAll` on the `Manager` to destroy the managed input connection.)
    public class InputConnection: _MIDIIOManagedProtocol {
        
        // _MIDIIOManagedProtocol
        internal weak var midiManager: MIDI.IO.Manager?
        
        // MIDIIOManagedProtocol
        public private(set) var api: MIDI.IO.APIVersion
        public var midiProtocol: MIDI.IO.ProtocolVersion { api.midiProtocol }
        
        // class-specific
        
        public private(set) var outputsCriteria: Set<MIDI.IO.OutputEndpointIDCriteria> = []
        
        private func setOutputsCriteria(_ criteria: Set<MIDI.IO.OutputEndpointIDCriteria>) {
            
            if preventAddingManagedOutputs,
               let midiManager = midiManager
            {
                let managedOutputs: [MIDI.IO.OutputEndpointIDCriteria] = midiManager.managedOutputs
                    .compactMap { $0.value.uniqueID }
                    .map { .uniqueID($0) }
                
                outputsCriteria = criteria
                    .filter { !managedOutputs.contains($0) }
            } else {
                outputsCriteria = criteria
            }
            
        }
        
        /// The Core MIDI input port reference.
        public private(set) var coreMIDIInputPortRef: MIDI.IO.CoreMIDIPortRef? = nil
        
        /// The Core MIDI output endpoint(s) reference(s).
        public private(set) var coreMIDIOutputEndpointRefs: Set<MIDI.IO.CoreMIDIEndpointRef> = []
        
        /// When new outputs appear in the system, automatically add them to the connection.
        public var automaticallyAddNewOutputs: Bool
        
        /// Prevent virtual outputs owned by the `Manager` (`.managedOutputs`) from being added to the connection.
        public var preventAddingManagedOutputs: Bool
        
        internal var receiveHandler: MIDI.IO.ReceiveHandler
        
        // init
        
        /// Internal init.
        /// This object is not meant to be instanced by the user. This object is automatically created and managed by the MIDI I/O `Manager` instance when calling `.addInputConnection()`, and destroyed when calling `.remove(.inputConnection, ...)` or `.removeAll()`.
        ///
        /// - Parameters:
        ///   - toOutputs: Output(s) to connect to.
        ///   - automaticallyAddNewOutputs: When new outputs appear in the system, automatically add them to the connection.
        ///   - preventAddingManagedOutputs: Prevent virtual outputs owned by the `Manager` from being added to the connection.
        ///   - receiveHandler: Receive handler to use for incoming MIDI messages.
        ///   - midiManager: Reference to I/O Manager object.
        ///   - api: Core MIDI API version.
        internal init(toOutputs: Set<MIDI.IO.OutputEndpointIDCriteria>,
                      automaticallyAddNewOutputs: Bool,
                      preventAddingManagedOutputs: Bool,
                      receiveHandler: MIDI.IO.ReceiveHandler.Definition,
                      midiManager: MIDI.IO.Manager,
                      api: MIDI.IO.APIVersion = .bestForPlatform()) {
            
            self.midiManager = midiManager
            self.automaticallyAddNewOutputs = automaticallyAddNewOutputs
            self.preventAddingManagedOutputs = preventAddingManagedOutputs
            self.receiveHandler = receiveHandler.createReceiveHandler()
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
            
            // relies on midiManager and preventAddingManagedOutputs
            setOutputsCriteria(toOutputs)
            
        }
        
        deinit {
            
            _ = try? disconnect()
            _ = try? stopListening()
            
        }
        
    }
    
}

extension MIDI.IO.InputConnection {
    
    /// Returns the output endpoint(s) this connection is connected to.
    public var endpoints: [MIDI.IO.OutputEndpoint] {
        
        coreMIDIOutputEndpointRefs.map { MIDI.IO.OutputEndpoint($0) }
        
    }
    
}

extension MIDI.IO.InputConnection {
    
    /// Create a MIDI Input port with which to subsequently connect to MIDI Output(s).
    ///
    /// - Parameter manager: MIDI manager instance by reference
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal func listen(in manager: MIDI.IO.Manager) throws {
        
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
                { [weak self] packetListPtr, srcConnRefCon in
                    guard let strongSelf = self else { return }
                    
                    let packets = packetListPtr.packets()
                    
                    strongSelf.midiManager?.eventQueue.async {
                        strongSelf.receiveHandler.packetListReceived(packets)
                    }
                }
            )
            .throwIfOSStatusErr()
            
        case .newCoreMIDI:
            guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *) else {
                throw MIDI.IO.MIDIError.internalInconsistency(
                    "New Core MIDI API is not accessible on this platform."
                )
            }
            
            try MIDIInputPortCreateWithProtocol(
                manager.coreMIDIClientRef,
                UUID().uuidString as CFString,
                self.api.midiProtocol.coreMIDIProtocol,
                &newInputPortRef,
                { [weak self] eventListPtr, srcConnRefCon in
                    guard let strongSelf = self else { return }
                    
                    let packets = eventListPtr.packets()
                    let midiProtocol = MIDI.IO.ProtocolVersion(eventListPtr.pointee.protocol)
                    
                    strongSelf.midiManager?.eventQueue.async {
                        strongSelf.receiveHandler.eventListReceived(packets,
                                                                    protocol: midiProtocol)
                    }
                }
            )
            .throwIfOSStatusErr()
            
        }
        
        coreMIDIInputPortRef = newInputPortRef
        
    }
    
    /// Disposes of the listening port if it exists.
    internal func stopListening() throws {
        
        guard let unwrappedInputPortRef = coreMIDIInputPortRef else { return }
        
        defer { self.coreMIDIInputPortRef = nil }
        
        try MIDIPortDispose(unwrappedInputPortRef)
            .throwIfOSStatusErr()
        
    }
    
    /// Connect to MIDI Output(s).
    ///
    /// - Parameter manager: MIDI manager instance by reference
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal func connect(in manager: MIDI.IO.Manager) throws {
        
        // if not already listening, start listening
        if coreMIDIInputPortRef == nil {
            try listen(in: manager)
        }
        
        guard let unwrappedInputPortRef = coreMIDIInputPortRef else {
            throw MIDI.IO.MIDIError.connectionError(
                "Not in a listening state; can't connect to endpoints."
            )
        }
        
        // if previously connected, clean the old connections. ignore errors.
        _ = try? disconnect()
        
        // resolve criteria to endpoints in the system
        let getOutputEndpointRefs = outputsCriteria
            .compactMap {
                $0.locate(in: manager.endpoints.outputs)?
                    .coreMIDIObjectRef
            }
        
        coreMIDIOutputEndpointRefs = Set(getOutputEndpointRefs)
        
        for outputEndpointRef in getOutputEndpointRefs {
            
            try? MIDIPortConnectSource(
                unwrappedInputPortRef,
                outputEndpointRef,
                nil
            )
            .throwIfOSStatusErr()
            
        }
        
    }
    
    /// Disconnects connections if any are currently connected.
    /// If nil is passed, the all of the connection's endpoint refs will be disconnected.
    /// 
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    internal func disconnect(
        endpointRefs: Set<MIDI.IO.CoreMIDIEndpointRef>? = nil
    ) throws {
        
        guard let unwrappedInputPortRef = self.coreMIDIInputPortRef else {
            throw MIDI.IO.MIDIError.connectionError(
                "Attempted to disconnect outputs but was not in a listening state; nothing to disconnect."
            )
        }
        
        let refs = endpointRefs ?? coreMIDIOutputEndpointRefs
        
        for outputEndpointRef in refs {
            
            do {
                try MIDIPortDisconnectSource(
                    unwrappedInputPortRef,
                    outputEndpointRef
                )
                .throwIfOSStatusErr()
            } catch {
                // ignore errors
            }
            
        }
        
    }
    
    /// Refresh the connection.
    /// This is typically called after receiving a Core MIDI notification that system port configuration has changed or endpoints were added/removed.
    internal func refreshConnection(in manager: MIDI.IO.Manager) throws {
        
        // call (re-)connect only if at least one matching endpoint exists in the system
        
        let getSystemOutputs = manager.endpoints.outputs
        
        var matchedEndpointCount = 0
        
        for criteria in outputsCriteria {
            if criteria.locate(in: getSystemOutputs) != nil { matchedEndpointCount += 1 }
        }
        
        guard matchedEndpointCount > 0 else {
            coreMIDIOutputEndpointRefs = []
            return
        }
        
        try connect(in: manager)
        
    }
    
}

extension MIDI.IO.InputConnection {
    
    // MARK: Add Endpoints
    
    /// Add output endpoints to the connection.
    public func add(
        outputs: [MIDI.IO.OutputEndpointIDCriteria]
    ) {
        
        let combined = outputsCriteria.union(outputs)
        setOutputsCriteria(combined)
        
        if let midiManager = midiManager {
            // this will re-generate coreMIDIOutputEndpointRefs and call connect()
            try? refreshConnection(in: midiManager)
        }
        
    }
    
    /// Add output endpoints to the connection.
    public func add(
        outputs: [MIDI.IO.OutputEndpoint]
    ) {
        
        add(outputs: outputs.map { .uniqueID($0.uniqueID) })
        
    }
    
    // MARK: Remove Endpoints
    
    /// Remove output endpoints to the connection.
    public func remove(
        outputs: [MIDI.IO.OutputEndpointIDCriteria]
    ) {
        
        let removed = outputsCriteria.subtracting(outputs)
        setOutputsCriteria(removed)
        
        if let midiManager = midiManager {
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
    public func remove(
        outputs: [MIDI.IO.OutputEndpoint]
    ) {
        
        remove(outputs: outputs.map { .uniqueID($0.uniqueID) })
        
    }
    
    public func removeAllOutputs() {
        
        let outputsToDisconnect = outputsCriteria
        
        setOutputsCriteria([])
        
        remove(outputs: Array(outputsToDisconnect))
        
    }
    
}

extension MIDI.IO.InputConnection {
    
    internal func notification(_ notif: MIDI.IO.Manager.InternalNotification) {
        
        if automaticallyAddNewOutputs,
           case .added(parent: _,
                       parentType: _,
                       child: let childRef,
                       childType: let childType) = notif,
           childType == .source || childType == .externalSource
        {
            add(outputs: [MIDI.IO.OutputEndpoint(childRef)])
            return
        }
        
        switch notif {
        case .setupChanged, .added, .removed:
            if let midiManager = midiManager {
                try? refreshConnection(in: midiManager)
            }
            
        default:
            break
        }
        
    }
    
}

extension MIDI.IO.InputConnection: CustomStringConvertible {
    
    public var description: String {
        
        let outputEndpointsString: [String] = coreMIDIOutputEndpointRefs
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
        
        var inputPortRefString: String = "nil"
        if let unwrappedInputPortRef = coreMIDIInputPortRef {
            inputPortRefString = "\(unwrappedInputPortRef)"
        }
                
        return "InputConnection(criteria: \(outputsCriteria), outputEndpointRefs: \(outputEndpointsString), inputPortRef: \(inputPortRefString))"
        
    }
    
}

extension MIDI.IO.InputConnection: MIDIIOReceivesMIDIMessagesProtocol {
    
    // empty
    
}
