//
//  OutputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - OutputEndpoint

extension MIDI.IO {
	
	/// A MIDI output endpoint in the system.
	///
	/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
	///
	/// Instead, read endpoint arrays and individual endpoint properties from `MIDI.IO.Manager.endpoints` ad-hoc when they are needed.
	public struct OutputEndpoint: Endpoint {
		
		public static let objectType: MIDI.IO.ObjectType = .endpoint
		
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
			
			self.name = (try? MIDI.IO.getName(of: ref)) ?? ""
			self.uniqueID = MIDI.IO.getUniqueID(of: ref)
			
		}
		
	}

}

extension MIDI.IO.OutputEndpoint {
	
	/// Returns `true` if the object exists in the system by querying CoreMIDI.
	public var exists: Bool {
		
		MIDI.IO.getSystemSourceEndpoint(matching: uniqueID) != nil
		
	}
	
}

extension MIDI.IO.OutputEndpoint: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		"OutputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
	}
	
}
