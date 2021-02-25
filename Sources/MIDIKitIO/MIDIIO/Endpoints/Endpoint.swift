//
//  Endpoint.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-24.
//

import CoreMIDI

extension MIDIIO {
	
	// MARK: - Endpoint
	
	/// A MIDI endpoint, wrapping `MIDIEndpointRef`.
	///
	/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
	///
	/// Instead, read `Endpoint` arrays and individual `Endpoint` properties from `MIDIIO.Manager.endpoints` ad-hoc when they are needed.
	public struct Endpoint {
		
		// MARK: - CoreMIDI ref
		
		public let ref: MIDIEndpointRef
		
		
		// MARK: - Init
		
		public init(_ ref: MIDIEndpointRef) {
			
			self.ref = ref
			update()
			
		}
		
		/// Update the cached properties
		internal mutating func update() {
			
			self.name = (try? ref.getName()) ?? ""
			self.uniqueID = ref.getUniqueID()
			
		}
		
		
		// MARK: - Common properties (cached)
		
		/// User-visible endpoint name.
		/// (`kMIDIPropertyName`)
		public internal(set) var name: String = ""
		
		/// System-global Unique ID.
		public internal(set) var uniqueID: UniqueID = 0
		
		
		// MARK: - Extended properties (computed)
		
		/// The entity's system-exclusive ID, in user-visible form.
		/// (`kMIDIPropertyDeviceID`)
		public var propertyDeviceID: Int32 { ref.getDeviceID() }
		
		/// Display name. Apple-recommended user-visible name; combines device & endpoint names.
		/// (`kMIDIPropertyDisplayName`)
		public var propertyDisplayName: String? { try? ref.getDisplayName() }
		
		/// Name of the driver that owns a device.
		///
		/// Set by the owning driver, on the device; should not be touched by other clients.
		/// Property is inherited from the device by its entities and endpoints.
		public var propertyDriverOwner: String? { try? ref.getDriverOwner() }
		
		/// `False` if there are external MIDI connectors, `True` if not.
		/// (`kMIDIPropertyIsEmbeddedEntity`)
		public var propertyIsEmbeddedEntity: Bool { ref.getIsEmbeddedEntity() }
		
		/// `True` if offline (temporarily absent) or `False` if present.
		/// (`kMIDIPropertyOffline`)
		public var propertyIsOffline: Bool { ref.getIsOffline() }
		
		/// `True` if endpoint is private, hidden from other clients.
		/// (`kMIDIPropertyPrivate`)
		public var propertyIsPrivate: Bool { ref.getIsPrivate() }
		
		/// Manufacturer name.
		/// (`kMIDIPropertyManufacturer`)
		public var propertyManufacturer: String? { try? ref.getManufacturer() }
		
		/// Model name.
		/// (`kMIDIPropertyModel`)
		public var propertyModel: String? { try? ref.getModel() }
		
	}
	
}

extension MIDIIO.Endpoint: Equatable {
	
	static public func == (lhs: Self, rhs: Self) -> Bool {
		lhs.ref == rhs.ref
	}
	
}

extension MIDIIO.Endpoint: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(ref)
	}
	
}

// MARK: - UniqueID

extension MIDIIO.Endpoint {
	
	public typealias UniqueID = Int32
	
}
