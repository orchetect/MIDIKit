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
	
	public class InputConnection {
		
		public private(set) var sourceCriteria: MIDIIO.Endpoint.IDCriteria
		
		internal private(set) var sourceEndpointRef: MIDIEndpointRef? = nil
		
		internal private(set) var destinationPortRef: MIDIPortRef? = nil
		
		internal var receiveHandler: ReceiveHandler
		
		public private(set) var isConnected: Bool = false
		
		internal init(toSource: MIDIIO.Endpoint.IDCriteria,
					  receiveHandler: ReceiveHandler) {
			
			self.sourceCriteria = toSource
			self.receiveHandler = receiveHandler
			
		}
		
		deinit {
			
			_ = try? disconnect()
			
		}
		
	}
	
}

extension MIDIIO.InputConnection {
	
	/// Connect to a MIDI Source
	/// - parameter context: MIDI manager instance by reference
	/// - Throws: `MIDIIO.GeneralError` or `MIDIIO.OSStatusResult`
	internal func connect(in context: MIDIIO.Manager) throws {
		
		if isConnected { return }
		
		// if previously connected, clean the old connection
		_ = try? disconnect()
		
		guard let getSourceEndpointRef = sourceCriteria
				.locate(in: context.endpoints.outputs)?
				.ref
		else {
			
			isConnected = false
			
			throw MIDIIO.GeneralError.connectionError(
				"MIDI: Source with criteria \(sourceCriteria) not found while attempting to form connection."
			)
			
		}
		
		self.sourceEndpointRef = getSourceEndpointRef
		
		var newConnection = MIDIPortRef()
		
		var result = noErr
		
		// connection name must be unique, otherwise process might hang (?)
		result = MIDIInputPortCreateWithBlock(
			context.clientRef,
			UUID().uuidString as CFString,
			&newConnection,
			receiveHandler.midiReadBlock
		)
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
		result = MIDIPortConnectSource(
			newConnection,
			getSourceEndpointRef,
			nil
		)
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
		destinationPortRef = newConnection
		
		isConnected = true
		
	}
	
	/// Disconnects the connection if it's currently connected.
	/// 
	/// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
	internal func disconnect() throws {
		
		isConnected = false
		
		guard let destinationPortRef = self.destinationPortRef,
			  let sourceEndpointRef = self.sourceEndpointRef else { return }
		
		let result = MIDIPortDisconnectSource(destinationPortRef, sourceEndpointRef)
		
		self.destinationPortRef = nil
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
	}
	
}

extension MIDIIO.InputConnection {
	
	internal func refreshConnection(in context: MIDIIO.Manager) throws {
		
		guard sourceCriteria
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
		
		let sourceEndpointName = (
			sourceEndpointRef?
				.transformed { try? MIDIIO.getName(of: $0) }?
				.transformed({ " " + $0 })
				.quoted
		) ?? ""
		
		let sourceEndpointRef = "\(self.sourceEndpointRef, ifNil: "nil")"
		
		let destinationPortRef = "\(self.destinationPortRef, ifNil: "nil")"
		
		return "InputConnection(criteria: \(sourceCriteria), sourceEndpointRef: \(sourceEndpointRef)\(sourceEndpointName), destinationPortRef: \(destinationPortRef), isConnected: \(isConnected))"
		
	}
	
}
