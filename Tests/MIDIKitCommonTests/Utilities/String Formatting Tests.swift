//
//  String Formatting Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCommon

final class StringFormatting_Tests: XCTestCase {
    func testHexString_Prefix() {
        XCTAssertEqual(0x0.hexString(prefix: true),   "0x0")
        XCTAssertEqual(0x9.hexString(prefix: true),   "0x9")
        XCTAssertEqual(0xA.hexString(prefix: true),   "0xA")
        XCTAssertEqual(0x10.hexString(prefix: true),  "0x10")
        XCTAssertEqual(0xFF.hexString(prefix: true),  "0xFF")
        XCTAssertEqual(0xFFF.hexString(prefix: true), "0xFFF")
    }
    
    func testHexString_NoPrefix() {
        XCTAssertEqual(0x0.hexString(prefix: false),   "0")
        XCTAssertEqual(0x9.hexString(prefix: false),   "9")
        XCTAssertEqual(0xA.hexString(prefix: false),   "A")
        XCTAssertEqual(0x10.hexString(prefix: false),  "10")
        XCTAssertEqual(0xFF.hexString(prefix: false),  "FF")
        XCTAssertEqual(0xFFF.hexString(prefix: false), "FFF")
    }
}

#endif
