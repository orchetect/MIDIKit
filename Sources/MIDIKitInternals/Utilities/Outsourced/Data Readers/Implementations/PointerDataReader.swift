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
/// > Warning: Do not pass pointers returned from reader methods outside of the `withPointerDataReader { reader in }` closure.
/// >
/// > Any data needed to be passed outside of the closure must be copied first.
/// >
/// > This can be done by constructing a `Data(pointer)` or `[UInt8](pointer)` instance from the `pointer`.
///
/// > Note:
/// >
/// > This type is not meant to be initialized directly, but rather used within a call to `<data>.withPointerDataReader { reader in }`.
///
/// Usage with `Data`:
///
/// ```swift
/// let data = Data( ... )
/// try data.withPointerDataReader { reader in
///     let bytes = try reader.read(bytes: 4)
///     // ...
/// }
/// ```
///
/// Usage with `[UInt8]`:
///
/// ```swift
/// let bytes: [UInt8] = [ ... ]
/// try bytes.withPointerDataReader { reader in
///     let bytes = try reader.read(bytes: 4)
///     // ...
/// }
/// ```
package struct PointerDataReader<DataType: DataProtocol>: _DataReaderProtocol {
    package typealias DataElement = DataType.Element
    package typealias DataRange = UnsafeBufferPointer<UInt8>
    
    @usableFromInline
    let pointer: UnsafeBufferPointer<UInt8>
    
    // MARK: - Init
    
    init(pointer: UnsafeBufferPointer<UInt8>) {
        self.pointer = pointer
    }
    
    // MARK: - State
    
    package internal(set) var readOffset = 0
    
    // MARK: - Internal
    
    @usableFromInline
    typealias DataIndex = Int
    
    func _dataSize() -> Int {
        pointer.count
    }
    
    @inlinable
    func _dataStartIndex() -> DataIndex {
        pointer.startIndex
    }
    
    @inlinable
    func _dataReadOffsetIndex(offsetBy offset: Int) -> DataIndex {
        pointer.indices.lowerBound.advanced(by: readOffset + offset)
    }
    
    @inlinable
    func _dataByte(at dataIndex: DataIndex) throws(DataReaderError) -> DataElement {
        pointer[dataIndex]
    }
    
    func _dataBytes(in dataIndexRange: Range<DataIndex>) throws(DataReaderError) -> DataRange {
        pointer.extracting(dataIndexRange)
    }
    
    func _dataBytes(in dataIndexRange: ClosedRange<DataIndex>) throws(DataReaderError) -> DataRange {
        pointer.extracting(dataIndexRange)
    }
}

// MARK: - DataProtocol Extensions

extension DataProtocol {
    /// Accesses the data by way of unsafe pointer access by providing a ``PointerDataReader`` instance to a closure.
    ///
    /// > Warning: Do not pass pointers returned from reader methods outside of the `withPointerDataReader { reader in }` closure.
    /// >
    /// > Any data needed to be passed outside of the closure must be copied first.
    /// >
    /// > This can be done by constructing a `Data(pointer)` or `[UInt8](pointer)` instance from the `pointer`.
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
