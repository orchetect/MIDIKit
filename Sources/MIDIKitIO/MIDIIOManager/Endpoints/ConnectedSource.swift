//
//  ConnectedSource.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIOManager {
	
	public class ConnectedSource {
		
		public var destinationEndpointName: String
		
		public private(set) var destinationEndpointRef: MIDIEndpointRef? = nil
		
		public private(set) var sourcePortRef: MIDIPortRef? = nil
		
		public private(set) var isConnected = false
		
		internal init(named: String) {
			
			self.destinationEndpointName = named
			
		}
		
		deinit {
			
			_ = try? disconnect()
			
		}
		
	}
	
}

extension MIDIIOManager.ConnectedSource {
	
	#warning("> should rework this to make it obvious it's connection to the first endpoint that matches the name; also create a 2nd connect method that connects by MIDIEndpointRef")
	
	/// Connect to a MIDI Destination
	/// - parameter context: MIDI manager instance by reference
	/// - Throws: `MIDIIOManager.GeneralError` or `MIDIIOManager.OSStatusResult`
	public func connect(context: MIDIIOManager) throws {
		
		if isConnected { return }
		
		// if previously connected, clean the old connection
		_ = try? disconnect()
		
		guard let destinationEndpoint =
				CoreMIDIHelpers
				.destinationEndpoints(matching: destinationEndpointName)
				.first
		else {
			
			isConnected = false
			
			throw MIDIIOManager.GeneralError.connectionError(
				"MIDI Destination \(destinationEndpointName.quoted) not found while trying to create destination connection."
			)
		}
		
		destinationEndpointRef = destinationEndpoint
		
		var newConnection = MIDIPortRef()
		
		// connection name must be unique, otherwise process might hang
		let result = MIDIOutputPortCreate(
			context.clientRef,
			UUID().uuidString as CFString,
			&newConnection
		)
		
		guard result == noErr else {
			throw MIDIIOManager.OSStatusResult(rawValue: result)
		}
		
		#warning("> shouldn't there be a call to MIDIPortConnectSource here, like in the ConnectedDestination class?")
		
		sourcePortRef = newConnection
		
		isConnected = true
		
	}
	
	/// Disconnects the connection if it's currently connected.
	/// 
	/// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
	public func disconnect() throws {
		
		isConnected = false
		
		guard let sourcePortRef = self.sourcePortRef,
			  let destinationEndpointRef = self.destinationEndpointRef else { return }
		
		let result = MIDIPortDisconnectSource(sourcePortRef, destinationEndpointRef)
		
		self.sourcePortRef = nil
		self.destinationEndpointRef = nil
		
		guard result == noErr else {
			throw MIDIIOManager.OSStatusResult(rawValue: result)
		}
		
	}
	
}

extension MIDIIOManager.ConnectedSource {
	
	internal func refreshConnection(_ context: MIDIIOManager) throws {
		
		let destinationEndpointName = self.destinationEndpointName
		
		guard CoreMIDIHelpers.destinationEndpointsNames
				.contains(destinationEndpointName) else {
			
			isConnected = false
			return
			
		}
		
		try connect(context: context)
		
	}
	
}

extension MIDIIOManager.ConnectedSource: CustomStringConvertible {
	
	public var description: String {
		
		let destinationEndpointRef = "\(self.destinationEndpointRef, ifNil: "nil")"
		
		let sourcePortRef = "\(self.sourcePortRef, ifNil: "nil")"
		
		return "ConnectedSource(destinationEndpointName: \(destinationEndpointName.quoted), destinationEndpointRef: \(destinationEndpointRef), sourcePortRef: \(sourcePortRef), isConnected: \(isConnected))"
		
	}
	
}
