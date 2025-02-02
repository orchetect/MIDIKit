//
//  MIDIEvent Filter Utility Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_Utility_Tests {
    @Test
    func metadata() {
        // isUtility
    
        let events = kEvents.Utility.oneOfEachEventType
    
        for event in events {
            #expect(!event.isChannelVoice)
            #expect(!event.isSystemCommon)
            #expect(!event.isSystemExclusive)
            #expect(!event.isSystemRealTime)
            #expect(event.isUtility)
        }
    
        // isUtility(ofType:)
    
        #expect(
            MIDIEvent.noOp(group: 0)
                .isUtility(ofType: .noOp)
        )
    
        #expect(
            !MIDIEvent.noOp(group: 0)
                .isUtility(ofType: .jrClock)
        )
    
        // isUtility(ofTypes:)
    
        #expect(
            MIDIEvent.noOp(group: 0)
                .isUtility(ofTypes: [.noOp])
        )
    
        #expect(
            MIDIEvent.noOp(group: 0)
                .isUtility(ofTypes: [.noOp, .jrClock])
        )
    
        #expect(
            !MIDIEvent.noOp(group: 0)
                .isUtility(ofTypes: [.jrClock])
        )
    
        #expect(
            !MIDIEvent.noOp(group: 0)
                .isUtility(ofTypes: [])
        )
    }
    
    // MARK: - only
    
    @Test
    func filter_only() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(utility: .only)
    
        let expectedEvents = kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(utility: .onlyType(.noOp))
    
        let expectedEvents = [kEvents.Utility.noOp]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        filteredEvents = events.filter(utility: .onlyTypes([.noOp]))
        expectedEvents = [kEvents.Utility.noOp]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(utility: .onlyTypes([.noOp, .jrClock]))
        expectedEvents = [kEvents.Utility.noOp, kEvents.Utility.jrClock]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(utility: .onlyTypes([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - keep
    
    @Test
    func filter_keepType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(utility: .keepType(.noOp))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.noOp
        ]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepTypes() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(utility: .keepTypes([.noOp, .jrClock]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.noOp,
            kEvents.Utility.jrClock
        ]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - drop
    
    @Test
    func filter_drop() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(utility: .drop)
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(utility: .dropType(.noOp))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.jrClock,
            kEvents.Utility.jrTimestamp
        ]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_dropTypes() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(utility: .dropTypes([.noOp, .jrClock]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.jrTimestamp
        ]
    
        #expect(filteredEvents == expectedEvents)
    }
}
