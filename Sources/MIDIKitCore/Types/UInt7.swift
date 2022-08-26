//
//  UInt7.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

/// A 7-bit unsigned integer value type used in `MIDIKit`.
public struct UInt7: _MIDIUnsignedInteger {
    public typealias Storage = UInt8
    var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt7 {
    static let integerName: StaticString = "UInt7"
    
    init(unchecked value: Storage) {
        self.storage = value
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
