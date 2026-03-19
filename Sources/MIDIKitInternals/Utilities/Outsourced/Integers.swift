/// ----------------------------------------------
/// ----------------------------------------------
/// Extensions/Swift/Integers.swift
///
/// Borrowed from swift-extensions 1.4.2 under MIT license.
/// https://github.com/orchetect/swift-extensions
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
    package var string: String { String(describing: self) }
    
    /// Convenience method to return a String, padded to `paddedTo` number of leading zeros
    @_disfavoredOverload
    package func string(paddedTo: Int) -> String {
        if let cVarArg = self as? CVarArg {
            String(format: "%0\(paddedTo)d", cVarArg)
        } else {
            // Typically this will never happen,
            // but BinaryInteger does not implicitly conform to CVarArg,
            // and we can't assume all concrete types that conform
            // to BinaryInteger CVarArg now or in the future.
            // Just return a string as-is as a failsafe:
            String(describing: self)
        }
    }
}
