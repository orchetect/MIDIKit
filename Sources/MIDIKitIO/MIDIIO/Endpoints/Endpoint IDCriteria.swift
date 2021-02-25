//
//  Endpoint IDCriteria.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO.Endpoint {
	
	/// Enum describing the criteria with which to identify endpoints.
	public enum IDCriteria: Hashable {
		
		/// Utilizes first endpoint matching the endpoint name and device ID.
		case endpointNameAndDeviceID(name: String, deviceID: Int32)
		
		/// Utilizes first endpoint matching the endpoint name.
		/// Use of this is discouraged outside of debugging, since multiple endpoints can potentially share the same name in the system.
		case endpointName(String)
		
		/// Endpoint matching the unique ID.
		case uniqueID(MIDIIO.Endpoint.UniqueID)
		
	}
	
}

extension MIDIIO.Endpoint.IDCriteria {
	
	/// Uses the criteria to find the first match and returns it if found.
	internal func locate(in endpoints: MIDIIO.EndpointArray) -> MIDIIO.Endpoint? {
		
		switch self {
		case .endpointNameAndDeviceID(let endpointName, let deviceID):
			return endpoints
				.filterBy(endpointName: endpointName, deviceID: deviceID)
				.first
			
		case .endpointName(let endpointName):
			return endpoints
				.filterBy(endpointName: endpointName)
				.first
			
		case .uniqueID(let uID):
			return endpoints
				.filterBy(uniqueID: uID)
			
		}
		
	}
	
}

extension MIDIIO.Endpoint.IDCriteria: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
		case .endpointNameAndDeviceID(let endpointName, let deviceID):
			return "EndpointName:\(endpointName.quoted)+DeviceID:\(deviceID)"
			
		case .endpointName(let endpointName):
			return "EndpointName:\(endpointName.quoted)"
			
		case .uniqueID(let uID):
			return "UniqueID:\(uID)"
			
		}
		
	}
	
}
