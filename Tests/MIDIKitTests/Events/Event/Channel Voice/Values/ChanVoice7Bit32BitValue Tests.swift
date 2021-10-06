//
//  ChanVoice7Bit32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
import MIDIKit

class ChanVoice7Bit32BitValueTests: XCTestCase {
    
    typealias Value = MIDI.Event.ChanVoice7Bit32BitValue
    
    func testEquatable_unitInterval() {
        
        XCTAssert(Value.unitInterval(0.00) == Value.unitInterval(0.00)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.unitInterval(0.25))
        XCTAssert(Value.unitInterval(0.50) == Value.unitInterval(0.50)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.unitInterval(0.75))
        XCTAssert(Value.unitInterval(1.00) == Value.unitInterval(1.00)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.unitInterval(0.50))
        
    }
    
    func testEquatable_midi1() {
        
        XCTAssert(Value.midi1(  0) == Value.midi1(  0)) // min
        XCTAssert(Value.midi1( 32) == Value.midi1( 32))
        XCTAssert(Value.midi1( 64) == Value.midi1( 64)) // midpoint
        XCTAssert(Value.midi1( 96) == Value.midi1( 96))
        XCTAssert(Value.midi1(127) == Value.midi1(127)) // max
        XCTAssert(Value.midi1(  0) != Value.midi1( 64))
        
    }
    
    func testEquatable_midi2() {
        
        XCTAssert(Value.midi2(0x00000000) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.midi2(0x40000000) == Value.midi2(0x40000000))
        XCTAssert(Value.midi2(0x80000000) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.midi2(0xC0000000) == Value.midi2(0xC0000000))
        XCTAssert(Value.midi2(0xFFFFFFFF) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.midi2(0x00000000) != Value.midi2(0x80000000))
        
    }
    
    func testEquatable_unitInterval_Converted() {
        
        // unitInterval <--> midi1
        XCTAssert(Value.unitInterval(0.00) == Value.midi1(  0)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi1( 32))
        XCTAssert(Value.unitInterval(0.50) == Value.midi1( 64)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.midi1( 95))
        XCTAssert(Value.unitInterval(1.00) == Value.midi1(127)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi1( 64))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.00) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi2(0x40000000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.midi2(0xBFFFFFFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi2(0x80000000))
        
        // midi1 <--> midi2
        XCTAssert(Value.midi1(  0) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.midi1( 32) == Value.midi2(0x40000000))
        XCTAssert(Value.midi1( 64) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.midi1( 96) == Value.midi2(0xC1041041))
        XCTAssert(Value.midi1(127) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.midi1(  0) != Value.midi2(0x80000000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.00).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.unitInterval(0.25).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.unitInterval(0.50).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).unitIntervalValue, 0.75)
        XCTAssertEqual(Value.unitInterval(1.00).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).midi1Value,   0) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi1Value,  32)
        XCTAssertEqual(Value.unitInterval(0.50).midi1Value,  64) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi1Value,  95)
        XCTAssertEqual(Value.unitInterval(1.00).midi1Value, 127) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi2Value, 0x40000000)
        XCTAssertEqual(Value.unitInterval(0.50).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi2Value, 0xBFFFFFFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi2Value, 0xFFFFFFFF) // max
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(  0).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.midi1( 32).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi1( 64).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.midi1( 96).unitIntervalValue, 0.7539682539705822)
        XCTAssertEqual(Value.midi1(127).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.midi1(  0).midi1Value,   0) // min
        XCTAssertEqual(Value.midi1( 32).midi1Value,  32)
        XCTAssertEqual(Value.midi1( 64).midi1Value,  64) // midpoint
        XCTAssertEqual(Value.midi1( 96).midi1Value,  96)
        XCTAssertEqual(Value.midi1(127).midi1Value, 127) // max
        
        XCTAssertEqual(Value.midi1(  0).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.midi1( 32).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi1( 64).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.midi1( 96).midi2Value, 0xC1041041)
        XCTAssertEqual(Value.midi1(127).midi2Value, 0xFFFFFFFF) // max
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x00000000).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.midi2(0x40000000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi2(0x80000000).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).unitIntervalValue, 0.7500000001187436)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).midi1Value,   0) // min
        XCTAssertEqual(Value.midi2(0x40000000).midi1Value,  32)
        XCTAssertEqual(Value.midi2(0x80000000).midi1Value,  64) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).midi1Value,  96)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi1Value, 127) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.midi2(0x40000000).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi2(0x80000000).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).midi2Value, 0xC0000000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi2Value, 0xFFFFFFFF) // max
        
    }
    
}

#endif
