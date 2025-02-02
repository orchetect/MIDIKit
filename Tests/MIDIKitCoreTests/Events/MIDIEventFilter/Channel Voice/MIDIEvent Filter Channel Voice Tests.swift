//
//  MIDIEvent Filter Channel Voice Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_Filter_ChannelVoice_Tests {
    @Test
    func Metadata() {
        // isChannelVoice
        
        let events = kEvents.ChanVoice.oneOfEachEventType
        
        for event in events {
            #expect(event.isChannelVoice)
            #expect(!event.isSystemCommon)
            #expect(!event.isSystemExclusive)
            #expect(!event.isSystemRealTime)
            #expect(!event.isUtility)
        }
        
        // isChannelVoice(ofType:)
        
        #expect(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOn)
        )
        
        #expect(
            !MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOff)
        )
        
        // isChannelVoice(ofTypes:)
        
        #expect(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn])
        )
        
        #expect(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn, .noteOff])
        )
        
        #expect(
            !MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOff, .cc])
        )
        
        #expect(
            !MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [])
        )
    }
    
    // MARK: - Convenience Static Constructors
    
    @Test
    func OnlyCC_ControllerNumber() {
        let events = [
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.noteOn
        ]
        
        #expect(
            events.filter(chanVoice: .onlyCC(2)) ==
                []
        )
        #expect(
            events.filter(chanVoice: .onlyCC(11)) ==
                [kEvents.ChanVoice.cc]
        )
        
        #expect(
            events.filter(chanVoice: .onlyCCs([2])) ==
                []
        )
        #expect(
            events.filter(chanVoice: .onlyCCs([11])) ==
                [kEvents.ChanVoice.cc]
        )
        
        #expect(
            events.filter(chanVoice: .keepCC(2)) ==
                [kEvents.ChanVoice.noteOn]
        )
        #expect(
            events.filter(chanVoice: .keepCC(11)) ==
                [
                    kEvents.ChanVoice.cc,
                    kEvents.ChanVoice.noteOn
                ]
        )
        
        #expect(
            events.filter(chanVoice: .keepCCs([2])) ==
                [kEvents.ChanVoice.noteOn]
        )
        #expect(
            events.filter(chanVoice: .keepCCs([11])) ==
                [
                    kEvents.ChanVoice.cc,
                    kEvents.ChanVoice.noteOn
                ]
        )
        
        #expect(
            events.filter(chanVoice: .dropCC(2)) ==
                [
                    kEvents.ChanVoice.cc,
                    kEvents.ChanVoice.noteOn
                ]
        )
        #expect(
            events.filter(chanVoice: .dropCC(11)) ==
                [kEvents.ChanVoice.noteOn]
        )
        
        #expect(
            events.filter(chanVoice: .dropCCs([2])) ==
                [
                    kEvents.ChanVoice.cc,
                    kEvents.ChanVoice.noteOn
                ]
        )
        #expect(
            events.filter(chanVoice: .dropCCs([11])) ==
                [kEvents.ChanVoice.noteOn]
        )
    }
}
