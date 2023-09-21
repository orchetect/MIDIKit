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

extension Data {
    /// Returns an Int64 value from Data
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toInt(from endianness: NumberEndianness = .platformDefault) -> Int? {
        toNumber(from: endianness, toType: Int.self)
    }
}

// MARK: - Int8

extension Data {
    /// Returns a Int8 value from Data (stored as two's complement).
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toInt8() -> Int8? {
        guard count == 1 else { return nil }
        
        var int = UInt8()
        withUnsafeMutablePointer(to: &int) {
            self.copyBytes(to: $0, count: 1)
        }
        return Int8(bitPattern: int)
    }
}

// MARK: - Int16

extension Data {
    /// Returns an Int16 value from Data
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toInt16(from endianness: NumberEndianness = .platformDefault) -> Int16? {
        toNumber(from: endianness, toType: Int16.self)
    }
}

// MARK: - Int32

extension Data {
    /// Returns an Int32 value from Data
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toInt32(from endianness: NumberEndianness = .platformDefault) -> Int32? {
        toNumber(from: endianness, toType: Int32.self)
    }
}

// MARK: - Int64

extension Data {
    /// Returns an Int64 value from Data
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toInt64(from endianness: NumberEndianness = .platformDefault) -> Int64? {
        toNumber(from: endianness, toType: Int64.self)
    }
}

// MARK: - UInt

extension Data {
    /// Returns a UInt value from Data.
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toUInt(from endianness: NumberEndianness = .platformDefault) -> UInt? {
        toNumber(from: endianness, toType: UInt.self)
    }
}

// MARK: - UInt8

extension Data {
    /// Returns a UInt8 value from Data.
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toUInt8() -> UInt8? {
        guard count == 1 else { return nil }
        return first
    }
}

// MARK: - UInt16

extension Data {
    /// Returns a UInt16 value from Data.
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toUInt16(from endianness: NumberEndianness = .platformDefault) -> UInt16? {
        toNumber(from: endianness, toType: UInt16.self)
    }
}

// MARK: - UInt32

extension Data {
    /// Returns a UInt32 value from Data.
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toUInt32(from endianness: NumberEndianness = .platformDefault) -> UInt32? {
        toNumber(from: endianness, toType: UInt32.self)
    }
}

// MARK: - UInt64

extension Data {
    /// Returns a UInt64 value from Data.
    /// Returns nil if Data is not the correct length.
    @_disfavoredOverload
    public func toUInt64(from endianness: NumberEndianness = .platformDefault) -> UInt64? {
        toNumber(from: endianness, toType: UInt64.self)
    }
}

// MARK: - Float32

extension Float32 {
    /// Returns Data representation of a Float32 value.
    @_disfavoredOverload
    public func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
        var number = self
        
        // TODO: Remove bindMemory(to:)
        // In Swift 5.7, `.bindMemory(to: UInt8.self)` is not necessary;
        // directly using .`withMemoryRebound` is supported on UnsafeRawBufferPointer.
        // Until Xcode 14 / Swift 5.7 is a minimum requirement we have to keep it this way:
        return withUnsafeBytes(of: &number) { rawBuffer in
            rawBuffer
                .bindMemory(to: UInt8.self)
                .withMemoryRebound(to: UInt8.self) { buffer in
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

extension Data {
    /// Returns a Float32 value from Data
    /// Returns nil if Data is != 4 bytes.
    @_disfavoredOverload
    public func toFloat32(from endianness: NumberEndianness = .platformDefault) -> Float32? {
        guard count == 4 else { return nil }
        
        // define conversions
        
        // this crashes if Data alignment isn't correct
        // let number = { self.withUnsafeBytes { $0.load(as: Float32.self) } }()
        
        // since .load(as:) is not memory alignment safe, memcpy is the current workaround (as of
        // Swift 5.3)
        // see for more info: https://bugs.swift.org/browse/SR-10273
        let number: Float32 = withUnsafeBytes {
            var value = Float32()
            memcpy(&value, $0.baseAddress!, 4)
            return value
        }
        
        // float twiddling
        
        let numberSwapped: Float32 = {
            var floatsw = CFConvertFloat32HostToSwapped(Float32())
            floatsw = self.withUnsafeBytes {
                // $0.load(as: CFSwappedFloat32.self)
                var value = CFSwappedFloat32()
                memcpy(&value, $0.baseAddress!, 4)
                return value
            }
            return CFConvertFloat32SwappedToHost(floatsw)
        }()
        
        // determine which conversion is needed
        
        switch endianness {
        case .platformDefault:
            return number
            
        case .littleEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return number
            case .bigEndian:
                return numberSwapped
            default:
                fatalError() // should never happen
            }
            
        case .bigEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return numberSwapped
            case .bigEndian:
                return number
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
    public func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
        var number = self
        
        // TODO: Remove bindMemory(to:)
        // In Swift 5.7, `.bindMemory(to: UInt8.self)` is not necessary;
        // directly using .`withMemoryRebound` is supported on UnsafeRawBufferPointer.
        // Until Xcode 14 / Swift 5.7 is a minimum requirement we have to keep it this way:
        return withUnsafeBytes(of: &number) { rawBuffer in
            rawBuffer
                .bindMemory(to: UInt8.self)
                .withMemoryRebound(to: UInt8.self) { buffer in
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

extension Data {
    /// Returns a Double value from Data
    /// Returns nil if Data is != 8 bytes.
    @_disfavoredOverload
    public func toDouble(from endianness: NumberEndianness = .platformDefault) -> Double? {
        guard count == 8 else { return nil }
        
        // define conversions
        
        // this crashes if Data alignment isn't correct
        // let number: Double = { self.withUnsafeBytes { $0.load(as: Double.self) } }()
        
        // since .load(as:) is not memory alignment safe, memcpy is the current workaround (as of
        // Swift 5.3)
        // see for more info: https://bugs.swift.org/browse/SR-10273
        let number: Double = withUnsafeBytes {
            var value = Double()
            memcpy(&value, $0.baseAddress!, 8)
            return value
        }
        
        // double twiddling
        
        let numberSwapped: Double = {
            var floatsw = CFConvertDoubleHostToSwapped(Double())
            floatsw = self.withUnsafeBytes {
                // $0.load(as: CFSwappedFloat64.self)
                var value = CFSwappedFloat64()
                memcpy(&value, $0.baseAddress!, 8)
                return value
            }
            return CFConvertDoubleSwappedToHost(floatsw)
        }()
        
        // determine which conversion is needed
        
        switch endianness {
        case .platformDefault:
            return number
            
        case .littleEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return number
            case .bigEndian:
                return numberSwapped
            default:
                fatalError() // should never happen
            }
            
        case .bigEndian:
            switch NumberEndianness.system {
            case .littleEndian:
                return numberSwapped
            case .bigEndian:
                return number
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
    public func toData(_ endianness: NumberEndianness = .platformDefault) -> Data {
        var int: Self
        
        switch endianness {
        case .platformDefault: int = self
        case .littleEndian:    int = littleEndian
        case .bigEndian:       int = bigEndian
        }
        
        // TODO: Remove bindMemory(to:)
        // In Swift 5.7, `.bindMemory(to: UInt8.self)` is not necessary;
        // directly using .`withMemoryRebound` is supported on UnsafeRawBufferPointer.
        // Until Xcode 14 / Swift 5.7 is a minimum requirement we have to keep it this way:
        return withUnsafeBytes(of: &int) { rawBuffer in
            rawBuffer
                .bindMemory(to: UInt8.self)
                .withMemoryRebound(to: UInt8.self) { buffer in
                    Data(buffer: buffer)
                }
        }
    }
}

// MARK: - Helper methods

extension Data {
    /// Internal use.
    func toNumber<T: FixedWidthInteger>(
        from endianness: NumberEndianness = .platformDefault,
        toType: T.Type
    ) -> T? {
        guard count == MemoryLayout<T>.size else { return nil }
        
        // define conversion
        
        // this crashes if Data alignment isn't correct
        // let int: T = { self.withUnsafeBytes { $0.load(as: T.self) } }()
        
        // since .load(as:) is not memory alignment safe, memcpy is the current workaround (as of
        // Swift 5.3)
        // see for more info: https://bugs.swift.org/browse/SR-10273
        let int: T = withUnsafeBytes {
            var value = T()
            memcpy(&value, $0.baseAddress!, MemoryLayout<T>.size)
            return value
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
    /// Returns a Data representation of a String, defaulting to utf8 encoding.
    @_disfavoredOverload
    public func toData(using encoding: String.Encoding = .utf8) -> Data? {
        data(using: encoding)
    }
}

extension Data {
    /// Returns a String converted from Data. Optionally pass an encoding type.
    @_disfavoredOverload
    public func toString(using encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
}

// MARK: - Data Bytes

extension Collection<UInt8> {
    /// Same as `Data(self)`
    /// Returns a Data object using the array as bytes.
    @_disfavoredOverload
    public var data: Data {
        Data(self)
    }
}

extension Data {
    /// Returns an array of bytes.
    /// Same as `[UInt8](self)`
    @_disfavoredOverload
    public var bytes: [UInt8] {
        [UInt8](self)
    }
}

#endif
