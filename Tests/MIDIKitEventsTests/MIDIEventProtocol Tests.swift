//
//  MIDIEventProtocol Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon

class MIDIEventProtocolTests: XCTestCase {
	
	func testMIDIEventMessage_constructEvent() {
		
		XCTAssertEqual(
			MIDI.Event.ChannelVoiceMessage
				.noteOn(note: 5, velocity: 5, channel: 5)
				.asEvent(),
			
			MIDI.Event(.noteOn(note: 5, velocity: 5, channel: 5))
		)
		
		XCTAssertEqual(
			MIDI.Event.SystemCommon
				.timecode
				.asEvent(),
			
			MIDI.Event(.timecode)
		)
		
		XCTAssertEqual(
			MIDI.Event.SystemRealTime
				.activeSense
				.asEvent(),
			
			MIDI.Event(.activeSense)
		)
		
		XCTAssertEqual(
			MIDI.Event.SystemExclusive
				.sysEx(manufacturer: 0x41,
					   message: [0x01, 0x34]) //[0xF0, 0x41, 0x01, 0x34, 0xF7]
				.asEvent(),
			
			MIDI.Event(.sysEx(manufacturer: 0x41, message: [0x01, 0x34]))
		)
		
	}
	
}

#endif
