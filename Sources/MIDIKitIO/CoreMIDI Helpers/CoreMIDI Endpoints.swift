//
//  CoreMIDI Endpoints.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore

internal enum CoreMIDIHelpers {
	
	// MARK: sources
	
	/// (Computed property) Array of source names
	internal static var sourceEndpointsNames: [String] {
		Array(sourceEndpoints.values)
	}
	
	/// (Computed property) Dictionary of source names & endpoint unique IDs
	internal static dynamic var sourceEndpoints: [Int32 : String] {
		
		let srcCount = MIDIGetNumberOfSources()
		
		var endpointDict: [MIDIEndpointUniqueID : String] = [:]
		endpointDict.reserveCapacity(srcCount)
		
		for i in 0..<srcCount {
			let destination = MIDIGetSource(i)
			endpointDict[destination.getUniqueID()] = try? destination.getName()
		}
		
		return endpointDict
		
	}
	
	// MARK: destinations
	
	/// (Computed property) Array of destination names
	internal static var destinationEndpointsNames: [String] {
		
		Array(destinationEndpoints.values)
		
	}
	
	/// (Computed property) Dictionary of destination names & endpoint unique IDs
	internal static dynamic var destinationEndpoints: [Int32 : String] {
		
		let destCount = MIDIGetNumberOfDestinations()
		
		var endpointDict: [MIDIEndpointUniqueID : String] = [:]
		endpointDict.reserveCapacity(destCount)
		
		for i in 0..<destCount {
			let destination = MIDIGetDestination(i)
			endpointDict[destination.getUniqueID()] = try? destination.getName()
		}
		
		return endpointDict
		
	}
	
}

extension CoreMIDIHelpers {
	
	/// Returns all source `MIDIEndpointRef`s in the system that have a name matching `name`.
	/// - parameter name: MIDI port name to search for.
	internal static func sourceEndpoints(matching name: String) -> [MIDIEndpointRef] {
		
		var refs: [MIDIEndpointRef] = []
		
		for i in 0..<MIDIGetNumberOfSources() {
			let source = MIDIGetSource(i)
			if (try? source.getName()) == name { refs.append(source) }
		}
		
		return refs
		
	}
	
	/// Returns the first source `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
	/// - parameter uniqueID: MIDI port unique ID to search for.
	internal static func sourceEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfSources() {
			let source = MIDIGetSource(i)
			if source.getUniqueID() == uniqueID { return source }
		}
		
		return nil
		
	}
	
}

extension CoreMIDIHelpers {
	
	/// Returns all destination `MIDIEndpointRef`s in the system that have a name matching `name`.
	/// - parameter name: MIDI port name to search for.
	internal static func destinationEndpoints(matching name: String) -> [MIDIEndpointRef] {
		
		var refs: [MIDIEndpointRef] = []
		
		for i in 0..<MIDIGetNumberOfDestinations() {
			let source = MIDIGetDestination(i)
			if (try? source.getName()) == name { refs.append(source) }
		}
		
		return refs
		
	}
	
	/// Returns the first destination `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
	/// - parameter uniqueID: MIDI port unique ID to search for.
	internal static func destinationEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfDestinations() {
			let source = MIDIGetDestination(i)
			if source.getUniqueID() == uniqueID { return source }
		}
		
		return nil
		
	}
	
}

extension CoreMIDIHelpers {
	
	/// Queries CoreMIDI for existing persistent play-through connections stored in the system matching the specified persistent owner ID.
	///
	/// To delete them all, see sister function `connectedThrusPersistentEntriesDeleteAll`.
	///
	/// - parameter byPersistentOwnerID: owner ID string that was set when the connection was first made
	internal static func connectedThrusPersistentEntries(
		byPersistentOwnerID: String
	) throws -> [MIDIThruConnectionRef] {
		
		#warning("> this code needs verification")
		
		// set up empty unmanaged data pointer
		var getConnectionList: Unmanaged<CFData> = Unmanaged.passUnretained(Data([]) as CFData)
		
		// get CFData containing list of matching 4-byte UInt32 ID numbers
		let result = MIDIThruConnectionFind(byPersistentOwnerID as CFString, &getConnectionList)
		
		guard result == noErr else {
			throw MIDIIOManager.OSStatusResult(rawValue: result)
		}
		
		// cast to NSData so we can use .getBytes(...)
		let outConnectionList = getConnectionList.takeRetainedValue() as NSData
		
		// get length of data
		let byteCount: CFIndex = CFDataGetLength(outConnectionList)
		
		// aka, byteCount / 4 (MIDIThruConnectionRef is a 4-byte UInt32)
		let itemCount = byteCount / MemoryLayout<MIDIThruConnectionRef>.size
		
		// init array with size
		var thruConnnectionArray = [MIDIThruConnectionRef](repeating: 0, count: itemCount)
		
		if itemCount > 0 {
			// fill array with constructed values from the data
			outConnectionList.getBytes(&thruConnnectionArray, length: byteCount as Int)
		}
		
		defer {
			// memory safety: release unmanaged pointer we created
			getConnectionList.release()
		}
		
		return thruConnnectionArray
		
	}
	
	/// Deletes all system-held MIDI thru connections matching an owner ID.
	///
	/// - Returns: Number of deleted matching connections.
	internal static func connectedThrusPersistentEntriesDeleteAll(
		byPersistentOwnerID: String
	) throws -> Int {
		
		let getList = try connectedThrusPersistentEntries(byPersistentOwnerID: byPersistentOwnerID)
		
		var err = noErr
		
		// iterate through persistent connection list
		for thruConnection in getList {
			
			err = MIDIThruConnectionDispose(thruConnection)
			
			if err != noErr {
				Log.debug("MIDI: Persistent connections: deletion of connection matching ID \"\(byPersistentOwnerID)\" with number \(thruConnection) failed.")
			}
			
		}
		
		return getList.count
		
	}
	
}
