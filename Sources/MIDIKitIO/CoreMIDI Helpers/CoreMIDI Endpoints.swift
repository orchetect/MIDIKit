//
//  CoreMIDI Endpoints.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import CoreMIDI

internal enum CoreMIDIHelpers {
	
	// MARK: sources
	
	/// (Computed property) Array of source names
	internal var sourceEndpointsNames: [String] {
		Array(sourceEndpoints.values)
	}
	
	/// (Computed property) Dictionary of source names & endpoint unique IDs
	internal dynamic var sourceEndpoints: [Int32 : String] {
		
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
	internal var destinationEndpointsNames: [String] {
		
		Array(destinationEndpoints.values)
		
	}
	
	/// (Computed property) Dictionary of destination names & endpoint unique IDs
	internal dynamic var destinationEndpoints: [Int32 : String] {
		
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
	
	/// Convenience function to return the first source `MIDIEndpointRef` in the system that matches `byName`. Otherwise returns `nil`.
	/// - parameter byName: MIDI port name to search for.
	internal static func sourceEndpoint(matching name: String) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfSources() {
			let source = MIDIGetSource(i)
			if (try? source.getName()) == name { return source }
		}
		
		return nil
		
	}
	
	/// Convenience function to return the first destination `MIDIEndpointRef` in the system that matches `byName`. Otherwise returns `nil`.
	/// - parameter byName: MIDI port name to search for.
	internal static func destinationEndpoint(matching name: String) -> MIDIEndpointRef? {
		
		for i in 0..<MIDIGetNumberOfDestinations() {
			let destination = MIDIGetDestination(i)
			if (try? destination.getName()) == name { return destination }
		}
		
		return nil
		
	}
	
}
