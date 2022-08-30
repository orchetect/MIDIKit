//
//  JRTimestamp Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitCore

final class MIDIEventJRTimestamp_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    
    typealias JRTimestamp = MIDIEvent.JRTimestamp
    
    func testJRTimestamp() {
        for grp: UInt4 in 0x0 ... 0xF {
            let event: MIDIEvent = .jrTimestamp(
                time: 0x1234,
                group: grp
            )
    
            XCTAssertEqual(
                event.umpRawWords(protocol: ._2_0),
                [[
                    UMPWord(
                        0x00 + grp.uInt8Value,
                        0x20,
                        0x12,
                        0x34
                    )
                ]]
            )
        }
    }
}

#endif
