//
//  NoOp Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class MIDIEventNoOp_Tests: XCTestCase {
    
    typealias NoOp = MIDI.Event.NoOp
    
    func testNoOp() {
        
        for grp: MIDI.UInt4 in 0x0...0xF {
            
            let event: MIDI.Event = .noOp(group: grp)
            
            XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                           [[
                            MIDI.UMPWord(0x00 + grp.uInt8Value,
                                         0x00,
                                         0x00, 0x00)
                           ]])
            
        }
        
    }
    
}

#endif
