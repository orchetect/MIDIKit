//
//  OutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// A managed MIDI output connection created in the system by the `Manager`.
    /// This connects to an external input in the system and outputs MIDI events to it.
    public class OutputConnection: _MIDIIOManagedProtocol {
        
        // _MIDIIOManagedProtocol
        internal weak var midiManager: Manager?
        
        // MIDIIOManagedProtocol
        public private(set) var api: APIVersion
        public var midiProtocol: MIDI.IO.ProtocolVersion { api.midiProtocol }
        
        // _MIDIIOSendsMIDIMessagesProtocol
        internal var portRef: MIDI.IO.CoreMIDIPortRef? = nil
        
        // class-specific
        public var inputCriteria: MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>
        internal var inputEndpointRef: MIDI.IO.CoreMIDIEndpointRef? = nil
        public private(set) var isConnected = false
        
        // init
        
        /// - Parameters:
        ///   - toInput: Input to connect to.
        ///   - api: Core MIDI API version.
        internal init(
            toInput: MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>,
            api: APIVersion = .bestForPlatform()
        ) {
            
            self.inputCriteria = toInput
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
            
        }
        
        deinit {
            
            _ = try? disconnect()
            
        }
        
    }
    
}

extension MIDI.IO.OutputConnection {
    
    /// Connect to a MIDI Input
    /// - Parameter manager: MIDI manager instance by reference
    /// - Throws: `MIDI.IO.MIDIError`
    internal func connect(in manager: MIDI.IO.Manager) throws {
        
        if isConnected { return }
        
        // if previously connected, clean the old connection
        _ = try? disconnect()
        
        guard let getInputEndpointRef = inputCriteria
                .locate(in: manager.endpoints.inputs)?
                .coreMIDIObjectRef
        else {
            isConnected = false
            
            throw MIDI.IO.MIDIError.connectionError(
                "MIDI input with criteria \(inputCriteria) not found while trying to form connection."
            )
        }
        
        inputEndpointRef = getInputEndpointRef
        
        var newConnection = MIDIPortRef()
        
        // connection name must be unique, otherwise process might hang (?)
        try MIDIOutputPortCreate(
            manager.clientRef,
            UUID().uuidString as CFString,
            &newConnection
        )
        .throwIfOSStatusErr()
        
        portRef = newConnection
        
        isConnected = true
        
    }
    
    /// Disconnects the connection if it's currently connected.
    /// 
    /// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
    internal func disconnect() throws {
        
        isConnected = false
        
        guard let unwrappedOutputPortRef = self.portRef,
              let unwrappedInputEndpointRef = self.inputEndpointRef else { return }
        
        defer {
            self.portRef = nil
            self.inputEndpointRef = nil
        }
        
        try MIDIPortDisconnectSource(unwrappedOutputPortRef, unwrappedInputEndpointRef)
            .throwIfOSStatusErr()
        
    }
    
}

extension MIDI.IO.OutputConnection {
    
    /// Refresh the connection.
    /// This is typically called after receiving a Core MIDI notification that system port configuration has changed or endpoints were added/removed.
    internal func refreshConnection(in manager: MIDI.IO.Manager) throws {
        
        guard inputCriteria
                .locate(in: manager.endpoints.inputs) != nil
        else {
            isConnected = false
            return
        }
        
        try connect(in: manager)
        
    }
    
}

extension MIDI.IO.OutputConnection: CustomStringConvertible {
    
    public var description: String {
        
        var inputEndpointName: String = "?"
        if let unwrappedInputEndpointRef = inputEndpointRef,
           let getName = try? MIDI.IO.getName(of: unwrappedInputEndpointRef) {
            inputEndpointName = "\(getName)".quoted
        }
        
        var inputEndpointRefString: String = "nil"
        if let unwrappediInputEndpointRef = inputEndpointRef {
            inputEndpointRefString = "\(unwrappediInputEndpointRef)"
        }
        
        var outputPortRefString: String = "nil"
        if let unwrappedPortRef = portRef {
            outputPortRefString = "\(unwrappedPortRef)"
        }
        
        return "OutputConnection(criteria: \(inputCriteria), inputEndpointRef: \(inputEndpointRefString) \(inputEndpointName), outputPortRef: \(outputPortRefString), isConnected: \(isConnected))"
        
    }
    
}

extension MIDI.IO.OutputConnection: MIDIIOSendsMIDIMessagesProtocol {
    
    // empty
    
}

extension MIDI.IO.OutputConnection: _MIDIIOSendsMIDIMessagesProtocol {
    
    internal func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        
        guard let unwrappedOutputPortRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Output port reference is nil."
            )
        }
        
        guard let unwrappedInputEndpointRef = self.inputEndpointRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Input port reference is nil."
            )
        }
        
        try MIDISend(unwrappedOutputPortRef,
                     unwrappedInputEndpointRef,
                     packetList)
            .throwIfOSStatusErr()
        
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    internal func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        
        guard let unwrappedOutputPortRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Output port reference is nil."
            )
        }
        
        guard let unwrappedInputEndpointRef = self.inputEndpointRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Input port reference is nil."
            )
        }
        
        try MIDISendEventList(unwrappedOutputPortRef,
                              unwrappedInputEndpointRef,
                              eventList)
            .throwIfOSStatusErr()
        
    }
    
}
