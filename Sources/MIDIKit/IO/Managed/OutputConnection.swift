//
//  OutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

extension MIDI.IO {
    
    /// A managed MIDI output connection created in the system by the `Manager`.
    /// This connects to an external input in the system and outputs MIDI events to it.
    public class OutputConnection: MIDIIOManagedProtocol {
        
        // MIDIIOManagedProtocol
        public weak var midiManager: Manager?
        public private(set) var api: APIVersion
        public private(set) var `protocol`: MIDI.IO.ProtocolVersion
        
        public var inputCriteria: MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>
        
        public private(set) var inputEndpointRef: MIDIEndpointRef? = nil
        
        public private(set) var portRef: MIDIPortRef? = nil
        
        public private(set) var isConnected = false
        
        internal init(
            toInput: MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>,
            api: APIVersion = .bestForPlatform(),
            protocol midiProtocol: MIDI.IO.ProtocolVersion = ._2_0
        ) {
            
            self.inputCriteria = toInput
            self.api = api.isValidOnCurrentPlatform ? api : .bestForPlatform()
            self.protocol = api == .legacyCoreMIDI ? ._1_0 : midiProtocol
            
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
    
    public func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
        
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
    public func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        
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
