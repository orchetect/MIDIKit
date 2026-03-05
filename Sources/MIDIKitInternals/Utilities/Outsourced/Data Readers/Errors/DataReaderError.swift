/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Abstractions/Data Readers/Errors/DataReaderError.swift
///
/// Borrowed from OTCore 2.1.0 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

/// Error returned by methods in ``DataReaderProtocol``-conforming types.
package enum DataReaderError: Error {
    case pastEndOfStream
    case invalidByteCount
}

extension DataReaderError: Equatable { }

extension DataReaderError: Hashable { }

extension DataReaderError: Sendable { }
