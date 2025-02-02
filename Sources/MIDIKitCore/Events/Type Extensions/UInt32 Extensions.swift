//
//  UInt32 Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UInt32 {
    /// Converts from a bipolar floating-point unit interval (having a 0.0 neutral midpoint).
    /// (`-1.0 ... 0.0 ... 1.0` == `0 ... 0x80000000 ... 0xFFFFFFFF`)
    ///
    /// Example:
    ///
    ///     init(bipolarUnitInterval: -1.0) == 0          == .min
    ///     init(bipolarUnitInterval: -0.5)
    ///     init(bipolarUnitInterval:  0.0) == 0x80000000 == .midpoint
    ///     init(bipolarUnitInterval:  0.5)
    ///     init(bipolarUnitInterval:  1.0) == 0xFFFFFFFF == .max
    @_disfavoredOverload
    public init(bipolarUnitInterval: some BinaryFloatingPoint) {
        let bipolarUnitInterval = bipolarUnitInterval.clamped(to: (-1.0) ... (1.0))
    
        if bipolarUnitInterval > 0.0 {
            let scaled = Self(Double(bipolarUnitInterval) * 0x7FFF_FFFF)
            self = 0x8000_0000 + scaled
        } else {
            let scaled = Self(abs(bipolarUnitInterval) * 0x8000_0000)
            self = 0x8000_0000 - scaled
        }
    }
    
    /// Converts from a bipolar floating-point unit interval (having a 0.0 neutral midpoint).
    /// (`-1.0 ... 0.0 ... 1.0` == `0 ... 0x80000000 ... 0xFFFFFFFF`)
    ///
    /// Example:
    ///
    ///     init(bipolarUnitInterval: -1.0) == 0          == .min
    ///     init(bipolarUnitInterval: -0.5)
    ///     init(bipolarUnitInterval:  0.0) == 0x80000000 == .midpoint
    ///     init(bipolarUnitInterval:  0.5)
    ///     init(bipolarUnitInterval:  1.0) == 0xFFFFFFFF == .max
    @_disfavoredOverload
    public init(bipolarUnitInterval: Double) {
        let bipolarUnitInterval = bipolarUnitInterval.clamped(to: (-1.0) ... (1.0))
    
        if bipolarUnitInterval > 0.0 {
            let scaled = Self(bipolarUnitInterval * 0x7FFF_FFFF)
            self = 0x8000_0000 + scaled
        } else {
            let scaled = Self(abs(bipolarUnitInterval) * 0x8000_0000)
            self = 0x8000_0000 - scaled
        }
    }
    
    /// Converts from integer to a bipolar floating-point unit interval (having a 0.0 neutral
    /// midpoint at 0x80000000).
    /// (`0 ... 0x80000000 ... 0xFFFFFFFF` == `-1.0 ... 0.0 ... 1.0`)
    @_disfavoredOverload
    public var bipolarUnitIntervalValue: Double {
        // Account for non-symmetry and round up.
        // (This is how MIDI 2.0 Spec pitch bend works.)
        if self > 0x8000_0000 {
            (Double(self) - 0x8000_0000) / 0x7FFF_FFFF
        } else {
            (Double(self) - 0x8000_0000) / 0x8000_0000
        }
    }
}
