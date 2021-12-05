//
//  CC Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventCC_Tests: XCTestCase {
    
    typealias CC = MIDI.Event.Note.CC
    
    func testCCNum() {
        
        for ccNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .cc(ccNum,
                                     value: .midi1(64),
                                     channel: 0)
            
            XCTAssertEqual(cc.midi1RawBytes, [0xB0, ccNum.uInt8Value, 64])
            
        }
        
    }
    
    func testCCEnum() {
        
        for ccNum: MIDI.UInt7 in 0...127 {
            
            let controller = MIDI.Event.CC.Controller(number: ccNum)
            
            let cc: MIDI.Event = .cc(controller,
                                     value: .midi1(64),
                                     channel: 0)
            
            XCTAssertEqual(cc.midi1RawBytes, [0xB0, ccNum.uInt8Value, 64])
            
        }
        
    }
    
}

#endif
