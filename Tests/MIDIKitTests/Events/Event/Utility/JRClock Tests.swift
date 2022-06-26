//
//  JRClock Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class MIDIEventJRClock_Tests: XCTestCase {
    
    typealias JRClock = MIDI.Event.JRClock
    
    func testJRClock() {
        
        for grp: MIDI.UInt4 in 0x0...0xF {
            
            let event: MIDI.Event = .jrClock(time: 0x1234,
                                             group: grp)
            
            XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                           [[
                            MIDI.UMPWord(0x00 + grp.uInt8Value,
                                         0x10,
                                         0x12, 0x34)
                           ]])
            
        }
        
    }
    
}

#endif
