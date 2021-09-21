//
//  SysEx Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class SysExTests: XCTestCase {
	
	// MARK: - MIDI.Event.SysEx
	
	func testInit_RawBytes_Typical() {
		
        let sourceRawBytes: [MIDI.Byte] = [0xF0, 0x41, 0x01, 0x34, 0xF7]
		
		XCTAssertNoThrow(
            try MIDI.Event.sysEx(from: sourceRawBytes)
		)
		
		let event = try! MIDI.Event.sysEx(from: sourceRawBytes)
        guard case .sysEx(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.manufacturer.bytes, [0x41])
        XCTAssertEqual(innerEvent.data, [0x01, 0x34])
        XCTAssertEqual(innerEvent.group, 0)
		
		XCTAssertEqual(event.midi1RawBytes, sourceRawBytes)
        #warning("> also test umpRawBytes here")
		
	}
	
	func testInit_RawBytes_EmptyMessageBytes_WithMfr_WithEndByte() {
		
        let sourceRawBytes: [MIDI.Byte] = [0xF0, 0x41, 0xF7]
		
		XCTAssertNoThrow(
			try MIDI.Event.sysEx(from: sourceRawBytes)
		)
		
        let event = try! MIDI.Event.sysEx(from: sourceRawBytes)
        guard case .sysEx(let innerEvent) = event
        else { XCTFail() ; return }
		
        XCTAssertEqual(innerEvent.manufacturer.bytes, [0x41])
        XCTAssertEqual(innerEvent.data, [])
        XCTAssertEqual(innerEvent.group, 0)
        
		XCTAssertEqual(event.midi1RawBytes, sourceRawBytes)
        #warning("> also test umpRawBytes here")
        
	}
    
    func testInit_RawBytes_EmptyMessageBytes_WithMfr() {
        
        let sourceRawBytes: [MIDI.Byte] = [0xF0, 0x41]
        
        XCTAssertNoThrow(
            try MIDI.Event.sysEx(from: sourceRawBytes)
        )
        
        let event = try! MIDI.Event.sysEx(from: sourceRawBytes)
        guard case .sysEx(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.manufacturer.bytes, [0x41])
        XCTAssertEqual(innerEvent.data, [])
        XCTAssertEqual(innerEvent.group, 0)
        
        XCTAssertEqual(event.midi1RawBytes, [0xF0, 0x41, 0xF7])
        #warning("> also test umpRawBytes here")
        
    }
    
    func testInit_RawBytes_EmptyMessageBytes_WithEndByte() {
        
        let sourceRawBytes: [MIDI.Byte] = [0xF0, 0xF7]
        
        XCTAssertThrowsError(
            try MIDI.Event.sysEx(from: sourceRawBytes)
        )
        
    }
	
	func testInit_RawBytes_MaxSize() {
        
        // valid - maximum byte length (256 bytes)
        XCTAssertNoThrow(
            try MIDI.Event.sysEx(
                from: [0xF0, 0x41]
                    + [MIDI.Byte](repeating: 0x20, count: 256-3)
                    + [0xF7])
        )
        
        // valid - length is larger than default 256 bytes (257 bytes)
        XCTAssertNoThrow(
            try MIDI.Event.sysEx(
                from: [0xF0, 0x41]
                    + [MIDI.Byte](repeating: 0x20, count: 256-2)
                    + [0xF7])
        )
        
    }
	
	func testInit_RawBytes_Malformed() {
		
		// empty raw bytes - invalid
		XCTAssertThrowsError(
			try MIDI.Event.sysEx(from: [])
		)
		
		// start byte only - invalid
		XCTAssertThrowsError(
			try MIDI.Event.sysEx(from: [0xF0])
		)
		
		// end byte only - invalid
		XCTAssertThrowsError(
			try MIDI.Event.sysEx(from: [0xF7])
		)
		
		// start and end bytes only - invalid
		XCTAssertThrowsError(
			try MIDI.Event.sysEx(from: [0xF0, 0xF7])
		)
		
		// correct start byte, valid length, but incorrect end byte
		XCTAssertThrowsError(
			try MIDI.Event.sysEx(from: [0xF0, 0x41, 0x01, 0x34, 0xF6])
		)
		
	}
	
	func testEquatable() {
		
		// ensure instances equate correctly
		
		let event1A = try! MIDI.Event.sysEx(from: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		let event1B = try! MIDI.Event.sysEx(from: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		
		let event2 = try! MIDI.Event.sysEx(from: [0xF0, 0x41, 0x01, 0x64, 0xF7])
		
		XCTAssert(event1A == event1B)
		
		XCTAssert(event1A != event2)
		
	}
	
	func testHashable() {
		
		// ensure instances hash correctly
		
		let event1A = try! MIDI.Event.sysEx(from: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		let event1B = try! MIDI.Event.sysEx(from: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		
		let event2 = try! MIDI.Event.sysEx(from: [0xF0, 0x41, 0x01, 0x64, 0xF7])
		
		let set1: Set<MIDI.Event> = [event1A, event1B]
		
		let set2: Set<MIDI.Event> = [event1A, event2]
		
		XCTAssertEqual(set1.count, 1)
		
		XCTAssertEqual(set2.count, 2)
		
	}
	
}

#endif
