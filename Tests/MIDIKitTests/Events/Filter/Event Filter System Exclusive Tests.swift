//
//  Event Filter System Exclusive Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_SystemExclusive_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isSystemExclusive
        
        let events = kEvents.SysEx.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertTrue($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
        }
        
    }
    
    // MARK: - only
    
    func testFilter_SysEx_only() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysEx: .only)
        
        let expectedEvents = kEvents.SysEx.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_onlyType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysEx: .onlyType(.sysEx))
        
        let expectedEvents = [kEvents.SysEx.sysEx]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_onlyTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(sysEx: .onlyTypes([.sysEx]))
        expectedEvents = [kEvents.SysEx.sysEx]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysEx: .onlyTypes([.sysEx, .universalSysEx]))
        expectedEvents = [kEvents.SysEx.sysEx, kEvents.SysEx.universalSysEx]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysEx: .onlyTypes([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - keep
    
    func testFilter_SysEx_keepType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysEx: .keepType(.sysEx))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + [
            kEvents.SysEx.sysEx
        ]
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_keepTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysEx: .keepTypes([.sysEx, .universalSysEx]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + [
            kEvents.SysEx.sysEx,
            kEvents.SysEx.universalSysEx
        ]
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - drop
    
    func testFilter_SysEx_drop() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysEx: .drop)
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + []
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_dropType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysEx: .dropType(.sysEx))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + [
            kEvents.SysEx.universalSysEx
        ]
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_dropTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(sysEx: .dropTypes([.sysEx, .universalSysEx]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + []
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
}

#endif
