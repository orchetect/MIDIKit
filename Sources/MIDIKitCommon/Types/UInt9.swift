//
//  UInt9.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitInternals

/// A 9-bit unsigned integer value type used in `MIDIKit`.
public struct UInt9: MIDIIntegerProtocol {
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
        // it should be safe to cast as T.self since it's virtually impossible
        // that we will encounter a BinaryFloatingPoint type that cannot fit UInt9.max
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
    
    // midpoint
    // 0b1_0000_0000, int 256, hex 0x0FF
    
    // 0b1_1111_1111, int 511, hex 0x1FF
    public static func max<T: BinaryInteger>(_ ofType: T.Type) -> T { 511 }
    public static func max<T: BinaryFloatingPoint>(_ ofType: T.Type) -> T { 511 }
    
    // MARK: Computed properties
    
    /// Returns the integer as a `UInt16` instance
    public var uInt16Value: UInt16 { value }
}

extension UInt9: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Storage
    
    public init(integerLiteral value: Storage) {
        self.init(value)
    }
}

extension UInt9: Strideable {
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

extension UInt9: Equatable, Comparable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

extension UInt9: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension UInt9: Codable {
    enum CodingKeys: String, CodingKey {
        case value = "UInt9"
    }
}

extension UInt9: CustomStringConvertible {
    public var description: String {
        "\(value)"
    }
}

// MARK: - Standard library extensions

extension BinaryInteger {
    /// Convenience initializer for `UInt9`.
    public var toUInt9: UInt9 {
        UInt9(self)
    }
    
    /// Convenience initializer for `UInt9(exactly:)`.
    public var toUInt9Exactly: UInt9? {
        UInt9(exactly: self)
    }
}

extension BinaryFloatingPoint {
    /// Convenience initializer for `UInt9`.
    public var toUInt9: UInt9 {
        UInt9(self)
    }
    
    /// Convenience initializer for `UInt9(exactly:)`.
    public var toUInt9Exactly: UInt9? {
        UInt9(exactly: self)
    }
}
