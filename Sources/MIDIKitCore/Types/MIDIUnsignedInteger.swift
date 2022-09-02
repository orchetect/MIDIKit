//
//  MIDIUnsignedInteger.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

// Protocol inheritance tree (not exhaustive):
//
// UnsignedInteger
//   -> BinaryInteger
//      -> CustomStringConvertible
//      -> Hashable
//      -> Numeric
//         -> AdditiveArithmetic
//            -> Equatable
//         -> ExpressibleByIntegerLiteral
//      -> Strideable
//         -> Comparable

/// Protocol adopted by specialized unsigned integer types in `MIDIKit` representing novel bit widths.
public protocol MIDIUnsignedInteger: UnsignedInteger, Codable
where Magnitude == Storage.Magnitude,
      Words == Storage.Words,
      IntegerLiteralType == Storage,
      IntegerLiteralType: Codable,
      Stride == Int
{
    /// Backing storage type for the integer.
    associatedtype Storage: BinaryInteger
    
    // Public conveniences
    
    /// Returns the integer as an `Int` instance
    var intValue: Int { get }
    
    // FixedWidthInteger types declared without conforming to FixedWidthInteger
    static var bitWidth: Int { get }
    static var min: Self { get }
    static var max: Self { get }
}

internal protocol _MIDIUnsignedInteger: MIDIUnsignedInteger {
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

extension _MIDIUnsignedInteger {
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

// MARK: - Strideable

extension MIDIUnsignedInteger /*: Strideable */ {
    //public typealias Stride = Int
    // Stride is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public func advanced(by n: Stride) -> Self {
        self + Self(n)
    }
    
    public func distance(to other: Self) -> Stride {
        Stride(other) - Stride(self)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension MIDIUnsignedInteger /*: ExpressibleByIntegerLiteral */ {
    //public typealias IntegerLiteralType = Storage
    // IntegerLiteralType is already expressed as same-type constraint on MIDIUnsignedInteger
    
    public init(integerLiteral value: Storage) {
        self.init(value)
    }
}
