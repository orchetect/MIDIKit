//
//  MIDIEvent Filter Channel Voice keep Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_ChannelVoiceKeep_Tests {
    @Test
    func filter_keepType() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepType(.noteOn))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepTypes() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepTypes([.noteOn, .noteOff]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - testFilter_keepChannel
    
    @Test
    func filter_keepChannel_0() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannel(0))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.cc
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannel_1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannel(1))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannel_2() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannel(2))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannel_3() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannel(3))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannel_15() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannel(15))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - testFilter_keepChannels
    
    @Test
    func filter_keepChannels_empty() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannels([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannels_0() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannels([0]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.cc
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannels_1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannels([1]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannels_2() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannels([2]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannels_3() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannels([3]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannels_15() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannels([15]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepChannels_0and1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepChannels([0, 1]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - testFilter_keepCC
    
    @Test
    func filter_keepCC_A() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCC(.expression))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCC_B() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCC(.modWheel))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCC_C() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [
            kEvents.ChanVoice.cc1
        ]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCC(.expression))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCC_D() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [
            kEvents.ChanVoice.cc1
        ]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCC(.modWheel))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCC_E() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [
            kEvents.ChanVoice.cc1
        ]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCC(.sustainPedal))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - testFilter_keepCCs
    
    @Test
    func filter_keepCCs_empty() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_11() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([.expression]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_1() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([.modWheel]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_emptyB() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_11B() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([.expression]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_1B() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([.modWheel]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_64() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([.sustainPedal]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_1and11() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([.modWheel, .expression]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn,
            kEvents.ChanVoice.cc1
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepCCs_11and64() {
        var events: [MIDIEvent] = []
        events += kEvents.ChanVoice.oneOfEachEventType
        events += [kEvents.ChanVoice.cc1]
        events += kEvents.SysCommon.oneOfEachEventType
        events += kEvents.SysEx.oneOfEachEventType
        events += kEvents.SysRealTime.oneOfEachEventType
        events += kEvents.Utility.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepCCs([.expression, .sustainPedal]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - testFilter_keepNotesInRange
    
    @Test
    func filter_keepNotesInRange_all() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRange(0 ... 127))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRange_60to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRange(60 ... 61))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRange_60to60() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRange(60 ... 60))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRange_61to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRange(61 ... 61))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRange_0to59() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRange(0 ... 59))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRange_62to127() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRange(62 ... 127))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    // MARK: - testFilter_keepNotesInRanges
    
    @Test
    func filter_keepNotesInRanges_empty() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_all() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([0 ... 127]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_60to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([60 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
            + [
                kEvents.ChanVoice.noteCC,
                kEvents.ChanVoice.notePitchBend,
                kEvents.ChanVoice.notePressure,
                kEvents.ChanVoice.noteManagement,
                kEvents.ChanVoice.cc,
                kEvents.ChanVoice.programChange,
                kEvents.ChanVoice.pitchBend,
                kEvents.ChanVoice.pressure,
                kEvents.ChanVoice.rpn,
                kEvents.ChanVoice.nrpn
            ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_60to60() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([60 ... 60]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn
        ]
            + [
                kEvents.ChanVoice.noteCC,
                kEvents.ChanVoice.notePitchBend,
                kEvents.ChanVoice.notePressure,
                kEvents.ChanVoice.noteManagement,
                kEvents.ChanVoice.cc,
                kEvents.ChanVoice.programChange,
                kEvents.ChanVoice.pitchBend,
                kEvents.ChanVoice.pressure,
                kEvents.ChanVoice.rpn,
                kEvents.ChanVoice.nrpn
            ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_61to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([61 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_0to59() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([0 ... 59]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_62to127() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([62 ... 127]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += []
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_0to10_60to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events.filter(chanVoice: .keepNotesInRanges([0 ... 10, 60 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
    
    @Test
    func filter_keepNotesInRanges_60to60_61to61() {
        let events = kEvents.oneOfEachEventType
    
        let filteredEvents = events
            .filter(chanVoice: .keepNotesInRanges([60 ... 60, 61 ... 61]))
    
        var expectedEvents: [MIDIEvent] = []
        expectedEvents += [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        expectedEvents += [
            kEvents.ChanVoice.noteCC,
            kEvents.ChanVoice.notePitchBend,
            kEvents.ChanVoice.notePressure,
            kEvents.ChanVoice.noteManagement,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.pitchBend,
            kEvents.ChanVoice.pressure,
            kEvents.ChanVoice.rpn,
            kEvents.ChanVoice.nrpn
        ]
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += kEvents.Utility.oneOfEachEventType
    
        #expect(filteredEvents == expectedEvents)
    }
}
