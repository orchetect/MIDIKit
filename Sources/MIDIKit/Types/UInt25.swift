//
//  UInt25.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

/// A 25-bit unsigned integer value type used in `MIDIKit`.
public struct UInt25: MIDIIntegerProtocol {
    // MARK: Storage
        
    public typealias Storage = UInt32
    public internal(set) var value: Storage
        
    // MARK: Inits
        
    public init() {
        value = 0
    }
        
    public init<T: BinaryInteger>(_ source: T) {
        if source < Self.min(Storage.self) {
            Exception.underflow.raise(reason: "UInt25 integer underflowed")
        }
        if source > Self.max(Storage.self) {
            Exception.overflow.raise(reason: "UInt25 integer overflowed")
        }
        value = Storage(source)
    }
        
    public init<T: BinaryFloatingPoint>(_ source: T) {
        // we need to cast to UInt here to ensure comparison succeeds
        if source < Self.min(T.self) {
            Exception.underflow.raise(reason: "UInt25 integer underflowed")
        }
        if UInt(source) > Self.max(UInt.self) {
            Exception.overflow.raise(reason: "UInt25 integer overflowed")
        }
        value = Storage(source)
    }
        
    // MARK: Constants
        
    public static let bitWidth: Int = 25
        
    public static func min<T: BinaryInteger>(_ ofType: T.Type) -> T { 0 }
    public static func min<T: BinaryFloatingPoint>(_ ofType: T.Type) -> T { 0 }
        
    // 0b1_00000000_00000000_00000000
    public static let midpoint = Self(Self.midpoint(Storage.self))
    public static func midpoint<T: BinaryInteger>(_ ofType: T.Type) -> T { 16_777_216 }
        
    // 0b1_11111111_11111111_11111111
    public static func max<T: BinaryInteger>(_ ofType: T.Type) -> T { 33_554_431 }
    public static func max<T: BinaryFloatingPoint>(_ ofType: T.Type) -> T { 33_554_431 }
        
    // MARK: Computed properties
        
    /// Returns the integer as a `UInt32` instance
    public var uInt32Value: UInt32 { value }
}

extension UInt25: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Storage
    
    public init(integerLiteral value: Storage) {
        self.init(value)
    }
}

extension UInt25: Strideable {
    public typealias Stride = Int
    
    @inlinable
    public func advanced(by n: Stride) -> Self {
        self + Self(n)
    }
    
    @inlinable
    public func distance(to other: Self) -> Stride {
        Stride(other) - Stride(self)
    }
}

extension UInt25: Equatable, Comparable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

extension UInt25: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension UInt25: Codable {
    enum CodingKeys: String, CodingKey {
        case value = "UInt25"
    }
}

extension UInt25: CustomStringConvertible {
    public var description: String {
        "\(value)"
    }
}

// MARK: - Standard library extensions

extension BinaryInteger {
    /// Convenience initializer for `UInt25`.
    public var toUInt25: UInt25 {
        UInt25(self)
    }
    
    /// Convenience initializer for `UInt25(exactly:)`.
    public var toUInt25Exactly: UInt25? {
        UInt25(exactly: self)
    }
}

extension BinaryFloatingPoint {
    /// Convenience initializer for `UInt25`.
    public var toUInt25: UInt25 {
        UInt25(self)
    }
    
    /// Convenience initializer for `UInt25(exactly:)`.
    public var toUInt25Exactly: UInt25? {
        UInt25(exactly: self)
    }
}
