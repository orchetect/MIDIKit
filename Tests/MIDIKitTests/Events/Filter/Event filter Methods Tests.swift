//
//  Event filter Methods Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilterMethodsTests: XCTestCase {
    
    // MARK: - Filter
    
    func testFilter_Collection_MIDIEvent() {
        
        #warning("> finish this test")
        
        let coll: [MIDI.Event] =
            [
                .noteOn(note: 60, velocity: 100, channel: 0),
                .cc(controller: .modWheel, value: 80, channel: 0),
                .timecodeQuarterFrame(byte: 0x00),
                .activeSensing,
                .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]))
            ]
        
        // -------------------------------------------------------------------
        // MIDI.Event -> sub typed filters
        // -------------------------------------------------------------------
        
        XCTAssertEqual(coll.filterChannelVoice(),
                       [.noteOn(note: 60, velocity: 100, channel: 0),
                        .cc(controller: .modWheel, value: 80, channel: 0)])
        
        XCTAssertEqual(coll.filterSystemCommon(),
                       [.timecodeQuarterFrame(byte: 0x00)])
        
        XCTAssertEqual(coll.filterSystemRealTime(),
                       [.activeSensing])
        
        XCTAssertEqual(coll.filterSystemExclusive(),
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42])])
        
        // -------------------------------------------------------------------
        // [MIDI.Event].filter(_ kinds: [Element.Kind]) -> [Element]
        // -------------------------------------------------------------------
        
        XCTAssertEqual(coll.filter([.chanVoice]),
                       [.noteOn(note: 60, velocity: 100, channel: 0),
                        .cc(controller: .modWheel, value: 80, channel: 0)])
        
        XCTAssertEqual(coll.filter([.sysCommon]),
                       [.timecodeQuarterFrame(byte: 0x00)])
        
        XCTAssertEqual(coll.filter([.sysRealTime]),
                       [.activeSensing])
        
        XCTAssertEqual(coll.filter([.sysEx]),
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42])])
        
        // -------------------------------------------------------------------
        // [MIDI.Event].filter(pattern: [MIDI.Event.KindPattern]) -> [MIDI.Event]
        // -------------------------------------------------------------------
        
        // ---- wildcard matching (empty sub-pattern arrays) ----
        
        // all chanVoice
        XCTAssertEqual(coll.filter(pattern: [.chanVoice(nil)]),
                       [
                        .noteOn(note: 60, velocity: 100, channel: 0),
                        .cc(controller: .modWheel, value: 80, channel: 0)
                       ])
        
        // all sysCommon
        XCTAssertEqual(coll.filter(pattern: [.sysCommon(nil)]),
                       [.timecodeQuarterFrame(byte: 0x00)])
        
        // all sysRealTime
        XCTAssertEqual(coll.filter(pattern: [.sysRealTime(nil)]),
                       [.activeSensing])
        
        // all sysEx
        XCTAssertEqual(coll.filter(pattern: [.sysEx(nil)]),
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42])])
        
        // ---- single sub-types ----
        
        // just chanVoice/noteOn events
        XCTAssertEqual(coll.filter(pattern: [.chanVoice([.noteOn])]),
                       [.noteOn(note: 60, velocity: 100, channel: 0)])
        
        // just chanVoice/CC events
        XCTAssertEqual(coll.filter(pattern: [.chanVoice([.controllerChange()])]),
                       [.cc(controller: .modWheel, value: 80, channel: 0)])
        
        // just chanVoice/programChange events
        XCTAssertEqual(coll.filter(pattern: [.chanVoice([.programChange])]),
                       [])
        
        // just sysCommon/timecode events
        XCTAssertEqual(coll.filter(pattern: [.sysCommon([.timecodeQuarterFrame])]),
                       [.timecodeQuarterFrame(byte: 0x00)])
        
        // just sysCommon/tuneRequest events
        XCTAssertEqual(coll.filter(pattern: [.sysCommon([.tuneRequest])]),
                       [])
        
        // just sysRealTime/activeSense events
        XCTAssertEqual(coll.filter(pattern: [.sysRealTime([.activeSensing])]),
                       [.activeSensing])
        
        // just sysRealTime/start events
        XCTAssertEqual(coll.filter(pattern: [.sysRealTime([.start])]),
                       [])
        
        // just sysEx events
        XCTAssertEqual(coll.filter(pattern: [.sysEx([.sysEx])]),
                       [.sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42])])
        
        // ---- single top-level type, multiple sub-types ----
        
        // chanVoice/noteOn and chanVoice/cc events
        XCTAssertEqual(coll.filter(pattern: [.chanVoice([.noteOn, .controllerChange()])]),
                       [
                        .noteOn(note: 60, velocity: 100, channel: 0),
                        .cc(controller: .modWheel, value: 80, channel: 0)
                       ])
        
        // sysCommon/timecode and sysCommon/tuneRequest events
        XCTAssertEqual(coll.filter(pattern: [.sysCommon([.timecodeQuarterFrame, .tuneRequest]) ]),
                       [.timecodeQuarterFrame(byte: 0x00)])
        
        // sysRealTime/activeSense and sysRealTime/start events
        XCTAssertEqual(coll.filter(pattern: [.sysRealTime([.activeSensing, .start]) ]),
                       [.activeSensing])
        
        // sysEx does not have multiple sub-types to test here
        
        // raw does not have multiple sub-types to test here
        
        // ---- multiple top-level types, multiple sub-types ----
        
        XCTAssertEqual(coll.filter(pattern: [.chanVoice([.noteOn]),
                                             .sysCommon([.timecodeQuarterFrame])]),
                       [
                        .noteOn(note: 60, velocity: 100, channel: 0),
                        .timecodeQuarterFrame(byte: 0x00)
                       ])
        
    }
    
//    func testFilter_Collection_MIDIEvent_ChannelVoiceMessage() {
//
//        let baseColl: [MIDI.Event] =
//            [
//                .noteOn(note: 60, velocity: 100, channel: 0),
//                .cc(controller: .modWheel, value: 80, channel: 0),
//                .timecodeQuarterFrame(byte: 0x00),
//                .activeSensing,
//                .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]))
//            ]
//
//        let coll: [MIDI.Event.ChanVoice] = baseColl.filterChannelVoice()
//
//        // empty Kind array
//
//        let emptyDropKinds: [MIDI.Event.ChanVoice.Kind] = []
//        XCTAssertEqual(coll.filter(emptyDropKinds), [])
//
//        // ----------------------------------------------------------------------------
//        // [MIDI.Event.ChanVoice].filter(_ kinds: [Element.Kind]) -> [Element]
//        // ----------------------------------------------------------------------------
//
//        // just noteOn events
//        XCTAssertEqual(coll.filter([.noteOn]),
//                       [.noteOn(note: 60, velocity: 100, channel: 0)])
//
//        // just cc events
//        XCTAssertEqual(coll.filter([.controllerChange]),
//                       [.cc(controller: .modWheel, value: 80, channel: 0)])
//
//        // both noteOn and cc events
//        XCTAssertEqual(coll.filter([.noteOn, .controllerChange]),
//                       [.noteOn(note: 60, velocity: 100, channel: 0),
//                        .cc(controller: .modWheel, value: 80, channel: 0)])
//
//        // just programChange events
//        XCTAssertEqual(coll.filter([.programChange]),
//                       [])
//
//    }
    
    // MARK: - Drop
    
//    func testDrop_Collection_MIDIEvent() {
//
//        let coll: [MIDI.Event] =
//            [
//                .noteOn(note: 60, velocity: 100, channel: 0),
//                .cc(controller: .modWheel, value: 80, channel: 0),
//                .timecodeQuarterFrame(byte: 0x00),
//                .activeSensing,
//                .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]),
//                try! .raw([0xFF])
//            ]
//
//        // empty MIDIEventKindProtocol/KindPattern array
//
//        let emptyDropKinds: [MIDIEventKindProtocol] = []
//        XCTAssertEqual(coll.drop(emptyDropKinds), coll)
//
//        let emptyDropKindPattern: [MIDI.Event.KindPattern] = []
//        XCTAssertEqual(coll.drop(pattern: emptyDropKindPattern), coll)
//
//        // -------------------------------------------------------------------
//        // [MIDI.Event].drop(_ kinds: [Element.Kind]) -> [Element]
//        // -------------------------------------------------------------------
//
//        XCTAssertEqual(coll.drop([.chanVoice]),
//                       [
//                        .timecodeQuarterFrame(byte: 0x00),
//                        .activeSensing,
//                        .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]),
//                        try! .raw([0xFF])
//                       ])
//
//        XCTAssertEqual(coll.drop(pattern: [.chanVoice([.controllerChange()])]),
//                       [
//                        .noteOn(note: 60, velocity: 100, channel: 0),
//                        .timecodeQuarterFrame(byte: 0x00),
//                        .activeSensing,
//                        .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]),
//                        try! .raw([0xFF])
//                       ])
//
//        XCTAssertEqual(coll.drop([.sysCommon]),
//                       [
//                        .noteOn(note: 60, velocity: 100, channel: 0),
//                        .cc(controller: .modWheel, value: 80, channel: 0),
//                        .activeSensing,
//                        .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]),
//                        try! .raw([0xFF])
//                       ])
//
//        XCTAssertEqual(coll.drop([.sysRealTime]),
//                       [
//                        .noteOn(note: 60, velocity: 100, channel: 0),
//                        .cc(controller: .modWheel, value: 80, channel: 0),
//                        .timecodeQuarterFrame(byte: 0x00),
//                        .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]),
//                        try! .raw([0xFF])
//                       ])
//
//        XCTAssertEqual(coll.drop([.sysEx]),
//                       [
//                        .noteOn(note: 60, velocity: 100, channel: 0),
//                        .cc(controller: .modWheel, value: 80, channel: 0),
//                        .timecodeQuarterFrame(byte: 0x00),
//                        .activeSensing,
//                        try! .raw([0xFF])
//                       ])
//
//        XCTAssertEqual(coll.drop([.raw]),
//                       [
//                        .noteOn(note: 60, velocity: 100, channel: 0),
//                        .cc(controller: .modWheel, value: 80, channel: 0),
//                        .timecodeQuarterFrame(byte: 0x00),
//                        .activeSensing,
//                        .sysEx(manufacturer: .oneByte(0x41)!, data: [0x20, 0x42]),
//                       ])
//
//    }

}
#endif
