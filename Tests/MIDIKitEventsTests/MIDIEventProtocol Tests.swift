//
//  MIDIEventProtocol Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-22.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon

class MIDIEventProtocolTests: XCTestCase {
	
	func testMIDIEventMessage_constructEvent() {
		
		XCTAssertEqual(
			MIDIEvent.ChannelVoiceMessage
				.noteOn(note: 5, velocity: 5, channel: 5)
				.asEvent(),
			
			MIDIEvent(.noteOn(note: 5, velocity: 5, channel: 5))
		)
		
		XCTAssertEqual(
			MIDIEvent.SystemCommon
				.timecode
				.asEvent(),
			
			MIDIEvent(.timecode)
		)
		
		XCTAssertEqual(
			MIDIEvent.SystemRealTime
				.activeSense
				.asEvent(),
			
			MIDIEvent(.activeSense)
		)
		
		XCTAssertEqual(
			MIDIEvent.SystemExclusive
				.sysEx(manufacturer: 0x41,
					   message: [0x01, 0x34]) //[0xF0, 0x41, 0x01, 0x34, 0xF7]
				.asEvent(),
			
			MIDIEvent(.sysEx(manufacturer: 0x41, message: [0x01, 0x34]))
		)
		
	}
	
}

#endif
