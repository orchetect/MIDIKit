//
//  JRClock Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitCore
import Testing

@Suite struct MIDIEventJRClock_Tests {
    // swiftformat:options --wrapcollections preserve
    
    typealias JRClock = MIDIEvent.JRClock
    
    @Test
    func jrClock() {
        for grp: UInt4 in 0x0 ... 0xF {
            let event: MIDIEvent = .jrClock(
                time: 0x1234,
                group: grp
            )
            
            #expect(
                event.umpRawWords(protocol: .midi2_0) ==
                    [[
                        UMPWord(
                            0x00 + grp.uInt8Value,
                            0x10,
                            0x12,
                            0x34
                        )
                    ]]
            )
        }
    }
}
