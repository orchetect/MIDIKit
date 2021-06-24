//
//  MIDIPacket PacketIterator Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon
import CoreMIDI
import SwiftRadix

extension MIDIKitEventsTests {
	
	override func setUp() { }
	override func tearDown() { }
	
//	func testMIDIPacket_PacketIterator() {
//
//		// Single MIDIPacket containing one MIDI events
//
//		var packet = kMIDIPacket.NoteOn60Vel65Chan1
//		var events = Array(packet)
//
//		XCTAssertEqual(events.count, 1)
//		XCTAssertEqual(events[0].timeStamp, 123456789)
//		XCTAssertEqual(events[0].event, MIDI.IO.Event(rawData:[0x90, 0x3C, 0x41]))
//
//		// Single MIDIPacket containing two MIDI events
//
//		packet = kMIDIPacket.NoteOn60Vel65Chan1_CC12Val105Chan1
//		events = Array(packet)
//
//		XCTAssertEqual(events.count, 2)
//		XCTAssertEqual(events[0].timeStamp, 987654321)
//		XCTAssertEqual(events[0].event, MIDI.IO.Event(rawData:[0x90, 0x3C, 0x41]))
//		XCTAssertEqual(events[1].timeStamp, 987654321)
//		XCTAssertEqual(events[1].event, MIDI.IO.Event(rawData:[0xB0, 0x08, 0x69]))
//
//	}
	
//	func testMIDIPacket_PacketIterator_EdgeCases() {
//	
//	// malformed: 256 x 0x00, with length of 256
//	
//		let packet = kMIDIPacket.emptyBytes256Length
//		let events = Array(packet)
//		
//		#warning("this should return one event, as an unknown event type, with the raw data encapsulated")
//		
//		XCTAssertEqual(events.count, 0)
//		
//		
//		
//	}
	
}

//print(events.map { $0.rawBytes.hex.stringValue(padTo: 2, prefix: true) })

#endif
