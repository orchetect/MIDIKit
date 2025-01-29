/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Swift/Ranges.swift
///
/// Borrowed from OTCore 1.4.1 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Foundation

// MARK: - .clamped(to:)

extension Comparable {
    // ie: 5.clamped(to: 7...10)
    // ie: 5.0.clamped(to: 7.0...10.0)
    // ie: "a".clamped(to: "b"..."h")
    /// Returns the value clamped to the passed range.
    @_disfavoredOverload @inlinable
    package func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
    
    // ie: 5.clamped(to: 300...)
    // ie: 5.0.clamped(to: 300.00...)
    // ie: "a".clamped(to: "b"...)
    /// Returns the value clamped to the passed range.
    @_disfavoredOverload @inlinable
    package func clamped(to limits: PartialRangeFrom<Self>) -> Self {
        max(self, limits.lowerBound)
    }
    
    // ie: 400.clamped(to: ...300)
    // ie: 400.0.clamped(to: ...300.0)
    // ie: "k".clamped(to: ..."h")
    /// Returns the value clamped to the passed range.
    @_disfavoredOverload @inlinable
    package func clamped(to limits: PartialRangeThrough<Self>) -> Self {
        min(self, limits.upperBound)
    }
    
    // ie: 5.0.clamped(to: 7.0..<10.0)
    // not a good idea to implement this -- floating point numbers don't make sense in a ..< type
    // range
    // because would the max of 7.0..<10.0 be 9.999999999...? It can't be 10.0.
    // func clamped(to limits: Range<Self>) -> Self { }
}

extension Strideable {
    // ie: 400.clamped(to: ..<300)
    // won't work for String
    /// Returns the value clamped to the passed range.
    @_disfavoredOverload @inlinable
    package func clamped(to limits: PartialRangeUpTo<Self>) -> Self {
        // advanced(by:) requires Strideable, not available on just Comparable
        min(self, limits.upperBound.advanced(by: -1))
    }
}

extension Strideable where Self.Stride: SignedInteger {
    // ie: 5.clamped(to: 7..<10)
    // won't work for String
    /// Returns the value clamped to the passed range.
    @_disfavoredOverload @inlinable
    package func clamped(to limits: Range<Self>) -> Self {
        // index(before:) only available on SignedInteger
        min(
            max(self, limits.lowerBound),
            limits.index(before: limits.upperBound)
        )
    }
}
