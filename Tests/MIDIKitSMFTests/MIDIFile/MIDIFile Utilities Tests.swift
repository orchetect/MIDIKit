//
//  MIDIFile Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import MIDIKitSMF
import Testing

@Suite struct MIDIFile_Utilities_Tests {
    @Test
    func encodeVariableLengthValue() async {
        #expect(MIDIFile.encodeVariableLengthValue(0, as: [UInt8].self) == [0x00])
        #expect(MIDIFile.encodeVariableLengthValue(1, as: [UInt8].self) == [0x01])
        #expect(MIDIFile.encodeVariableLengthValue(64, as: [UInt8].self) == [0x40])
        
        #expect(MIDIFile.encodeVariableLengthValue(127, as: [UInt8].self) == [0x7F])
        #expect(MIDIFile.encodeVariableLengthValue(128, as: [UInt8].self) == [0x81, 0x00])
        #expect(MIDIFile.encodeVariableLengthValue(129, as: [UInt8].self) == [0x81, 0x01])
        
        #expect(MIDIFile.encodeVariableLengthValue(255, as: [UInt8].self) == [0x81, 0x7F])
        #expect(MIDIFile.encodeVariableLengthValue(256, as: [UInt8].self) == [0x82, 0x00])
        #expect(MIDIFile.encodeVariableLengthValue(257, as: [UInt8].self) == [0x82, 0x01])
        
        #expect(MIDIFile.encodeVariableLengthValue(16383, as: [UInt8].self) == [0xFF, 0x7F])
        #expect(MIDIFile.encodeVariableLengthValue(16384, as: [UInt8].self) == [0x81, 0x80, 0x00])
        #expect(MIDIFile.encodeVariableLengthValue(16385, as: [UInt8].self) == [0x81, 0x80, 0x01])
    }
    
    @Test
    func decodeVariableLengthValue_Empty() async {
        #expect(MIDIFile.decodeVariableLengthValue(from: []) == nil)
    }
    
    @Test
    func decodeVariableLengthValue() async {
        // repeat the test for:
        //   1. empty trailing bytes (so input bytes comprise only the variable length value)
        //   2. one or more trailing bytes existing in the input buffer
        // the outcome should be the same in either case.
        
        let trailingBytesCases: [[UInt8]] = [[], [0x80], [0x12, 0x23]]
        
        for trailingBytes in trailingBytesCases {
            let decode = { MIDIFile.decodeVariableLengthValue(from: $0 + trailingBytes) }
            
            // 1 byte: max 7-bit value
            
            #expect(decode([0x00])?.value == 0)
            #expect(decode([0x00])?.byteLength == 1)
            
            #expect(decode([0x01])?.value == 1)
            #expect(decode([0x01])?.byteLength == 1)
            
            #expect(decode([0x40])?.value == 64)
            #expect(decode([0x40])?.byteLength == 1)
            
            #expect(decode([0x7F])?.value == 127)
            #expect(decode([0x7F])?.byteLength == 1)
            
            // 2 bytes: max 14-bit value
            
            #expect(decode([0x81, 0x00])?.value == 128)
            #expect(decode([0x81, 0x00])?.byteLength == 2)
            
            #expect(decode([0x81, 0x01])?.value == 129)
            #expect(decode([0x81, 0x00])?.byteLength == 2)
            
            #expect(decode([0x81, 0x7F])?.value == 255)
            #expect(decode([0x81, 0x7F])?.byteLength == 2)
            
            #expect(decode([0x82, 0x00])?.value == 256)
            #expect(decode([0x82, 0x00])?.byteLength == 2)
            
            #expect(decode([0x82, 0x01])?.value == 257)
            #expect(decode([0x82, 0x01])?.byteLength == 2)
            
            #expect(decode([0xFF, 0x7F])?.value == 16383)
            #expect(decode([0xFF, 0x7F])?.byteLength == 2)
            
            // 3 bytes: max 21-bit value
            
            #expect(decode([0x81, 0x80, 0x00])?.value == 16384)
            #expect(decode([0x81, 0x80, 0x00])?.byteLength == 3)
            
            #expect(decode([0x81, 0x80, 0x01])?.value == 16385)
            #expect(decode([0x81, 0x80, 0x01])?.byteLength == 3)
            
            // 4 bytes: max 28-bit value
            
            #expect(decode([0xFF, 0xFF, 0xFF, 0x7F])?.value == 268_435_455)
            #expect(decode([0xFF, 0xFF, 0xFF, 0x7F])?.byteLength == 4)
        }
    }
    
    @Test
    func decodeVariableLengthValue_data_pointer() async throws {
        // 1 byte: max 7-bit value
        
        try Data([0x7F, 0x00]).withContiguousStorageIfAvailable({
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: $0))
            #expect(result.value == 127)
            #expect(result.byteLength == 1)
        })!
        
        // 2 bytes: max 14-bit value
        
        try Data([0x81, 0x00]).withContiguousStorageIfAvailable({
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: $0))
            #expect(result.value == 128)
            #expect(result.byteLength == 2)
        })!
        
        // 3 bytes: max 21-bit value
        
        try Data([0x81, 0x80, 0x00]).withContiguousStorageIfAvailable({
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: $0))
            #expect(result.value == 16384)
            #expect(result.byteLength == 3)
        })!
        
        // 4 bytes: max 28-bit value
        
        try Data([0xFF, 0xFF, 0xFF, 0x7F]).withContiguousStorageIfAvailable({
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: $0))
            #expect(result.value == 268_435_455)
            #expect(result.byteLength == 4)
        })!
    }
    
    @Test
    func decodeVariableLengthValue_uInt8Array_pointer_slice() async throws {
        // 1 byte: max 7-bit value
        
        try Data([0x01, 0x7F, 0x00]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: slice))
            #expect(result.value == 127)
            #expect(result.byteLength == 1)
        })!
        
        // 2 bytes: max 14-bit value
        
        try Data([0x01, 0x81, 0x00]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: slice))
            #expect(result.value == 128)
            #expect(result.byteLength == 2)
        })!
        
        // 3 bytes: max 21-bit value
        
        try Data([0x01, 0x81, 0x80, 0x00]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: slice))
            #expect(result.value == 16384)
            #expect(result.byteLength == 3)
        })!
        
        // 4 bytes: max 28-bit value
        
        try Data([0x01, 0xFF, 0xFF, 0xFF, 0x7F]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(MIDIFile.decodeVariableLengthValue(from: slice))
            #expect(result.value == 268_435_455)
            #expect(result.byteLength == 4)
        })!
    }
    
    @Test
    func decodeVariableLengthValue_EdgeCase() async {
        // ensure setting the top bit with no bytes following does not crash
        
        #expect(MIDIFile.decodeVariableLengthValue(from: [0x80]) == nil)
    }
}
