//
//  MIDI File Utilities.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents

extension MIDIFile {
    // MARK: - Utilities math and number conversion

    static func uint16To2BytesBigEndian(_ number: UInt16) -> [Byte] {
        var val = number

        return Array(NSData(bytes: &val, length: 2) as Data)
            .reversed()
    }

    static func uint32To4BytesBigEndian(_ number: UInt32) -> [Byte] {
        var val = number

        return Array(NSData(bytes: &val, length: 4) as Data)
            .reversed()
    }

    /// Returns variable length value encoded byte array
    static func encodeVariableLengthValue<T: BinaryInteger>(_ number: T) -> [Byte] {
        var result: [Byte] = []
        var count = 0

        var parseNum = number

        if parseNum < 1 { return [0x00] }

        while parseNum > 0 {
            if (result.count - 1) < count {
                // increase size of array as needed
                result.insert(0x00, at: 0)
            }

            // Get lowest 7 bits of current data
            result[0] = Byte(parseNum & 0x7F)

            // shift by 7 bits
            parseNum = parseNum >> 7

            if count > 0 { // not least significant byte?
                // set a flag on the byte
                result[0] = result[0] | 0x80
            }

            count += 1 // count up for next byte
        }

        return result
    }

    /// Returns the decoded value and the number of bytes read from the bytes array if successful.
    /// Returns nil if bytes is empty or variable length value could not be read in the expected format (ie: malformed or unexpected data)
    /// Currently returns nil if value overflows a 28-bit unsigned value.
    static func decodeVariableLengthValue(from bytes: [Byte]) -> (
        value: Int,
        byteLength: Int
    )? {
        // make mutable so we can call the `inout` overload of this method and not duplicate code here
        var bytes = bytes
        return decodeVariableLengthValue(from: &bytes)
    }

    /// Returns the decoded value and the number of bytes read from the bytes array if successful.
    /// Returns nil if bytes is empty or variable length value could not be read in the expected format (ie: malformed or unexpected data)
    /// Currently returns nil if value overflows a 28-bit unsigned value.
    static func decodeVariableLengthValue(from bytes: inout [Byte]) -> (
        value: Int,
        byteLength: Int
    )? {
        let uInt28Max = 0b1111_11111111_11111111_11111111
        
        var result = 0 // don't cast as UInt32 yet, we need room to check for overflow

        var count = 0

        if bytes.count < 1 { return nil }

        // while flag bit is set
        while count < bytes.count,
              bytes[count] & 0x80 > 0,
              count <= 4
        {
            result = result << 7
            result = result | (Int(bytes[count]) & 0x7F)

            // validation check: if we overflow, return nil - input data may be malformed
            if result > uInt28Max { return nil }

            count += 1
        }
        
        guard count < bytes.count else {
            // malformed
            return nil
        }
        
        // get last byte (the one without the flag bit set)
        result = result << 7
        result = result | (Int(bytes[count]) & 0x7F)
        
        // validation check: if we overflow, return nil - input data may be malformed
        if result > uInt28Max { return nil }

        return (value: Int(result), byteLength: count + 1)
    }
}

extension Data {
    mutating func append(deltaTime ticks: UInt32) {
        // Variable length delta timestamp representing the number of ticks that have elapsed
        // According to the Standard MIDI File Spec 1.0, the entire delta-time should be at most 4 bytes long.

        append(contentsOf: MIDIFile.encodeVariableLengthValue(ticks))
    }
}
