//
//  MIDIEvent Filter System Real-Time Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_SystemRealTime_Tests {
    @Test
    func metadata() {
        // isSystemRealTime
    
        let events = kEvents.SysRealTime.oneOfEachEventType
    
        events.forEach {
            #expect(!$0.isChannelVoice)
            #expect(!$0.isSystemCommon)
            #expect(!$0.isSystemExclusive)
            #expect($0.isSystemRealTime)
            #expect(!$0.isUtility)
        }
    
        // isSystemRealTime(ofType:)
    
        #expect(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofType: .timingClock)
        )
    
        #expect(
            !MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofType: .start)
        )
    
        // isSystemRealTime(ofTypes:)
    
        #expect(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock])
        )
    
        #expect(
            MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock, .start])
        )
    
        #expect(
            !MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.start])
        )
    
        #expect(
            !MIDIEvent.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [])
        )
    }
    
    // MARK: - only
    
    @Test
    func filter_only() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .only)
    
        let expectedEvents = kEvents.SysRealTime.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .onlyType(.start))
    
        let expectedEvents = [kEvents.SysRealTime.start]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        filteredEvents = events.filter(sysRealTime: .onlyTypes([.start]))
        expectedEvents = [kEvents.SysRealTime.start]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(sysRealTime: .onlyTypes([.start, .stop]))
        expectedEvents = [kEvents.SysRealTime.start, kEvents.SysRealTime.stop]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(sysRealTime: .onlyTypes([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - keep
    
    @Test
    func filter_keepType() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepTypes() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - drop
    
    @Test
    func filter_drop() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysRealTime: .drop)
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropType() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropTypes() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
}
