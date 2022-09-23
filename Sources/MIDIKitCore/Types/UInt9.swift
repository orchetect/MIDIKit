//
//  UInt9.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

/// A 9-bit unsigned integer value type used in `MIDIKit`.
public struct UInt9: MIDIUnsignedInteger, _MIDIUnsignedInteger {
    public typealias Storage = UInt16
    var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt9 {
    static let integerName: StaticString = "UInt9"
    
    init(unchecked value: Storage) {
        storage = value
    }
}

// MARK: - Protocol Requirements

extension UInt9 {
    public typealias Magnitude = Storage.Magnitude
    public typealias Words = Storage.Words
    
    public static let bitWidth: Int = 9
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

// MARK: - Struct-Specific Properties

extension UInt9 {
    // midpoint
    // 0b1_0000_0000, int 256, hex 0x0FF
    
    /// Returns the integer as a `UInt16` instance.
    public var uInt16Value: UInt16 { storage }
}

// ----------------------------------------
// MARK: - Common Conformances Across UInts
// ----------------------------------------

// MARK: - Equatable

extension UInt9 /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
}

// MARK: - Comparable

extension UInt9 /*: Comparable */ {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
}

// MARK: - Hashable

extension UInt9 /*: Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(storage)
    }
}

// MARK: - Codable

extension UInt9 /*: Codable */ {
    public func encode(to encoder: Encoder) throws {
        var e = encoder.singleValueContainer()
        try e.encode(storage)
    }
    
    public init(from decoder: Decoder) throws {
        let d = try decoder.singleValueContainer()
        let decoded = try d.decode(Storage.self)
        guard let new = Self(exactly: decoded) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Encoded value is not a valid \(Self.integerName)."
                )
            )
        }
        self = new
    }
}

// MARK: - CustomStringConvertible

extension UInt9 { //: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        storage.description
    }
    
    public var debugDescription: String {
        "\(Self.integerName)(\(storage.description))"
    }
}

// MARK: - _MIDIUnsignedInteger Default Implementation

extension UInt9 {
    static func min<T: BinaryInteger>(as ofType: T.Type) -> T { 0 }
    static func min<T: BinaryFloatingPoint>(as ofType: T.Type) -> T { 0 }
    
    static func max<T: BinaryInteger>(as ofType: T.Type) -> T {
        (0 ..< bitWidth)
            .reduce(into: T()) { $0 |= (0b1 << $1) }
    }
    
    static func max<T: BinaryFloatingPoint>(as ofType: T.Type) -> T {
        T(max(as: Int.self))
    }
}

// MARK: - MIDIUnsignedInteger Conveniences

extension UInt9 {
    /// Returns the integer converted to an `Int` instance (convenience).
    public var intValue: Int { Int(storage) }
}

// MARK: - FixedWidthInteger

extension UInt9 /*: FixedWidthInteger */ {
    public static var min: Self { Self(Self.min(as: Storage.self)) }
    
    public static var max: Self { Self(Self.max(as: Storage.self)) }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger {
        lhs.storage >>= rhs
    }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger {
        lhs.storage <<= rhs
    }
}

// MARK: - Numeric

extension UInt9 /*: Numeric */ {
    // public typealias Magnitude = Storage.Magnitude
    // Magnitude is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public var magnitude: Storage.Magnitude {
        storage.magnitude
    }
    
    public init?<T>(exactly source: T) where T: BinaryInteger {
        if source < Self.min(as: Storage.self) ||
            source > Self.max(as: Storage.self)
        {
            return nil
        }
        self.init(unchecked: Storage(source))
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage * rhs.storage)
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.storage * rhs.storage)
    }
}

// MARK: - AdditiveArithmetic

extension UInt9 /*: AdditiveArithmetic */ {
    // static let zero synthesized by AdditiveArithmetic
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage + rhs.storage)
    }
    
    // += operator synthesized by AdditiveArithmetic
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage - rhs.storage)
    }
    
    // -= operator synthesized by AdditiveArithmetic
}

// MARK: - BinaryInteger

extension UInt9 /*: BinaryInteger */ {
    // public typealias Words = Storage.Words
    // Words is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public var words: Storage.Words {
        storage.words
    }
    
    // synthesized?
    //    public static var isSigned: Bool { false }
    
    public var bitWidth: Int { Self.bitWidth }
    
    public var trailingZeroBitCount: Int {
        storage.trailingZeroBitCount - (storage.bitWidth - Self.bitWidth)
    }
    
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage / rhs.storage)
    }
    
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = Self(lhs.storage / rhs.storage)
    }
    
    public static func % (lhs: Self, rhs: Self) -> Self {
        Self(lhs.storage % rhs.storage)
    }
    
    public static func << <RHS>(lhs: Self, rhs: RHS) -> Self
    where RHS: BinaryInteger {
        Self(lhs.storage << rhs)
    }
    
    public static func >> <RHS>(lhs: Self, rhs: RHS) -> Self
    where RHS: BinaryInteger {
        Self(lhs.storage >> rhs)
    }
    
    public static func %= (lhs: inout Self, rhs: Self) {
        lhs.storage %= rhs.storage
    }
    
    public static func &= (lhs: inout Self, rhs: Self) {
        lhs.storage &= rhs.storage
    }
    
    public static func |= (lhs: inout Self, rhs: Self) {
        lhs.storage |= rhs.storage
    }
    
    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs.storage ^= rhs.storage
    }
    
    public static prefix func ~ (x: Self) -> Self {
        // mask to bit width
        Self(unchecked: ~x.storage & Self.max(as: Self.self).storage)
    }
}
