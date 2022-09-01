//
//  UInt14.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals

/// A 14-bit unsigned integer value type used in `MIDIKit`.
///
/// Formed as from two bytes (MSB, LSB) as `(MSB << 7) + LSB` where MSB and LSB are 7-bit values.
public struct UInt14: _MIDIUnsignedInteger {
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

// MARK: - Equatable

extension UInt14 /*: Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
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
    public init<T: BinaryFloatingPoint>(bipolarUnitInterval: T) {
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
    
    /// Converts from integer to a bipolar floating-point unit interval (having a 0.0 neutral midpoint at 8192).
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
