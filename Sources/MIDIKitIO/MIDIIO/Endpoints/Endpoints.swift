//
//  Endpoints.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import CoreMIDI
@_implementationOnly import OTCore

// MARK: - MIDIEndpointUniqueID

public typealias MIDIEndpointUniqueID = Int32

// MARK: - System endpoints

extension MIDIIO {
	
	// MARK: sources
	
	/// (Computed property) Array of source names
	internal static var systemSourceEndpointsNames: [String] {
		Array(systemSourceEndpoints.values)
	}
	
	/// (Computed property) Dictionary of source names & endpoint unique IDs
	public static dynamic var systemSourceEndpoints: [Int32 : String] {
		
		let srcCount = MIDIGetNumberOfSources()
		
		var endpointDict: [MIDIEndpointUniqueID : String] = [:]
		endpointDict.reserveCapacity(srcCount)
		
		for i in 0..<srcCount {
			let destination = MIDIGetSource(i)
			endpointDict[destination.getUniqueID()] = (try? destination.getName()) ?? ""
		}
		
		return endpointDict
		
	}
	
	// MARK: destinations
	
	/// (Computed property) Array of destination names
	internal static var systemDestinationEndpointsNames: [String] {
		
		Array(systemDestinationEndpoints.values)
		
	}
	
	/// (Computed property) Dictionary of destination names & endpoint unique IDs
	public static dynamic var systemDestinationEndpoints: [Int32 : String] {
		
		let destCount = MIDIGetNumberOfDestinations()
		
		var endpointDict: [MIDIEndpointUniqueID : String] = [:]
		endpointDict.reserveCapacity(destCount)
		
		for i in 0..<destCount {
			let destination = MIDIGetDestination(i)
			endpointDict[destination.getUniqueID()] = (try? destination.getName()) ?? ""
		}
		
		return endpointDict
		
	}
	
}

extension MIDIIO {
	
	/// Returns all source `MIDIEndpointRef`s in the system that have a name matching `name`.
	/// - parameter name: MIDI port name to search for.
	public static func systemSourceEndpoints(matching name: String) -> [MIDIEndpointRef] {
		
		var refs: [MIDIEndpointRef] = []
		
		for i in 0..<MIDIGetNumberOfSources() {
			let source = MIDIGetSource(i)
			if (try? source.getName()) == name { refs.append(source) }
		}
		
		return refs
		
	}
	
	/// Returns the first source `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
	/// - parameter uniqueID: MIDI port unique ID to search for.
	public static func systemSourceEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfSources() {
			let source = MIDIGetSource(i)
			if source.getUniqueID() == uniqueID { return source }
		}
		
		return nil
		
	}
	
}

extension MIDIIO {
	
	/// Returns all destination `MIDIEndpointRef`s in the system that have a name matching `name`.
	/// - parameter name: MIDI port name to search for.
	public static func systemDestinationEndpoints(matching name: String) -> [MIDIEndpointRef] {
		
		var refs: [MIDIEndpointRef] = []
		
		for i in 0..<MIDIGetNumberOfDestinations() {
			let source = MIDIGetDestination(i)
			if (try? source.getName()) == name { refs.append(source) }
		}
		
		return refs
		
	}
	
	/// Returns the first destination `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
	/// - parameter uniqueID: MIDI port unique ID to search for.
	public static func systemDestinationEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfDestinations() {
			let source = MIDIGetDestination(i)
			if source.getUniqueID() == uniqueID { return source }
		}
		
		return nil
		
	}
	
}

extension MIDIIO {
	
	/// Queries CoreMIDI for existing persistent play-through connections stored in the system matching the specified persistent owner ID.
	///
	/// To delete them all, see sister function `connectedThrusPersistentEntriesDeleteAll`.
	///
	/// - parameter byPersistentOwnerID: owner ID string that was set when the connection was first made
	internal static func systemConnectedThrusPersistentEntries(
		matching persistentOwnerID: String
	) throws -> [MIDIThruConnectionRef] {
		
		#warning("> this code needs verification")
		
		// set up empty unmanaged data pointer
		var getConnectionList: Unmanaged<CFData> = Unmanaged.passUnretained(Data([]) as CFData)
		
		// get CFData containing list of matching 4-byte UInt32 ID numbers
		let result = MIDIThruConnectionFind(persistentOwnerID as CFString, &getConnectionList)
		
		guard result == noErr else {
			// memory safety: release unmanaged pointer we created
			getConnectionList.release()
			
			throw MIDIIO.OSStatusResult(rawValue: result)
		}
		
		// cast to NSData so we can use .getBytes(...)
		let outConnectionList = getConnectionList.takeRetainedValue() as NSData
		
		// get length of data
		let byteCount: CFIndex = CFDataGetLength(outConnectionList)
		
		// aka, byteCount / 4 (MIDIThruConnectionRef is a 4-byte UInt32)
		let itemCount = byteCount / MemoryLayout<MIDIThruConnectionRef>.size
		
		// init array with size
		var thruConnnectionArray = [MIDIThruConnectionRef](repeating: 0x00, count: itemCount)
		
		if itemCount > 0 {
			// fill array with constructed values from the data
			outConnectionList.getBytes(&thruConnnectionArray, length: byteCount as Int)
		}
		
		return thruConnnectionArray
		
	}
	
	/// Deletes all system-held MIDI thru connections matching an owner ID.
	///
	/// - Returns: Number of deleted matching connections.
	internal static func systemConnectedThrusPersistentEntriesDeleteAll(
		matching persistentOwnerID: String
	) throws -> Int {
		
		let getList = try systemConnectedThrusPersistentEntries(matching: persistentOwnerID)
		
		var result = noErr
		
		// iterate through persistent connection list
		for thruConnection in getList {
			
			result = MIDIThruConnectionDispose(thruConnection)
			
			if result != noErr {
				Log.debug("MIDI: Persistent connections: deletion of connection matching ID \"\(persistentOwnerID)\" with number \(thruConnection) failed.")
			}
			
		}
		
		return getList.count
		
	}
	
}
