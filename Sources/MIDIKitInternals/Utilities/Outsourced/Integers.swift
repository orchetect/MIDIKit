/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Swift/Integers.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Foundation

// MARK: - String Formatting

extension BinaryInteger {
    /// Same as `String(describing: self)`
    /// (Functional convenience method)
    @_disfavoredOverload
    public var string: String { String(describing: self) }
    
    /// Convenience method to return a String, padded to `paddedTo` number of leading zeros
    @_disfavoredOverload
    public func string(paddedTo: Int) -> String {
        if let cVarArg = self as? CVarArg {
            return String(format: "%0\(paddedTo)d", cVarArg)
        } else {
            // Typically this will never happen,
            // but BinaryInteger does not implicitly conform to CVarArg,
            // and we can't assume all concrete types that conform
            // to BinaryInteger CVarArg now or in the future.
            // Just return a string as-is as a failsafe:
            return String(describing: self)
        }
    }
}

// MARK: - Binary & Bitwise

extension UnsignedInteger {
    /// Access binary bits, zero-based from right-to-left
    @_disfavoredOverload
    public func bit(_ position: Int) -> Int {
        Int((self & (0b1 << position)) >> position)
    }
}

extension Int8 {
    /// Returns a two's complement bit format of an `Int8` so it can be stored as a byte (`UInt8`)
    @_disfavoredOverload
    public var twosComplement: UInt8 {
        UInt8(bitPattern: self)
    }
}
