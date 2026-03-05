/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Abstractions/Data Readers/Implementations/InoutDataReader.swift
///
/// Borrowed from OTCore 2.1.0 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import protocol Foundation.DataProtocol

/// Utility to facilitate sequential reading of bytes.
/// Passing the data in as a mutable `inout` allows for passive memory reading. The data itself is never mutated.
///
/// This type is not meant to be initialized directly, but rather used within a call to `<data>.withInoutDataReader { reader in }`.
///
/// Usage with `Data`:
///
/// ```swift
/// let data = Data( ... )
/// data.withInoutDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
///
/// Usage with `[UInt8]`:
///
/// ```swift
/// let bytes: [UInt8] = [ ... ]
/// bytes.withInoutDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
package struct InoutDataReader<DataType: DataProtocol>: _DataReaderProtocol {
    package typealias DataElement = DataType.Element
    package typealias DataRange = DataType.SubSequence
    
    typealias DataAccess = (_ block: InoutDataAccess) -> Void
    typealias InoutDataAccess = (inout DataType) -> Void
    
    let dataAccess: DataAccess
    
    // MARK: - Init
    
    init(dataAccess: @escaping DataAccess) {
        self.dataAccess = dataAccess
    }
    
    // MARK: - State
    
    package internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    typealias DataIndex = DataType.Index
    
    func _dataSize() -> Int {
        withData { $0.count }
    }
    
    func _dataStartIndex() -> DataType.Index {
        withData { $0.startIndex }
    }
    
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataType.Index {
        withData { $0.index($0.startIndex, offsetBy: readOffset + offset) }
    }
    
    func _dataByte(at dataIndex: DataType.Index) throws(DataReaderError) -> DataElement {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataType.Index>) throws(DataReaderError) -> DataRange {
        withData { $0[dataIndexRange] }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataType.Index>) throws(DataReaderError) -> DataRange {
        withData { $0[dataIndexRange] }
    }
    
    // MARK: - Helpers
    
    @inline(__always) @usableFromInline
    func withData<T>(_ block: (inout DataType) -> T) -> T {
        var out: T!
        dataAccess { out = block(&$0) }
        return out
    }
}

// MARK: - DataProtocol Extensions

// This generic implementation will work on any `DataProtocol`-conforming concrete type without needing
// individual implementations on the known concrete types.

extension DataProtocol {
    /// Accesses the data by providing an ``InoutDataReader`` instance to a closure.
    @discardableResult
    package mutating func withInoutDataReader<T, E>(
        _ block: (_ reader: inout InoutDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafe... { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        
        withUnsafeMutablePointer(to: &self) { ptr in
            var reader = InoutDataReader(dataAccess: { $0(&ptr.pointee) })
            do throws(E) {
                let value = try block(&reader)
                result = .success(value)
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}
