//
//  Number Formatting.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Double {
    /// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces <= 0`, then `trunc(self)` is returned.
    @_disfavoredOverload
    package func rounded(
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
