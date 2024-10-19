//
//  MIDIEvent Filter System Real-Time Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import XCTest

final class MIDIEvent_Filter_SystemRealTime_Tests: XCTestCase {
    func testMetadata() {
        // isSystemRealTime
    
        let events = kEvents.SysRealTime.oneOfEachEventType
    
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertTrue($0.isSystemRealTime)
            XCTAssertFalse($0.isUtility)
        }
    
        // isSystemRealTime(ofType:)
    
        XCTAssertTrue(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofType: .timingClock)
        )
    
        XCTAssertFalse(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofType: .start)
        )
    
        // isSystemRealTime(ofTypes:)
    
        XCTAssertTrue(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock])
        )
    
        XCTAssertTrue(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock, .start])
        )
    
        XCTAssertFalse(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.start])
        )
    
        XCTAssertFalse(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [])
        )
    }
    
    // MARK: - only
    
    func testFilter_only() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .only)
    
        let expectedEvents = kEvents.SysRealTime.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .onlyType(.start))
    
        let expectedEvents = [kEvents.SysRealTime.start]
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
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
    
    func testFilter_keepType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .keepType(.start))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += [
            kEvents.SysRealTime.start
        ]
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_keepTypes() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .keepTypes([.start, .stop]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += [
            kEvents.SysRealTime.start,
            kEvents.SysRealTime.stop
        ]
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - drop
    
    func testFilter_drop() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .drop)
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .dropType(.start))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += [
            kEvents.SysRealTime.timingClock,
            kEvents.SysRealTime.continue,
            kEvents.SysRealTime.stop,
            kEvents.SysRealTime.activeSensing,
            kEvents.SysRealTime.systemReset
        ]
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropTypes() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .dropTypes([.start, .stop]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += [
            kEvents.SysRealTime.timingClock,
            kEvents.SysRealTime.continue,
            kEvents.SysRealTime.activeSensing,
            kEvents.SysRealTime.systemReset
        ]
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
}
