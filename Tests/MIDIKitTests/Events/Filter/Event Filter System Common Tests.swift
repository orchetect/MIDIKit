//
//  Event Filter System Common Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_SystemCommon_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isSystemCommon
        
        let events = kEvents.SysCommon.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertTrue($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
        }
        
        // isSystemCommon(ofType:)
        
        XCTAssertTrue(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofType: .tuneRequest)
        )
        
        XCTAssertFalse(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofType: .songPositionPointer)
        )
        
        // isSystemCommon(ofTypes:)
        
        XCTAssertTrue(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest])
        )
        
        XCTAssertTrue(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.tuneRequest, .songSelect])
        )
        
        XCTAssertFalse(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [.songSelect])
        )
        
        XCTAssertFalse(
            MIDI.Event.tuneRequest(group: 0)
                .isSystemCommon(ofTypes: [])
        )
        
    }
    
    #warning("> add tests")
    
}

#endif
