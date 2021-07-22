//
//  UInt4.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import OTCore
@_implementationOnly import OTCoreTesting

extension MIDI {
    
    /// A 4-bit unsigned integer value type used in `MIDIKit`.
    public struct UInt4: MIDIKitIntegerProtocol {
        
        // MARK: Storage
        
        public typealias Storage = UInt8
        public internal(set) var value: Storage
        
        // MARK: Inits
        
        public init() {
            value = 0
        }
        
        public init<T: BinaryInteger>(_ source: T) {
            if source.int < Self.min(Int.self) { fatalError("Underflow") }
            if source.int > Self.max(Int.self) { fatalError("Overflow") }
            value = Storage(source)
        }
        
        // MARK: Constants
        
        public static let bitWidth: Int = 4
        
        public static func min<T: BinaryInteger>(_ ofType: T.Type) -> T { 0 }
        
        public static func max<T: BinaryInteger>(_ ofType: T.Type) -> T { 0b1111 }
        
        // MARK: Computed properties
        
        /// Returns the integer as a `UInt8` instance
        public var uint8: UInt8 { value }
        
    }
    
}

extension MIDI.UInt4: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = Storage
    
    public init(integerLiteral value: Storage) {
        self.init(value)
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

extension MIDI.UInt4: CustomStringConvertible {
    
    public var description: String {
        "\(value)"
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
