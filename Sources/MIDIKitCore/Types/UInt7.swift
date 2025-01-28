//
//  UInt7.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import MIDIKitInternals

/// A 7-bit unsigned integer value type used in `MIDIKit`.
public struct UInt7: MIDIUnsignedInteger, _MIDIUnsignedInteger {
    public typealias Storage = UInt8
    var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt7 {
    static let integerName: StaticString = "UInt7"
    
    init(unchecked value: Storage) {
        storage = value
    }
}

// MARK: - Protocol Requirements

extension UInt7 {
    public typealias Magnitude = Storage.Magnitude
    public typealias Words = Storage.Words
    
    public static let bitWidth: Int = 7
}

// MARK: - Standard library extensions

extension BinaryInteger {
    /// Convenience initializer for `UInt7`.
    public var toUInt7: UInt7 {
        UInt7(self)
    }
    
    /// Convenience initializer for `UInt7(exactly:)`.
    public var toUInt7Exactly: UInt7? {
        UInt7(exactly: self)
    }
}

extension BinaryFloatingPoint {
    /// Convenience initializer for `UInt7`.
    public var toUInt7: UInt7 {
        UInt7(self)
    }
    
    /// Convenience initializer for `UInt7(exactly:)`.
    public var toUInt7Exactly: UInt7? {
        UInt7(exactly: self)
    }
}

// MARK: - Struct-Specific Properties

extension UInt7 {
    // 0b100_0000, int 64, hex 0x40
    /// Neutral midpoint.
    public static let midpoint = Self(Self.midpoint(as: Storage.self))
    static func midpoint<T: BinaryInteger>(as ofType: T.Type) -> T { 0b1000000 }
    
    /// Returns the integer as a `UInt8` instance.
    public var uInt8Value: UInt8 { storage }
}

// ----------------------------------------
// MARK: - Common Conformances Across UInts
// ----------------------------------------

// MARK: - Equatable

extension UInt7 /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
}

// MARK: - Comparable

extension UInt7 /*: Comparable */ {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
}

// MARK: - Hashable

extension UInt7 /*: Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(storage)
    }
}

// MARK: - Sendable

extension UInt7: Sendable { }

// MARK: - Codable

extension UInt7 /*: Codable */ {
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

extension UInt7 /* : CustomStringConvertible */ {
    public var description: String {
        storage.description
    }
}

extension UInt7 /* : CustomDebugStringConvertible */ {
    public var debugDescription: String {
        "\(Self.integerName)(\(storage.description))"
    }
}

// MARK: - _MIDIUnsignedInteger Default Implementation

extension UInt7 {
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

extension UInt7 {
    /// Returns the integer converted to an `Int` instance (convenience).
    public var intValue: Int { Int(storage) }
}

// MARK: - FixedWidthInteger

extension UInt7 /*: FixedWidthInteger */ {
    public static var min: Self { Self(Self.min(as: Storage.self)) }
    
    public static var max: Self { Self(Self.max(as: Storage.self)) }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func >>= (lhs: inout Self, rhs: some BinaryInteger) {
        lhs.storage >>= rhs
    }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func <<= (lhs: inout Self, rhs: some BinaryInteger) {
        lhs.storage <<= rhs
    }
}

// MARK: - Numeric

extension UInt7 /*: Numeric */ {
    // public typealias Magnitude = Storage.Magnitude
    // Magnitude is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public var magnitude: Storage.Magnitude {
        storage.magnitude
    }
    
    public init?(exactly source: some BinaryInteger) {
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

extension UInt7 /*: AdditiveArithmetic */ {
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

extension UInt7 /*: BinaryInteger */ {
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
    
    public static func << (lhs: Self, rhs: some BinaryInteger) -> Self {
        Self(lhs.storage << rhs)
    }
    
    public static func >> (lhs: Self, rhs: some BinaryInteger) -> Self {
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
