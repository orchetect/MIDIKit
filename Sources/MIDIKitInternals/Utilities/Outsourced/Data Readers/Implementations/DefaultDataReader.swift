/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Abstractions/Data Readers/Implementations/DefaultDataReader.swift
///
/// Borrowed from OTCore 2.1.0 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import struct Foundation.Data
import protocol Foundation.DataProtocol

/// Alias to the most performant data reader for the current platform.
package typealias DefaultDataReader = PointerDataReader

// MARK: - DataReader Extensions

extension DataProtocol {
    /// Accesses the data using the most performant data reader for the current platform.
    @_disfavoredOverload @discardableResult
    package func withDataReader<T, E>(
        _ block: (_ reader: inout DefaultDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        try withPointerDataReader(block)
    }
}
