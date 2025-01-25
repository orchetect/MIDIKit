//
//  MIDIEvent Filter Channel Voice only Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_ChannelVoiceOnly_Tests {
    @Test
    func filter_only() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .only)
    
        let expectedEvents = kEvents.ChanVoice.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .onlyType(.noteOn))
    
        let expectedEvents = [kEvents.ChanVoice.noteOn]
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyTypes() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        filteredEvents = events.filter(chanVoice: .onlyTypes([.noteOn]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(chanVoice: .onlyTypes([.noteOn, .noteOff]))
        expectedEvents = [kEvents.ChanVoice.noteOn, kEvents.ChanVoice.noteOff]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(chanVoice: .onlyTypes([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyChannel() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        // channel 0
        filteredEvents = events.filter(chanVoice: .onlyChannel(0))
        expectedEvents = [kEvents.ChanVoice.cc]
        #expect(filteredEvents == expectedEvents)
    
        // channel 1
        filteredEvents = events.filter(chanVoice: .onlyChannel(1))
        expectedEvents = [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        #expect(filteredEvents == expectedEvents)
    
        // channel 2
        filteredEvents = events.filter(chanVoice: .onlyChannel(2))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        #expect(filteredEvents == expectedEvents)
    
        // channel 3
        filteredEvents = events.filter(chanVoice: .onlyChannel(3))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        #expect(filteredEvents == expectedEvents)
    
        // channel 4
        filteredEvents = events.filter(chanVoice: .onlyChannel(4))
        expectedEvents = [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.noteManagement
        ]
        #expect(filteredEvents == expectedEvents)
    
        // channel 15
        filteredEvents = events.filter(chanVoice: .onlyChannel(15))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyChannels() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        // empty
        filteredEvents = events.filter(chanVoice: .onlyChannels([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // channel 0
        filteredEvents = events.filter(chanVoice: .onlyChannels([0]))
        expectedEvents = [kEvents.ChanVoice.cc]
        #expect(filteredEvents == expectedEvents)
    
        // channel 1
        filteredEvents = events.filter(chanVoice: .onlyChannels([1]))
        expectedEvents = [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        #expect(filteredEvents == expectedEvents)
    
        // channel 2
        filteredEvents = events.filter(chanVoice: .onlyChannels([2]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        #expect(filteredEvents == expectedEvents)
    
        // channel 3
        filteredEvents = events.filter(chanVoice: .onlyChannels([3]))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        #expect(filteredEvents == expectedEvents)
    
        // channel 4
        filteredEvents = events.filter(chanVoice: .onlyChannels([4]))
        expectedEvents = [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.noteManagement
        ]
        #expect(filteredEvents == expectedEvents)
    
        // channel 15
        filteredEvents = events.filter(chanVoice: .onlyChannels([15]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // channel 0, 1
        filteredEvents = events.filter(chanVoice: .onlyChannels([0, 1]))
        expectedEvents = [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyCC() {
        var events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        filteredEvents = events.filter(chanVoice: .onlyCC(.expression))
        expectedEvents = [kEvents.ChanVoice.cc]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(chanVoice: .onlyCC(.modWheel))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        events = [
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.cc1
        ]
    
        filteredEvents = events.filter(chanVoice: .onlyCC(.expression))
        expectedEvents = [kEvents.ChanVoice.cc]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(chanVoice: .onlyCC(.modWheel))
        expectedEvents = [kEvents.ChanVoice.cc1]
        #expect(filteredEvents == expectedEvents)
    
        filteredEvents = events.filter(chanVoice: .onlyCC(.sustainPedal))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyCCs() {
        var events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        // empty
        filteredEvents = events.filter(chanVoice: .onlyCCs([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // expression (11)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.expression]))
        expectedEvents = [kEvents.ChanVoice.cc]
        #expect(filteredEvents == expectedEvents)
    
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.modWheel]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        events = kEvents.ChanVoice.oneOfEachEventType
            + [kEvents.ChanVoice.cc1]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
    
        // empty
        filteredEvents = events.filter(chanVoice: .onlyCCs([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // expression (11)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.expression]))
        expectedEvents = [kEvents.ChanVoice.cc]
        #expect(filteredEvents == expectedEvents)
    
        // modWheel (1)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.modWheel]))
        expectedEvents = [kEvents.ChanVoice.cc1]
        #expect(filteredEvents == expectedEvents)
    
        // sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.sustainPedal]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // modWheel (1), expression (11)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.modWheel, .expression]))
        expectedEvents = [
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.cc1
        ]
        #expect(filteredEvents == expectedEvents)
    
        // expression (11), sustainPedal (64)
        filteredEvents = events.filter(chanVoice: .onlyCCs([.expression, .sustainPedal]))
        expectedEvents = [kEvents.ChanVoice.cc]
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyNotesInRange() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        // 0...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(0 ... 127))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        #expect(filteredEvents == expectedEvents)
    
        // 60...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(60 ... 61))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        #expect(filteredEvents == expectedEvents)
    
        // 60...60
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(60 ... 60))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        #expect(filteredEvents == expectedEvents)
    
        // 61...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(61 ... 61))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        #expect(filteredEvents == expectedEvents)
    
        // 0...59
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(0 ... 59))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // 62...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRange(62 ... 127))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_onlyNotesInRanges() {
        let events = kEvents.oneOfEachEventType
    
        var filteredEvents: [MIDIEvent]
        var expectedEvents: [MIDIEvent]
    
        // empty
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // 0...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([0 ... 127]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        #expect(filteredEvents == expectedEvents)
    
        // 60...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([60 ... 61]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        #expect(filteredEvents == expectedEvents)
    
        // 60...60
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([60 ... 60]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        #expect(filteredEvents == expectedEvents)
    
        // 61...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([61 ... 61]))
        expectedEvents = [kEvents.ChanVoice.noteOff]
        #expect(filteredEvents == expectedEvents)
    
        // 0...59
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([0 ... 59]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // 62...127
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([62 ... 127]))
        expectedEvents = []
        #expect(filteredEvents == expectedEvents)
    
        // 0...10, 60...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([0 ... 10, 60 ... 61]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        #expect(filteredEvents == expectedEvents)
    
        // 60...60, 61...61
        filteredEvents = events.filter(chanVoice: .onlyNotesInRanges([60 ... 60, 61 ... 61]))
        expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        #expect(filteredEvents == expectedEvents)
    }
}
