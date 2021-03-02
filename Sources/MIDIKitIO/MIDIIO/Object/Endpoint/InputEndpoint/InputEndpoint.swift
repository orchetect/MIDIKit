//
//  InputEndpoint.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-28.
//

import CoreMIDI

// MARK: - InputEndpoint

extension MIDIIO {
	
	/// A MIDI input endpoint in the system.
	///
	/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
	///
	/// Instead, read endpoint arrays and individual endpoint properties from `MIDIIO.Manager.endpoints` ad-hoc when they are needed.
	public struct InputEndpoint: Endpoint {
		
		public static let objectType: MIDIIO.ObjectType = .endpoint
		
		// MARK: CoreMIDI ref
		
		public let ref: MIDIEndpointRef
		
		// MARK: Identifiable
		
		public var id = UUID()
		
		// MARK: Init
		
		internal init(_ ref: MIDIEndpointRef) {
			
			assert(ref != MIDIEndpointRef())
			
			self.ref = ref
			update()
			
		}
		
		// MARK: - Properties (Cached)
		
		/// User-visible endpoint name.
		/// (`kMIDIPropertyName`)
		public internal(set) var name: String = ""
		
		/// System-global Unique ID.
		/// (`kMIDIPropertyUniqueID`)
		public internal(set) var uniqueID: UniqueID = 0
		
		/// Update the cached properties
		internal mutating func update() {
			
			self.name = (try? MIDIIO.getName(of: ref)) ?? ""
			self.uniqueID = MIDIIO.getUniqueID(of: ref)
			
		}
		
	}

}

extension MIDIIO.InputEndpoint {
	
	/// Returns `true` if the object exists in the system by querying CoreMIDI.
	public var exists: Bool {
		
		MIDIIO.getSystemDestinationEndpoint(matching: uniqueID) != nil
		
	}
	
}


extension MIDIIO.InputEndpoint: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		"InputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
	}
	
}
