//
//  Event Filter System Real Time Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_SystemRealTime_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isSystemRealTime
        
        let events = kEvents.SysRealTime.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertTrue($0.isSystemRealTime)
        }
        
        // isSystemRealTime(ofType:)
        
        XCTAssertTrue(
            MIDI.Event.timingClock(group: 0)
            .isSystemRealTime(ofType: .timingClock)
        )
        
        XCTAssertFalse(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofType: .start)
        )
        
        // isSystemRealTime(ofTypes:)
        
        XCTAssertTrue(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock])
        )
        
        XCTAssertTrue(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock, .start])
        )
        
        XCTAssertFalse(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.start])
        )
        
        XCTAssertFalse(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [])
        )
        
    }
    
    // MARK: - only
    
    func testFilter_SysRealTime_only() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysRealTime: .only)
        
        let expectedEvents = kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysRealTime_onlyType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysRealTime: .onlyType(.start))
        
        let expectedEvents = [kEvents.SysRealTime.start]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysRealTime_onlyTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(sysRealTime: .onlyTypes([.start]))
        expectedEvents = [kEvents.SysRealTime.start]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysRealTime: .onlyTypes([.start, .stop]))
        expectedEvents = [kEvents.SysRealTime.start, kEvents.SysRealTime.stop]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysRealTime: .onlyTypes([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - keep
    
    func testFilter_SysRealTime_keepType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysRealTime: .keepType(.start))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + [
            kEvents.SysRealTime.start
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysRealTime_keepTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysRealTime: .keepTypes([.start, .stop]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + [
            kEvents.SysRealTime.start,
            kEvents.SysRealTime.stop
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - drop
    
    func testFilter_SysRealTime_drop() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysRealTime: .drop)
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysRealTime_dropType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysRealTime: .dropType(.start))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + [
            kEvents.SysRealTime.timingClock,
            kEvents.SysRealTime.continue,
            kEvents.SysRealTime.stop,
            kEvents.SysRealTime.activeSensing,
            kEvents.SysRealTime.systemReset
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysRealTime_dropTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysRealTime: .dropTypes([.start, .stop]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + [
            kEvents.SysRealTime.timingClock,
            kEvents.SysRealTime.continue,
            kEvents.SysRealTime.activeSensing,
            kEvents.SysRealTime.systemReset
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
}

#endif
