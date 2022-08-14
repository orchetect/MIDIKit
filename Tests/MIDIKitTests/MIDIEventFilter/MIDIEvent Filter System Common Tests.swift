//
//  MIDIEvent Filter System Common Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEvent_Filter_SystemCommon_Tests: XCTestCase {
    func testMetadata() {
        // isSystemCommon
        
        let events = kEvents.SysCommon.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertTrue($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
            XCTAssertFalse($0.isUtility)
        }
        
        // isSystemCommon(ofType:)
        
        XCTAssertTrue(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofType: .tuneRequest)
        )
        
        XCTAssertFalse(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofType: .songPositionPointer)
        )
        
        // isSystemCommon(ofTypes:)
        
        XCTAssertTrue(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest])
        )
        
        XCTAssertTrue(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest, .songSelect])
        )
        
        XCTAssertFalse(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.songSelect])
        )
        
        XCTAssertFalse(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [])
        )
    }
    
    // MARK: - only
    
    func testFilter_only() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .only)
        
        let expectedEvents = kEvents.SysCommon.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyType() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .onlyType(.tuneRequest))
        
        let expectedEvents = [kEvents.SysCommon.tuneRequest]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
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
    
    func testFilter_keepType() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .keepType(.tuneRequest))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += [
            kEvents.SysCommon.tuneRequest
        ]
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_keepTypes() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .keepTypes([.tuneRequest, .songSelect]))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += [
            kEvents.SysCommon.songSelect,
            kEvents.SysCommon.tuneRequest
        ]
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - drop
    
    func testFilter_drop() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .drop)
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += []
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropType() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .dropType(.tuneRequest))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += [
            kEvents.SysCommon.timecodeQuarterFrame,
            kEvents.SysCommon.songPositionPointer,
            kEvents.SysCommon.songSelect,
            kEvents.SysCommon.unofficialBusSelect
        ]
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropTypes() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysCommon: .dropTypes([.tuneRequest, .songSelect]))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += [
            kEvents.SysCommon.timecodeQuarterFrame,
            kEvents.SysCommon.songPositionPointer,
            kEvents.SysCommon.unofficialBusSelect
        ]
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
}

#endif
