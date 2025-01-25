//
//  MIDIEvent Filter System Exclusive Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_SystemExclusive_Tests {
    @Test
    func metadata() {
        // isSystemExclusive
    
        let events = kEvents.SysEx.oneOfEachEventType
    
        events.forEach {
            #expect(!$0.isChannelVoice)
            #expect(!$0.isSystemCommon)
            #expect($0.isSystemExclusive)
            #expect(!$0.isSystemRealTime)
            #expect(!$0.isUtility)
        }
    }
    
    // MARK: - only
    
    @Test
    func filter_only() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysEx: .only)
    
        let expectedEvents = kEvents.SysEx.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysEx: .onlyType(.sysEx7))
    
        let expectedEvents = [kEvents.SysEx.sysEx7]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        filteredEvents = events.filter(sysEx: .onlyTypes([.sysEx7]))
        expectedEvents = [kEvents.SysEx.sysEx7]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(sysEx: .onlyTypes([.sysEx7, .universalSysEx7]))
        expectedEvents = [kEvents.SysEx.sysEx7, kEvents.SysEx.universalSysEx7]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(sysEx: .onlyTypes([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - keep
    
    @Test
    func filter_keepType() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepTypes() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - drop
    
    @Test
    func filter_drop() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysEx: .drop)
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += []
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropType() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropTypes() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
}
