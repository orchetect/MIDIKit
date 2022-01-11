//
//  Byte Pair Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

final class Byte_Pair_Tests: XCTestCase {
    
    func testUInt16Value_A() {
        
        let pair = MIDI.Byte.Pair(msb: 0xFF, lsb: 0xFF)
        
        let uInt16 = pair.uInt16Value
        
        XCTAssertEqual(uInt16, UInt16.max)
        
    }
    
    func testUInt16Value_B() {
        
        let pair = MIDI.Byte.Pair(msb: 0x12, lsb: 0x34)
        
        let uInt16 = pair.uInt16Value
        
        XCTAssertEqual(uInt16, 0x1234)
        
    }
    
}

#endif
