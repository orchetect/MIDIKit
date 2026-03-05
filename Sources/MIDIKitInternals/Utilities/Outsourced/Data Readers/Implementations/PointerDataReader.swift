/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Abstractions/Data Readers/Implementations/PointerDataReader.swift
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
/// This type is not meant to be initialized directly, but rather used within a call to `<data>.withPointerDataReader { reader in }`.
///
/// Usage with `Data`:
///
/// ```swift
/// let data = Data( ... )
/// data.withPointerDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
///
/// Usage with `[UInt8]`:
///
/// ```swift
/// let bytes: [UInt8] = [ ... ]
/// bytes.withPointerDataReader { reader in
///     if let bytes = reader.read(bytes: 4) { ... }
/// }
/// ```
package struct PointerDataReader<DataType: DataProtocol>: _DataReaderProtocol {
    package typealias DataElement = DataType.Element
    public typealias DataRange = UnsafeBufferPointer<UInt8>
    
    private let pointer: UnsafeBufferPointer<UInt8>
    
    // MARK: - Init
    
    init(pointer: UnsafeBufferPointer<UInt8>) {
        self.pointer = pointer
    }
    
    // MARK: - State
    
    package internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    @usableFromInline typealias DataIndex = Int
    
    func _dataSize() -> Int {
        withData { $0.count }
    }
    
    @inlinable
    func _dataStartIndex() -> DataIndex {
        withData { $0.startIndex }
    }
    
    @inlinable
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataIndex {
        withData { $0.indices.lowerBound.advanced(by: readOffset + offset) }
    }
    
    @inlinable
    func _dataByte(at dataIndex: DataIndex) throws(DataReaderError) -> DataElement {
        withData { $0[dataIndex] }
    }
    
    func _dataBytes(in dataIndexRange: Range<DataIndex>) throws(DataReaderError) -> DataRange {
        withData { $0.extracting(dataIndexRange) }
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataIndex>) throws(DataReaderError) -> DataRange {
        withData { $0.extracting(dataIndexRange) }
    }
    
    // MARK: - Helpers
    
    @inline(__always) @usableFromInline
    func withData<T>(_ block: (UnsafeBufferPointer<UInt8>) -> T) -> T {
        block(pointer)
    }
}

// MARK: - DataProtocol Extensions

extension DataProtocol {
    /// Accesses the data by way of unsafe pointer access by providing a ``PointerDataReader`` instance to a closure.
    @discardableResult
    package func withPointerDataReader<T, E>(
        _ block: (_ reader: inout PointerDataReader<Self>) throws(E) -> T
    ) throws(E) -> T {
        // since `withUnsafe... { }` does not work with typed error throws, we have to use a workaround to get the typed error out
        var result: Result<T, E>!
        
        // Knowledge of the underlying concrete data type is necessary to ensure correct pointer access.
        if let self = self as? any DataReaderDataProtocol {
            self.withUnsafeBytes { ptr in
                let boundPtr = ptr.assumingMemoryBound(to: UInt8.self)
                var reader = PointerDataReader<Self>(pointer: boundPtr)
                do throws(E) {
                    let value = try block(&reader)
                    result = .success(value)
                } catch {
                    result = .failure(error)
                }
            }
        } else {
            if withContiguousStorageIfAvailable({ ptr in
                var reader = PointerDataReader<Self>(pointer: ptr)
                do throws(E) {
                    let value = try block(&reader)
                    result = .success(value)
                } catch {
                    result = .failure(error)
                }
            }) as Void? == nil {
                // TODO: this is not tested and may not work with unhandled concrete DataProtocol types
                withUnsafeBytes(of: self) { ptr in
                    let boundPtr = ptr.assumingMemoryBound(to: UInt8.self)
                    var reader = PointerDataReader<Self>(pointer: boundPtr)
                    do throws(E) {
                        let value = try block(&reader)
                        result = .success(value)
                    } catch {
                        result = .failure(error)
                    }
                }
            }
        }
        return try result.get()
    }
}
