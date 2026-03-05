/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Abstractions/Data Readers/Protocols/DataReaderDataProtocol.swift
///
/// Borrowed from OTCore 2.1.0 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Foundation

/// Protocol adopted by data types supported by ``DataReaderProtocol``.
package protocol DataReaderDataProtocol where Self: DataProtocol, SubSequence: DataReaderDataProtocol {
    associatedtype SubSequence
    
    // Restated from DataProtocol concrete types
    func withUnsafeBytes<ResultType>(_ body: (UnsafeRawBufferPointer) throws -> ResultType) rethrows -> ResultType
}

// MARK: - Concrete Type Conformances

extension Data: DataReaderDataProtocol { }
// extension Data.SubSequence: DataReaderDataProtocol { } // not needed since Data.SubSequence == Data

extension [UInt8]: DataReaderDataProtocol { }
extension [UInt8].SubSequence: DataReaderDataProtocol { }

extension UnsafeBufferPointer<UInt8>: DataReaderDataProtocol { }
extension UnsafeBufferPointer<UInt8>.SubSequence: DataReaderDataProtocol { }
