//
//  InputConnection.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	/// A managed MIDI input connection created in the system by the `Manager`.
	/// This connects to an external output in the system and subscribes to its MIDI events.
	public class InputConnection {
		
		public private(set) var outputCriteria: MIDIIO.EndpointIDCriteria
		
		internal private(set) var outputEndpointRef: MIDIEndpointRef? = nil
		
		internal private(set) var inputPortRef: MIDIPortRef? = nil
		
		internal var receiveHandler: ReceiveHandler
		
		public private(set) var isConnected: Bool = false
		
		internal init(toOutput: MIDIIO.EndpointIDCriteria,
					  receiveHandler: ReceiveHandler) {
			
			self.outputCriteria = toOutput
			self.receiveHandler = receiveHandler
			
		}
		
		deinit {
			
			_ = try? disconnect()
			
		}
		
	}
	
}

extension MIDIIO.InputConnection {
	
	/// Connect to a MIDI Output
	/// - parameter context: MIDI manager instance by reference
	/// - throws: `MIDIIO.MIDIError`
	internal func connect(in context: MIDIIO.Manager) throws {
		
		if isConnected { return }
		
		// if previously connected, clean the old connection
		_ = try? disconnect()
		
		guard let getOutputEndpointRef = outputCriteria
				.locate(in: context.endpoints.outputs)?
				.ref
		else {
			
			isConnected = false
			
			throw MIDIIO.MIDIError.connectionError(
				"MIDI output with criteria \(outputCriteria) not found while attempting to form connection."
			)
			
		}
		
		self.outputEndpointRef = getOutputEndpointRef
		
		var newConnection = MIDIPortRef()
		
		// connection name must be unique, otherwise process might hang (?)
		try MIDIInputPortCreateWithBlock(
			context.clientRef,
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

extension MIDIIO.InputConnection {
	
	/// Refresh the connection.
	/// This is typically called after receiving a CoreMIDI notification that system port configuration has changed or endpoints were added/removed.
	internal func refreshConnection(in context: MIDIIO.Manager) throws {
		
		guard outputCriteria
				.locate(in: context.endpoints.outputs) != nil
		else {
			isConnected = false
			return
		}
		
		try connect(in: context)
		
	}
	
}

extension MIDIIO.InputConnection: CustomStringConvertible {
	
	public var description: String {
		
		let outputEndpointName = (
			outputEndpointRef?
				.transformed { try? MIDIIO.getName(of: $0) }?
				.transformed({ " " + $0 })
				.quoted
		) ?? ""
		
		let outputEndpointRef = "\(self.outputEndpointRef, ifNil: "nil")"
		
		let inputPortRef = "\(self.inputPortRef, ifNil: "nil")"
		
		return "InputConnection(criteria: \(outputCriteria), outputEndpointRef: \(outputEndpointRef)\(outputEndpointName), inputPortRef: \(inputPortRef), isConnected: \(isConnected))"
		
	}
	
}
