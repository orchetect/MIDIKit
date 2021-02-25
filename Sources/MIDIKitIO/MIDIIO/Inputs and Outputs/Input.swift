//
//  Input.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	public class Input {
		
		/// The port name as displayed in the system.
		public private(set) var endpointName: String = ""
		
		/// The port's unique ID in the system.
		public private(set) var uniqueID: MIDIIO.Endpoint.UniqueID? = nil
		
		public private(set) var destinationPortRef: MIDIPortRef? = nil
		
		internal var receiveHandler: ReceiveHandler
		
		internal init(name: String,
					  uniqueID: MIDIIO.Endpoint.UniqueID? = nil,
					  receiveHandler: ReceiveHandler) {
			
			self.endpointName = name
			self.uniqueID = uniqueID
			self.receiveHandler = receiveHandler
			
		}
		
		deinit {
			
			_ = try? dispose()
			
		}
		
	}
	
}

extension MIDIIO.Input {
	
	/// Queries the system and returns true if the endpoint exists (by matching port name and unique ID)
	public var uniqueIDExistsInSystem: MIDIEndpointRef? {
		
		guard let uniqueID = self.uniqueID else {
			return nil
		}
		
		if let endpoint = MIDIIO.systemDestinationEndpoint(matching: uniqueID) {
			return endpoint
		}
		
		return nil
		
	}
	
}

extension MIDIIO.Input {
	
	internal func create(context: MIDIIO.Manager) throws {
		
		if uniqueIDExistsInSystem != nil {
			// if uniqueID is already in use, set it to nil
			// so MIDIDestinationCreateWithBlock can find a new unused ID
			uniqueID = nil
		}
		
		var newDestinationPortRef = MIDIPortRef()
		
		var result = noErr
		
		result = MIDIDestinationCreateWithBlock(
			context.clientRef,
			endpointName as CFString,
			&newDestinationPortRef,
			receiveHandler.midiReadBlock
		)
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
		// cache unique ID if cache is nil
		if uniqueID == nil {
			uniqueID = newDestinationPortRef.getUniqueID()
		}
		
		// reuse unique ID if it's non-nil
		guard let uniqueID = self.uniqueID else {
			return
		}
		
		result = MIDIObjectSetIntegerProperty(
			newDestinationPortRef,
			kMIDIPropertyUniqueID,
			uniqueID
		)
		
		guard result == noErr else {
			throw MIDIIO.GeneralError.connectionError(
				"MIDI: Error setting unique ID to \(uniqueID) on virtual destination: \(endpointName.quoted). Current ID is \(newDestinationPortRef.getUniqueID())."
			)
		}
		
	}
	
	/// Disposes of the the virtual port if it's already been created in the system via the `create()` method.
	///
	/// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
	internal func dispose() throws {
		
		guard let destinationPortRef = self.destinationPortRef else { return }
		
		let result = MIDIEndpointDispose(destinationPortRef)
		
		self.destinationPortRef = nil
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
	}
	
}

extension MIDIIO.Input: CustomStringConvertible {
	
	public var description: String {
		
		"Input(name: \(endpointName.quoted), uniqueID: \(uniqueID, ifNil: "nil"))"
		
	}
	
}
