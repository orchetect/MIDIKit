//
//  SysExID Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class SysExIDTests: XCTestCase {
    
    func testInit_SysEx7_OneByte() {
        
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x01]),
            .manufacturer(.oneByte(0x01))
        )
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x7D]),
            .manufacturer(.oneByte(0x7D))
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x00])
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x7E]),
            .universal(.nonRealTime)
        )
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x7F]),
            .universal(.realTime)
        )
        
        // > 0x7F is illegal
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x80])
        )
        // > 0x7F is illegal
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx7RawBytes: [0xFF])
        )
        
    }
    
    func testInit_SysEx7_ThreeByte() {
        
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x00, 0x00, 0x00]),
            .manufacturer(.threeByte(byte2: 0x00, byte3: 0x00))
        )
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x00, 0x7F, 0x7F]),
            .manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
        )
        
        // invalid conditions
        
        // > 0x7F is illegal
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x00, 0x00, 0x80])
        )
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x00, 0x80, 0x00])
        )
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx7RawBytes: [0x00, 0x80, 0x80])
        )
        
    }
    
    func testInit_SysEx8_OneByte() {
        
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x00, 0x01]),
            .manufacturer(.oneByte(0x01))
        )
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x00, 0x7D]),
            .manufacturer(.oneByte(0x7D))
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x00, 0x00])
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x00, 0x7E]),
            .universal(.nonRealTime)
        )
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x00, 0x7F]),
            .universal(.realTime)
        )
        
        // > 0x7F is illegal
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x00, 0x80])
        )
        // > 0x7F is illegal
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x00, 0xFF])
        )
        
    }
    
    func testInit_SysEx8_ThreeByte() {
        
        // valid conditions
        
        // min/max valid
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x80, 0x00]),
            .manufacturer(.threeByte(byte2: 0x00, byte3: 0x00))
        )
        XCTAssertEqual(
            MIDI.Event.SysExID(sysEx8RawBytes: [0xFF, 0x7F]),
            .manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
        )
        
        // invalid conditions
        
        // > 0x7F is illegal in byte 2
        XCTAssertNil(
            MIDI.Event.SysExID(sysEx8RawBytes: [0x80, 0x80])
        )
        
    }
    
}

#endif
