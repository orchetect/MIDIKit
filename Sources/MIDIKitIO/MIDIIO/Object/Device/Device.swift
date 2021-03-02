//
//  Device.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-26.
//

import CoreMIDI

// MARK: - Device

extension MIDIIO {
	
	/// A MIDI device, wrapping `MIDIDeviceRef`.
	///
	/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
	///
	/// Instead, read `Device` arrays and individual `Device` properties from `MIDIIO.Manager.devices` ad-hoc when they are needed.
	public struct Device: Object, ObjectRef {
		
		public static let objectType: MIDIIO.ObjectType = .device
		
		// MARK: CoreMIDI ref
		
		public let ref: MIDIDeviceRef
		
		// MARK: Identifiable
		
		public var id = UUID()
		
		// MARK: Init
		
		internal init(_ ref: MIDIDeviceRef) {
			
			assert(ref != MIDIDeviceRef())
			
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

extension MIDIIO.Device {
	
	/// List of entities within the device.
	public var entities: [MIDIIO.Entity] {
		
		MIDIIO.getSystemEntities(for: ref)
		
	}
	
}

extension MIDIIO.Device {
	
	/// Returns `true` if the object exists in the system by querying CoreMIDI.
	public var exists: Bool {
		
		MIDIIO.getSystemDevices
			.contains(where: { $0.uniqueID == self.uniqueID })
		
	}
	
}

extension MIDIIO.Device: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		"Device(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
	}
	
}
