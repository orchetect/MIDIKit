//
//  CoreMIDI Entities.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-27.
//

import Foundation

import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	/// (Computed property) List of MIDI entities in the system
	internal static func getSystemDevice(for entity: MIDIEntityRef) throws -> Device? {

		var dev: MIDIDeviceRef = MIDIDeviceRef()
		
		try MIDIEntityGetDevice(entity, &dev)
			.throwIfOSStatusErr()
		
		guard dev != MIDIDeviceRef() else { return nil }
		
		return Device(dev)
		
	}
	
	/// (Computed property) List of source endpoints for the entity
	internal static func getSystemSources(for entity: MIDIEntityRef) -> [OutputEndpoint] {
		
		let srcCount = MIDIEntityGetNumberOfSources(entity)
		
		var endpoints: [OutputEndpoint] = []
		endpoints.reserveCapacity(srcCount)
		
		for i in 0..<srcCount {
			let endpoint = MIDIEntityGetSource(entity, i)
			
			endpoints += .init(endpoint)
		}
		
		return endpoints
		
	}
	
	/// (Computed property) List of destination endpoints for the entity
	internal static func getSystemDestinations(for entity: MIDIEntityRef) -> [InputEndpoint] {
		
		let srcCount = MIDIEntityGetNumberOfDestinations(entity)
		
		var endpoints: [InputEndpoint] = []
		endpoints.reserveCapacity(srcCount)
		
		for i in 0..<srcCount {
			let endpoint = MIDIEntityGetDestination(entity, i)
			
			endpoints += .init(endpoint)
		}
		
		return endpoints
		
	}
	
}
