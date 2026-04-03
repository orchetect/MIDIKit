//
//  Data+MIDI1File.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MutableDataProtocol {
    /// Utility:
    /// Returns variable length value encoded byte array.
    init(midi1SMFVariableLengthValue number: some BinaryInteger) {
        var result = Self()
        var count = 0
        
        var parseNum = number
        
        guard parseNum > 0 else {
            self = Self([0x00])
            return
        }
        
        while parseNum > 0 {
            if (result.count - 1) < count {
                // increase size of array as needed
                result.insert(0x00, at: result.startIndex)
            }
            
            // Get lowest 7 bits of current data
            result[result.startIndex] = Self.Element(parseNum & 0x7F)
            
            // shift by 7 bits
            parseNum = parseNum >> 7
            
            if count > 0 { // not least significant byte?
                // set a flag on the byte
                result[result.startIndex] = result[result.startIndex] | 0x80
            }
            
            count += 1 // count up for next byte
        }
        
        self = result
    }
}

extension MutableDataProtocol {
    mutating func append(deltaTime ticks: UInt32) {
        // Variable length delta timestamp representing the number of ticks that have elapsed
        // According to the Standard MIDI File 1.0 Spec, the entire delta-time should be at most 4
        // bytes long.
        
        append(contentsOf: Self(midi1SMFVariableLengthValue: ticks))
    }
}

extension DataProtocol {
    /// Utility:
    /// Returns the decoded value and the number of bytes read from the bytes array if successful.
    /// Returns nil if bytes is empty or variable length value could not be read in the expected
    /// format (ie: malformed or unexpected data)
    /// Currently returns nil if value overflows a 28-bit unsigned value.
    func decodeSMF1VariableLengthValue() -> (value: Int, byteLength: Int)? {
        let uInt28Max = 0b1111_11111111_11111111_11111111
        
        var result = 0 // don't cast as UInt32 yet, we need room to check for overflow
        
        var parsedByteCount = 0
        
        if count < 1 { return nil }
        
        func countAsIndex() -> Self.Index {
            index(startIndex, offsetBy: parsedByteCount)
        }
        
        // while flag bit is set
        while parsedByteCount < count,
              self[countAsIndex()] & 0x80 > 0,
              parsedByteCount <= 4
        {
            result = result << 7
            result = result | (Int(self[countAsIndex()]) & 0x7F)
            
            // validation check: if we overflow, return nil - input data may be malformed
            if result > uInt28Max { return nil }
            
            parsedByteCount += 1
        }
        
        guard parsedByteCount < count else {
            // malformed
            return nil
        }
        
        // get last byte (the one without the flag bit set)
        result = result << 7
        result = result | (Int(self[countAsIndex()]) & 0x7F)
        
        // validation check: if we overflow, return nil - input data may be malformed
        if result > uInt28Max { return nil }
        
        return (value: Int(result), byteLength: parsedByteCount + 1)
    }
}
