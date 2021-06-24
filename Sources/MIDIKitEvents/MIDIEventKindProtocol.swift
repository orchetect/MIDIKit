//
//  MIDIEventKindProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - MIDIEventKindProtocol

public protocol MIDIEventKindProtocol {
	
	/// Returns `self` wrapped in `AnyMIDIEventKind`
	func asAny() -> AnyMIDIEventKind

	/// Returns equitability of `self` and `other`
	func equals(_ other: MIDIEventKindProtocol) -> Bool
	
	/// Returns equitability of `self` and `other`
	func equals(_ other: AnyMIDIEventKind) -> Bool
	
}

extension MIDIEventKindProtocol where Self : Hashable {
	
	public func asAnyHashable() -> AnyHashable {
		AnyHashable(self)
	}
	
}

extension MIDIEventKindProtocol {
	
	public func asAny() -> AnyMIDIEventKind {
		AnyMIDIEventKind(self)
	}
	
}

extension MIDIEventKindProtocol where Self : Equatable {

	public func equals(_ other: MIDIEventKindProtocol) -> Bool {
		
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
	public var base: MIDIEventKindProtocol
	
	public init(_ kind: MIDIEventKindProtocol) {
		base = kind
	}
	
}

extension AnyMIDIEventKind {
	
	public func equals(_ other: AnyMIDIEventKind) -> Bool {
		
		self.base.equals(other.base)

	}
	
	public func equals(_ other: MIDIEventKindProtocol) -> Bool {
		
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
	
	public static func == (lhs: AnyMIDIEventKind, rhs: MIDIEventKindProtocol) -> Bool {

		lhs.base.equals(rhs)

	}
	
	public static func != (lhs: AnyMIDIEventKind, rhs: MIDIEventKindProtocol) -> Bool {

		!lhs.base.equals(rhs)

	}
	
	public static func == (lhs: MIDIEventKindProtocol, rhs: AnyMIDIEventKind) -> Bool {

		lhs.equals(rhs.base)

	}
	
	public static func != (lhs: MIDIEventKindProtocol, rhs: AnyMIDIEventKind) -> Bool {

		!lhs.equals(rhs.base)

	}

}

