//
//  MIDIUInt7.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-24.
//

@_implementationOnly import OTCore
@_implementationOnly import OTCoreTesting

/// An 7-bit unsigned integer value type used in `MIDIKit`.
public struct MIDIUInt7: MIDIKitInteger {
	
	// MARK: Storage
	
	internal var value: UInt8
	
	// MARK: Inits
	
	public init() {
		value = 0
	}
	
	public init<T: BinaryInteger>(_ source: T) {
		if source < 0 { fatalError("Underflow") }
		if source > 0b111_1111 { fatalError() }
		value = UInt8(source)
	}
	
	public init?<T: BinaryInteger>(exactly source: T) {
		if source < 0 { return nil }
		if source > 0b111_1111 { return nil }
		value = UInt8(source)
	}
	
	public init<T: BinaryInteger>(clamping source: T) {
		value = UInt8(source.clamped(to: 0...0b111_1111))
	}
	
	// MARK: Constants
	
	public static let bitWidth: Int = 7
	
	public static let min: Self = Self(0)
	
	public static let midpoint: Self = Self(64)
	
	public static let max: Self = Self(0b111_1111)
	
	// MARK: Computed properties
	
	public var asInt: Int { Int(value) }
	
	/// Returns the integer as a `UInt8` instance
	public var asUInt8: UInt8 { UInt8(value) }
	
}

extension MIDIUInt7: ExpressibleByIntegerLiteral {
	
	public typealias IntegerLiteralType = UInt8
	
	public init(integerLiteral value: UInt8) {
		self.value = value
	}
	
}

extension MIDIUInt7: Equatable, Comparable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.value == rhs.value
	}
	
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.value < rhs.value
	}
	
}

extension MIDIUInt7: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}
	
}

extension MIDIUInt7: Codable {
	
	enum CodingKeys: String, CodingKey {
		case value = "UInt7"
	}
	
}

// MARK: - Standard library extensions

extension BinaryInteger {
	
	/// Convenience initializer for `MIDIUInt7` as a property.
	public var midiUInt7: MIDIUInt7 {
		MIDIUInt7(self)
	}
	
}
