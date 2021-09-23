//
//  UInt9.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// A 9-bit unsigned integer value type used in `MIDIKit`.
    public struct UInt9: MIDIKitIntegerProtocol {
        
        // MARK: Storage
        
        public typealias Storage = UInt16
        public internal(set) var value: Storage
        
        // MARK: Inits
        
        public init() {
            value = 0
        }
        
        public init<T: BinaryInteger>(_ source: T) {
            if source < Self.min(Storage.self) {
                Exception.underflow.raise(reason: "UInt9 integer underflowed")
            }
            if source > Self.max(Storage.self) {
                Exception.overflow.raise(reason: "UInt9 integer overflowed")
            }
            value = Storage(source)
        }
        
        public init<T: BinaryFloatingPoint>(_ source: T) {
            // it should be safe to cast as T.self since it's virtually impossible that we will encounter a BinaryFloatingPoint type less than the largest MIDIKitIntegerProtocol concrete type we're using (UInt9).
            // the smallest floating point number in the Swift standard library is Float16 which can hold UInt9.max fine.
            if source < Self.min(T.self) {
                Exception.underflow.raise(reason: "UInt9 integer underflowed")
            }
            if source > Self.max(T.self) {
                Exception.overflow.raise(reason: "UInt9 integer overflowed")
            }
            value = Storage(source)
        }
        
        // MARK: Constants
        
        public static let bitWidth: Int = 9
        
        public static func min<T: BinaryInteger>(_ ofType: T.Type) -> T { 0 }
        public static func min<T: BinaryFloatingPoint>(_ ofType: T.Type) -> T { 0 }
        
        // 0b1_1111_1111
        public static func max<T: BinaryInteger>(_ ofType: T.Type) -> T { 511 }
        public static func max<T: BinaryFloatingPoint>(_ ofType: T.Type) -> T { 511 }
        
        // MARK: Computed properties
        
        /// Returns the integer as a `UInt16` instance
        public var uInt16Value: UInt16 { value }
        
    }
    
}

extension MIDI.UInt9: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = Storage
    
    public init(integerLiteral value: Storage) {
        self.init(value)
    }
    
}

extension MIDI.UInt9: Equatable, Comparable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
    
}

extension MIDI.UInt9: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
}

extension MIDI.UInt9: Codable {
    
    enum CodingKeys: String, CodingKey {
        case value = "UInt9"
    }
    
}

extension MIDI.UInt9: CustomStringConvertible {
    
    public var description: String {
        "\(value)"
    }
    
}

// MARK: - Standard library extensions

extension BinaryInteger {
    
    /// Convenience initializer for `MIDI.UInt9`.
    public var toMIDIUInt9: MIDI.UInt9 {
        MIDI.UInt9(self)
    }
    
    /// Convenience initializer for `MIDI.UInt9(exactly:)`.
    public var toMIDIUInt9Exactly: MIDI.UInt9? {
        MIDI.UInt9(exactly: self)
    }
    
}

extension BinaryFloatingPoint {
    
    /// Convenience initializer for `MIDI.UInt9`.
    public var toMIDIUInt9: MIDI.UInt9 {
        MIDI.UInt9(self)
    }
    
    /// Convenience initializer for `MIDI.UInt9(exactly:)`.
    public var toMIDIUInt9Exactly: MIDI.UInt9? {
        MIDI.UInt9(exactly: self)
    }
    
}
