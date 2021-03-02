//
//  Entity.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-26.
//

import CoreMIDI

// MARK: - Entity

extension MIDIIO {
	
	/// A MIDI device, wrapping `MIDIEntityRef`.
	///
	/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
	public struct Entity: Object, ObjectRef {
		
		public static let objectType: MIDIIO.ObjectType = .entity
		
		// MARK: CoreMIDI ref
		
		public let ref: MIDIEntityRef
		
		// MARK: Identifiable
		
		public var id = UUID()
		
		// MARK: Init
		
		internal init(_ ref: MIDIEntityRef) {
			
			assert(ref != MIDIEntityRef())
			
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

extension MIDIIO.Entity {
	
	public var device: MIDIIO.Device? {
		
		try? MIDIIO.getSystemDevice(for: ref)
		
	}
	
	/// Returns the inputs for the entity.
	public var inputs: [MIDIIO.InputEndpoint] {
		
		MIDIIO.getSystemDestinations(for: ref)
		
	}
	
	/// Returns the outputs for the entity.
	public var outputs: [MIDIIO.OutputEndpoint] {
		
		MIDIIO.getSystemSources(for: ref)
		
	}
	
}

extension MIDIIO.Entity {
	
	/// Returns `true` if the object exists in the system by querying CoreMIDI.
	public var exists: Bool {
		
		device != nil
		
	}
	
}

extension MIDIIO.Entity: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		"Entity(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
	}
	
}
