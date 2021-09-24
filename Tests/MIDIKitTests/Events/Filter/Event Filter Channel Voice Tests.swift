//
//  Event Filter Channel Voice Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_ChannelVoice_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isChannelVoice
        
        let events = kEvents.ChanVoice.oneOfEachEventType
        
        events.forEach {
            XCTAssertTrue($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
        }
        
        // isChannelVoice(ofType:)
        
        XCTAssertTrue(
            MIDI.Event.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOn)
        )
        
        XCTAssertFalse(
            MIDI.Event.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOff)
        )
        
        // isChannelVoice(ofTypes:)
        
        XCTAssertTrue(
            MIDI.Event.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn])
        )
        
        XCTAssertTrue(
            MIDI.Event.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn, .noteOff])
        )
        
        XCTAssertFalse(
            MIDI.Event.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOff, .cc])
        )
        
        XCTAssertFalse(
            MIDI.Event.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [])
        )
        
    }
    
    // MARK: - only
    
    func testFilter_ChanVoice_only() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .only)
        
        let expectedEvents = kEvents.ChanVoice.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .onlyType(.noteOn))
        
        let expectedEvents = [kEvents.ChanVoice.noteOn]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(chanVoice: .onlyTypes([.noteOn]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyTypes([.noteOn, .noteOff]))
        expectedEvents = [kEvents.ChanVoice.noteOn, kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyTypes([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyChannel() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // channel 0
        filteredEvents = events.filter(chanVoice: .onlyChannel(0))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 1
        filteredEvents = events.filter(chanVoice: .onlyChannel(1))
        expectedEvents = [kEvents.ChanVoice.polyAftertouch,
                          kEvents.ChanVoice.programChange,
                          kEvents.ChanVoice.chanAftertouch,
                          kEvents.ChanVoice.pitchBend]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .onlyChannel(2))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .onlyChannel(3))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .onlyChannel(15))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyChannels() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // empty
        filteredEvents = events.filter(chanVoice: .onlyChannels([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 0
        filteredEvents = events.filter(chanVoice: .onlyChannels([0]))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 1
        filteredEvents = events.filter(chanVoice: .onlyChannels([1]))
        expectedEvents = [kEvents.ChanVoice.polyAftertouch,
                          kEvents.ChanVoice.programChange,
                          kEvents.ChanVoice.chanAftertouch,
                          kEvents.ChanVoice.pitchBend]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .onlyChannels([2]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .onlyChannels([3]))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .onlyChannels([15]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 0, 1
        filteredEvents = events.filter(chanVoice: .onlyChannels([0, 1]))
        expectedEvents = [kEvents.ChanVoice.polyAftertouch,
                          kEvents.ChanVoice.cc,
                          kEvents.ChanVoice.programChange,
                          kEvents.ChanVoice.chanAftertouch,
                          kEvents.ChanVoice.pitchBend]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyCC() {
        
        var events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(chanVoice: .onlyCC(.expression))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyCC(.modWheel))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        events = [kEvents.ChanVoice.cc,
                  kEvents.ChanVoice.cc1]
        
        filteredEvents = events.filter(chanVoice: .onlyCC(.expression))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyCC(.modWheel))
        expectedEvents = [kEvents.ChanVoice.cc1]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyCC(.sustainPedal))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyCCs() {
        
        var events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // empty
        filteredEvents = events.filter(chanVoice: .onlyCCs([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.expression]))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.modWheel]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        events = kEvents.ChanVoice.oneOfEachEventType
        + [kEvents.ChanVoice.cc1]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        // empty
        filteredEvents = events.filter(chanVoice: .onlyCCs([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.expression]))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.modWheel]))
        expectedEvents = [kEvents.ChanVoice.cc1]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.sustainPedal]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1), expression (11)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.modWheel, .expression]))
        expectedEvents = [kEvents.ChanVoice.cc,
                          kEvents.ChanVoice.cc1]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11), sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.expression, .sustainPedal]))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - keep
    
    func testFilter_ChanVoice_keepType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .keepType(.noteOn))
        
        let expectedEvents = [
            kEvents.ChanVoice.noteOn
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_keepTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .keepTypes([.noteOn, .noteOff]))
        
        let expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_keepChannel() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // channel 0
        filteredEvents = events.filter(chanVoice: .keepChannel(0))
        expectedEvents = [kEvents.ChanVoice.cc]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 1
        filteredEvents = events.filter(chanVoice: .keepChannel(1))
        expectedEvents = [kEvents.ChanVoice.polyAftertouch,
                          kEvents.ChanVoice.programChange,
                          kEvents.ChanVoice.chanAftertouch,
                          kEvents.ChanVoice.pitchBend]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .keepChannel(2))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .keepChannel(3))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .keepChannel(15))
        expectedEvents = []
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_keepChannels() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // empty
        filteredEvents = events.filter(chanVoice: .keepChannels([]))
        expectedEvents = []
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 0
        filteredEvents = events.filter(chanVoice: .keepChannels([0]))
        expectedEvents = [kEvents.ChanVoice.cc]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 1
        filteredEvents = events.filter(chanVoice: .keepChannels([1]))
        expectedEvents = [kEvents.ChanVoice.polyAftertouch,
                          kEvents.ChanVoice.programChange,
                          kEvents.ChanVoice.chanAftertouch,
                          kEvents.ChanVoice.pitchBend]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .keepChannels([2]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .keepChannels([3]))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .keepChannels([15]))
        expectedEvents = []
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channels 0, 1
        filteredEvents = events.filter(chanVoice: .keepChannels([0, 1]))
        expectedEvents = [kEvents.ChanVoice.polyAftertouch,
                          kEvents.ChanVoice.cc,
                          kEvents.ChanVoice.programChange,
                          kEvents.ChanVoice.chanAftertouch,
                          kEvents.ChanVoice.pitchBend]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_keepCC() {
        
        var events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(chanVoice: .keepCC(.expression))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .keepCC(.modWheel))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        events = kEvents.ChanVoice.oneOfEachEventType
        + [kEvents.ChanVoice.cc1]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        filteredEvents = events.filter(chanVoice: .keepCC(.expression))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .keepCC(.modWheel))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .keepCC(.sustainPedal))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_keepCCs() {
        
        var events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // empty
        filteredEvents = events.filter(chanVoice: .keepCCs([]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11)
        filteredEvents = events.filter(chanVoice: .keepCCs([.expression]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .keepCCs([.modWheel]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        events = kEvents.ChanVoice.oneOfEachEventType
        + [kEvents.ChanVoice.cc1]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        // empty
        filteredEvents = events.filter(chanVoice: .keepCCs([]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11)
        filteredEvents = events.filter(chanVoice: .keepCCs([.expression]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .keepCCs([.modWheel]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .keepCCs([.sustainPedal]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1), expression (11)
        filteredEvents = events.filter(chanVoice: .keepCCs([.modWheel, .expression]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11), sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .keepCCs([.expression, .sustainPedal]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - drop
    
    func testFilter_ChanVoice_drop() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .drop)
        
        let expectedEvents =
        kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .dropType(.noteOn))
        
        let expectedEvents = [
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .dropTypes([.noteOn, .noteOff]))
        
        let expectedEvents = [
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropChannel() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // channel 0
        filteredEvents = events.filter(chanVoice: .dropChannel(0))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 1
        filteredEvents = events.filter(chanVoice: .dropChannel(1))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.cc
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .dropChannel(2))
        expectedEvents = [
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .dropChannel(3))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .dropChannel(15))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropChannels() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // empty
        filteredEvents = events.filter(chanVoice: .dropChannels([]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 0
        filteredEvents = events.filter(chanVoice: .dropChannels([0]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 1
        filteredEvents = events.filter(chanVoice: .dropChannels([1]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.cc
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .dropChannels([2]))
        expectedEvents = [
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .dropChannels([3]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .dropChannels([15]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channels 0, 1
        filteredEvents = events.filter(chanVoice: .dropChannels([0, 1]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropCC() {
        
        var events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(chanVoice: .dropCC(.expression))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .dropCC(.modWheel))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        events = kEvents.ChanVoice.oneOfEachEventType
        + [kEvents.ChanVoice.cc1]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        filteredEvents = events.filter(chanVoice: .dropCC(.expression))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .dropCC(.modWheel))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .dropCC(.sustainPedal))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropCCs() {
        
        var events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        // empty
        filteredEvents = events.filter(chanVoice: .dropCCs([]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11)
        filteredEvents = events.filter(chanVoice: .dropCCs([.expression]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .dropCCs([.modWheel]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        events = kEvents.ChanVoice.oneOfEachEventType
        + [kEvents.ChanVoice.cc1]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        // empty
        filteredEvents = events.filter(chanVoice: .dropCCs([]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11)
        filteredEvents = events.filter(chanVoice: .dropCCs([.expression]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .dropCCs([.modWheel]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .dropCCs([.sustainPedal]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // modWheel (1), expression (11)
        filteredEvents = events.filter(chanVoice: .dropCCs([.modWheel, .expression]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11), sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .dropCCs([.expression, .sustainPedal]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.cc1
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
}

#endif
