//
//  MIDIEvent Filter Channel Voice Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class MIDIEvent_Filter_ChannelVoice_Tests: XCTestCase {
    func testMetadata() {
        // isChannelVoice
    
        let events = kEvents.ChanVoice.oneOfEachEventType
    
        events.forEach {
            XCTAssertTrue($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
            XCTAssertFalse($0.isUtility)
        }
    
        // isChannelVoice(ofType:)
    
        XCTAssertTrue(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOn)
        )
    
        XCTAssertFalse(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofType: .noteOff)
        )
    
        // isChannelVoice(ofTypes:)
    
        XCTAssertTrue(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn])
        )
    
        XCTAssertTrue(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOn, .noteOff])
        )
    
        XCTAssertFalse(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [.noteOff, .cc])
        )
    
        XCTAssertFalse(
            MIDIEvent.noteOn(1, velocity: .unitInterval(1.0), channel: 1, group: 0)
                .isChannelVoice(ofTypes: [])
        )
    }
    
    // MARK: - Convenience Static Constructors
    
    func testOnlyCC_ControllerNumber() {
        let events = [
            kEvents.ChanVoice.cc,
            kEvents.ChanVoice.noteOn
        ]
    
        XCTAssertEqual(
            events.filter(chanVoice: .onlyCC(2)),
            []
        )
        XCTAssertEqual(
            events.filter(chanVoice: .onlyCC(11)),
            [kEvents.ChanVoice.cc]
        )
    
        XCTAssertEqual(
            events.filter(chanVoice: .onlyCCs([2])),
            []
        )
        XCTAssertEqual(
            events.filter(chanVoice: .onlyCCs([11])),
            [kEvents.ChanVoice.cc]
        )
    
        XCTAssertEqual(
            events.filter(chanVoice: .keepCC(2)),
            [kEvents.ChanVoice.noteOn]
        )
        XCTAssertEqual(
            events.filter(chanVoice: .keepCC(11)),
            [
                kEvents.ChanVoice.cc,
                kEvents.ChanVoice.noteOn
            ]
        )
    
        XCTAssertEqual(
            events.filter(chanVoice: .keepCCs([2])),
            [kEvents.ChanVoice.noteOn]
        )
        XCTAssertEqual(
            events.filter(chanVoice: .keepCCs([11])),
            [
                kEvents.ChanVoice.cc,
                kEvents.ChanVoice.noteOn
            ]
        )
    
        XCTAssertEqual(
            events.filter(chanVoice: .dropCC(2)),
            [
                kEvents.ChanVoice.cc,
                kEvents.ChanVoice.noteOn
            ]
        )
        XCTAssertEqual(
            events.filter(chanVoice: .dropCC(11)),
            [kEvents.ChanVoice.noteOn]
        )
    
        XCTAssertEqual(
            events.filter(chanVoice: .dropCCs([2])),
            [
                kEvents.ChanVoice.cc,
                kEvents.ChanVoice.noteOn
            ]
        )
        XCTAssertEqual(
            events.filter(chanVoice: .dropCCs([11])),
            [kEvents.ChanVoice.noteOn]
        )
    }
}

#endif
