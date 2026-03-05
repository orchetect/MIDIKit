/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Foundation/Data.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// Endianness: All Apple platforms are currently little-endian

// Floating endianness:
// On some machines, while integers were represented in little-endian form, floating point numbers
// were represented in big-endian form. Because there are many floating point formats, and a lack of
// a standard "network" representation, no standard for transferring floating point values has been
// made. This means that floating point data written on one machine may not be readable on another,
// and this is the case even if both use IEEE 754 floating point arithmetic since the endianness of
// the memory representation is not part of the IEEE specification.

// int32
//   32-bit big-endian two's complement integer
// float32
//   OSC spec: 32-bit big-endian IEEE 754 floating point number
//   (I believe this means decimal32 of the IEEE 754 spec.)
// int64
//   OSC spec: 64-bit big-endian fixed-point

#if canImport(Foundation)

import Foundation

// MARK: - Int

extension DataProtocol {
    /// Returns an Int64 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toInt(from endianness: NumberEndianness = .platformDefault) -> Int? {
        toNumber(from: endianness, toType: Int.self)
    }
}

// MARK: - Int8

extension DataProtocol {
    /// Returns a Int8 value from Data (stored as two's complement).
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toInt8() -> Int8? {
        guard count == 1 else { return nil }
        
        var int = UInt8()
        withUnsafeMutableBytes(of: &int) {
            _ = self.copyBytes(to: $0, count: 1)
        }
        return Int8(bitPattern: int)
    }
}

// MARK: - Int16

extension DataProtocol {
    /// Returns an Int16 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toInt16(from endianness: NumberEndianness = .platformDefault) -> Int16? {
        toNumber(from: endianness, toType: Int16.self)
    }
}

// MARK: - Int32

extension DataProtocol {
    /// Returns an Int32 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toInt32(from endianness: NumberEndianness = .platformDefault) -> Int32? {
        toNumber(from: endianness, toType: Int32.self)
    }
}

// MARK: - Int64

extension DataProtocol {
    /// Returns an Int64 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toInt64(from endianness: NumberEndianness = .platformDefault) -> Int64? {
        toNumber(from: endianness, toType: Int64.self)
    }
}

// MARK: - UInt

extension DataProtocol {
    /// Returns a UInt value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toUInt(from endianness: NumberEndianness = .platformDefault) -> UInt? {
        toNumber(from: endianness, toType: UInt.self)
    }
}

// MARK: - UInt8

extension DataProtocol {
    /// Returns a UInt8 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toUInt8() -> UInt8? {
        guard count == 1 else { return nil }
        return first
    }
}

// MARK: - UInt16

extension DataProtocol {
    /// Returns a UInt16 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toUInt16(from endianness: NumberEndianness = .platformDefault) -> UInt16? {
        toNumber(from: endianness, toType: UInt16.self)
    }
}

// MARK: - UInt32

extension DataProtocol {
    /// Returns a UInt32 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toUInt32(from endianness: NumberEndianness = .platformDefault) -> UInt32? {
        toNumber(from: endianness, toType: UInt32.self)
    }
}

// MARK: - UInt64

extension DataProtocol {
    /// Returns a UInt64 value from Data.
    /// Returns `nil` if Data is not the correct length.
    @_disfavoredOverload
    package func toUInt64(from endianness: NumberEndianness = .platformDefault) -> UInt64? {
        toNumber(from: endianness, toType: UInt64.self)
    }
}

// MARK: - Float32

extension Float32 {
    /// Returns Data representation of a Float32 value.
    @_disfavoredOverload
    package func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
        var number = self
        
        return withUnsafeBytes(of: &number) { rawBuffer in
            rawBuffer.withMemoryRebound(to: UInt8.self) { buffer in
                switch endianness {
                case .platformDefault:
                    return Data(buffer: buffer)
                    
                case .littleEndian:
                    switch NumberEndianness.system {
                    case .littleEndian:
                        return Data(buffer: buffer)
                    case .bigEndian:
                        return Data(Data(buffer: buffer).reversed())
                    default:
                        fatalError() // should never happen
                    }
                    
                case .bigEndian:
                    switch NumberEndianness.system {
                    case .littleEndian:
                        return Data(Data(buffer: buffer).reversed())
                    case .bigEndian:
                        return Data(buffer: buffer)
                    default:
                        fatalError() // should never happen
                    }
                }
            }
        }
    }
}

extension DataProtocol {
    /// Returns a Float32 value from Data.
    /// Returns `nil` if Data is != 4 bytes.
    @_disfavoredOverload
    package func toFloat32(from endianness: NumberEndianness = .platformDefault) -> Float32? {
        guard count == 4 else { return nil }
        
        // define conversions
        
        // this crashes if Data alignment isn't correct
        // let number = { self.withUnsafeBytes { $0.load(as: Float32.self) } }()
        
        // since load(as:) is not memory alignment safe, memcpy is the current workaround
        // see for more info: https://bugs.swift.org/browse/SR-10273
        
        func number() -> Float32? {
            if let self = self as? Data {
                self.withUnsafeBytes({
                    var value = Float32()
                    memcpy(&value, $0.baseAddress!, 4)
                    return value
                })
            } else if let self = self as? [UInt8] {
                self.withUnsafeBytes({
                    var value = Float32()
                    memcpy(&value, $0.baseAddress!, 4)
                    return value
                })
            } else {
                self.withContiguousStorageIfAvailable({
                    var value = Float32()
                    memcpy(&value, $0.baseAddress!, 4)
                    return value
                })
            }
        }
        
        func numberSwapped() -> Float32? {
            guard let swapped: CFSwappedFloat32 = if let self = self as? Data {
                self.withUnsafeBytes({
                    // $0.load(as: CFSwappedFloat32.self)
                    var value = CFSwappedFloat32()
                    memcpy(&value, $0.baseAddress!, 4)
                    return value
                })
            } else if let self = self as? [UInt8] {
                self.withUnsafeBytes({
                    // $0.load(as: CFSwappedFloat32.self)
                    var value = CFSwappedFloat32()
                    memcpy(&value, $0.baseAddress!, 4)
                    return value
                })
            } else {
                self.withContiguousStorageIfAvailable({
                    // $0.load(as: CFSwappedFloat32.self)
                    var value = CFSwappedFloat32()
                    memcpy(&value, $0.baseAddress!, 4)
                    return value
                })
            } else {
                return nil
            }
            return CFConvertFloat32SwappedToHost(swapped)
        }
        
        // determine which conversion is needed
        
        switch endianness {
        case .platformDefault:
            return number()
            
        case .littleEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return number()
            case .bigEndian:
                return numberSwapped()
            default:
                fatalError() // should never happen
            }
            
        case .bigEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return numberSwapped()
            case .bigEndian:
                return number()
            default:
                fatalError() // should never happen
            }
        }
    }
}

// MARK: - Double

extension Double {
    /// Returns Data representation of a Double value.
    @_disfavoredOverload
    package func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
        var number = self
        
        return withUnsafeBytes(of: &number) { rawBuffer in
            rawBuffer.withMemoryRebound(to: UInt8.self) { buffer in
                switch endianness {
                case .platformDefault:
                    return Data(buffer: buffer)
                    
                case .littleEndian:
                    switch NumberEndianness.system {
                    case .littleEndian:
                        return Data(buffer: buffer)
                    case .bigEndian:
                        return Data(Data(buffer: buffer).reversed())
                    default:
                        fatalError() // should never happen
                    }
                    
                case .bigEndian:
                    switch NumberEndianness.system {
                    case .littleEndian:
                        return Data(Data(buffer: buffer).reversed())
                    case .bigEndian:
                        return Data(buffer: buffer)
                    default:
                        fatalError() // should never happen
                    }
                }
            }
        }
    }
}

extension DataProtocol {
    /// Returns a Double value from Data.
    /// Returns `nil` if Data is != 8 bytes.
    @_disfavoredOverload
    package func toDouble(from endianness: NumberEndianness = .platformDefault) -> Double? {
        guard count == 8 else { return nil }
        
        // define conversions
        
        // this crashes if Data alignment isn't correct
        // let number: Double = { self.withUnsafeBytes { $0.load(as: Double.self) } }()
        
        // since load(as:) is not memory alignment safe, memcpy is the current workaround
        // see for more info: https://bugs.swift.org/browse/SR-10273
        
        func number() -> Double? {
            if let self = self as? Data {
                self.withUnsafeBytes({
                    var value = Double()
                    memcpy(&value, $0.baseAddress!, 8)
                    return value
                })
            } else if let self = self as? [UInt8] {
                self.withUnsafeBytes({
                    var value = Double()
                    memcpy(&value, $0.baseAddress!, 8)
                    return value
                })
            } else {
                self.withContiguousStorageIfAvailable({
                    var value = Double()
                    memcpy(&value, $0.baseAddress!, 8)
                    return value
                })
            }
        }
        
        // double twiddling
        
        func numberSwapped() -> Double? {
            guard let swapped = if let self = self as? Data {
                self.withUnsafeBytes({
                    // $0.load(as: CFSwappedFloat64.self)
                    var value = CFSwappedFloat64()
                    memcpy(&value, $0.baseAddress!, 8)
                    return value
                })
            } else if let self = self as? [UInt8] {
                self.withUnsafeBytes({
                    // $0.load(as: CFSwappedFloat64.self)
                    var value = CFSwappedFloat64()
                    memcpy(&value, $0.baseAddress!, 8)
                    return value
                })
            } else {
                self.withContiguousStorageIfAvailable({
                    // $0.load(as: CFSwappedFloat64.self)
                    var value = CFSwappedFloat64()
                    memcpy(&value, $0.baseAddress!, 8)
                    return value
                })
            } else {
                return nil
            }
            return CFConvertDoubleSwappedToHost(swapped)
        }
        
        // determine which conversion is needed
        
        switch endianness {
        case .platformDefault:
            return number()
            
        case .littleEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return number()
            case .bigEndian:
                return numberSwapped()
            default:
                fatalError() // should never happen
            }
            
        case .bigEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return numberSwapped()
            case .bigEndian:
                return number()
            default:
                fatalError() // should never happen
            }
        }
    }
}

// MARK: - .toData

extension FixedWidthInteger {
    /// Returns Data representation of an integer. (Endianness has no effect on single-byte
    /// integers.)
    @_disfavoredOverload
    package func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
        var int: Self
        
        switch endianness {
        case .platformDefault: int = self
        case .littleEndian: int = littleEndian
        case .bigEndian: int = bigEndian
        }
        
        return withUnsafeBytes(of: &int) { rawBuffer in
            rawBuffer.withMemoryRebound(to: UInt8.self) { buffer in
                Data(buffer: buffer)
            }
        }
    }
}

// MARK: - Helper methods

extension DataProtocol {
    /// Internal use.
    func toNumber<T: FixedWidthInteger>(
        from endianness: NumberEndianness = .platformDefault,
        toType: T.Type
    ) -> T? {
        guard count == MemoryLayout<T>.size else { return nil }
        
        // define conversion
        
        // this crashes if Data alignment isn't correct
        // let int: T = { self.withUnsafeBytes { $0.load(as: T.self) } }()
        
        // since load(as:) is not memory alignment safe, memcpy is the current workaround
        // see for more info: https://bugs.swift.org/browse/SR-10273
        guard let int: T = if let self = self as? Data {
            self.withUnsafeBytes({
                var value = T()
                memcpy(&value, $0.baseAddress!, MemoryLayout<T>.size)
                return value
            })
        } else if let self = self as? [UInt8] {
            self.withUnsafeBytes({
                var value = T()
                memcpy(&value, $0.baseAddress!, MemoryLayout<T>.size)
                return value
            })
        } else {
            self.withContiguousStorageIfAvailable({
                var value = T()
                memcpy(&value, $0.baseAddress!, MemoryLayout<T>.size)
                return value
            })
        } else {
            return nil
        }
        
        // determine which conversion is needed
        
        switch endianness {
        case .platformDefault:
            return int
            
        case .littleEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return int
            case .bigEndian:
                return int.byteSwapped
            default:
                fatalError() // should never happen
            }
            
        case .bigEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return int.byteSwapped
            case .bigEndian:
                return int
            default:
                fatalError() // should never happen
            }
        }
    }
}

// MARK: - String

extension String {
    /// Returns a Data representation of a String, defaulting to UTF-8 encoding.
    @_disfavoredOverload
    package func toData(using encoding: String.Encoding = .utf8) -> Data? {
        data(using: encoding)
    }
}

extension Data {
    /// Returns a String converted from Data. Optionally pass an encoding type.
    @_disfavoredOverload
    package func toString(using encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
}

extension DataProtocol {
    /// Returns a String converted from Data. Optionally pass an encoding type.
    @_disfavoredOverload
    package func toString(using encoding: String.Encoding = .utf8) -> String? {
        String(data: Data(self), encoding: encoding)
    }
}

// MARK: - Data Bytes

extension Collection<UInt8> {
    /// Returns a Data object using the array as bytes.
    /// Same as `Data(self)`.
    @_disfavoredOverload
    package func toData() -> Data {
        Data(self)
    }
}

extension DataProtocol {
    /// Returns an array of `UInt8` bytes.
    /// Same as `[UInt8](self)`
    @_disfavoredOverload
    package func toUInt8Bytes() -> [UInt8] {
        [UInt8](self)
    }
}

#endif
