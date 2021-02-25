//
//  Output.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	public class Output {
		
		/// The port name as displayed in the system.
		public private(set) var endpointName: String = ""
		
		/// The port's unique ID in the system.
		public private(set) var uniqueID: MIDIIO.Endpoint.UniqueID? = nil
		
		public private(set) var sourcePortRef: MIDIPortRef? = nil
		
		internal init(name: String,
					  uniqueID: MIDIIO.Endpoint.UniqueID? = nil) {
			
			self.endpointName = name
			self.uniqueID = uniqueID
			
		}
		
		deinit {
			
			_ = try? dispose()
			
		}
		
	}
	
}

extension MIDIIO.Output {
	
	/// Queries the system and returns true if the endpoint exists (by matching port name and unique ID)
	public var uniqueIDExistsInSystem: MIDIEndpointRef? {
		
		guard let uniqueID = self.uniqueID else {
			return nil
		}
		
		if let endpoint = MIDIIO.systemSourceEndpoint(matching: uniqueID) {
			return endpoint
		}
		
		return nil
		
	}
	
}

extension MIDIIO.Output {
	
	internal func create(context: MIDIIO.Manager) throws {
		
		if uniqueIDExistsInSystem != nil {
			// if uniqueID is already in use, set it to nil
			// so MIDIDestinationCreateWithBlock can find a new unused ID
			uniqueID = nil
		}
		
		var newSourcePortRef = MIDIPortRef()
		
		var result = noErr
		
		result = MIDISourceCreate(
			context.clientRef,
			endpointName as CFString,
			&newSourcePortRef
		)
		
		sourcePortRef = newSourcePortRef
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
		// cache unique ID if cache is nil
		if uniqueID == nil {
			uniqueID = newSourcePortRef.getUniqueID()
		}
		
		// reuse unique ID if it's non-nil
		guard let uniqueID = self.uniqueID else {
			return
		}
		
		// inject unique ID into port
		result = MIDIObjectSetIntegerProperty(
			newSourcePortRef,
			kMIDIPropertyUniqueID,
			uniqueID
		)
		
		guard result == noErr else {
			throw MIDIIO.GeneralError.connectionError(
				"MIDI: Error setting unique ID to \(uniqueID) on virtual source: \(endpointName.quoted). Current ID is \(newSourcePortRef.getUniqueID())."
			)
		}
		
	}
	
	/// Disposes of the the virtual port if it's already been created in the system via the `create()` method.
	///
	/// Errors thrown can be safely ignored and are typically only useful for debugging purposes.
	internal func dispose() throws {
		
		guard let sourcePortRef = self.sourcePortRef else { return }
		
		let result = MIDIEndpointDispose(sourcePortRef)
		
		self.sourcePortRef = nil
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
	}
	
}

extension MIDIIO.Output: CustomStringConvertible {
	
	public var description: String {
		
		let uniqueID = "\(self.uniqueID, ifNil: "nil")"
		
		return "Output(name: \(endpointName.quoted), uniqueID: \(uniqueID))"
		
	}
	
}

extension MIDIIO.Output: MIDIIOSendsMIDIMessages {
	
	public func send(packetList: UnsafeMutablePointer<MIDIPacketList>) throws {
		
		guard let sourcePortRef = self.sourcePortRef else {
			throw MIDIIO.PacketError.internalInconsistency(
				"Port reference is nil."
			)
		}
		
		let result = MIDIReceived(sourcePortRef, packetList)
		
		guard result == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
	}
	
}
