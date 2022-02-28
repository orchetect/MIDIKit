//
//  UInt7 Pair Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class UInt7_Pair_Tests: XCTestCase {
    
    func testUInt14Value() {
        
        let pair = MIDI.UInt7.Pair(msb: 0x7F, lsb: 0x7F)
        
        let uInt14 = pair.uInt14Value
        
        XCTAssertEqual(uInt14, MIDI.UInt14.max)
        
    }
    
}

#endif
