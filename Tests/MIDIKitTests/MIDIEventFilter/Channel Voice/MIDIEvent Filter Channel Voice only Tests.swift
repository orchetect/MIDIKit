//
//  MIDIEvent Filter Channel Voice only Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEvent_Filter_ChannelVoiceOnly_Tests: XCTestCase {
    func testFilter_only() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(chanVoice: .only)
        
        let expectedEvents = kEvents.ChanVoice.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyType() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(chanVoice: .onlyType(.noteOn))
        
        let expectedEvents = [kEvents.ChanVoice.noteOn]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
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
    
    func testFilter_onlyChannel() {
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
        // channel 0
        filteredEvents = events.filter(chanVoice: .onlyChannel(0))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 1
        filteredEvents = events.filter(chanVoice: .onlyChannel(1))
        expectedEvents = [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .onlyChannel(2))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .onlyChannel(3))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 4
        filteredEvents = events.filter(chanVoice: .onlyChannel(4))
        expectedEvents = [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.noteManagement
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .onlyChannel(15))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyChannels() {
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
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
        expectedEvents = [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 2
        filteredEvents = events.filter(chanVoice: .onlyChannels([2]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 3
        filteredEvents = events.filter(chanVoice: .onlyChannels([3]))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 4
        filteredEvents = events.filter(chanVoice: .onlyChannels([4]))
        expectedEvents = [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.noteManagement
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 15
        filteredEvents = events.filter(chanVoice: .onlyChannels([15]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // channel 0, 1
        filteredEvents = events.filter(chanVoice: .onlyChannels([0, 1]))
        expectedEvents = [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyCC() {
        var events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
        filteredEvents = events.filter(chanVoice: .onlyCC(.expression))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyCC(.modWheel))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        events = [
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.cc1
        ]
        
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
    
    func testFilter_onlyCCs() {
        var events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
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
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        
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
        expectedEvents = [
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.cc1
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // expression (11), sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.expression, .sustainPedal]))
        expectedEvents = [kEvents.ChanVoice.cc]
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyNotesInRange() {
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
        // 0...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(0 ... 127))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 60...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(60 ... 61))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 60...60
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(60 ... 60))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 61...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(61 ... 61))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 0...59
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(0 ... 59))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 62...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(62 ... 127))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyNotesInRanges() {
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
        // empty
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 0...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([0 ... 127]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 60...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([60 ... 61]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 60...60
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([60 ... 60]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 61...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([61 ... 61]))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 0...59
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([0 ... 59]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 62...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([62 ... 127]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 0...10, 60...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([0 ... 10, 60 ... 61]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        // 60...60, 61...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([60 ... 60, 61 ... 61]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
}

#endif
