//
//  InputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - InputEndpoint

extension MIDI.IO {
	
	/// A MIDI input endpoint in the system.
	///
	/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
	///
	/// Instead, read endpoint arrays and individual endpoint properties from `MIDI.IO.Manager.endpoints` ad-hoc when they are needed.
	public struct InputEndpoint: Endpoint {
		
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

extension MIDI.IO.InputEndpoint {
	
	/// Returns `true` if the object exists in the system by querying CoreMIDI.
	public var exists: Bool {
		
        MIDI.IO.getSystemDestinationEndpoint(matching: uniqueID.id) != nil
		
	}
	
}


extension MIDI.IO.InputEndpoint: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		"InputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
	}
	
}
