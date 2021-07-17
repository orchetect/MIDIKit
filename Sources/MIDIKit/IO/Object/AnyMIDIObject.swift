//
//  AnyMIDIObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO {
	
	/// A type-erased box to contain a type that conforms to the `MIDI.IO.Object` and `MIDI.IO.ObjectRef` protocols.
	///
	/// When creating a variable or collection that can store any `MIDI.IO` object, using `MIDI.IO.ObjectRef` protocol as the type will allow storage of the objects and expose the properties protocolized by `MIDI.IO.ObjectRef`, but the protocol is not implicitly `Hashable` or `Identifiable` because these introduce Self requirements which would reduce the contexts in which it can be used.
	///
	/// To that end, the sister protocol `MIDI.IO.Object` exposes conformance to `Hashable` or `Identifiable` but at a cost of not having implicit properties exposed.
	///
	/// When `Hashable`/`Identifiable` conformance and object properties are required, `AnyMIDIObject` is provided as a box to contain `MIDI.IO` objects which meets both criteria.
	///
	/// - Warning: It is recommended to only use this to box objects that originate from MIDIKit.
	public struct AnyMIDIObject {
		
		internal let fallbackID: UUID = UUID()
		
		/// Guaranteed to be a type conforming to the `MIDI.IO.Object` and `MIDI.IO.ObjectRef` protocols.
		public let base: ObjectRef
		
		/// Initialize with a type conforming to the `MIDI.IO.Object` and `MIDI.IO.ObjectRef` protocols.
		public init<T: Object & ObjectRef>(_ object: T) {
			base = object
		}
		
	}
	
}

extension MIDI.IO.AnyMIDIObject: Hashable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.base.ref == rhs.base.ref
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(base.ref)
	}
	
}

@available(macOS 10.15, macCatalyst 13, iOS 13, *)
extension MIDI.IO.AnyMIDIObject: Identifiable {
	
	public var id: UUID {
		
		switch base {
		case let typed as MIDI.IO.Device:
			return typed.id
		case let typed as MIDI.IO.Entity:
			return typed.id
		case let typed as MIDI.IO.InputEndpoint:
			return typed.id
		case let typed as MIDI.IO.OutputEndpoint:
			return typed.id
		default:
			assertionFailure("Unhandled MIDI.IO.Object type.")
			return fallbackID
		}
		
	}
	
}
