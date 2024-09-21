//
//  UInt14.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if compiler(>=6.0)
internal import MIDIKitInternals
#else
@_implementationOnly import MIDIKitInternals
#endif

/// A 14-bit unsigned integer value type used in `MIDIKit`.
///
/// Formed as from two bytes (MSB, LSB) as `(MSB << 7) + LSB` where MSB and LSB are 7-bit values.
public struct UInt14: MIDIUnsignedInteger, _MIDIUnsignedInteger {
    public typealias Storage = UInt16
    var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt14 {
    static let integerName: StaticString = "UInt14"
    
    init(unchecked value: Storage) {
        storage = value
    }
}

// MARK: - Protocol Requirements

extension UInt14 {
    public typealias Magnitude = Storage.Magnitude
    public typealias Words = Storage.Words
    
    public static let bitWidth: Int = 14
}

// MARK: - Standard library extensions

extension BinaryInteger {
    /// Convenience initializer for `UInt14`.
    public var toUInt14: UInt14 {
        UInt14(self)
    }
    
    /// Convenience initializer for `UInt14(exactly:)`.
    public var toUInt14Exactly: UInt14? {
        UInt14(exactly: self)
    }
}

extension BinaryFloatingPoint {
    /// Convenience initializer for `UInt14`.
    public var toUInt14: UInt14 {
        UInt14(self)
    }
    
    /// Convenience initializer for `UInt14(exactly:)`.
    public var toUInt14Exactly: UInt14? {
        UInt14(exactly: self)
    }
}

// MARK: - Struct-Specific Properties

extension UInt14 {
    // (0x40 << 7) + 0x00
    // 0b1000000_0000000, int 8192, hex 0x2000
    /// Neutral midpoint.
    public static let midpoint = Self(Self.midpoint(as: Storage.self))
    static func midpoint<T: BinaryInteger>(as ofType: T.Type) -> T { 8192 }
    
    // MARK: - Inits
    
    /// Converts from a bipolar floating-point unit interval (having a 0.0 neutral midpoint)
    /// (`-1.0 ... 0.0 ... 1.0` == `0 ... 8192 ... 16383`).
    ///
    /// Example:
    ///
    ///     init(bipolarUnitInterval: -1.0) == 0     == .min
    ///     init(bipolarUnitInterval: -0.5) == 4096
    ///     init(bipolarUnitInterval:  0.0) == 8192  == .midpoint
    ///     init(bipolarUnitInterval:  0.5) == 12287
    ///     init(bipolarUnitInterval:  1.0) == 16383 == .max
    public init(bipolarUnitInterval: some BinaryFloatingPoint) {
        let bipolarUnitInterval = bipolarUnitInterval.clamped(to: (-1.0) ... (1.0))
    
        if bipolarUnitInterval > 0.0 {
            storage = 8192 + Storage(bipolarUnitInterval * 8191)
        } else {
            storage = 8192 - Storage(abs(bipolarUnitInterval) * 8192)
        }
    }
    
    /// Initialize the raw 14-bit value from two 7-bit value bytes.
    /// The top bit of each byte (`0b1000_0000`) will be truncated (set to 0).
    public init(bytePair: BytePair) {
        let msb = Storage(bytePair.msb & 0b1111111) << 7
        let lsb = Storage(bytePair.lsb & 0b1111111)
        storage = msb + lsb
    }
    
    /// Initialize the raw 14-bit value from two 7-bit value bytes.
    public init(uInt7Pair: UInt7Pair) {
        let msb = Storage(uInt7Pair.msb.storage) << 7
        let lsb = Storage(uInt7Pair.lsb.storage)
        storage = msb + lsb
    }
    
    // MARK: - Computed properties
    
    /// Returns the integer as a `UInt16` instance.
    public var uInt16Value: UInt16 { storage }
    
    /// Converts from integer to a bipolar floating-point unit interval (having a 0.0 neutral
    /// midpoint at 8192).
    /// (`0 ... 8192 ... 16383` == `-1.0 ... 0.0 ... 1.0`)
    public var bipolarUnitIntervalValue: Double {
        // account for non-symmetry and round up. (This is how MIDI 1.0 Spec pitchbend works)
        if storage > 8192 {
            return (Double(storage) - 8192) / 8191
        } else {
            return (Double(storage) - 8192) / 8192
        }
    }
    
    /// Returns the raw 14-bit value as two 7-bit value bytes.
    public var bytePair: BytePair {
        let msb = (storage & 0b111111_10000000) >> 7
        let lsb = storage & 0b1111111
        return .init(msb: UInt8(msb), lsb: UInt8(lsb))
    }
    
    /// Returns the raw 14-bit value as two 7-bit value bytes.
    public var midiUInt7Pair: UInt7Pair {
        let msb = (storage & 0b111111_10000000) >> 7
        let lsb = storage & 0b1111111
        return .init(msb: UInt7(msb), lsb: UInt7(lsb))
    }
}

// ----------------------------------------
// MARK: - Common Conformances Across UInts
// ----------------------------------------

// MARK: - Equatable

extension UInt14 /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
}

// MARK: - Comparable

extension UInt14 /*: Comparable */ {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
}

// MARK: - Hashable

extension UInt14 /*: Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(storage)
    }
}

// MARK: - Sendable

extension UInt14: Sendable { }

// MARK: - Codable

extension UInt14 /*: Codable */ {
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

extension UInt14 { //: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        storage.description
    }
    
    public var debugDescription: String {
        "\(Self.integerName)(\(storage.description))"
    }
}

// MARK: - _MIDIUnsignedInteger Default Implementation

extension UInt14 {
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

extension UInt14 {
    /// Returns the integer converted to an `Int` instance (convenience).
    public var intValue: Int { Int(storage) }
}

// MARK: - FixedWidthInteger

extension UInt14 /*: FixedWidthInteger */ {
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

extension UInt14 /*: Numeric */ {
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

extension UInt14 /*: AdditiveArithmetic */ {
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

extension UInt14 /*: BinaryInteger */ {
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
