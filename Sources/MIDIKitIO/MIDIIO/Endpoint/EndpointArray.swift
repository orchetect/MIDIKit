//
//  EndpointArray.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

import Foundation
import CoreMIDI

extension MIDIIO {
	
	public typealias EndpointArray = [Endpoint]
	
}

extension MIDIIO.EndpointArray {
	
	/// Returns the endpoint dictionary sorted alphabetically by endpoint name.
	public func sortedByName() -> [Element] {
		
		self
			.sorted(by: {
				$0.name
					.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
			})
		
	}
	
}

extension MIDIIO.EndpointArray {
	
	/// Returns the element where uniqueID matches.
	/// Returns `nil` if not found.
	public func filterBy(uniqueID: MIDIIO.Endpoint.UniqueID) -> MIDIIO.Endpoint? {
		
		first(where: { $0.uniqueID == uniqueID })
		
	}
	
	/// Returns all endpoints matching the given name.
	public func filterBy(endpointName: String) -> Self {
		
		filter { $0.name == endpointName }
		
	}
	
	/// Returns all endpoints matching the given endpoint name and device ID.
	public func filterBy(endpointName: String,
						 deviceID: Int32) -> Self {
		
		#warning("> change this - deviceID isn't relevant")
		fatalError("not coded yet")
//		filter {
//			$0.name == endpointName
//				&& $0.getDeviceID == deviceID
//		}
		
	}
	
}
