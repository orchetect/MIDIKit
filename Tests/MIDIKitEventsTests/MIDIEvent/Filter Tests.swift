//
//  Filter Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-28.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon

class FilterTests: XCTestCase {
	
	// MARK: - Filter
	
	func testFilter_Collection_MIDIEvent() {
		
		let coll: [MIDIEvent] =
		[
			.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
			.chanVoice(.cc(.modWheel(value: 80), channel: 0)),
			.sysCommon(.timecode),
			.sysRealTime(.activeSense),
			.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
			try! .raw([0xFF])
		]
		
		// empty MIDIEventKind/KindPattern array
		
		let emptyDropKinds: [MIDIEventKind] = []
		XCTAssertEqual(coll.filter(emptyDropKinds), [])
		
		let emptyDropKindPattern: [MIDIEvent.KindPattern] = []
		XCTAssertEqual(coll.filter(pattern: emptyDropKindPattern), [])
		
		// -------------------------------------------------------------------
		// MIDIEvent -> sub typed filters
		// -------------------------------------------------------------------
		
		XCTAssertEqual(coll.filterChannelVoice(),
					   [.noteOn(note: 60, velocity: 100, channel: 0),
						.cc(.modWheel(value: 80), channel: 0)])
		
		XCTAssertEqual(coll.filterSystemCommon(),
					   [.timecode])
		
		XCTAssertEqual(coll.filterRealTime(),
					   [.activeSense])
		
		XCTAssertEqual(coll.filterSystemExclusive(),
					   [.sysEx(manufacturer: 0x41, message: [0x20, 0x42])])
		
		// -------------------------------------------------------------------
		// [MIDIEvent].filter(_ kinds: [Element.Kind]) -> [Element]
		// -------------------------------------------------------------------
		
		XCTAssertEqual(coll.filter([.chanVoice]),
					   [.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.chanVoice(.cc(.modWheel(value: 80), channel: 0))])
		
		XCTAssertEqual(coll.filter([.sysCommon]),
					   [.sysCommon(.timecode)])
		
		XCTAssertEqual(coll.filter([.sysRealTime]),
					   [.sysRealTime(.activeSense)])
		
		XCTAssertEqual(coll.filter([.sysEx]),
					   [.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42])])
		
		XCTAssertEqual(coll.filter([.raw]),
					   [try! .raw([0xFF])])
		
		// -------------------------------------------------------------------
		// [MIDIEvent].filter(pattern: [MIDIEvent.KindPattern]) -> [MIDIEvent]
		// -------------------------------------------------------------------
		
		// ---- wildcard matching (empty sub-pattern arrays) ----
		
		// all chanVoice
		XCTAssertEqual(coll.filter(pattern: [.chanVoice(nil)]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.chanVoice(.cc(.modWheel(value: 80), channel: 0))
					   ])
		
		// all sysCommon
		XCTAssertEqual(coll.filter(pattern: [.sysCommon(nil)]),
					   [.sysCommon(.timecode)])
		
		// all sysRealTime
		XCTAssertEqual(coll.filter(pattern: [.sysRealTime(nil)]),
					   [.sysRealTime(.activeSense)])
		
		// all sysExclusive
		XCTAssertEqual(coll.filter(pattern: [.sysExclusive(nil)]),
					   [.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42])])
		
		// all raw
		XCTAssertEqual(coll.filter(pattern: [.raw]),
					   [try! .raw([0xFF])])
		
		// ---- single sub-types ----
		
		// just chanVoice/noteOn events
		XCTAssertEqual(coll.filter(pattern: [.chanVoice([.noteOn])]),
					   [.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0))])
		
		// just chanVoice/CC events
		XCTAssertEqual(coll.filter(pattern: [.chanVoice([.controllerChange()])]),
					   [.chanVoice(.cc(.modWheel(value: 80), channel: 0))])
		
		// just chanVoice/programChange events
		XCTAssertEqual(coll.filter(pattern: [.chanVoice([.programChange])]),
					   [])
		
		// just sysCommon/timecode events
		XCTAssertEqual(coll.filter(pattern: [.sysCommon([.timecode])]),
					   [.sysCommon(.timecode)])
		
		// just sysCommon/tuneRequest events
		XCTAssertEqual(coll.filter(pattern: [.sysCommon([.tuneRequest])]),
					   [])
		
		// just sysRealTime/activeSense events
		XCTAssertEqual(coll.filter(pattern: [.sysRealTime([.activeSense])]),
					   [.sysRealTime(.activeSense)])
		
		// just sysRealTime/start events
		XCTAssertEqual(coll.filter(pattern: [.sysRealTime([.start])]),
					   [])
		
		// just sysEx events
		XCTAssertEqual(coll.filter(pattern: [.sysExclusive([.systemExclusive])]),
					   [.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42])])
		
		// ---- single top-level type, multiple sub-types ----
		
		// chanVoice/noteOn and chanVoice/cc events
		XCTAssertEqual(coll.filter(pattern: [.chanVoice([.noteOn, .controllerChange()])]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.chanVoice(.cc(.modWheel(value: 80), channel: 0))
					   ])
		
		// sysCommon/timecode and sysCommon/tuneRequest events
		XCTAssertEqual(coll.filter(pattern: [.sysCommon([.timecode, .tuneRequest]) ]),
					   [.sysCommon(.timecode)])
		
		// sysRealTime/activeSense and sysRealTime/start events
		XCTAssertEqual(coll.filter(pattern: [.sysRealTime([.activeSense, .start]) ]),
					   [.sysRealTime(.activeSense)])
		
		// sysEx does not have multiple sub-types to test here
		
		// raw does not have multiple sub-types to test here
		
		// ---- multiple top-level types, multiple sub-types ----
		
		XCTAssertEqual(coll.filter(pattern: [.chanVoice([.noteOn]),
											 .sysCommon([.timecode])]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.sysCommon(.timecode)
					   ])
		
	}
	
	func testFilter_Collection_MIDIEvent_ChannelVoiceMessage() {
		
		let baseColl: [MIDIEvent] =
		[
			.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
			.chanVoice(.cc(.modWheel(value: 80), channel: 0)),
			.sysCommon(.timecode),
			.sysRealTime(.activeSense),
			.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
			try! .raw([0xFF])
		]
		
		let coll: [MIDIEvent.ChannelVoiceMessage] = baseColl.filterChannelVoice()
		
		// empty Kind array
		
		let emptyDropKinds: [MIDIEvent.ChannelVoiceMessage.Kind] = []
		XCTAssertEqual(coll.filter(emptyDropKinds), [])
		
		// ----------------------------------------------------------------------------
		// [MIDIEvent.ChannelVoiceMessage].filter(_ kinds: [Element.Kind]) -> [Element]
		// ----------------------------------------------------------------------------
		
		// just noteOn events
		XCTAssertEqual(coll.filter([.noteOn]),
					   [.noteOn(note: 60, velocity: 100, channel: 0)])
		
		// just cc events
		XCTAssertEqual(coll.filter([.controllerChange]),
					   [.cc(.modWheel(value: 80), channel: 0)])
		
		// both noteOn and cc events
		XCTAssertEqual(coll.filter([.noteOn, .controllerChange]),
					   [.noteOn(note: 60, velocity: 100, channel: 0),
						.cc(.modWheel(value: 80), channel: 0)])
		
		// just programChange events
		XCTAssertEqual(coll.filter([.programChange]),
					   [])
		
	}
	
	// MARK: - Drop
	
	func testDrop_Collection_MIDIEvent() {
		
		let coll: [MIDIEvent] =
		[
			.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
			.chanVoice(.cc(.modWheel(value: 80), channel: 0)),
			.sysCommon(.timecode),
			.sysRealTime(.activeSense),
			.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
			try! .raw([0xFF])
		]
		
		// empty MIDIEventKind/KindPattern array
		
		let emptyDropKinds: [MIDIEventKind] = []
		XCTAssertEqual(coll.drop(emptyDropKinds), coll)
		
		let emptyDropKindPattern: [MIDIEvent.KindPattern] = []
		XCTAssertEqual(coll.drop(pattern: emptyDropKindPattern), coll)
		
		// -------------------------------------------------------------------
		// [MIDIEvent].drop(_ kinds: [Element.Kind]) -> [Element]
		// -------------------------------------------------------------------
		
		XCTAssertEqual(coll.drop([.chanVoice]),
					   [
						.sysCommon(.timecode),
						.sysRealTime(.activeSense),
						.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
						try! .raw([0xFF])
					   ])
		
		XCTAssertEqual(coll.drop(pattern: [.chanVoice([.controllerChange()])]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.sysCommon(.timecode),
						.sysRealTime(.activeSense),
						.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
						try! .raw([0xFF])
					   ])
		
		XCTAssertEqual(coll.drop([.sysCommon]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.chanVoice(.cc(.modWheel(value: 80), channel: 0)),
						.sysRealTime(.activeSense),
						.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
						try! .raw([0xFF])
					   ])
		
		XCTAssertEqual(coll.drop([.sysRealTime]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.chanVoice(.cc(.modWheel(value: 80), channel: 0)),
						.sysCommon(.timecode),
						.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
						try! .raw([0xFF])
					   ])
		
		XCTAssertEqual(coll.drop([.sysEx]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.chanVoice(.cc(.modWheel(value: 80), channel: 0)),
						.sysCommon(.timecode),
						.sysRealTime(.activeSense),
						try! .raw([0xFF])
					   ])
		
		XCTAssertEqual(coll.drop([.raw]),
					   [
						.chanVoice(.noteOn(note: 60, velocity: 100, channel: 0)),
						.chanVoice(.cc(.modWheel(value: 80), channel: 0)),
						.sysCommon(.timecode),
						.sysRealTime(.activeSense),
						.sysExclusive(manufacturer: 0x41, message: [0x20, 0x42]),
					   ])
		
	}

}

#endif
