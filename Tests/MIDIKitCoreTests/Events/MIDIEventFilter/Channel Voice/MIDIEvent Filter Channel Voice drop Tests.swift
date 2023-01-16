//
//  MIDIEvent Filter Channel Voice drop Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class MIDIEvent_Filter_ChannelVoiceDrop_Tests: XCTestCase {
    func testFilter_drop() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .drop)
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropType(.noteOn))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropTypes() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropTypes([.noteOn, .noteOff]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - testFilter_dropChannel
    
    func testFilter_dropChannel_0() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannel(0))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannel_1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannel(1))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannel_2() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannel(2))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannel_3() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannel(3))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannel_15() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannel(15))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - testFilter_dropChannels
    
    func testFilter_dropChannels_empty() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannels([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannels_0() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannels([0]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannels_1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannels([1]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannels_2() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannels([2]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannels_3() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannels([3]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannels_15() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannels([15]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropChannels_0and1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropChannels([0, 1]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.noteManagement
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - testFilter_dropCC
    
    func testFilter_dropCC_A() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCC(.expression))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCC_B() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCC(.modWheel))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCC_C() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCC(.expression))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCC_D() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCC(.modWheel))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCC_E() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCC(.sustainPedal))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - testFilter_dropCCs
    
    func testFilter_dropCCs_empty() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_11() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([.expression]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([.modWheel]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_emptyB() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_11B() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([.expression]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_1B() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([.modWheel]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_64() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([.sustainPedal]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_1and11() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([.modWheel, .expression]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropCCs_11and64() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropCCs([.expression, .sustainPedal]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - testFilter_dropNotesInRange
    
    func testFilter_dropNotesInRange_all() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRange(0 ... 127))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRange_60to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRange(60 ... 61))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRange_60to60() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRange(60 ... 60))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRange_61to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRange(61 ... 61))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRange_0to59() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRange(0 ... 59))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRange_62to127() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRange(62 ... 127))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - testFilter_dropNotesInRanges
    
    func testFilter_dropNotesInRanges_empty() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_all() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([0 ... 127]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_60to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([60 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_60to60() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([60 ... 60]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_61to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([61 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_0to59() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([0 ... 59]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_62to127() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([62 ... 127]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_0to10_60to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .dropNotesInRanges([0 ... 10, 60 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropNotesInRanges_60to60_61to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events
            .filter(chanVoice: .dropNotesInRanges([60 ... 60, 61 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
}

#endif
