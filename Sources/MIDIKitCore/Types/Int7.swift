//
//  Int7.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import MIDIKitInternals

/// A 7-bit signed integer value type used in `MIDIKit`. (`-64 ... 63`)
public struct Int7 {
    static let integerName = "Int7"
    
    var sixBitStorage: UInt8
    var isNegative: Bool
    
    /// Initializes from an unsigned integer value, throwing an exception in the event of overflow
    /// or underflow.
    public init(_ source: some UnsignedInteger) {
        switch source {
        case 0 ... 63:
            sixBitStorage = UInt8(source)
            isNegative = false
        case 64...:
            Exception.overflow.raise(reason: "\(Self.integerName) integer overflowed")
            // default value
            sixBitStorage = 0
            isNegative = false
        default:
            fatalError()
        }
    }
    
    /// Initializes from a signed integer value, throwing an exception in the event of overflow or
    /// underflow.
    public init(_ source: some SignedInteger) {
        switch source {
        case ...(-65):
            Exception.underflow.raise(reason: "\(Self.integerName) integer underflowed")
            // default value
            sixBitStorage = 0
            isNegative = false
        case -64 ..< 0:
            let truncated = Self.literalBits(truncatingIfNecessary: source)
            sixBitStorage = truncated.sixBitStorage
            isNegative = truncated.isNegative
        case 0 ... 63:
            sixBitStorage = UInt8(source)
            isNegative = false
        case 64...:
            Exception.overflow.raise(reason: "\(Self.integerName) integer overflowed")
            // default value
            sixBitStorage = 0
            isNegative = false
        default:
            fatalError()
        }
    }
    
    /// Initializes from an unsigned integer value, returning nil if the value cannot be preserved
    /// because it would otherwise overflow or underflow.
    public init?(exactly source: some UnsignedInteger) {
        guard (-64 ... 63).contains(source) else { return nil }
        self.init(truncatingIfNecessary: source)
    }
    
    /// Initializes from a signed integer value, returning nil if the value cannot be preserved
    /// because it would otherwise overflow or underflow.
    public init?(exactly source: some SignedInteger) {
        guard (-64 ... 63).contains(source) else { return nil }
        self.init(truncatingIfNecessary: source)
    }
    
    public init(truncatingIfNecessary uint: some UnsignedInteger) {
        sixBitStorage = UInt8(uint & 0b111111)
        isNegative = false
    }
    
    public init(truncatingIfNecessary int: some SignedInteger) {
        let truncated = Self.literalBits(truncatingIfNecessary: int)
        sixBitStorage = truncated.sixBitStorage
        isNegative = truncated.isNegative
    }
    
    public init(bitPattern source: some UnsignedInteger) {
        let truncated = Self.literalBits(truncatingIfNecessary: source)
        sixBitStorage = truncated.sixBitStorage
        isNegative = truncated.isNegative
    }
    
    static func literalBits(
        truncatingIfNecessary int: some BinaryInteger
    ) -> (sixBitStorage: UInt8, isNegative: Bool) {
        let absInt = int & 0b111111
        let isNeg = ((int & 0b1000000) >> 6) == 0b1
        return (
            sixBitStorage: UInt8(absInt),
            isNegative: isNeg
        )
    }
    
    /// Returns the 7-bit signed integer as a raw `UInt8` byte bit pattern.
    /// The top (8th) bit will always be `0`.
    public var rawByte: UInt8 {
        isNegative
            ? sixBitStorage + 0b1000000
            : sixBitStorage
    }
    
    /// Returns the 7-bit signed integer as a raw `UInt7` byte bit pattern.
    public var rawUInt7Byte: UInt7 {
        UInt7(rawByte)
    }
    
    /// Returns the integer as `Int`.
    public var intValue: Int {
        isNegative
            ? -Int((~(sixBitStorage) & 0b111111) + 1)
            : Int(sixBitStorage)
    }
    
    /// Returns the bit pattern as a 7-bit binary string.
    public var binaryString: String {
        "0b" + ("0000000" + String(rawByte, radix: 2)).suffix(7)
    }
}

// MARK: - Equatable

extension Int7: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.sixBitStorage == rhs.sixBitStorage &&
            lhs.isNegative == rhs.isNegative
    }
}

// MARK: - Hashable

extension Int7: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(intValue)
    }
}

// MARK: - Comparable

extension Int7: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.intValue < rhs.intValue
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Int7: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int8
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(truncatingIfNecessary: value)
    }
}

// MARK: - CustomStringConvertible

extension Int7: CustomStringConvertible {
    public var description: String {
        "\(intValue)"
    }
}
