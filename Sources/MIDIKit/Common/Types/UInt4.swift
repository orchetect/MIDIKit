//
//  UInt4.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import OTCore
@_implementationOnly import OTCoreTesting

extension MIDI {
	
	/// An 4-bit unsigned integer value type used in `MIDIKit`.
	public struct UInt4: MIDIKitIntegerProtocol {
		
		// MARK: Storage
		
		internal var value: UInt8
		
		// MARK: Inits
		
		public init() {
			value = 0
		}
		
		public init<T: BinaryInteger>(_ source: T) {
			if source < 0 { fatalError("Underflow") }
			if source > 0b1111 { fatalError("Overflow") }
			value = UInt8(source)
		}
		
		public init?<T: BinaryInteger>(exactly source: T) {
			if source < 0 { return nil }
			if source > 0b1111 { return nil }
			value = UInt8(source)
		}
		
		public init<T: BinaryInteger>(clamping source: T) {
			value = UInt8(source.clamped(to: 0...0b1111))
		}
		
		// MARK: Constants
		
		public static let bitWidth: Int = 4
		
		public static let min: Self = Self(0)
		
		public static let max: Self = Self(0b1111)
		
		// MARK: Computed properties
		
		public var asInt: Int { Int(value) }
		
		/// Returns the integer as a `UInt8` instance
		public var asUInt8: UInt8 { UInt8(value) }
		
	}
	
}

extension MIDI.UInt4: CustomStringConvertible {
    
    public var description: String {
        "\(value)"
    }
    
}


extension MIDI.UInt4: ExpressibleByIntegerLiteral {
	
	public typealias IntegerLiteralType = UInt8
	
	public init(integerLiteral value: UInt8) {
		self.value = value
	}
	
}

extension MIDI.UInt4: Equatable, Comparable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.value == rhs.value
	}
	
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.value < rhs.value
	}
	
}

extension MIDI.UInt4: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}
	
}

extension MIDI.UInt4: Codable {
	
	enum CodingKeys: String, CodingKey {
		case value = "UInt4"
	}
	
}

// MARK: - Standard library extensions

extension BinaryInteger {
	
	/// Convenience initializer for `MIDI.UInt4`.
	public var midiUInt4: MIDI.UInt4 {
		MIDI.UInt4(self)
	}
    
    /// Convenience initializer for `MIDI.UInt4(exactly:)`.
    public var midiUInt4Exactly: MIDI.UInt4? {
        MIDI.UInt4(exactly: self)
    }
	
}
