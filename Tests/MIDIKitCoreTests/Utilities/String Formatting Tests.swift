//
//  String Formatting Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class StringFormatting_Tests: XCTestCase {
    // MARK: - Hex Strings
    
    func testHexString_Prefix() {
        XCTAssertEqual(0x0.hexString(prefix: true),    "0x0")
        XCTAssertEqual(0x9.hexString(prefix: true),    "0x9")
        XCTAssertEqual(0xA.hexString(prefix: true),    "0xA")
        XCTAssertEqual(0x10.hexString(prefix: true),   "0x10")
        XCTAssertEqual(0xFF.hexString(prefix: true),   "0xFF")
        XCTAssertEqual(0xFFF.hexString(prefix: true),  "0xFFF")
    }
    
    func testHexString_NoPrefix() {
        XCTAssertEqual(0x0.hexString(prefix: false),   "0")
        XCTAssertEqual(0x9.hexString(prefix: false),   "9")
        XCTAssertEqual(0xA.hexString(prefix: false),   "A")
        XCTAssertEqual(0x10.hexString(prefix: false),  "10")
        XCTAssertEqual(0xFF.hexString(prefix: false),  "FF")
        XCTAssertEqual(0xFFF.hexString(prefix: false), "FFF")
    }
    
    func testHexString_PadTo_Prefix() {
        XCTAssertEqual(0x0.hexString(padTo: 0, prefix: true),   "0x0")
        XCTAssertEqual(0x9.hexString(padTo: 0, prefix: true),   "0x9")
        XCTAssertEqual(0xA.hexString(padTo: 0, prefix: true),   "0xA")
        XCTAssertEqual(0x10.hexString(padTo: 0, prefix: true),  "0x10")
        XCTAssertEqual(0xFF.hexString(padTo: 0, prefix: true),  "0xFF")
        XCTAssertEqual(0xFFF.hexString(padTo: 0, prefix: true), "0xFFF")
        
        XCTAssertEqual(0x0.hexString(padTo: 1, prefix: true),   "0x0")
        XCTAssertEqual(0x9.hexString(padTo: 1, prefix: true),   "0x9")
        XCTAssertEqual(0xA.hexString(padTo: 1, prefix: true),   "0xA")
        XCTAssertEqual(0x10.hexString(padTo: 1, prefix: true),  "0x10")
        XCTAssertEqual(0xFF.hexString(padTo: 1, prefix: true),  "0xFF")
        XCTAssertEqual(0xFFF.hexString(padTo: 1, prefix: true), "0xFFF")
        
        XCTAssertEqual(0x0.hexString(padTo: 2, prefix: true),   "0x00")
        XCTAssertEqual(0x9.hexString(padTo: 2, prefix: true),   "0x09")
        XCTAssertEqual(0xA.hexString(padTo: 2, prefix: true),   "0x0A")
        XCTAssertEqual(0x10.hexString(padTo: 2, prefix: true),  "0x10")
        XCTAssertEqual(0xFF.hexString(padTo: 2, prefix: true),  "0xFF")
        XCTAssertEqual(0xFFF.hexString(padTo: 2, prefix: true), "0xFFF")
        
        XCTAssertEqual(0x0.hexString(padTo: 3, prefix: true),   "0x000")
        XCTAssertEqual(0x9.hexString(padTo: 3, prefix: true),   "0x009")
        XCTAssertEqual(0xA.hexString(padTo: 3, prefix: true),   "0x00A")
        XCTAssertEqual(0x10.hexString(padTo: 3, prefix: true),  "0x010")
        XCTAssertEqual(0xFF.hexString(padTo: 3, prefix: true),  "0x0FF")
        XCTAssertEqual(0xFFF.hexString(padTo: 3, prefix: true), "0xFFF")
        
        // edge cases
        XCTAssertEqual(0x0.hexString(padTo: -1, prefix: true),  "0x0")
        XCTAssertEqual(0xF.hexString(padTo: -1, prefix: true),  "0xF")
        XCTAssertEqual(0xFF.hexString(padTo: -1, prefix: true), "0xFF")
    }
    
    func testHexString_PadTo_NoPrefix() {
        XCTAssertEqual(0x0.hexString(padTo: 0, prefix: false),   "0")
        XCTAssertEqual(0x9.hexString(padTo: 0, prefix: false),   "9")
        XCTAssertEqual(0xA.hexString(padTo: 0, prefix: false),   "A")
        XCTAssertEqual(0x10.hexString(padTo: 0, prefix: false),  "10")
        XCTAssertEqual(0xFF.hexString(padTo: 0, prefix: false),  "FF")
        XCTAssertEqual(0xFFF.hexString(padTo: 0, prefix: false), "FFF")
        
        XCTAssertEqual(0x0.hexString(padTo: 1, prefix: false),   "0")
        XCTAssertEqual(0x9.hexString(padTo: 1, prefix: false),   "9")
        XCTAssertEqual(0xA.hexString(padTo: 1, prefix: false),   "A")
        XCTAssertEqual(0x10.hexString(padTo: 1, prefix: false),  "10")
        XCTAssertEqual(0xFF.hexString(padTo: 1, prefix: false),  "FF")
        XCTAssertEqual(0xFFF.hexString(padTo: 1, prefix: false), "FFF")
        
        XCTAssertEqual(0x0.hexString(padTo: 2, prefix: false),   "00")
        XCTAssertEqual(0x9.hexString(padTo: 2, prefix: false),   "09")
        XCTAssertEqual(0xA.hexString(padTo: 2, prefix: false),   "0A")
        XCTAssertEqual(0x10.hexString(padTo: 2, prefix: false),  "10")
        XCTAssertEqual(0xFF.hexString(padTo: 2, prefix: false),  "FF")
        XCTAssertEqual(0xFFF.hexString(padTo: 2, prefix: false), "FFF")
        
        XCTAssertEqual(0x0.hexString(padTo: 3, prefix: false),   "000")
        XCTAssertEqual(0x9.hexString(padTo: 3, prefix: false),   "009")
        XCTAssertEqual(0xA.hexString(padTo: 3, prefix: false),   "00A")
        XCTAssertEqual(0x10.hexString(padTo: 3, prefix: false),  "010")
        XCTAssertEqual(0xFF.hexString(padTo: 3, prefix: false),  "0FF")
        XCTAssertEqual(0xFFF.hexString(padTo: 3, prefix: false), "FFF")
        
        // edge cases
        XCTAssertEqual(0x0.hexString(padTo: -1, prefix: false),  "0")
        XCTAssertEqual(0xF.hexString(padTo: -1, prefix: false),  "F")
        XCTAssertEqual(0xFF.hexString(padTo: -1, prefix: false), "FF")
    }
    
    func testCollection_HexString_Prefixes() {
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(prefixes: true),
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
    }
    
    func testCollection_HexString_NoPrefixes() {
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(prefixes: false),
            "0 1 9 F FF FFF"
        )
    }
    
    func testCollection_HexString_PadToEach_Prefixes() {
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 0, prefixes: true),
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 1, prefixes: true),
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 2, prefixes: true),
            "0x00 0x01 0x09 0x0F 0xFF 0xFFF"
        )
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 3, prefixes: true),
            "0x000 0x001 0x009 0x00F 0x0FF 0xFFF"
        )
        
        // edge cases
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: -1, prefixes: true),
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
    }
    
    func testCollection_HexString_PadToEach_NoPrefixes() {
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 0, prefixes: false),
            "0 1 9 F FF FFF"
        )
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 1, prefixes: false),
            "0 1 9 F FF FFF"
        )
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 2, prefixes: false),
            "00 01 09 0F FF FFF"
        )
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 3, prefixes: false),
            "000 001 009 00F 0FF FFF"
        )
        
        // edge cases
        
        XCTAssertEqual(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: -1, prefixes: false),
            "0 1 9 F FF FFF"
        )
    }
    
    // MARK: - Binary Strings
    
    func testBinaryxString_Prefix() {
        XCTAssertEqual(0b0.binaryString(prefix: true),    "0b0")
        XCTAssertEqual(0b1.binaryString(prefix: true),    "0b1")
        XCTAssertEqual(0b10.binaryString(prefix: true),   "0b10")
        XCTAssertEqual(0b11.binaryString(prefix: true),   "0b11")
        XCTAssertEqual(0b110.binaryString(prefix: true),  "0b110")
    }
    
    func testBinaryString_NoPrefix() {
        XCTAssertEqual(0b0.binaryString(prefix: false),   "0")
        XCTAssertEqual(0b1.binaryString(prefix: false),   "1")
        XCTAssertEqual(0b10.binaryString(prefix: false),  "10")
        XCTAssertEqual(0b11.binaryString(prefix: false),  "11")
        XCTAssertEqual(0b110.binaryString(prefix: false), "110")
    }
    
    func testHBinaryString_PadTo_Prefix() {
        XCTAssertEqual(0b0.binaryString(padTo: 0, prefix: true),   "0b0")
        XCTAssertEqual(0b1.binaryString(padTo: 0, prefix: true),   "0b1")
        XCTAssertEqual(0b10.binaryString(padTo: 0, prefix: true),  "0b10")
        XCTAssertEqual(0b11.binaryString(padTo: 0, prefix: true),  "0b11")
        XCTAssertEqual(0b110.binaryString(padTo: 0, prefix: true), "0b110")
        
        XCTAssertEqual(0b0.binaryString(padTo: 1, prefix: true),   "0b0")
        XCTAssertEqual(0b1.binaryString(padTo: 1, prefix: true),   "0b1")
        XCTAssertEqual(0b10.binaryString(padTo: 1, prefix: true),  "0b10")
        XCTAssertEqual(0b11.binaryString(padTo: 1, prefix: true),  "0b11")
        XCTAssertEqual(0b110.binaryString(padTo: 1, prefix: true), "0b110")
        
        XCTAssertEqual(0b0.binaryString(padTo: 2, prefix: true),   "0b00")
        XCTAssertEqual(0b1.binaryString(padTo: 2, prefix: true),   "0b01")
        XCTAssertEqual(0b10.binaryString(padTo: 2, prefix: true),  "0b10")
        XCTAssertEqual(0b11.binaryString(padTo: 2, prefix: true),  "0b11")
        XCTAssertEqual(0b110.binaryString(padTo: 2, prefix: true), "0b110")
        
        XCTAssertEqual(0b0.binaryString(padTo: 3, prefix: true),   "0b000")
        XCTAssertEqual(0b1.binaryString(padTo: 3, prefix: true),   "0b001")
        XCTAssertEqual(0b10.binaryString(padTo: 3, prefix: true),  "0b010")
        XCTAssertEqual(0b11.binaryString(padTo: 3, prefix: true),  "0b011")
        XCTAssertEqual(0b110.binaryString(padTo: 3, prefix: true), "0b110")
        
        // edge cases
        XCTAssertEqual(0b0.binaryString(padTo: -1, prefix: true),  "0b0")
        XCTAssertEqual(0b1.binaryString(padTo: -1, prefix: true),  "0b1")
        XCTAssertEqual(0b11.binaryString(padTo: -1, prefix: true), "0b11")
    }
    
    func testBinaryString_PadTo_NoPrefix() {
        XCTAssertEqual(0b0.binaryString(padTo: 0, prefix: false),   "0")
        XCTAssertEqual(0b1.binaryString(padTo: 0, prefix: false),   "1")
        XCTAssertEqual(0b10.binaryString(padTo: 0, prefix: false),  "10")
        XCTAssertEqual(0b11.binaryString(padTo: 0, prefix: false),  "11")
        XCTAssertEqual(0b110.binaryString(padTo: 0, prefix: false), "110")
        
        XCTAssertEqual(0b0.binaryString(padTo: 1, prefix: false),   "0")
        XCTAssertEqual(0b1.binaryString(padTo: 1, prefix: false),   "1")
        XCTAssertEqual(0b10.binaryString(padTo: 1, prefix: false),  "10")
        XCTAssertEqual(0b11.binaryString(padTo: 1, prefix: false),  "11")
        XCTAssertEqual(0b110.binaryString(padTo: 1, prefix: false), "110")
        
        XCTAssertEqual(0b0.binaryString(padTo: 2, prefix: false),   "00")
        XCTAssertEqual(0b1.binaryString(padTo: 2, prefix: false),   "01")
        XCTAssertEqual(0b10.binaryString(padTo: 2, prefix: false),  "10")
        XCTAssertEqual(0b11.binaryString(padTo: 2, prefix: false),  "11")
        XCTAssertEqual(0b110.binaryString(padTo: 2, prefix: false), "110")
        
        XCTAssertEqual(0b0.binaryString(padTo: 3, prefix: false),   "000")
        XCTAssertEqual(0b1.binaryString(padTo: 3, prefix: false),   "001")
        XCTAssertEqual(0b10.binaryString(padTo: 3, prefix: false),  "010")
        XCTAssertEqual(0b11.binaryString(padTo: 3, prefix: false),  "011")
        XCTAssertEqual(0b110.binaryString(padTo: 3, prefix: false), "110")
        
        // edge cases
        XCTAssertEqual(0b0.binaryString(padTo: -1, prefix: false),  "0")
        XCTAssertEqual(0b1.binaryString(padTo: -1, prefix: false),  "1")
        XCTAssertEqual(0b11.binaryString(padTo: -1, prefix: false), "11")
    }
    
    func testCollection_BinaryString_Prefixes() {
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(prefixes: true),
            "0b0 0b1 0b11 0b110"
        )
    }
    
    func testCollection_BinaryString_NoPrefixes() {
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(prefixes: false),
            "0 1 11 110"
        )
    }
    
    func testCollection_BinaryString_PadToEach_Prefixes() {
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 0, prefixes: true),
            "0b0 0b1 0b11 0b110"
        )
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 1, prefixes: true),
            "0b0 0b1 0b11 0b110"
        )
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 2, prefixes: true),
            "0b00 0b01 0b11 0b110"
        )
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 3, prefixes: true),
            "0b000 0b001 0b011 0b110"
        )
        
        // edge cases
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: -1, prefixes: true),
            "0b0 0b1 0b11 0b110"
        )
    }
    
    func testCollection_BinaryString_PadToEach_NoPrefixes() {
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 0, prefixes: false),
            "0 1 11 110"
        )
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 1, prefixes: false),
            "0 1 11 110"
        )
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 2, prefixes: false),
            "00 01 11 110"
        )
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 3, prefixes: false),
            "000 001 011 110"
        )
        
        // edge cases
        
        XCTAssertEqual(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: -1, prefixes: false),
            "0 1 11 110"
        )
    }
}

#endif
