//
//  JRTimestamp Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class MIDIEventJRTimestamp_Tests: XCTestCase {
    
    typealias JRTimestamp = MIDI.Event.JRTimestamp
    
    func testJRTimestamp() {
        
        for grp: MIDI.UInt4 in 0x0...0xF {
            
            let event: MIDI.Event = .jrTimestamp(time: 0x1234,
                                                 group: grp)
            
            XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                           [[
                            MIDI.UMPWord(0x00 + grp.uInt8Value,
                                         0x20,
                                         0x12, 0x34)
                           ]])
            
        }
        
    }
    
}

#endif
