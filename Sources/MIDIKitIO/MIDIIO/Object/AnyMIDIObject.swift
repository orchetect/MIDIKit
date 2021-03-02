//
//  AnyMIDIObject.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-28.
//

import CoreMIDI

extension MIDIIO {
	
	/// A type-erased box to contain a MIDIKitIO type that conforms to the `MIDIIO.Object` and `MIDIIO.ObjectRef` protocols.
	///
	/// When creating a variable or collection that can store any MIDIIO object, using `MIDIIO.ObjectRef` protocol as the type will allow storage of the objects and expose the properties protocolized by `MIDIIO.ObjectRef`, but the protocol is not implicitly `Hashable` or `Identifiable` because these introduce Self requirements which would reduce the contexts in which it can be used.
	///
	/// To that end, the sister protocol `MIDIIO.Object` exposes conformance to `Hashable` or `Identifiable` but at a cost of not having implicit properties exposed.
	///
	/// When `Hashable`/`Identifiable` conformance and object properties are required, `AnyMIDIObject` is provided as a box to contain MIDIIO objects which meets both criteria.
	///
	/// - Warning: It is recommended to only use this to box objects that originate from MIDIKitIO.
	public struct AnyMIDIObject {
		
		internal let fallbackID: UUID = UUID()
		
		/// Guaranteed to be a type conforming to the `MIDIIO.Object` and `MIDIIO.ObjectRef` protocols.
		public let base: ObjectRef
		
		/// Initialize with a type conforming to the `MIDIIO.Object` and `MIDIIO.ObjectRef` protocols.
		public init<T: Object & ObjectRef>(_ object: T) {
			base = object
		}
		
		
		
	}
	
}

extension MIDIIO.AnyMIDIObject: Hashable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.base.ref == rhs.base.ref
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(base.ref)
	}
	
}

@available(macOS 10.15, macCatalyst 13, iOS 13, *)
extension MIDIIO.AnyMIDIObject: Identifiable {
	
	public var id: UUID {
		
		switch base {
		case let typed as MIDIIO.Device: return typed.id
		case let typed as MIDIIO.Entity: return typed.id
		case let typed as MIDIIO.InputEndpoint: return typed.id
		case let typed as MIDIIO.OutputEndpoint: return typed.id
		default:
			assertionFailure("Unhandled MIDIIO.Object type.")
			return fallbackID
		}
		
	}
	
}
