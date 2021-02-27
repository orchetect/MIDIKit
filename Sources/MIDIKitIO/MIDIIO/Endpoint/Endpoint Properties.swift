//
//  Endpoint Properties.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import CoreMIDI
@_implementationOnly import OTCore

// MARK: - System endpoints

extension MIDIIO {
	
	// MARK: sources
	
	/// (Computed property) Dictionary of source names & endpoint unique IDs
	internal static var getSystemSourceEndpoints: EndpointArray {
		
		let srcCount = MIDIGetNumberOfSources()
		
		var endpoints: EndpointArray = []
		endpoints.reserveCapacity(srcCount)
		
		for i in 0..<srcCount {
			let source = MIDIGetSource(i)
			
			endpoints += .init(source)
		}
		
		return endpoints
		
	}
	
	/// (Computed property) Array of source endpoints unique IDs
	internal static var getSystemSourceEndpointsUniqueIDs: [MIDIIO.Endpoint.UniqueID] {
		getSystemSourceEndpoints.map { $0.uniqueID }
	}
	
	/// (Computed property) Array of source endpoints names
	internal static var getSystemSourceEndpointsNames: [String] {
		getSystemSourceEndpoints.map { $0.name }
	}
	
	// MARK: destinations
	
	/// (Computed property) Dictionary of destination names & endpoint unique IDs
	internal static var getSystemDestinationEndpoints: EndpointArray {
		
		let destCount = MIDIGetNumberOfDestinations()
		
		var endpoints: EndpointArray = []
		endpoints.reserveCapacity(destCount)
		
		for i in 0..<destCount {
			let destination = MIDIGetDestination(i)
			
			endpoints += .init(destination)
		}
		
		return endpoints
		
	}
	
	/// (Computed property) Array of destination endpoints unique IDs
	internal static var getSystemDestinationEndpointsUniqueIDs: [MIDIIO.Endpoint.UniqueID] {
		getSystemDestinationEndpoints.map { $0.uniqueID }
	}
	
	/// (Computed property) Array of destination endpoints names
	internal static var getSystemDestinationEndpointsNames: [String] {
		getSystemDestinationEndpoints.map { $0.name }
	}
	
}

extension MIDIIO.Manager {
	
	internal func updateSystemEndpointsCache() {
		
		endpoints.update(context: self)
		notificationHandler?(.systemEndpointsChanged, self)
		
	}
	
}

extension MIDIIO {
	
	/// Returns all source `MIDIEndpointRef`s in the system that have a name matching `name`.
	/// - parameter name: MIDI port name to search for.
	internal static func systemSourceEndpoints(matching name: String) -> [MIDIEndpointRef] {
		
		var refs: [MIDIEndpointRef] = []
		
		for i in 0..<MIDIGetNumberOfSources() {
			let source = MIDIGetSource(i)
			if (try? MIDIIO.getName(of: source)) == name { refs.append(source) }
		}
		
		return refs
		
	}
	
	/// Returns the first source `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
	/// - parameter uniqueID: MIDI port unique ID to search for.
	internal static func systemSourceEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfSources() {
			let source = MIDIGetSource(i)
			if MIDIIO.getUniqueID(of: source) == uniqueID { return source }
		}
		
		return nil
		
	}
	
}

extension MIDIIO {
	
	/// Returns all destination `MIDIEndpointRef`s in the system that have a name matching `name`.
	/// - parameter name: MIDI port name to search for.
	internal static func systemDestinationEndpoints(matching name: String) -> [MIDIEndpointRef] {
		
		var refs: [MIDIEndpointRef] = []
		
		for i in 0..<MIDIGetNumberOfDestinations() {
			let source = MIDIGetDestination(i)
			if (try? MIDIIO.getName(of: source)) == name { refs.append(source) }
		}
		
		return refs
		
	}
	
	/// Returns the first destination `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
	/// - parameter uniqueID: MIDI port unique ID to search for.
	internal static func systemDestinationEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfDestinations() {
			let source = MIDIGetDestination(i)
			if MIDIIO.getUniqueID(of: source) == uniqueID { return source }
		}
		
		return nil
		
	}
	
}

extension MIDIIO {
	
	/// Queries CoreMIDI for existing persistent play-through connections stored in the system matching the specified persistent owner ID.
	///
	/// To delete them all, see sister function `systemThruConnectionsPersistentEntriesDeleteAll`.
	///
	/// - parameter byPersistentOwnerID: reverse-DNS domain that was used when the connection was first made
	internal static func systemThruConnectionsPersistentEntries(
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
		var thruConnectionArray = [MIDIThruConnectionRef](repeating: 0x00, count: itemCount)
		
		if itemCount > 0 {
			// fill array with constructed values from the data
			outConnectionList.getBytes(&thruConnectionArray, length: byteCount as Int)
		}
		
		return thruConnectionArray
		
	}
	
	/// Deletes all system-held MIDI thru connections matching an owner ID.
	///
	/// - Returns: Number of deleted matching connections.
	internal static func systemThruConnectionsPersistentEntriesDeleteAll(
		matching persistentOwnerID: String
	) throws -> Int {
		
		let getList = try systemThruConnectionsPersistentEntries(matching: persistentOwnerID)
		
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
