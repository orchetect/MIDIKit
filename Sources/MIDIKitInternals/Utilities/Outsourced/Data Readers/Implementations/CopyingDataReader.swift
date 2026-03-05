/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Abstractions/Data Readers/Implementations/CopyingDataReader.swift
///
/// Borrowed from OTCore 2.1.0 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import struct Foundation.Data
import protocol Foundation.DataProtocol

/// Utility to facilitate sequential reading of bytes.
///
/// This type is not meant to be initialized directly, but rather used within a call to `<data>.withCopyingDataReader { reader in }`.
package struct CopyingDataReader<DataType: DataProtocol & Sendable>: _DataReaderProtocol {
    package typealias DataElement = DataType.Element
    package typealias DataRange = DataType.SubSequence
    
    let base: DataType
    
    init(data: DataType) {
        base = data
    }
    
    // MARK: - State
    
    package internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    typealias DataIndex = DataType.Index
    
    func _dataSize() -> Int {
        base.count
    }
    
    func _dataStartIndex() -> DataType.Index {
        base.startIndex
    }
    
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index {
        base.index(base.startIndex, offsetBy: readOffset + offset)
    }
    
    func _dataByte(at dataIndex: DataType.Index) throws(DataReaderError) -> DataElement {
        base[dataIndex]
    }
    
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(DataReaderError) -> DataRange {
        base[dataIndexRange]
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(DataReaderError) -> DataRange {
        base[dataIndexRange]
    }
}

extension CopyingDataReader: Sendable { }

// MARK: - DataProtocol Extensions

// This generic implementation will work on any `DataProtocol`-conforming concrete type without needing
// individual implementations on the known concrete types.

extension DataProtocol {
    /// Accesses the data by providing a ``CopyingDataReader`` instance to a closure.
    @discardableResult
    package mutating func withCopyingDataReader<T, E>(
        _ block: (_ reader: inout CopyingDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        var reader = CopyingDataReader(data: self)
        return try block(&reader)
    }
}
