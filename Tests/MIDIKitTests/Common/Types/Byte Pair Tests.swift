//
//  Byte Pair Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class Byte_Pair_Tests: XCTestCase {
    
    func testInit_msb_lsb() {
        
        let pair = MIDI.Byte.Pair(msb: 0x12, lsb: 0x34)
        
        XCTAssertEqual(pair.msb, 0x12)
        XCTAssertEqual(pair.lsb, 0x34)
        
    }
    
    func testInit_UInt16() {
        
        let pair = MIDI.Byte.Pair(0x1234)
        
        XCTAssertEqual(pair.msb, 0x12)
        XCTAssertEqual(pair.lsb, 0x34)
        
    }
    
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
    
    // MARK: - UInt16 Category Methods
    
    func testUInt16_Init_bytePair() {
        
        let pair = MIDI.Byte.Pair(msb: 0xFF, lsb: 0xFF)
        
        let uInt16 = UInt16(bytePair: pair)
        
        XCTAssertEqual(uInt16, UInt16.max)
        
    }
    
    func testUInt16_bytePair() {
        
        let pair: MIDI.Byte.Pair = UInt16(0x1234).bytePair
        
        XCTAssertEqual(pair.msb, 0x12)
        XCTAssertEqual(pair.lsb, 0x34)
        
    }
    
}

#endif
