//
//  Endpoints.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

import Foundation

public protocol MIDIIOEndpointsProtocol {
	
	var outputs: MIDIIO.EndpointArray { get }
	var inputs: MIDIIO.EndpointArray { get }
	func update(context: MIDIIO.Manager)
	
}

extension MIDIIO {
	
	/// Manages system endpoints information cache.
	public class Endpoints: NSObject, MIDIIOEndpointsProtocol {
		
		public internal(set) dynamic var outputs: EndpointArray = []
		
		public internal(set) dynamic var inputs: EndpointArray = []
		
		internal override init() {
			super.init()
		}
		
		/// Manually update the locally cached contents from the system.
		public func update(context: MIDIIO.Manager) {
			
			outputs = MIDIIO.getSystemSourceEndpoints
			inputs = MIDIIO.getSystemDestinationEndpoints
			
		}
		
	}
	
}

// experimental, for SwiftUI:

//#if canImport(Combine)
//import Combine
//
//extension MIDIIO {
//
//	@available(macOS 10.15, macCatalyst 13, iOS 13, *)
//	public class ManagerNew: Manager, ObservableObject {
//
//		@Published public var systemEndpointsPublished = SystemEndpointsPublished()
//
//		internal override func updateSystemEndpointsCache() {
//
//			super.updateSystemEndpointsCache()
//
//			systemEndpointsPublished.update()
//
//		}
//
//	}
//
//}
//
//extension MIDIIO {
//
//	@available(macOS 10.15, macCatalyst 13, iOS 13, *)
//	public class EndpointsPublished: ObservableObject, MIDIIOEndpointsProtocol {
//
//		@Published public internal(set) var outputs: Endpoints = []
//
//		@Published public internal(set) var inputs: Endpoints = []
//
//		public func update() {
//			sources = MIDIIO.getSystemSourceEndpoints
//			destinations = MIDIIO.getSystemDestinationEndpoints
//		}
//
//	}
//
//}
//
//#endif
