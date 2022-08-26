//
//  MIDIUnsignedInteger.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

/// Specialized integer types representing non-standard bit-width values in `MIDIKit`.
public protocol MIDIUnsignedInteger: BinaryInteger, UnsignedInteger, Numeric, AdditiveArithmetic, Equatable, Comparable, Hashable, Codable, ExpressibleByIntegerLiteral, Strideable
where Magnitude == Storage.Magnitude,
      Words == Storage.Words,
      IntegerLiteralType == Storage,
      Stride == Int
{
    /// Backing storage type for the integer.
    associatedtype Storage: BinaryInteger
    
    // Public conveniences
    
    /// Returns the integer as an `Int` instance
    var intValue: Int { get }
    
    // FixedWidthInteger types declared without conforming to FixedWidthInteger
    static var bitWidth: Int { get }
    
    // FixedWidthInteger types declared without conforming to FixedWidthInteger
    static var min: Self { get }
    
    // FixedWidthInteger types declared without conforming to FixedWidthInteger
    static var max: Self { get }
}

protocol _MIDIIntegerProtocol: MIDIUnsignedInteger {
    /// Internal: Type name for use in debugging and exceptions.
    static var integerName: StaticString { get }
    
    /// Internal: Backing storage for the integer.
    var storage: Storage { get set }
    
    /// Internal: Initialize storage from a known good value, without validation checks.
    init(unchecked value: Storage)
    
    static func min<T: BinaryInteger>(as ofType: T.Type) -> T
    static func min<T: BinaryFloatingPoint>(as ofType: T.Type) -> T
    
    static func max<T: BinaryInteger>(as ofType: T.Type) -> T
    static func max<T: BinaryFloatingPoint>(as ofType: T.Type) -> T
}

extension _MIDIIntegerProtocol {
    public init<T: BinaryInteger>(_ source: T) {
        if source < Self.min(as: Storage.self) {
            Exception.underflow.raise(reason: "\(Self.integerName) integer underflowed")
        }
        if source > Self.max(as: Storage.self) {
            Exception.overflow.raise(reason: "\(Self.integerName) integer overflowed")
        }
        self.init(unchecked: Storage(source))
    }
    
    public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
        self.init(Storage(truncatingIfNeeded: source))
    }
    
    public init<T: BinaryInteger>(clamping source: T) {
        let clamped = Storage(
            Int(source)
                .clamped(to: Self.min(as: Int.self) ... Self.max(as: Int.self))
        )
        self.init(clamped)
    }
    
    public init<T: BinaryFloatingPoint>(_ source: T) {
        // it should be safe to cast as T.self since it's virtually impossible
        // that we will encounter a BinaryFloatingPoint type that cannot fit UInt4.max
        if source < Self.min(as: T.self) {
            Exception.underflow.raise(
                reason: "\(Self.integerName) integer underflowed"
            )
        }
        if source > Self.max(as: T.self) {
            Exception.overflow.raise(
                reason: "\(Self.integerName) integer overflowed"
            )
        }
        self.init(unchecked: Storage(source))
    }
    
    public init?<T: BinaryFloatingPoint>(exactly source: T) {
        // it should be safe to cast as T.self since it's virtually impossible
        // that we will encounter a BinaryFloatingPoint type less than the
        // largest MIDIUnsignedInteger concrete type.
        // the smallest floating point number in the Swift standard library
        // is Float16.
        if source < Self.min(as: T.self) { return nil }
        if source > Self.max(as: T.self) { return nil }
        self.init(source)
    }
}

// MARK: - Equatable

extension _MIDIIntegerProtocol /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
}

// MARK: - Comparable

extension _MIDIIntegerProtocol /*: Comparable */ {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.storage < rhs.storage
    }
}

// MARK: - Hashable

extension _MIDIIntegerProtocol /*: Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(storage)
    }
}

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
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Encoded value is not a valid \(Self.integerName).")
            )
        }
        self = new
    }
}

// MARK: - CustomStringConvertible

extension UInt4: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        storage.description
    }
    
    public var debugDescription: String {
        "\(Self.integerName)(\(storage.description))"
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension _MIDIIntegerProtocol /*: ExpressibleByIntegerLiteral */ {
    //public typealias IntegerLiteralType = Storage
    // IntegerLiteralType is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public init(integerLiteral value: Storage) {
        self.init(value)
    }
}

// MARK: - Strideable

extension _MIDIIntegerProtocol /*: Strideable */ {
    //public typealias Stride = Int
    // Stride is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public func advanced(by n: Stride) -> Self {
        self + Self(n)
    }
    
    public func distance(to other: Self) -> Stride {
        Stride(other) - Stride(self)
    }
}

// MARK: - MIDIUnsignedInteger Default Implementation

extension _MIDIIntegerProtocol {
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

extension _MIDIIntegerProtocol {
    /// Returns the integer as an `Int` instance
    public var intValue: Int { Int(storage) }
}

// MARK: - FixedWidthInteger

extension _MIDIIntegerProtocol /*: FixedWidthInteger */ {
    public static var min: Self { Self(Self.min(as: Storage.self)) }
    
    public static var max: Self { Self(Self.max(as: Storage.self)) }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs.storage >>= rhs
    }
    
    // this would be synthesized if MIDIUnsignedInteger conformed to FixedWidthInteger
    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
        lhs.storage <<= rhs
    }
}

// MARK: - Numeric

extension _MIDIIntegerProtocol /*: Numeric */ {
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

extension _MIDIIntegerProtocol /*: AdditiveArithmetic */ {
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

extension _MIDIIntegerProtocol /*: BinaryInteger */ {
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
