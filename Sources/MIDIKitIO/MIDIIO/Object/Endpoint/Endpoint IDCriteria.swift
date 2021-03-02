//
//  Endpoint IDCriteria.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	/// Enum describing the criteria with which to identify endpoints.
	public enum EndpointIDCriteria: Hashable {
		
		/// Utilizes first endpoint matching the endpoint name.
		/// Use of this is discouraged outside of debugging, since multiple endpoints can potentially share the same name in the system.
		case name(String)
		
		/// Utilizes first endpoint matching the display name.
		/// Use of this is discouraged outside of debugging, since multiple endpoints can potentially share the same name in the system.
		case displayName(String)
		
		/// Endpoint matching the unique ID.
		case uniqueID(Endpoint.UniqueID)
		
	}
	
}

extension MIDIIO.EndpointIDCriteria {
	
	/// Uses the criteria to find the first match and returns it if found.
	internal func locate<T: MIDIIO.Endpoint>(in endpoints: [T]) -> T? {
		
		switch self {
		case .name(let endpointName):
			return endpoints
				.filterBy(name: endpointName)
				.first
		
		case .displayName(let endpointName):
			return endpoints
				.filterBy(displayName: endpointName)
				.first
			
		case .uniqueID(let uID):
			return endpoints
				.filterBy(uniqueID: uID)
			
		}
		
	}
	
}

extension MIDIIO.EndpointIDCriteria: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
		case .name(let endpointName):
			return "EndpointName:\(endpointName.quoted)"
		
		case .displayName(let displayName):
			return "EndpointDisplayName:\(displayName.quoted))"
			
		case .uniqueID(let uID):
			return "UniqueID:\(uID)"
			
		}
		
	}
	
}
