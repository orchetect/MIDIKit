//
//  Byte Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class Byte_Tests: XCTestCase {
    func testNibbles() {
        let byte = Byte(0x12)
        
        let nibbles = byte.nibbles
        
        XCTAssertEqual(nibbles.high, 0x1)
        XCTAssertEqual(nibbles.low, 0x2)
    }
    
    func testInit_Nibbles() {
        let byte = Byte(high: 0x1, low: 0x2)
        
        XCTAssertEqual(byte, 0x12)
    }
}

#endif
