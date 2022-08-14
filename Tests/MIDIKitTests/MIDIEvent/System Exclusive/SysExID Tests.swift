//
//  SysExID Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class SysExID_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    
    func testInit_SysEx7_OneByte() {
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x01]),
            .manufacturer(.oneByte(0x01))
        )
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x7D]),
            .manufacturer(.oneByte(0x7D))
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00])
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x7E]),
            .universal(.nonRealTime)
        )
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x7F]),
            .universal(.realTime)
        )
        
        // > 0x7F is illegal
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x80])
        )
        // > 0x7F is illegal
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx7RawBytes: [0xFF])
        )
    }
    
    func testInit_SysEx7_ThreeByte() {
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x00, 0x00]),
            .manufacturer(.threeByte(byte2: 0x00, byte3: 0x00))
        )
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x7F, 0x7F]),
            .manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
        )
        
        // invalid conditions
        
        // > 0x7F is illegal
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x00, 0x80])
        )
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x80, 0x00])
        )
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x80, 0x80])
        )
    }
    
    func testInit_SysEx8_OneByte() {
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x01]),
            .manufacturer(.oneByte(0x01))
        )
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x7D]),
            .manufacturer(.oneByte(0x7D))
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x00])
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x7E]),
            .universal(.nonRealTime)
        )
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x7F]),
            .universal(.realTime)
        )
        
        // > 0x7F is illegal
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x80])
        )
        // > 0x7F is illegal
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0xFF])
        )
    }
    
    func testInit_SysEx8_ThreeByte() {
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x80, 0x00]),
            .manufacturer(.threeByte(byte2: 0x00, byte3: 0x00))
        )
        XCTAssertEqual(
            MIDIEvent.SysExID(sysEx8RawBytes: [0xFF, 0x7F]),
            .manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
        )
        
        // invalid conditions
        
        // > 0x7F is illegal in byte 2
        XCTAssertNil(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x80, 0x80])
        )
    }
    
    func testManufacturer_sysEx7RawBytes() {
        XCTAssertEqual(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x01)).sysEx7RawBytes(),
            [0x01]
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x7D)).sysEx7RawBytes(),
            [0x7D]
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExID.manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
                .sysEx7RawBytes(),
            [0x00, 0x7F, 0x7F]
        )
    }
    
    func testManufacturer_sysEx8RawBytes() {
        XCTAssertEqual(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x01)).sysEx8RawBytes(),
            [0x00, 0x01]
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x7D)).sysEx8RawBytes(),
            [0x00, 0x7D]
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExID.manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
                .sysEx8RawBytes(),
            [0xFF, 0x7F]
        )
    }
    
    func testUniversal_sysEx7RawBytes() {
        XCTAssertEqual(
            MIDIEvent.SysExID.universal(.nonRealTime).sysEx7RawBytes(),
            [0x7E]
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExID.universal(.realTime).sysEx7RawBytes(),
            [0x7F]
        )
    }
    
    func testUniversal_sysEx8RawBytes() {
        XCTAssertEqual(
            MIDIEvent.SysExID.universal(.nonRealTime).sysEx8RawBytes(),
            [0x00, 0x7E]
        )
        
        XCTAssertEqual(
            MIDIEvent.SysExID.universal(.realTime).sysEx8RawBytes(),
            [0x00, 0x7F]
        )
    }
}

#endif
