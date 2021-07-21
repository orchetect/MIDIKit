//
//  UInt14.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import OTCore
@_implementationOnly import OTCoreTesting

extension MIDI {
	
	/// A 14-bit unsigned integer value type used in `MIDIKit`.
	///
	/// Formed as from two bytes (MSB, LSB) as `(MSB << 7) + LSB` where MSB and LSB are 7-bit values.
	public struct UInt14: MIDIKitIntegerProtocol {
		
		// MARK: Storage
		
		/// Raw value
		public let value: Int
		
		// MARK: Inits
		
		/// Defaults to neutral midpoint value
		public init() {
			value = 8192
		}
		
		/// Initialize with a raw value (0...16383)
		public init<T: BinaryInteger>(_ source: T) {
			let sourceInt = Int(source)
			
			guard (0...16383).contains(sourceInt)
			else { fatalError("Overflow") }
			
			self.value = sourceInt.clamped(to: 0...16383)
		}
		
		/// Initialize with a raw value (0...16383)
		/// Returns `nil` in the event of overflow.
		public init?<T: BinaryInteger>(exactly source: T) {
			let sourceInt = Int(source)
			
			if !(0...16383).contains(sourceInt) { return nil }
			
			value = sourceInt
		}
		
		public init<T: BinaryInteger>(clamping source: T) {
			self.value = Int(source).clamped(to: 0...16383)
		}
		
		/// Converts from a floating-point unit interval having a 0.0 neutral midpoint
		/// (`-1.0...0.0...1.0` to `0...8192...16383`)
		///
		/// Example:
		///
		///     init(zeroMidpointFloat: -1.0) == 0     == .min
		///     init(zeroMidpointFloat: -0.5) == 4096
		///     init(zeroMidpointFloat:  0.0) == 8192  == .midpoint
		///     init(zeroMidpointFloat:  0.5) == 12287
		///     init(zeroMidpointFloat:  1.0) == 16383 == .max
		public init<T: BinaryFloatingPoint>(zeroMidpointFloat: T) {
			let zeroMidpointFloat = zeroMidpointFloat.clamped(to: (-1.0)...(1.0))
			
			if zeroMidpointFloat > 0.0 {
				value = 8192 + Int(zeroMidpointFloat * 8191)
			} else {
				value = 8192 - Int(abs(zeroMidpointFloat) * 8192)
			}
			
		}
		
		/// Initialize the raw 14-bit value from two 7-bit value bytes
        public init(bytePair: MIDI.BytePair) {
			let msb = Int(bytePair.MSB & 0b1111111) << 7
			let lsb = Int(bytePair.LSB & 0b1111111)
			value = msb + lsb
		}
		
		
		// MARK: Constants
		
		public static let bitWidth: Int = 14
		
		/// Minimum value
		public static let min = Self(0)
		
		// (0x40 << 7) + 0x00
		// 0b1000000_0000000
		/// Neutral midpoint
		public static let midpoint = Self(8192)
		
		// (0x7F << 7) + 0x7F
		// 0b1111111_1111111
		/// Maximum value
		public static let max = Self(16383)
		
		
		// MARK: Computed properties
		
		public var asInt: Int { value }
		
		/// Returns the integer as a `UInt16` instance
		public var asUInt16: UInt16 { UInt16(value) }
		
		/// Converts from integer to a floating-point unit interval having a 0.0 neutral midpoint
		/// (`0...8192...16383` to `-1.0...0.0...1.0`)
		public var zeroMidpointFloat: Double {
			
			// account for non-symmetry of the pitch wheel raw value range
			if value > 8192 {
				return (Double(value) - 8192) / 8191
			} else {
				return (Double(value) - 8192) / 8192
			}
			
		}
		
		/// Returns the raw 14-bit value as two 7-bit value bytes
        public var bytePair: MIDI.BytePair {
			let msb = (value & 0b1111111_0000000) >> 7
			let lsb = value & 0b1111111
			return .init(MSB: MIDI.Byte(msb), LSB: MIDI.Byte(lsb))
		}
		
	}
	
}

extension MIDI.UInt14: CustomStringConvertible {
    
    public var description: String {
        "\(value)"
    }
    
}

extension MIDI.UInt14: ExpressibleByIntegerLiteral {
	
	public typealias IntegerLiteralType = UInt16
	
	public init(integerLiteral value: UInt16) {
		self.value = Int(value).clamped(to: 0...16383)
	}
	
}

extension MIDI.UInt14: Equatable, Comparable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.value == rhs.value
	}
	
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.value < rhs.value
	}
	
}

extension MIDI.UInt14: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}
	
}

extension MIDI.UInt14: Codable {
	
	enum CodingKeys: String, CodingKey {
		case value = "UInt14"
	}
	
}

extension BinaryInteger {
	
	/// Convenience initializer for `MIDI.UInt14`.
	public var midiUInt14: MIDI.UInt14 {
		MIDI.UInt14(self)
	}
	
    /// Convenience initializer for `MIDI.UInt14(exactly:)`.
    public var midiUInt14Exactly: MIDI.UInt14? {
        MIDI.UInt14(exactly: self)
    }
    
    /// Creates a new instance from the given integer.
    public init(_ source: MIDI.UInt14) {
        self.init(source.value)
    }
    
    /// Creates a new instance from the given integer, if it can be represented exactly.
    public init?(exactly source: MIDI.UInt14) {
        self.init(exactly: source.value)
    }
    
}
