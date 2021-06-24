//
//  KindPattern Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon

class KindPatternTests: XCTestCase {
	
	// MARK: - Collection filterChannelVoiceAndConsolidate
	
	func testFilterChannelVoice_Nil() {
		
		let coll: [MIDI.Event.KindPattern] =
		[
			.chanVoice(nil),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
		let collFiltered = coll.filterChannelVoiceAndConsolidate()
		
		// assert it's the expected return type
		let expectedType: [MIDI.Event.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, MIDI.Event.ChannelVoiceMessage.KindPattern.allCases)
		
	}
	
	func testFilterChannelVoice_Empty() {
		
		let coll: [MIDI.Event.KindPattern] =
		[
			.chanVoice([]),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
		let collFiltered = coll.filterChannelVoiceAndConsolidate()
		
		// assert it's the expected return type
		let expectedType: [MIDI.Event.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, [])
		
	}
	
	func testFilterChannelVoice_SingleEntry() {
		
		let coll: [MIDI.Event.KindPattern] =
		[
			.chanVoice([.noteOn]),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
		let collFiltered = coll.filterChannelVoiceAndConsolidate()
		
		// assert it's the expected return type
		let expectedType: [MIDI.Event.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, [.noteOn])
		
	}
	
	func testFilterChannelVoice_MultipleEntries() {
		
		let coll: [MIDI.Event.KindPattern] =
		[
			.chanVoice([.noteOn, .noteOff, .controllerChange(nil)]),
			.chanVoice([.pitchBend]),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
		let collFiltered = coll.filterChannelVoiceAndConsolidate()
		
		// assert it's the expected return type
		let expectedType: [MIDI.Event.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, [.noteOn, .noteOff, .controllerChange(nil), .pitchBend])
		
	}
	
	// MIDI.Event.KindPattern .filterChannelVoice()
	
	func testMIDIEvent_KindPattern_filterChannelVoice() {
		
		if let _ = MIDI.Event.KindPattern.chanVoice(nil)
			.filterChannelVoice() {
			// Optional(nil)
			// Have to test with `if let ...` and not XCTAssertEqual because it will equate to nil, not Optional(nil)
		} else { XCTFail() }
		
		XCTAssertEqual(MIDI.Event.KindPattern.chanVoice([])
						.filterChannelVoice(),
					   Optional([]))
		
		XCTAssertEqual(MIDI.Event.KindPattern.chanVoice([.noteOn])
						.filterChannelVoice(),
					   Optional([.noteOn]))
		
		if let _ = MIDI.Event.KindPattern.sysCommon(nil)
			.filterChannelVoice() {
			XCTFail()
		}
		
	}

}

#endif
