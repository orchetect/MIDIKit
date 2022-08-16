//
//  UInt7Pair Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCommon

final class UInt7Pair_Tests: XCTestCase {
    func testUInt14Value() {
        let pair = UInt7Pair(msb: 0x7F, lsb: 0x7F)
    
        let uInt14 = pair.uInt14Value
    
        XCTAssertEqual(uInt14, UInt14.max)
    }
}

#endif
