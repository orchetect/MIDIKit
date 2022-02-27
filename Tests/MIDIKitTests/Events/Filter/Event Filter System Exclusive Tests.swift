//
//  Event Filter System Exclusive Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEventFilter_SystemExclusive_Tests: XCTestCase {
    
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
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .only)
        
        let expectedEvents = kEvents.SysEx.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_onlyType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .onlyType(.sysEx7))
        
        let expectedEvents = [kEvents.SysEx.sysEx7]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_onlyTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(sysEx: .onlyTypes([.sysEx7]))
        expectedEvents = [kEvents.SysEx.sysEx7]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysEx: .onlyTypes([.sysEx7, .universalSysEx7]))
        expectedEvents = [kEvents.SysEx.sysEx7, kEvents.SysEx.universalSysEx7]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(sysEx: .onlyTypes([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - keep
    
    func testFilter_SysEx_keepType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .keepType(.sysEx7))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + [
            kEvents.SysEx.sysEx7
        ]
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_keepTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .keepTypes([.sysEx7, .universalSysEx7]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + [
            kEvents.SysEx.sysEx7,
            kEvents.SysEx.universalSysEx7
        ]
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - drop
    
    func testFilter_SysEx_drop() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .drop)
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + []
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_dropType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .dropType(.sysEx7))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + [
            kEvents.SysEx.universalSysEx7,
            kEvents.SysEx.sysEx8,
            kEvents.SysEx.universalSysEx8
        ]
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_SysEx_dropTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .dropTypes([.sysEx7, .universalSysEx7]))
        
        let expectedEvents =
        kEvents.ChanVoice.oneOfEachEventType
        + kEvents.SysCommon.oneOfEachEventType
        + [
            kEvents.SysEx.sysEx8,
            kEvents.SysEx.universalSysEx8
        ]
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
}

#endif
