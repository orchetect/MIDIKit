//
//  OutputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

extension MIDI.IO {
    
    /// A managed MIDI output connection created in the system by the `Manager`.
    /// This connects to an external input in the system and outputs MIDI events to it.
    public class OutputConnection {
        
        public weak var midiManager: MIDI.IO.Manager?
        
        public var inputCriteria: MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>
        
        public private(set) var inputEndpointRef: MIDIEndpointRef? = nil
        
        public private(set) var portRef: MIDIPortRef? = nil
        
        public private(set) var isConnected = false
        
        internal init(toInput: MIDI.IO.EndpointIDCriteria<MIDI.IO.InputEndpoint>) {
            
            self.inputCriteria = toInput
            
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
        
        guard let upwrappedOutputPortRef = self.portRef,
              let upwrappedInputEndpointRef = self.inputEndpointRef else { return }
        
        defer {
            self.portRef = nil
            self.inputEndpointRef = nil
        }
        
        try MIDIPortDisconnectSource(upwrappedOutputPortRef, upwrappedInputEndpointRef)
            .throwIfOSStatusErr()
        
    }
    
}

extension MIDI.IO.OutputConnection {
    
    /// Refresh the connection.
    /// This is typically called after receiving a CoreMIDI notification that system port configuration has changed or endpoints were added/removed.
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
            inputEndpointName = "\(getName)".otcQuoted
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
        
        guard let upwrappedOutputPortRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Output port reference is nil."
            )
        }
        
        guard let upwrappedInputEndpointRef = self.inputEndpointRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Input port reference is nil."
            )
        }
        
        try MIDISend(upwrappedOutputPortRef,
                     upwrappedInputEndpointRef,
                     packetList)
            .throwIfOSStatusErr()
        
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
    public func send(eventList: UnsafeMutablePointer<MIDIEventList>) throws {
        
        guard let upwrappedOutputPortRef = self.portRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Output port reference is nil."
            )
        }
        
        guard let upwrappedInputEndpointRef = self.inputEndpointRef else {
            throw MIDI.IO.MIDIError.internalInconsistency(
                "Input port reference is nil."
            )
        }
        
        try MIDISendEventList(upwrappedOutputPortRef,
                              upwrappedInputEndpointRef,
                              eventList)
            .throwIfOSStatusErr()
        
    }
    
}
