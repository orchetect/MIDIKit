//
//  ConnectedDestination.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	public class ConnectedDestination {
		
		public var sourceEndpointName: String
		
		public private(set) var sourceEndpointRef: MIDIEndpointRef? = nil
		
		public private(set) var destinationPortRef: MIDIPortRef? = nil
		
		internal var receiveHandler: MIDIReadBlock
		
		public private(set) var isConnected: Bool = false
		
		internal init(named: String,
					  receiveHandler: @escaping MIDIReadBlock) {
			
			self.sourceEndpointName = named
			self.receiveHandler = receiveHandler
			
		}
		
		deinit {
			
			_ = try? disconnect()
			
		}
		
	}
	
}

extension MIDIIO.ConnectedDestination {
	
	#warning("> should rework this to make it obvious it's connection to the first endpoint that matches the name; also create a 2nd connect method that connects by MIDIEndpointRef")
	
	/// Connect to a MIDI Source
	/// - parameter context: MIDI manager instance by reference
	/// - Throws: `MIDIIO.GeneralError` or `MIDIIO.OSStatusResult`
	public func connect(context: MIDIIO.Manager) throws {
		
		if isConnected { return }
		
		// if previously connected, clean the old connection
		_ = try? disconnect()
		
		guard let sourceEndpoint =
				MIDIIO.systemSourceEndpoints(matching: sourceEndpointName)
				.first
		else {
			
			isConnected = false
			
			throw MIDIIO.GeneralError.connectionError(
				"MIDI: Source \(sourceEndpointName.quoted) not found while trying to connect to it."
			)
			
		}
		
		sourceEndpointRef = sourceEndpoint
		
		var newConnection = MIDIPortRef()
		
		var result = noErr
		
		// connection name must be unique, otherwise process might hang (?)
		result = MIDIInputPortCreateWithBlock(
			context.clientRef,
			UUID().uuidString as CFString,
			&newConnection,
			receiveHandler
		)
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
		result = MIDIPortConnectSource(
			newConnection,
			sourceEndpoint,
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
	public func disconnect() throws {
		
		isConnected = false
		
		guard let destinationPortRef = self.destinationPortRef,
			  let sourceEndpointRef = self.sourceEndpointRef else { return }
		
		let result = MIDIPortDisconnectSource(destinationPortRef, sourceEndpointRef)
		
		self.destinationPortRef = nil
		self.sourceEndpointRef = nil
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
	}
	
}

extension MIDIIO.ConnectedDestination {
	
	internal func refreshConnection(_ context: MIDIIO.Manager) throws {
		
		let sourceEndpointName = self.sourceEndpointName
		
		guard MIDIIO.systemSourceEndpointsNames
				.contains(sourceEndpointName)
		else {
			
			isConnected = false
			return
			
		}
		
		try connect(context: context)
		
	}
	
}

extension MIDIIO.ConnectedDestination: CustomStringConvertible {
	
	public var description: String {
		
		let sourceEndpointRef = "\(self.sourceEndpointRef, ifNil: "nil")"
		
		let destinationPortRef = "\(self.destinationPortRef, ifNil: "nil")"
		
		return "ConnectedDestination(sourceEndpointName: \(sourceEndpointName.quoted), sourceEndpointRef: \(sourceEndpointRef), destinationPortRef: \(destinationPortRef), isConnected: \(isConnected))"
		
	}
	
}
