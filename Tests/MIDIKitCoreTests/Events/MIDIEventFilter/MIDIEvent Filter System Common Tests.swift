//
//  MIDIEvent Filter System Common Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_SystemCommon_Tests {
    @Test
    func metadata() {
        // isSystemCommon
    
        let events = kEvents.SysCommon.oneOfEachEventType
    
        for event in events {
            #expect(!event.isChannelVoice)
            #expect(event.isSystemCommon)
            #expect(!event.isSystemExclusive)
            #expect(!event.isSystemRealTime)
            #expect(!event.isUtility)
        }
    
        // isSystemCommon(ofType:)
    
        #expect(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofType: .tuneRequest)
        )
    
        #expect(
            !MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofType: .songPositionPointer)
        )
    
        // isSystemCommon(ofTypes:)
    
        #expect(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest])
        )
    
        #expect(
            MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest, .songSelect])
        )
    
        #expect(
            !MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.songSelect])
        )
    
        #expect(
            !MIDIEvent.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [])
        )
    }
    
    // MARK: - only
    
    @Test
    func filter_only() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysCommon: .only)
    
        let expectedEvents = kEvents.SysCommon.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysCommon: .onlyType(.tuneRequest))
    
        let expectedEvents = [kEvents.SysCommon.tuneRequest]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        filteredEvents = events.filter(sysCommon: .onlyTypes([.tuneRequest]))
        expectedEvents = [kEvents.SysCommon.tuneRequest]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(sysCommon: .onlyTypes([.tuneRequest, .songSelect]))
        expectedEvents = [kEvents.SysCommon.songSelect, kEvents.SysCommon.tuneRequest]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(sysCommon: .onlyTypes([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - keep
    
    @Test
    func filter_keepType() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepTypes() {
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
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - drop
    
    @Test
    func filter_drop() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysCommon: .drop)
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += []
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysCommon: .dropType(.tuneRequest))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += [
            kEvents.SysCommon.timecodeQuarterFrame,
            kEvents.SysCommon.songPositionPointer,
            kEvents.SysCommon.songSelect
        ]
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropTypes() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(sysCommon: .dropTypes([.tuneRequest, .songSelect]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += [
            kEvents.SysCommon.timecodeQuarterFrame,
            kEvents.SysCommon.songPositionPointer
        ]
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
}
