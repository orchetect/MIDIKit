//
//  OutputConnection.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	public class OutputConnection {
		
		public var destinationCriteria: MIDIIO.Endpoint.IDCriteria
		
		public private(set) var destinationEndpointRef: MIDIEndpointRef? = nil
		
		public private(set) var sourcePortRef: MIDIPortRef? = nil
		
		public private(set) var isConnected = false
		
		internal init(toDestination: MIDIIO.Endpoint.IDCriteria) {
			
			self.destinationCriteria = toDestination
			
		}
		
		deinit {
			
			_ = try? disconnect()
			
		}
		
	}
	
}

extension MIDIIO.OutputConnection {
	
	/// Connect to a MIDI Destination
	/// - parameter context: MIDI manager instance by reference
	/// - Throws: `MIDIIO.GeneralError` or `MIDIIO.OSStatusResult`
	internal func connect(context: MIDIIO.Manager) throws {
		
		if isConnected { return }
		
		// if previously connected, clean the old connection
		_ = try? disconnect()
		
		guard let getDestinationEndpointRef = destinationCriteria
				.locate(in: context.endpoints.sources)?
				.ref

		else {
			
			isConnected = false
			
			throw MIDIIO.GeneralError.connectionError(
				"MIDI Destination with criteria \(destinationCriteria) not found while trying to form connection."
			)
		}
		
		destinationEndpointRef = getDestinationEndpointRef
		
		var newConnection = MIDIPortRef()
		
		// connection name must be unique, otherwise process might hang (?)
		let result = MIDIOutputPortCreate(
			context.clientRef,
			UUID().uuidString as CFString,
			&newConnection
		)
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
		#warning("> shouldn't there be a call to MIDIPortConnectSource here, like in the InputConnection class?")
		
		sourcePortRef = newConnection
		
		isConnected = true
		
	}
	
	/// Disconnects the connection if it's currently connected.
	/// 
	/// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
	internal func disconnect() throws {
		
		isConnected = false
		
		guard let sourcePortRef = self.sourcePortRef,
			  let destinationEndpointRef = self.destinationEndpointRef else { return }
		
		let result = MIDIPortDisconnectSource(sourcePortRef, destinationEndpointRef)
		
		self.sourcePortRef = nil
		self.destinationEndpointRef = nil
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
	}
	
}

extension MIDIIO.OutputConnection {
	
	internal func refreshConnection(_ context: MIDIIO.Manager) throws {
		
		guard destinationCriteria
				.locate(in: context.endpoints.destinations) != nil
		
		else {
			isConnected = false
			return
		}
		
		try connect(context: context)
		
	}
	
}

extension MIDIIO.OutputConnection: CustomStringConvertible {
	
	public var description: String {
		
		let destinationEndpointName = "\(try? destinationEndpointRef?.getName().quoted, ifNil: "nil")".quoted
		
		let destinationEndpointRef = "\(self.destinationEndpointRef, ifNil: "nil")"
		
		let sourcePortRef = "\(self.sourcePortRef, ifNil: "nil")"
		
		return "OutputConnection(criteria: \(destinationCriteria), destinationEndpointRef: \(destinationEndpointRef), sourcePortRef: \(sourcePortRef), isConnected: \(isConnected))"
		
	}
	
}

extension MIDIIO.OutputConnection: MIDIIOSendsMIDIMessages {
	
	public func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
		
		guard let sourcePortRef = self.sourcePortRef else {
			throw MIDIIO.PacketError.internalInconsistency(
				"Source port reference is nil."
			)
		}
		
		guard let destinationEndpointRef = self.destinationEndpointRef else {
			throw MIDIIO.PacketError.internalInconsistency(
				"Destination port reference is nil."
			)
		}
		
		let result = MIDISend(sourcePortRef,
							   destinationEndpointRef,
							   packetList)
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
	}
	
}
