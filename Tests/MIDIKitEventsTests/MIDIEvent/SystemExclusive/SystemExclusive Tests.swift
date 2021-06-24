//
//  SystemExclusive Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon

class SystemExclusiveTests: XCTestCase {
	
	// MARK: - MIDI.Event.SystemExclusive
	
	func testInit_RawBytes_Typical() {
		
		let sourceRawBytes: [Byte] = [0xF0, 0x41, 0x01, 0x34, 0xF7]
		
		XCTAssertNoThrow(
			try MIDI.Event.SystemExclusive(rawBytes: sourceRawBytes)
		)
		
		let event = try! MIDI.Event.SystemExclusive(rawBytes: sourceRawBytes)
		
		XCTAssertEqual(event.manufacturer, 0x41)
		XCTAssertEqual(event.messageBytes, [0x01, 0x34])
		
		XCTAssertEqual(event.rawBytes, sourceRawBytes)
		
	}
	
	func testInit_RawBytes_EmptyMessageBytes() {
		
		let sourceRawBytes: [Byte] = [0xF0, 0x41, 0xF7]
		
		XCTAssertNoThrow(
			try MIDI.Event.SystemExclusive(rawBytes: sourceRawBytes)
		)
		
		let event = try! MIDI.Event.SystemExclusive(rawBytes: sourceRawBytes)
		
		XCTAssertEqual(event.manufacturer, 0x41)
		XCTAssertEqual(event.messageBytes, [])
		
		XCTAssertEqual(event.rawBytes, sourceRawBytes)
		
	}
	
	func testInit_RawBytes_MaxSize() {
		
		// valid - maximum byte length (256 bytes)
		XCTAssertNoThrow(
			try MIDI.Event.SystemExclusive(rawBytes:
											[0xF0, 0x41]
											+ [Byte](repeating: 0x20, count: 256-3)
											+ [0xF7])
		)
		
		// valid - length is larger than default 256 bytes (257 bytes)
		XCTAssertNoThrow(
			try MIDI.Event.SystemExclusive(rawBytes:
											[0xF0, 0x41]
											+ [Byte](repeating: 0x20, count: 256-2)
											+ [0xF7])
		)
		
	}
	
	func testInit_RawBytes_Malformed() {
		
		// empty raw bytes - invalid
		XCTAssertThrowsError(
			try MIDI.Event.SystemExclusive(rawBytes: [])
		)
		
		// start byte only - invalid
		XCTAssertThrowsError(
			try MIDI.Event.SystemExclusive(rawBytes: [0xF0])
		)
		
		// end byte only - invalid
		XCTAssertThrowsError(
			try MIDI.Event.SystemExclusive(rawBytes: [0xF7])
		)
		
		// start and end bytes only - invalid
		XCTAssertThrowsError(
			try MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0xF7])
		)
		
		// correct start byte, valid length, but incorrect end byte
		XCTAssertThrowsError(
			try MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF6])
		)
		
	}
	
	func testEquatable() {
		
		// ensure instances equate correctly
		
		let event1A = try! MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		let event1B = try! MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		
		let event2 = try! MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x64, 0xF7])
		
		XCTAssert(event1A == event1B)
		
		XCTAssert(event1A != event2)
		
	}
	
	func testHashable() {
		
		// ensure instances hash correctly
		
		let event1A = try! MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		let event1B = try! MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		
		let event2 = try! MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x64, 0xF7])
		
		let set1: Set<MIDI.Event.SystemExclusive> = [event1A, event1B]
		
		let set2: Set<MIDI.Event.SystemExclusive> = [event1A, event2]
		
		XCTAssertEqual(set1.count, 1)
		
		XCTAssertEqual(set2.count, 2)
		
	}
	
	// MARK: - Kind
	
	func testKind() {
		
		let event = try! MIDI.Event.SystemExclusive(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		
		// .kind
		
		XCTAssertEqual(event.kind, .systemExclusive)
		
	}
	
	// MARK: - Attributes
	
	// don't need to test attributes, they are already tested in the rawBytes tests above
	
}

#endif
