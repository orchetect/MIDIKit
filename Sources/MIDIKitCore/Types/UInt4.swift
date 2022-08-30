//
//  UInt4.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

/// A 4-bit unsigned integer value type used in `MIDIKit`.
public struct UInt4: _MIDIUnsignedInteger {
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
