//
//  Event Filter System Common Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEventFilter_SystemCommon_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isSystemCommon
        
        let events = kEvents.SysCommon.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertTrue($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
        }
        
        // isSystemCommon(ofType:)
        
        XCTAssertTrue(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofType: .tuneRequest)
        )
        
        XCTAssertFalse(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofType: .songPositionPointer)
        )
        
        // isSystemCommon(ofTypes:)
        
        XCTAssertTrue(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest])
        )
        
        XCTAssertTrue(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest, .songSelect])
        )
        
        XCTAssertFalse(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.songSelect])
        )
        
        XCTAssertFalse(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [])
        )
        
    }
    
    // MARK: - only
    
    func testFilter_SysCommon_only() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .only)
        
        let expectedEvents = kEvents.SysCommon.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysCommon_onlyType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .onlyType(.tuneRequest))
        
        let expectedEvents = [kEvents.SysCommon.tuneRequest]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysCommon_onlyTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(sysCommon: .onlyTypes([.tuneRequest]))
        expectedEvents = [kEvents.SysCommon.tuneRequest]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysCommon: .onlyTypes([.tuneRequest, .songSelect]))
        expectedEvents = [kEvents.SysCommon.songSelect, kEvents.SysCommon.tuneRequest]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysCommon: .onlyTypes([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - keep
    
    func testFilter_SysCommon_keepType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .keepType(.tuneRequest))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + [
            kEvents.SysCommon.tuneRequest
        ]
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysCommon_keepTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .keepTypes([.tuneRequest, .songSelect]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + [
            kEvents.SysCommon.songSelect,
            kEvents.SysCommon.tuneRequest
        ]
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - drop
    
    func testFilter_SysCommon_drop() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .drop)
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + []
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysCommon_dropType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .dropType(.tuneRequest))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + [
            kEvents.SysCommon.timecodeQuarterFrame,
            kEvents.SysCommon.songPositionPointer,
            kEvents.SysCommon.songSelect,
            kEvents.SysCommon.unofficialBusSelect
        ]
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysCommon_dropTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .dropTypes([.tuneRequest, .songSelect]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + [
            kEvents.SysCommon.timecodeQuarterFrame,
            kEvents.SysCommon.songPositionPointer,
            kEvents.SysCommon.unofficialBusSelect
        ]
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
}

#endif
