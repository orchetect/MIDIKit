//
//  JRClock Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitCore

final class MIDIEventJRClock_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    
    typealias JRClock = MIDIEvent.JRClock
    
    func testJRClock() {
        for grp: UInt4 in 0x0 ... 0xF {
            let event: MIDIEvent = .jrClock(
                time: 0x1234,
                group: grp
            )
    
            XCTAssertEqual(
                event.umpRawWords(protocol: ._2_0),
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

#endif
