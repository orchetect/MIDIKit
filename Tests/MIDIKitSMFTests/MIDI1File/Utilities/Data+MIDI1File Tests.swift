//
//  Data+MIDI1File Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import MIDIKitSMF
import Testing

@Suite struct Data_MIDI1File_Tests {
    @Test
    func encodeSMF1VariableLengthValue() async {
        #expect([UInt8].encodeSMF1VariableLengthValue(0) == [0x00])
        #expect([UInt8].encodeSMF1VariableLengthValue(1) == [0x01])
        #expect([UInt8].encodeSMF1VariableLengthValue(64) == [0x40])
        
        #expect([UInt8].encodeSMF1VariableLengthValue(127) == [0x7F])
        #expect([UInt8].encodeSMF1VariableLengthValue(128) == [0x81, 0x00])
        #expect([UInt8].encodeSMF1VariableLengthValue(129) == [0x81, 0x01])
        
        #expect([UInt8].encodeSMF1VariableLengthValue(255) == [0x81, 0x7F])
        #expect([UInt8].encodeSMF1VariableLengthValue(256) == [0x82, 0x00])
        #expect([UInt8].encodeSMF1VariableLengthValue(257) == [0x82, 0x01])
        
        #expect([UInt8].encodeSMF1VariableLengthValue(16383) == [0xFF, 0x7F])
        #expect([UInt8].encodeSMF1VariableLengthValue(16384) == [0x81, 0x80, 0x00])
        #expect([UInt8].encodeSMF1VariableLengthValue(16385) == [0x81, 0x80, 0x01])
    }
    
    @Test
    func decodeSMF1VariableLengthValue_Empty() async {
        #expect(([] as [UInt8]).decodeSMF1VariableLengthValue() == nil)
    }
    
    @Test
    func decodeSMF1VariableLengthValue() async {
        // repeat the test for:
        //   1. empty trailing bytes (so input bytes comprise only the variable length value)
        //   2. one or more trailing bytes existing in the input buffer
        // the outcome should be the same in either case.
        
        let trailingBytesCases: [[UInt8]] = [[], [0x80], [0x12, 0x23]]
        
        for trailingBytes in trailingBytesCases {
            let decode = { ($0 + trailingBytes).decodeSMF1VariableLengthValue() }
            
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
    func decodeSMF1VariableLengthValue_data_pointer() async throws {
        // 1 byte: max 7-bit value
        
        try Data([0x7F, 0x00]).withContiguousStorageIfAvailable({
            let result = try #require($0.decodeSMF1VariableLengthValue())
            #expect(result.value == 127)
            #expect(result.byteLength == 1)
        })!
        
        // 2 bytes: max 14-bit value
        
        try Data([0x81, 0x00]).withContiguousStorageIfAvailable({
            let result = try #require($0.decodeSMF1VariableLengthValue())
            #expect(result.value == 128)
            #expect(result.byteLength == 2)
        })!
        
        // 3 bytes: max 21-bit value
        
        try Data([0x81, 0x80, 0x00]).withContiguousStorageIfAvailable({
            let result = try #require($0.decodeSMF1VariableLengthValue())
            #expect(result.value == 16384)
            #expect(result.byteLength == 3)
        })!
        
        // 4 bytes: max 28-bit value
        
        try Data([0xFF, 0xFF, 0xFF, 0x7F]).withContiguousStorageIfAvailable({
            let result = try #require($0.decodeSMF1VariableLengthValue())
            #expect(result.value == 268_435_455)
            #expect(result.byteLength == 4)
        })!
    }
    
    @Test
    func decodeSMF1VariableLengthValue_uInt8Array_pointer_slice() async throws {
        // 1 byte: max 7-bit value
        
        try Data([0x01, 0x7F, 0x00]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(slice.decodeSMF1VariableLengthValue())
            #expect(result.value == 127)
            #expect(result.byteLength == 1)
        })!
        
        // 2 bytes: max 14-bit value
        
        try Data([0x01, 0x81, 0x00]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(slice.decodeSMF1VariableLengthValue())
            #expect(result.value == 128)
            #expect(result.byteLength == 2)
        })!
        
        // 3 bytes: max 21-bit value
        
        try Data([0x01, 0x81, 0x80, 0x00]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(slice.decodeSMF1VariableLengthValue())
            #expect(result.value == 16384)
            #expect(result.byteLength == 3)
        })!
        
        // 4 bytes: max 28-bit value
        
        try Data([0x01, 0xFF, 0xFF, 0xFF, 0x7F]).withContiguousStorageIfAvailable({
            let slice = $0[1...]
            let result = try #require(slice.decodeSMF1VariableLengthValue())
            #expect(result.value == 268_435_455)
            #expect(result.byteLength == 4)
        })!
    }
    
    @Test
    func decodeSMF1VariableLengthValue_EdgeCase() async {
        // ensure setting the top bit with no bytes following does not crash
        
        #expect([0x80].decodeSMF1VariableLengthValue() == nil)
    }
}
