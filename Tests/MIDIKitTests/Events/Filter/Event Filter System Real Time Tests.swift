//
//  Event Filter System Real Time Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_SystemRealTime_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isSystemRealTime
        
        let events = kEvents.SysRealTime.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertTrue($0.isSystemRealTime)
        }
        
        // isSystemRealTime(ofType:)
        
        XCTAssertTrue(
            MIDI.Event.timingClock(group: 0)
            .isSystemRealTime(ofType: .timingClock)
        )
        
        XCTAssertFalse(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofType: .start)
        )
        
        // isSystemRealTime(ofTypes:)
        
        XCTAssertTrue(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock])
        )
        
        XCTAssertTrue(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.timingClock, .start])
        )
        
        XCTAssertFalse(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [.start])
        )
        
        XCTAssertFalse(
            MIDI.Event.timingClock(group: 0)
                .isSystemRealTime(ofTypes: [])
        )
        
    }
    
    #warning("> add tests")
    
}

#endif
