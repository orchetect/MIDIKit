//
//  UInt4.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if compiler(>=6.0)
internal import MIDIKitInternals
#else
@_implementationOnly import MIDIKitInternals
#endif

/// A 4-bit unsigned integer value type used in `MIDIKit`.
public struct UInt4: MIDIUnsignedInteger, _MIDIUnsignedInteger {
    public typealias Storage = UInt8
    var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt4 {
    static let integerName: StaticString = "UInt4"
    
    init(unchecked value: Storage) {
        storage = value
    }
}

// MARK: - Protocol Requirements

extension UInt4 {
    public typealias Magnitude = Storage.Magnitude
    public typealias Words = Storage.Words
    
    public static let bitWidth: Int = 4
}

// MARK: - Standard library extensions

extension BinaryInteger {
    /// Convenience initializer for `UInt4`.
    public var toUInt4: UInt4 {
        UInt4(self)
    }
    
    /// Convenience initializer for `UInt4(exactly:)`.
    public var toUInt4Exactly: UInt4? {
        UInt4(exactly: self)
    }
}

extension BinaryFloatingPoint {
    /// Convenience initializer for `UInt4`.
    public var toUInt4: UInt4 {
        UInt4(self)
    }
    
    /// Convenience initializer for `UInt4(exactly:)`.
    public var toUInt4Exactly: UInt4? {
        UInt4(exactly: self)
    }
}

// MARK: - Struct-Specific Properties

extension UInt4 {
    /// Returns the integer as a `UInt8` instance.
    public var uInt8Value: UInt8 { storage }
}

// ----------------------------------------
// MARK: - Common Conformances Across UInts
// ----------------------------------------

// MARK: - Equatable

extension UInt4 /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
}

// MARK: - Comparable

extension UInt4 /*: Comparable */ {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
}

// MARK: - Hashable

extension UInt4 /*: Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(storage)
    }
}

// MARK: - Sendable

extension UInt4: Sendable { }

// MARK: - Codable

extension UInt4 /*: Codable */ {
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

extension UInt4 { //: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        storage.description
    }
    
    public var debugDescription: String {
        "\(Self.integerName)(\(storage.description))"
    }
}

// MARK: - _MIDIUnsignedInteger Default Implementation

extension UInt4 {
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

extension UInt4 {
    /// Returns the integer converted to an `Int` instance (convenience).
    public var intValue: Int { Int(storage) }
}

// MARK: - FixedWidthInteger

extension UInt4 /*: FixedWidthInteger */ {
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

extension UInt4 /*: Numeric */ {
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

extension UInt4 /*: AdditiveArithmetic */ {
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

extension UInt4 /*: BinaryInteger */ {
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
