//
//  InputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// A managed MIDI input connection created in the system by the `Manager`.
    /// This connects to an external output in the system and subscribes to its MIDI events.
    public class InputConnection: _MIDIIOManagedProtocol {
        
        // _MIDIIOManagedProtocol
        internal weak var midiManager: MIDI.IO.Manager?
        
        // MIDIIOManagedProtocol
        public private(set) var api: MIDI.IO.APIVersion
        public var midiProtocol: MIDI.IO.ProtocolVersion { api.midiProtocol }
        
        // class-specific
        
        public private(set) var outputsCriteria: [MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint>]
        internal var outputEndpointRefs: [MIDI.IO.CoreMIDIEndpointRef?] = []
        internal var inputPortRef: MIDI.IO.CoreMIDIPortRef? = nil
        
        internal var receiveHandler: MIDI.IO.ReceiveHandler
        
        // init
        
        /// - Parameters:
        ///   - toOutputs: Output(s) to connect to.
        ///   - receiveHandler: Receive handler to use for incoming MIDI messages.
        ///   - midiManager: Reference to I/O Manager object.
        ///   - api: Core MIDI API version.
        internal init(toOutputs: [MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint>],
                      receiveHandler: MIDI.IO.ReceiveHandler.Definition,
                      midiManager: MIDI.IO.Manager,
                      api: MIDI.IO.APIVersion = .bestForPlatform()) {
            
            self.outputsCriteria = toOutputs
            self.receiveHandler = receiveHandler.createReceiveHandler()
            self.midiManager = midiManager
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
            
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
        
        outputEndpointRefs.compactMap {
            if let unwrapped = $0 {
                return MIDI.IO.OutputEndpoint(unwrapped)
            } else { return nil }
        }
        
    }
    
}

extension MIDI.IO.InputConnection {
    
    /// Create a MIDI Input port with which to subsequently connect to MIDI Output(s).
    ///
    /// - Parameter manager: MIDI manager instance by reference
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal func listen(in manager: MIDI.IO.Manager) throws {
        
        guard inputPortRef == nil else {
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
        
        inputPortRef = newInputPortRef
        
    }
    
    /// Disposes of the listening port if it exists.
    internal func stopListening() throws {
        
        guard let unwrappedInputPortRef = inputPortRef else { return }
        
        defer { self.inputPortRef = nil }
        
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
        if inputPortRef == nil {
            try listen(in: manager)
        }
        
        guard let unwrappedInputPortRef = inputPortRef else {
            throw MIDI.IO.MIDIError.connectionError(
                "Not in a listening state; can't connect to endpoints."
            )
        }
        
        // if previously connected, clean the old connections. ignore errors.
        _ = try? disconnect()
        
        // resolve criteria to endpoints in the system
        let getOutputEndpointRefs = outputsCriteria
            .map {
                $0.locate(in: manager.endpoints.outputs)?
                    .coreMIDIObjectRef
            }
        
        outputEndpointRefs = getOutputEndpointRefs
        
        for refIndex in 0..<getOutputEndpointRefs.count {
            
            if let outputEndpointRef = getOutputEndpointRefs[refIndex] {
                
                try? MIDIPortConnectSource(
                    unwrappedInputPortRef,
                    outputEndpointRef,
                    nil
                )
                .throwIfOSStatusErr()
                
            }
                
        }
        
    }
    
    /// Disconnects the connections if any are currently connected.
    /// 
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    internal func disconnect() throws {
        
        guard let unwrappedInputPortRef = self.inputPortRef else {
            throw MIDI.IO.MIDIError.connectionError(
                "Attempted to disconnect outputs but was not in a listening state; nothing to disconnect."
            )
        }
        
        for refIndex in 0..<outputEndpointRefs.count {
            
            if let unwrappedOutputEndpointRef = outputEndpointRefs[refIndex] {
                
                do {
                    try MIDIPortDisconnectSource(
                        unwrappedInputPortRef,
                        unwrappedOutputEndpointRef
                    )
                        .throwIfOSStatusErr()
                } catch {
                    // ignore errors
                }
                
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
        
        guard matchedEndpointCount > 0 else { return }
        
        try connect(in: manager)
        
    }
    
}

extension MIDI.IO.InputConnection: CustomStringConvertible {
    
    public var description: String {
        
        let outputEndpointsString: [String] = outputEndpointRefs
            .map {
                var str = ""
                
                // ref
                if let unwrapped = $0 {
                    // ref
                    str = "\(unwrapped):"
                    
                    // name
                    if let getName = try? MIDI.IO.getName(of: unwrapped) {
                        str += "\(getName)".quoted
                    } else {
                        str += "nil"
                    }
                } else {
                    str = "nil"
                }
                
                return str
            }
        
        var inputPortRefString: String = "nil"
        if let unwrappedInputPortRef = inputPortRef {
            inputPortRefString = "\(unwrappedInputPortRef)"
        }
                
        return "InputConnection(criteria: \(outputsCriteria), outputEndpointRefs: \(outputEndpointsString), inputPortRef: \(inputPortRefString))"
        
    }
    
}

extension MIDI.IO.InputConnection: MIDIIOReceivesMIDIMessagesProtocol {
    
    // empty
    
}
