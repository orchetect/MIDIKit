//
//  Event Filter System Exclusive Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventFilter_SystemExclusive_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isSystemExclusive
        
        let events = kEvents.SysExclusive.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertTrue($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
        }
        
    }
    
    #warning("> add tests")
    
}

#endif
