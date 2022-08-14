//
//  MIDIEvent Filter System Exclusive Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEvent_Filter_SystemExclusive_Tests: XCTestCase {
    func testMetadata() {
        // isSystemExclusive
        
        let events = kEvents.SysEx.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertTrue($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
            XCTAssertFalse($0.isUtility)
        }
    }
    
    // MARK: - only
    
    func testFilter_only() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .only)
        
        let expectedEvents = kEvents.SysEx.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyType() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .onlyType(.sysEx7))
        
        let expectedEvents = [kEvents.SysEx.sysEx7]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
        
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
    
    func testFilter_keepType() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .keepType(.sysEx7))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += [
            kEvents.SysEx.sysEx7
        ]
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_keepTypes() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .keepTypes([.sysEx7, .universalSysEx7]))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += [
            kEvents.SysEx.sysEx7,
            kEvents.SysEx.universalSysEx7
        ]
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    // MARK: - drop
    
    func testFilter_drop() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .drop)
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += []
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropType() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .dropType(.sysEx7))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += [
            kEvents.SysEx.universalSysEx7,
            kEvents.SysEx.sysEx8,
            kEvents.SysEx.universalSysEx8
        ]
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
    
    func testFilter_dropTypes() {
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(sysEx: .dropTypes([.sysEx7, .universalSysEx7]))
        
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += [
            kEvents.SysEx.sysEx8,
            kEvents.SysEx.universalSysEx8
        ]
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
    }
}

#endif
