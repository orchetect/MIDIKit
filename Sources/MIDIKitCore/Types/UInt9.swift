//
//  UInt9.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

/// A 9-bit unsigned integer value type used in `MIDIKit`.
public struct UInt9: _MIDIUnsignedInteger {
    public typealias Storage = UInt16
    var storage: Storage
}

// MARK: - MIDIUnsignedInteger

extension UInt9 {
    static let integerName: StaticString = "UInt9"
    
    init(unchecked value: Storage) {
        self.storage = value
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
