//
//  SysExManufacturer Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class SysExManufacturer_Tests: XCTestCase {
    func testOneByte() {
        // valid conditions
        
        // min/max valid
        XCTAssertTrue(
            MIDIEvent.SysExManufacturer.oneByte(0x01).isValid
        )
        XCTAssertTrue(
            MIDIEvent.SysExManufacturer.oneByte(0x7D).isValid
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        XCTAssertFalse(
            MIDIEvent.SysExManufacturer.oneByte(0x00).isValid
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        XCTAssertFalse(
            MIDIEvent.SysExManufacturer.oneByte(0x7E).isValid
        )
        XCTAssertFalse(
            MIDIEvent.SysExManufacturer.oneByte(0x7F).isValid
        )
    }
    
    func testThreeByte() {
        // valid conditions
        
        // min/max valid
        XCTAssertFalse(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x00).isValid
        )
        XCTAssertTrue(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x01, byte3: 0x00).isValid
        )
        XCTAssertTrue(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x01).isValid
        )
        XCTAssertTrue(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x7F, byte3: 0x7F).isValid
        )
    }
    
    func testName() {
        // spot-check: manufacturer name lookup
        // test first and last manufacturer in each section
        
        // single byte ID
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.oneByte(0x01).name,
            "Sequential Circuits"
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.oneByte(0x3F).name,
            "Quasimidi"
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.oneByte(0x40).name,
            "Kawai Musical Instruments MFG. CO. Ltd"
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.oneByte(0x5F).name,
            "SD Card Association"
        )
        
        // 3-byte ID
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x58).name,
            "Atari Corporation"
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x58).name,
            "Atari Corporation"
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x02, byte3: 0x3B).name,
            "Sonoclast, LLC"
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x20, byte3: 0x00).name,
            "Dream SAS"
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x21, byte3: 0x59).name,
            "Robkoo Information & Technologies Co., Ltd."
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x40, byte3: 0x00).name,
            "Crimson Technology Inc."
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x40, byte3: 0x07).name,
            "Slik Corporation"
        )
    }
}

#endif
