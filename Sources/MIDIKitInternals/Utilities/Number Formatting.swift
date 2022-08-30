//
//  Number Formatting.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Double {
    /// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces` <= 0, trunc(self) is returned.
    @_disfavoredOverload
    public func rounded(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) -> Self {
        if decimalPlaces < 1 {
            return rounded(rule)
        }
        
        let offset = pow(10.0, Self(decimalPlaces))
        
        return (self * offset).rounded(rule) / offset
    }
}
