//
//  CC Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEventCC_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    typealias CC = MIDIEvent.Note.CC
    
    func testCCNum() {
        for ccNum: UInt7 in 0 ... 127 {
            let cc: MIDIEvent = .cc(
                ccNum,
                value: .midi1(64),
                channel: 0
            )
            
            XCTAssertEqual(
                cc.midi1RawBytes(),
                [0xB0, ccNum.uInt8Value, 64]
            )
        }
    }
    
    func testCCEnum() {
        for ccNum: UInt7 in 0 ... 127 {
            let controller = MIDIEvent.CC.Controller(number: ccNum)
            
            let cc: MIDIEvent = .cc(
                controller,
                value: .midi1(64),
                channel: 0
            )
            
            XCTAssertEqual(
                cc.midi1RawBytes(),
                [0xB0, ccNum.uInt8Value, 64]
            )
        }
    }
}

#endif
