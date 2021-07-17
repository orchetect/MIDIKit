//
//  Endpoint IDCriteria.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDI.IO {
	
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

extension MIDI.IO.EndpointIDCriteria {
	
	/// Uses the criteria to find the first match and returns it if found.
	internal func locate<T: MIDI.IO.Endpoint>(in endpoints: [T]) -> T? {
		
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

extension MIDI.IO.EndpointIDCriteria: CustomStringConvertible {
	
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
