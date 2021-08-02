//
//  Manufacturer Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class SystemExclusive_ManufacturerTests: XCTestCase {
	
	func testInitOneByte() {
		
		// valid conditions
		
		// min/max valid
		XCTAssertNotNil(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x01)
		)
		XCTAssertNotNil(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x7D)
		)
		
		// invalid conditions
		
		// 0x00 is reserved as first byte of 3-byte IDs
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x00)
		)
		
		// 0x7E and 0x7F are reserved for universal sys ex
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x7E)
		)
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x7F)
		)
		
		// > 0x7F is illegal
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x80)
		)
		// > 0x7F is illegal
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0xFF)
		)
		
	}
	
	func testInitThreeByte() {
		
		// valid conditions
		
		// min/max valid
		XCTAssertNotNil(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x00, 0x00))
		)
		XCTAssertNotNil(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x7F, 0x7F))
		)
		
		// invalid conditions
		
		// > 0x7F is illegal
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x00, 0x80))
		)
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x80, 0x00))
		)
		XCTAssertNil(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x80, 0x80))
		)
		
	}
	
	func testName() {
		
		// spot-check: manufacturer name lookup
		// test first and last manufacturer in each section
		
		// single byte ID
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x01)?.name,
			"Sequential Circuits"
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x3F)?.name,
			"Quasimidi"
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x40)?.name,
			"Kawai Musical Instruments MFG. CO. Ltd"
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(oneByte: 0x5F)?.name,
			"SD Card Association"
		)
		
		// 3-byte ID
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x00, 0x58))?.name,
			"Atari Corporation"
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x00, 0x58))?.name,
			"Atari Corporation"
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x02, 0x3B))?.name,
			"Sonoclast, LLC"
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x20, 0x00))?.name,
			"Dream SAS"
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x21, 0x59))?.name,
			"Robkoo Information & Technologies Co., Ltd."
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x40, 0x00))?.name,
			"Crimson Technology Inc."
		)
		
		XCTAssertEqual(
			MIDI.Event.SysEx.Manufacturer(threeByte: (0x40, 0x07))?.name,
			"Slik Corporation"
		)
		
	}

}

#endif
