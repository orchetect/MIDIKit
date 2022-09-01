//
//  UInt25.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

/// A 25-bit unsigned integer value type used in `MIDIKit`.
public struct UInt25: _MIDIUnsignedInteger {
    public typealias Storage = UInt32
    var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt25 {
    static let integerName: StaticString = "UInt25"
    
    init(unchecked value: Storage) {
        storage = value
    }
}

// MARK: - Protocol Requirements

extension UInt25 {
    public typealias Magnitude = Storage.Magnitude
    public typealias Words = Storage.Words
    
    public static let bitWidth: Int = 25
}

// MARK: - Equatable

extension UInt25 /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
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

// MARK: - Struct-Specific Properties

extension UInt25 {
    // 0b1_00000000_00000000_00000000
    /// Neutral midpoint.
    public static let midpoint = Self(Self.midpoint(as: Storage.self))
    static func midpoint<T: BinaryInteger>(as ofType: T.Type) -> T { 16_777_216 }
    
    /// Returns the integer as a `UInt32` instance
    public var uInt32Value: UInt32 { storage }
}
