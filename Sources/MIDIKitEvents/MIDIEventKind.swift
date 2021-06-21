//
//  MIDIEventKind.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-28.
//

// MARK: - MIDIEventKind

public protocol MIDIEventKind {
	
	/// Returns `self` wrapped in `AnyMIDIEventKind`
	func asAny() -> AnyMIDIEventKind

	/// Returns equitability of `self` and `other`
	func equals(_ other: MIDIEventKind) -> Bool
	
	/// Returns equitability of `self` and `other`
	func equals(_ other: AnyMIDIEventKind) -> Bool
	
}

extension MIDIEventKind where Self : Hashable {
	
	public func asAnyHashable() -> AnyHashable {
		AnyHashable(self)
	}
	
}

extension MIDIEventKind {
	
	public func asAny() -> AnyMIDIEventKind {
		AnyMIDIEventKind(self)
	}
	
}

extension MIDIEventKind where Self : Equatable {

	public func equals(_ other: MIDIEventKind) -> Bool {
		
		guard let other = other as? Self else { return false }
		return self == other

	}
	
	public func equals(_ other: AnyMIDIEventKind) -> Bool {

		guard let other = other.base as? Self else { return false }
		return self == other

	}
	
}


// MARK: - AnyMIDIEventKind

/// A type-erased MIDIEventKind value.
public struct AnyMIDIEventKind {
	
	/// The value wrapped by this instance.
	public var base: MIDIEventKind
	
	public init(_ kind: MIDIEventKind) {
		base = kind
	}
	
}

extension AnyMIDIEventKind {
	
	public func equals(_ other: AnyMIDIEventKind) -> Bool {
		
		self.base.equals(other.base)

	}
	
	public func equals(_ other: MIDIEventKind) -> Bool {
		
		self.base.equals(other)

	}
	
}

extension AnyMIDIEventKind: Equatable {

	public static func == (lhs: AnyMIDIEventKind, rhs: AnyMIDIEventKind) -> Bool {

		lhs.base.equals(rhs.base)

	}
	
	public static func != (lhs: AnyMIDIEventKind, rhs: AnyMIDIEventKind) -> Bool {

		!lhs.base.equals(rhs.base)

	}
	
	public static func == (lhs: AnyMIDIEventKind, rhs: MIDIEventKind) -> Bool {

		lhs.base.equals(rhs)

	}
	
	public static func != (lhs: AnyMIDIEventKind, rhs: MIDIEventKind) -> Bool {

		!lhs.base.equals(rhs)

	}
	
	public static func == (lhs: MIDIEventKind, rhs: AnyMIDIEventKind) -> Bool {

		lhs.equals(rhs.base)

	}
	
	public static func != (lhs: MIDIEventKind, rhs: AnyMIDIEventKind) -> Bool {

		!lhs.equals(rhs.base)

	}

}

