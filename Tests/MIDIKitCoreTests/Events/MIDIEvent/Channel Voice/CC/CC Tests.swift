//
//  CC Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_CC_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    typealias CC = MIDIEvent.NoteCC
    
    @Test
    func ccNum() {
        for ccNum: UInt7 in 0 ... 127 {
            let cc: MIDIEvent = .cc(
                ccNum,
                value: .midi1(64),
                channel: 0
            )
            
            #expect(
                cc.midi1RawBytes() ==
                [0xB0, ccNum.uInt8Value, 64]
            )
        }
    }
    
    @Test
    func ccEnum() {
        for ccNum: UInt7 in 0 ... 127 {
            let controller = MIDIEvent.CC.Controller(number: ccNum)
            
            let cc: MIDIEvent = .cc(
                controller,
                value: .midi1(64),
                channel: 0
            )
            
            #expect(
                cc.midi1RawBytes() ==
                [0xB0, ccNum.uInt8Value, 64]
            )
        }
    }
}
