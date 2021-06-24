//
//  InputConnection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDI.IO {
	
	/// A managed MIDI input connection created in the system by the `Manager`.
	/// This connects to an external output in the system and subscribes to its MIDI events.
	public class InputConnection {
		
		public private(set) var outputCriteria: MIDI.IO.EndpointIDCriteria
		
		internal private(set) var outputEndpointRef: MIDIEndpointRef? = nil
		
		internal private(set) var inputPortRef: MIDIPortRef? = nil
		
		internal var receiveHandler: ReceiveHandler
		
		public private(set) var isConnected: Bool = false
		
		internal init(toOutput: MIDI.IO.EndpointIDCriteria,
					  receiveHandler: ReceiveHandler) {
			
			self.outputCriteria = toOutput
			self.receiveHandler = receiveHandler
			
		}
		
		deinit {
			
			_ = try? disconnect()
			
		}
		
	}
	
}

extension MIDI.IO.InputConnection {
	
	/// Connect to a MIDI Output
	/// - Parameter manager: MIDI manager instance by reference
	/// - Throws: `MIDI.IO.MIDIError`
	internal func connect(in manager: MIDI.IO.Manager) throws {
		
		if isConnected { return }
		
		// if previously connected, clean the old connection
		_ = try? disconnect()
		
		guard let getOutputEndpointRef = outputCriteria
				.locate(in: manager.endpoints.outputs)?
				.ref
		else {
			
			isConnected = false
			
			throw MIDI.IO.MIDIError.connectionError(
				"MIDI output with criteria \(outputCriteria) not found while attempting to form connection."
			)
			
		}
		
		self.outputEndpointRef = getOutputEndpointRef
		
		var newConnection = MIDIPortRef()
		
		// connection name must be unique, otherwise process might hang (?)
		try MIDIInputPortCreateWithBlock(
			manager.clientRef,
			UUID().uuidString as CFString,
			&newConnection,
			receiveHandler.midiReadBlock
		)
		.throwIfOSStatusErr()
		
		try MIDIPortConnectSource(
			newConnection,
			getOutputEndpointRef,
			nil
		)
		.throwIfOSStatusErr()
		
		inputPortRef = newConnection
		
		isConnected = true
		
	}
	
	/// Disconnects the connection if it's currently connected.
	/// 
	/// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
	internal func disconnect() throws {
		
		isConnected = false
		
		guard let inputPortRef = self.inputPortRef,
			  let outputEndpointRef = self.outputEndpointRef else { return }
		
		defer { self.inputPortRef = nil }
		
		try MIDIPortDisconnectSource(inputPortRef, outputEndpointRef)
			.throwIfOSStatusErr()
		
	}
	
}

extension MIDI.IO.InputConnection {
	
	/// Refresh the connection.
	/// This is typically called after receiving a CoreMIDI notification that system port configuration has changed or endpoints were added/removed.
	internal func refreshConnection(in manager: MIDI.IO.Manager) throws {
		
		guard outputCriteria
				.locate(in: manager.endpoints.outputs) != nil
		else {
			isConnected = false
			return
		}
		
		try connect(in: manager)
		
	}
	
}

extension MIDI.IO.InputConnection: CustomStringConvertible {
	
	public var description: String {
		
		let outputEndpointName = (
			outputEndpointRef?
				.transformed { try? MIDI.IO.getName(of: $0) }?
				.transformed({ " " + $0 })
				.quoted
		) ?? ""
		
		let outputEndpointRef = "\(self.outputEndpointRef, ifNil: "nil")"
		
		let inputPortRef = "\(self.inputPortRef, ifNil: "nil")"
		
		return "InputConnection(criteria: \(outputCriteria), outputEndpointRef: \(outputEndpointRef)\(outputEndpointName), inputPortRef: \(inputPortRef), isConnected: \(isConnected))"
		
	}
	
}
