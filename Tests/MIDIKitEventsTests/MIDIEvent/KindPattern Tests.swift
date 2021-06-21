//
//  KindPattern Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-28.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon

class KindPatternTests: XCTestCase {
	
	// MARK: - Collection filterChannelVoiceAndConsolidate
	
	func testFilterChannelVoice_Nil() {
		
		let coll: [MIDIEvent.KindPattern] =
		[
			.chanVoice(nil),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
		let collFiltered = coll.filterChannelVoiceAndConsolidate()
		
		// assert it's the expected return type
		let expectedType: [MIDIEvent.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, MIDIEvent.ChannelVoiceMessage.KindPattern.allCases)
		
	}
	
	func testFilterChannelVoice_Empty() {
		
		let coll: [MIDIEvent.KindPattern] =
		[
			.chanVoice([]),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
		let collFiltered = coll.filterChannelVoiceAndConsolidate()
		
		// assert it's the expected return type
		let expectedType: [MIDIEvent.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, [])
		
	}
	
	func testFilterChannelVoice_SingleEntry() {
		
		let coll: [MIDIEvent.KindPattern] =
		[
			.chanVoice([.noteOn]),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
		let collFiltered = coll.filterChannelVoiceAndConsolidate()
		
		// assert it's the expected return type
		let expectedType: [MIDIEvent.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, [.noteOn])
		
	}
	
	func testFilterChannelVoice_MultipleEntries() {
		
		let coll: [MIDIEvent.KindPattern] =
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
		let expectedType: [MIDIEvent.ChannelVoiceMessage.KindPattern]? = nil
		XCTAssert(type(of: collFiltered) == type(of: expectedType))
		
		// assert result contents
		XCTAssertEqual(collFiltered, [.noteOn, .noteOff, .controllerChange(nil), .pitchBend])
		
	}
	
	// MIDIEvent.KindPattern .filterChannelVoice()
	
	func testMIDIEvent_KindPattern_filterChannelVoice() {
		
		if let _ = MIDIEvent.KindPattern.chanVoice(nil)
			.filterChannelVoice() {
			// Optional(nil)
			// Have to test with `if let ...` and not XCTAssertEqual because it will equate to nil, not Optional(nil)
		} else { XCTFail() }
		
		XCTAssertEqual(MIDIEvent.KindPattern.chanVoice([])
						.filterChannelVoice(),
					   Optional([]))
		
		XCTAssertEqual(MIDIEvent.KindPattern.chanVoice([.noteOn])
						.filterChannelVoice(),
					   Optional([.noteOn]))
		
		if let _ = MIDIEvent.KindPattern.sysCommon(nil)
			.filterChannelVoice() {
			XCTFail()
		}
		
	}

}

#endif
