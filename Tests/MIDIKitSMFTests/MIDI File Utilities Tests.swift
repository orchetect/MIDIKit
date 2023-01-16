//
//  MIDI File Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class MIDIFileUtilities_Tests: XCTestCase {
    func testEncodeVariableLengthValue() {
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(0), [0x00])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(1), [0x01])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(64), [0x40])
        
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(127), [0x7F])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(128), [0x81, 0x00])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(129), [0x81, 0x01])
        
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(255), [0x81, 0x7F])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(256), [0x82, 0x00])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(257), [0x82, 0x01])
        
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(16383), [0xFF, 0x7F])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(16384), [0x81, 0x80, 0x00])
        XCTAssertEqual(MIDIFile.encodeVariableLengthValue(16385), [0x81, 0x80, 0x01])
    }
    
    func testDecodeVariableLengthValue_Empty() {
        XCTAssertNil(MIDIFile.decodeVariableLengthValue(from: []))
    }
    
    func testDecodeVariableLengthValue() {
        // repeat the test for:
        //   1. empty trailing bytes (so input bytes comprise only the variable length value)
        //   2. one or more trailing bytes existing in the input buffer
        // the outcome should be the same in either case.
        
        let trailingBytesCases: [[UInt8]] = [[], [0x80], [0x12, 0x23]]
        
        trailingBytesCases.forEach { trailingBytes in
            
            let decode = { MIDIFile.decodeVariableLengthValue(from: $0 + trailingBytes) }
            
            // 1 byte: max 7-bit value
            
            XCTAssertEqual(decode([0x00])?.value, 0)
            XCTAssertEqual(decode([0x00])?.byteLength, 1)
            
            XCTAssertEqual(decode([0x01])?.value, 1)
            XCTAssertEqual(decode([0x01])?.byteLength, 1)
            
            XCTAssertEqual(decode([0x40])?.value, 64)
            XCTAssertEqual(decode([0x40])?.byteLength, 1)
            
            XCTAssertEqual(decode([0x7F])?.value, 127)
            XCTAssertEqual(decode([0x7F])?.byteLength, 1)
            
            // 2 bytes: max 14-bit value
            
            XCTAssertEqual(decode([0x81, 0x00])?.value, 128)
            XCTAssertEqual(decode([0x81, 0x00])?.byteLength, 2)
            
            XCTAssertEqual(decode([0x81, 0x01])?.value, 129)
            XCTAssertEqual(decode([0x81, 0x00])?.byteLength, 2)
            
            XCTAssertEqual(decode([0x81, 0x7F])?.value, 255)
            XCTAssertEqual(decode([0x81, 0x7F])?.byteLength, 2)
            
            XCTAssertEqual(decode([0x82, 0x00])?.value, 256)
            XCTAssertEqual(decode([0x82, 0x00])?.byteLength, 2)
            
            XCTAssertEqual(decode([0x82, 0x01])?.value, 257)
            XCTAssertEqual(decode([0x82, 0x01])?.byteLength, 2)
            
            XCTAssertEqual(decode([0xFF, 0x7F])?.value, 16383)
            XCTAssertEqual(decode([0xFF, 0x7F])?.byteLength, 2)
            
            // 3 bytes: max 21-bit value
            
            XCTAssertEqual(decode([0x81, 0x80, 0x00])?.value, 16384)
            XCTAssertEqual(decode([0x81, 0x80, 0x00])?.byteLength, 3)
            
            XCTAssertEqual(decode([0x81, 0x80, 0x01])?.value, 16385)
            XCTAssertEqual(decode([0x81, 0x80, 0x01])?.byteLength, 3)
            
            // 4 bytes: max 28-bit value
            
            XCTAssertEqual(decode([0xFF, 0xFF, 0xFF, 0x7F])?.value, 268_435_455)
            XCTAssertEqual(decode([0xFF, 0xFF, 0xFF, 0x7F])?.byteLength, 4)
        }
    }
    
    func testDecodeVariableLengthValue_EdgeCase() {
        // ensure setting the top bit with no bytes following does not crash
        
        XCTAssertNil(MIDIFile.decodeVariableLengthValue(from: [0x80]))
    }
}

#endif
