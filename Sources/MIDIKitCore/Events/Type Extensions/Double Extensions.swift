//
//  Double Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Double {
    /// Converts from a bipolar floating-point unit interval (having a 0.0 neutral midpoint).
    ///
    /// Example:
    ///
    ///     init(bipolarUnitInterval: -1.0) == 0.0
    ///     init(bipolarUnitInterval: -0.5) == 0.25
    ///     init(bipolarUnitInterval:  0.0) == 0.5
    ///     init(bipolarUnitInterval:  0.5) == 0.75
    ///     init(bipolarUnitInterval:  1.0) == 1.0
    @_disfavoredOverload
    public init(bipolarUnitInterval: some BinaryFloatingPoint) {
        self = Double((bipolarUnitInterval / 2.0) + 0.5)
    }
    
    /// Converts from a bipolar floating-point unit interval (having a 0.0 neutral midpoint).
    ///
    /// Example:
    ///
    ///     init(bipolarUnitInterval: -1.0) == 0.0
    ///     init(bipolarUnitInterval: -0.5) == 0.25
    ///     init(bipolarUnitInterval:  0.0) == 0.5
    ///     init(bipolarUnitInterval:  0.5) == 0.75
    ///     init(bipolarUnitInterval:  1.0) == 1.0
    @_disfavoredOverload
    public init(bipolarUnitInterval: Double) {
        self = (bipolarUnitInterval / 2.0) + 0.5
    }
    
    /// Converts from integer to a bipolar floating-point unit interval (having a 0.0 neutral
    /// midpoint).
    @_disfavoredOverload
    public var bipolarUnitIntervalValue: Double {
        2 * (clamped(to: 0.0 ... 1.0) - 0.5)
    }
}
