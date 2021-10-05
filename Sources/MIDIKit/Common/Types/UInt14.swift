//
//  UInt14.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// A 14-bit unsigned integer value type used in `MIDIKit`.
    ///
    /// Formed as from two bytes (MSB, LSB) as `(MSB << 7) + LSB` where MSB and LSB are 7-bit values.
    public struct UInt14: MIDIKitIntegerProtocol {
        
        // MARK: Storage
        
        public typealias Storage = UInt16
        public internal(set) var value: Storage
        
        // MARK: Inits
        
        public init() {
            value = 0
        }
        
        public init<T: BinaryInteger>(_ source: T) {
            if source < Self.min(Storage.self) {
                Exception.underflow.raise(reason: "UInt14 integer underflowed")
            }
            if source > Self.max(Storage.self) {
                Exception.overflow.raise(reason: "UInt14 integer overflowed")
            }
            value = Storage(source)
        }
        
        public init<T: BinaryFloatingPoint>(_ source: T) {
            // it should be safe to cast as T.self since it's virtually impossible that we will encounter a BinaryFloatingPoint type less than the largest MIDIKitIntegerProtocol concrete type we're using (UInt14).
            // the smallest floating point number in the Swift standard library is Float16 which can hold UInt14.max fine.
            if source < Self.min(T.self) {
                Exception.underflow.raise(reason: "UInt14 integer underflowed")
            }
            if source > Self.max(T.self) {
                Exception.overflow.raise(reason: "UInt14 integer overflowed")
            }
            value = Storage(source)
        }
        
        /// Converts from a bipolar floating-point unit interval (having a 0.0 neutral midpoint)
        /// (`-1.0...0.0...1.0` == `0...8192...16383`)
        ///
        /// Example:
        ///
        ///     init(bipolarUnitInterval: -1.0) == 0     == .min
        ///     init(bipolarUnitInterval: -0.5) == 4096
        ///     init(bipolarUnitInterval:  0.0) == 8192  == .midpoint
        ///     init(bipolarUnitInterval:  0.5) == 12287
        ///     init(bipolarUnitInterval:  1.0) == 16383 == .max
        public init<T: BinaryFloatingPoint>(bipolarUnitInterval: T) {
            let bipolarUnitInterval = bipolarUnitInterval.clamped(to: (-1.0)...(1.0))
            
            if bipolarUnitInterval > 0.0 {
                value = 8192 + Storage(bipolarUnitInterval * 8191)
            } else {
                value = 8192 - Storage(abs(bipolarUnitInterval) * 8192)
            }
        }
        
        /// Initialize the raw 14-bit value from two 7-bit value bytes.
        /// The top bit of each byte (0b1000_0000) will be truncated (set to 0).
        public init(bytePair: MIDI.Byte.Pair) {
            let msb = Storage(bytePair.msb & 0b111_1111) << 7
            let lsb = Storage(bytePair.lsb & 0b111_1111)
            value = msb + lsb
        }
        
        /// Initialize the raw 14-bit value from two 7-bit value bytes
        public init(uInt7Pair: MIDI.UInt7.Pair) {
            let msb = Storage(uInt7Pair.msb.value) << 7
            let lsb = Storage(uInt7Pair.lsb.value)
            value = msb + lsb
        }
        
        // MARK: Constants
        
        public static let bitWidth: Int = 14
        
        public static func min<T: BinaryInteger>(_ ofType: T.Type) -> T { 0 }
        public static func min<T: BinaryFloatingPoint>(_ ofType: T.Type) -> T { 0 }
        
        // (0x40 << 7) + 0x00
        // 0b1000000_0000000
        /// Neutral midpoint
        public static let midpoint = Self(Self.midpoint(Storage.self))
        public static func midpoint<T: BinaryInteger>(_ ofType: T.Type) -> T { 8192 }
        
        // (0x7F << 7) + 0x7F
        // 0b1111111_1111111
        public static func max<T: BinaryInteger>(_ ofType: T.Type) -> T { 16383 }
        public static func max<T: BinaryFloatingPoint>(_ ofType: T.Type) -> T { 16383 }
        
        // MARK: Computed properties
        
        /// Returns the integer as a `UInt16` instance
        public var uInt16Value: UInt16 { value }
        
        /// Converts from integer to a bipolar floating-point unit interval (having a 0.0 neutral midpoint at 8192).
        /// (`0...8192...16383` == `-1.0...0.0...1.0`)
        public var bipolarUnitIntervalValue: Double {
            
            // account for non-symmetry and round up. (This is how MIDI 1.0 Spec pitchbend works)
            if value > 8192 {
                return (Double(value) - 8192) / 8191
            } else {
                return (Double(value) - 8192) / 8192
            }
            
        }
        
        /// Returns the raw 14-bit value as two 7-bit value bytes
        public var bytePair: MIDI.Byte.Pair {
            
            let msb = (value & 0b1111111_0000000) >> 7
            let lsb = value & 0b1111111
            return .init(msb: MIDI.Byte(msb), lsb: MIDI.Byte(lsb))
            
        }
        
        /// Returns the raw 14-bit value as two 7-bit value bytes
        public var midiUInt7Pair: MIDI.UInt7.Pair {
            
            let msb = (value & 0b1111111_0000000) >> 7
            let lsb = value & 0b1111111
            return .init(msb: MIDI.UInt7(msb), lsb: MIDI.UInt7(lsb))
            
        }
        
    }
    
}

extension MIDI.UInt14: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = Storage
    
    public init(integerLiteral value: Storage) {
        self.init(value)
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

extension MIDI.UInt14: CustomStringConvertible {
    
    public var description: String {
        "\(value)"
    }
    
}

// MARK: - Standard library extensions

extension BinaryInteger {
    
    /// Convenience initializer for `MIDI.UInt14`.
    public var toMIDIUInt14: MIDI.UInt14 {
        MIDI.UInt14(self)
    }
    
    /// Convenience initializer for `MIDI.UInt14(exactly:)`.
    public var toMIDIUInt14Exactly: MIDI.UInt14? {
        MIDI.UInt14(exactly: self)
    }
    
}

extension BinaryFloatingPoint {
    
    /// Convenience initializer for `MIDI.UInt14`.
    public var toMIDIUInt14: MIDI.UInt14 {
        MIDI.UInt14(self)
    }
    
    /// Convenience initializer for `MIDI.UInt14(exactly:)`.
    public var toMIDIUInt14Exactly: MIDI.UInt14? {
        MIDI.UInt14(exactly: self)
    }
    
}
