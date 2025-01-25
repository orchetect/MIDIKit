//
//  MIDI File Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct MIDIFileUtilities_Tests {
    @Test
    func encodeVariableLengthValue() {
        #expect(MIDIFile.encodeVariableLengthValue(0) == [0x00])
        #expect(MIDIFile.encodeVariableLengthValue(1) == [0x01])
        #expect(MIDIFile.encodeVariableLengthValue(64) == [0x40])
        
        #expect(MIDIFile.encodeVariableLengthValue(127) == [0x7F])
        #expect(MIDIFile.encodeVariableLengthValue(128) == [0x81, 0x00])
        #expect(MIDIFile.encodeVariableLengthValue(129) == [0x81, 0x01])
        
        #expect(MIDIFile.encodeVariableLengthValue(255) == [0x81, 0x7F])
        #expect(MIDIFile.encodeVariableLengthValue(256) == [0x82, 0x00])
        #expect(MIDIFile.encodeVariableLengthValue(257) == [0x82, 0x01])
        
        #expect(MIDIFile.encodeVariableLengthValue(16383) == [0xFF, 0x7F])
        #expect(MIDIFile.encodeVariableLengthValue(16384) == [0x81, 0x80, 0x00])
        #expect(MIDIFile.encodeVariableLengthValue(16385) == [0x81, 0x80, 0x01])
    }
    
    @Test
    func decodeVariableLengthValue_Empty() {
        #expect(MIDIFile.decodeVariableLengthValue(from: []) == nil)
    }
    
    @Test
    func decodeVariableLengthValue() {
        // repeat the test for:
        //   1. empty trailing bytes (so input bytes comprise only the variable length value)
        //   2. one or more trailing bytes existing in the input buffer
        // the outcome should be the same in either case.
        
        let trailingBytesCases: [[UInt8]] = [[], [0x80], [0x12, 0x23]]
        
        trailingBytesCases.forEach { trailingBytes in
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
    func decodeVariableLengthValue_EdgeCase() {
        // ensure setting the top bit with no bytes following does not crash
        
        #expect(MIDIFile.decodeVariableLengthValue(from: [0x80]) == nil)
    }
}
