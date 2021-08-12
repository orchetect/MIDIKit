//
//  Event Filter Channel Voice Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_ChannelVoice_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isChannelVoice
        
        let events = kEvents.ChanVoice.oneOfEachEventType
        
        events.forEach {
            XCTAssertTrue($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
        }
        
        // isChannelVoice(ofType:)
        
        XCTAssertTrue(
            MIDI.Event.noteOn(note: 1, velocity: 1, channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOn)
        )
        
        XCTAssertFalse(
            MIDI.Event.noteOn(note: 1, velocity: 1, channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOff)
        )
        
        // isChannelVoice(ofTypes:)
        
        XCTAssertTrue(
            MIDI.Event.noteOn(note: 1, velocity: 1, channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn])
        )
        
        XCTAssertTrue(
            MIDI.Event.noteOn(note: 1, velocity: 1, channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn, .noteOff])
        )
        
        XCTAssertFalse(
            MIDI.Event.noteOn(note: 1, velocity: 1, channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOff, .cc])
        )
        
        XCTAssertFalse(
            MIDI.Event.noteOn(note: 1, velocity: 1, channel: 1, group: 0)
                .isChannelVoice(ofTypes: [])
        )
        
    }
    
    // MARK: - only
    
    func testFilter_ChanVoice_only() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .only)
        
        let expectedEvents = kEvents.ChanVoice.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .onlyType(.noteOn))
        
        let expectedEvents = [kEvents.ChanVoice.noteOn]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(chanVoice: .onlyTypes([.noteOn]))
        expectedEvents = [kEvents.ChanVoice.noteOn]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyTypes([.noteOn, .noteOff]))
        expectedEvents = [kEvents.ChanVoice.noteOn, kEvents.ChanVoice.noteOff]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(chanVoice: .onlyTypes([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_onlyChannel() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_onlyChannels() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_onlyCC() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_onlyCCs() {
        #warning("> write unit test")
    }
    
    // MARK: - keep
    
    func testFilter_ChanVoice_keepType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .keepType(.noteOn))
        
        let expectedEvents = [
            kEvents.ChanVoice.noteOn
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_keepTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .keepTypes([.noteOn, .noteOff]))
        
        let expectedEvents = [
            kEvents.ChanVoice.noteOn,
            kEvents.ChanVoice.noteOff
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_keepChannel() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_keepChannels() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_keepCC() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_keepCCs() {
        #warning("> write unit test")
    }
    
    // MARK: - drop
    
    func testFilter_ChanVoice_drop() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .drop)
        
        let expectedEvents =
        kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropType() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .dropType(.noteOn))
        
        let expectedEvents = [
            kEvents.ChanVoice.noteOff,
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropTypes() {
        
        let events = kEvents.oneOfEachMIDI1EventType
        
        let filteredEvents = events.filter(chanVoice: .dropTypes([.noteOn, .noteOff]))
        
        let expectedEvents = [
            kEvents.ChanVoice.polyAftertouch,
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.programChange,
            kEvents.ChanVoice.chanAftertouch,
            kEvents.ChanVoice.pitchBend
        ]
        + kEvents.SysCommon.oneOfEachEventType
        + kEvents.SysEx.oneOfEachEventType
        + kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_ChanVoice_dropChannel() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_dropChannels() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_dropCC() {
        #warning("> write unit test")
    }
    
    func testFilter_ChanVoice_dropCCs() {
        #warning("> write unit test")
    }
    
}

#endif
