//
//  VirtualDestination.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIOManager {
	
	public class VirtualDestination {
		
		/// The port name as displayed in the system.
		public private(set) var endpointName: String = ""
		
		/// The port's unique ID.
		public private(set) var uniqueID: MIDIEndpointUniqueID? = nil
		
		public private(set) var destinationPortRef: MIDIPortRef? = nil
		
		internal var receiveHandler: MIDIReadBlock
		
		internal init(name: String,
					  uniqueID: MIDIEndpointUniqueID? = nil,
					  receiveHandler: @escaping MIDIReadBlock) {
			
			self.endpointName = name
			self.uniqueID = uniqueID
			self.receiveHandler = receiveHandler
			
		}
		
		deinit {
			
			_ = try? dispose()
			
		}
		
	}
	
}

extension MIDIIOManager.VirtualDestination {
	
	/// Queries the system and returns true if the endpoint exists (by matching port name and unique ID)
	public var exists: Bool {
		
		guard let uniqueID = self.uniqueID else {
			return false
		}
		
		guard let matchingIDRef = CoreMIDIHelpers.destinationEndpoint(matching: uniqueID)
		else { return false }
		
		return (try? matchingIDRef.getName()) == endpointName
		
	}
	
}

extension MIDIIOManager.VirtualDestination {
	
	public func create(context: MIDIIOManager) throws {
		
		guard !exists else { return }
		
		var newDestinationPortRef = MIDIPortRef()
		
		var result = noErr
		
		result = MIDIDestinationCreateWithBlock(
			context.clientRef,
			endpointName as CFString,
			&newDestinationPortRef,
			receiveHandler
		)
		
		guard result == noErr else {
			throw MIDIIOManager.OSStatusResult(rawValue: result)
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
			throw MIDIIOManager.GeneralError.connectionError(
				"MIDI: Error setting unique ID to \(uniqueID) on virtual destination: \(endpointName.quoted). Current ID is \(newDestinationPortRef.getUniqueID())."
			)
		}
		
	}
	
	/// Disposes of the the virtual port if it's already been created in the system via the `create()` method.
	///
	/// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
	public func dispose() throws {
		
		guard let destinationPortRef = self.destinationPortRef else { return }
		
		let result = MIDIEndpointDispose(destinationPortRef)
		
		self.destinationPortRef = nil
		
		guard result == noErr else {
			throw MIDIIOManager.OSStatusResult(rawValue: result)
		}
		
	}
	
}

extension MIDIIOManager.VirtualDestination: CustomStringConvertible {
	
	public var description: String {
		
		"VirtualDestination(name: \(endpointName.quoted), uniqueID: \(uniqueID, ifNil: "nil"))"
		
	}
	
}
