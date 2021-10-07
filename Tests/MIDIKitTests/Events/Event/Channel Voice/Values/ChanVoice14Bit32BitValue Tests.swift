//
//  ChanVoice14Bit32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
import MIDIKit

class ChanVoice14Bit32BitValueTests: XCTestCase {
    
    typealias Value = MIDI.Event.ChanVoice14Bit32BitValue
    
    func testEquatable_unitInterval() {
        
        XCTAssert(Value.unitInterval(0.00) == Value.unitInterval(0.00)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.unitInterval(0.25))
        XCTAssert(Value.unitInterval(0.50) == Value.unitInterval(0.50)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.unitInterval(0.75))
        XCTAssert(Value.unitInterval(1.00) == Value.unitInterval(1.00)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.unitInterval(0.50))
        
    }
    
    func testEquatable_bipolarUnitInterval() {
        
        XCTAssert(Value.bipolarUnitInterval(-1.0) == Value.bipolarUnitInterval(-1.0)) // min
        XCTAssert(Value.bipolarUnitInterval(-0.5) == Value.bipolarUnitInterval(-0.5))
        XCTAssert(Value.bipolarUnitInterval( 0.0) == Value.bipolarUnitInterval( 0.0)) // midpoint
        XCTAssert(Value.bipolarUnitInterval( 0.5) == Value.bipolarUnitInterval( 0.5))
        XCTAssert(Value.bipolarUnitInterval( 1.0) == Value.bipolarUnitInterval( 1.0)) // max
        XCTAssert(Value.bipolarUnitInterval( 0.0) != Value.bipolarUnitInterval( 0.5))
        
    }
    
    func testEquatable_midi1() {
        
        XCTAssert(Value.midi1(0x0000) == Value.midi1(0x0000)) // min
        XCTAssert(Value.midi1(0x1000) == Value.midi1(0x1000))
        XCTAssert(Value.midi1(0x2000) == Value.midi1(0x2000)) // midpoint
        XCTAssert(Value.midi1(0x3000) == Value.midi1(0x3000))
        XCTAssert(Value.midi1(0x3FFF) == Value.midi1(0x3FFF)) // max
        XCTAssert(Value.midi1(0x0000) != Value.midi1(0x2000))
        
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
        
        // unitInterval <--> bipolarUnitInterval
        XCTAssert(Value.unitInterval(0.00) == Value.bipolarUnitInterval(-1.0)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.bipolarUnitInterval(-0.5))
        XCTAssert(Value.unitInterval(0.50) == Value.bipolarUnitInterval( 0.0)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.bipolarUnitInterval( 0.5))
        XCTAssert(Value.unitInterval(1.00) == Value.bipolarUnitInterval( 1.0)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.bipolarUnitInterval( 0.5))
        
        // unitInterval <--> midi1
        XCTAssert(Value.unitInterval(0.00) == Value.midi1(0x0000)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi1(0x1000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi1(0x2000)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.midi1(0x2FFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi1(0x3FFF)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi1(0x2000))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.00) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi2(0x40000000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.midi2(0xBFFFFFFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi2(0x80000000))
        
        // bipolarUnitInterval <--> midi1
        XCTAssert(Value.bipolarUnitInterval(-1.0) == Value.midi1(0x0000)) // min
        XCTAssert(Value.bipolarUnitInterval(-0.5) == Value.midi1(0x1000))
        XCTAssert(Value.bipolarUnitInterval( 0.0) == Value.midi1(0x2000)) // midpoint
        XCTAssert(Value.bipolarUnitInterval( 0.5) == Value.midi1(0x2FFF))
        XCTAssert(Value.bipolarUnitInterval( 1.0) == Value.midi1(0x3FFF)) // max
        XCTAssert(Value.bipolarUnitInterval( 0.5) != Value.midi1(0x2000))
        
        // bipolarUnitInterval <--> midi2
        XCTAssert(Value.bipolarUnitInterval(-1.0) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.bipolarUnitInterval(-0.5) == Value.midi2(0x40000000))
        XCTAssert(Value.bipolarUnitInterval( 0.0) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.bipolarUnitInterval( 0.5) == Value.midi2(0xBFFFFFFF))
        XCTAssert(Value.bipolarUnitInterval( 1.0) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.bipolarUnitInterval( 0.5) != Value.midi2(0xFFFFFFFF))
        
        // midi1 <--> midi2
        XCTAssert(Value.midi1(0x0000) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.midi1(0x1000) == Value.midi2(0x40000000))
        XCTAssert(Value.midi1(0x2000) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.midi1(0x3000) == Value.midi2(0xC0020010))
        XCTAssert(Value.midi1(0x3FFF) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.midi1(0x0000) != Value.midi2(0x80000000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.00).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.unitInterval(0.25).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.unitInterval(0.50).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).unitIntervalValue, 0.75)
        XCTAssertEqual(Value.unitInterval(1.00).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).bipolarUnitIntervalValue, -1.0) // min
        XCTAssertEqual(Value.unitInterval(0.25).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.unitInterval(0.50).bipolarUnitIntervalValue,  0.0) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).bipolarUnitIntervalValue,  0.5)
        XCTAssertEqual(Value.unitInterval(1.00).bipolarUnitIntervalValue,  1.0) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).midi1Value, 0x0000) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi1Value, 0x1000)
        XCTAssertEqual(Value.unitInterval(0.50).midi1Value, 0x2000) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi1Value, 0x2FFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi1Value, 0x3FFF) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi2Value, 0x40000000)
        XCTAssertEqual(Value.unitInterval(0.50).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi2Value, 0xBFFFFFFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi2Value, 0xFFFFFFFF) // max
        
    }
    
    func testBipolarUnitInterval_Values() {
        
        XCTAssertEqual(Value.bipolarUnitInterval(-1.0).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.bipolarUnitInterval(-0.5).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.bipolarUnitInterval( 0.0).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.bipolarUnitInterval( 0.5).unitIntervalValue, 0.75)
        XCTAssertEqual(Value.bipolarUnitInterval( 1.0).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.bipolarUnitInterval(-1.0).bipolarUnitIntervalValue, -1.0) // min
        XCTAssertEqual(Value.bipolarUnitInterval(-0.5).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.bipolarUnitInterval( 0.0).bipolarUnitIntervalValue,  0.0) // midpoint
        XCTAssertEqual(Value.bipolarUnitInterval( 0.5).bipolarUnitIntervalValue,  0.5)
        XCTAssertEqual(Value.bipolarUnitInterval( 1.0).bipolarUnitIntervalValue,  1.0) // max
        
        XCTAssertEqual(Value.bipolarUnitInterval(-1.0).midi1Value, 0x0000) // min
        XCTAssertEqual(Value.bipolarUnitInterval(-0.5).midi1Value, 0x1000)
        XCTAssertEqual(Value.bipolarUnitInterval( 0.0).midi1Value, 0x2000) // midpoint
        XCTAssertEqual(Value.bipolarUnitInterval( 0.5).midi1Value, 0x2FFF)
        XCTAssertEqual(Value.bipolarUnitInterval( 1.0).midi1Value, 0x3FFF) // max
        
        XCTAssertEqual(Value.bipolarUnitInterval(-1.0).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.bipolarUnitInterval(-0.5).midi2Value, 0x40000000)
        XCTAssertEqual(Value.bipolarUnitInterval( 0.0).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.bipolarUnitInterval( 0.5).midi2Value, 0xBFFFFFFF)
        XCTAssertEqual(Value.bipolarUnitInterval( 1.0).midi2Value, 0xFFFFFFFF) // max
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(0x0000).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.midi1(0x1000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi1(0x2000).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.midi1(0x3000).unitIntervalValue, 0.7500305213061984)
        XCTAssertEqual(Value.midi1(0x3FFF).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.midi1(0x0000).bipolarUnitIntervalValue, -1.0) // min
        XCTAssertEqual(Value.midi1(0x1000).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.midi1(0x2000).bipolarUnitIntervalValue,  0.0) // midpoint
        XCTAssertEqual(Value.midi1(0x3000).bipolarUnitIntervalValue,  0.5000610426077402)
        XCTAssertEqual(Value.midi1(0x3FFF).bipolarUnitIntervalValue,  1.0) // max
        
        XCTAssertEqual(Value.midi1(0x0000).midi1Value, 0x0000) // min
        XCTAssertEqual(Value.midi1(0x1000).midi1Value, 0x1000)
        XCTAssertEqual(Value.midi1(0x2000).midi1Value, 0x2000) // midpoint
        XCTAssertEqual(Value.midi1(0x3000).midi1Value, 0x3000)
        XCTAssertEqual(Value.midi1(0x3FFF).midi1Value, 0x3FFF) // max
        
        XCTAssertEqual(Value.midi1(0x0000).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.midi1(0x1000).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi1(0x2000).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.midi1(0x3000).midi2Value, 0xC0020010)
        XCTAssertEqual(Value.midi1(0x3FFF).midi2Value, 0xFFFFFFFF) // max
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x00000000).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.midi2(0x40000000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi2(0x80000000).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).unitIntervalValue, 0.7500000001187436)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).bipolarUnitIntervalValue, -1.0) // min
        XCTAssertEqual(Value.midi2(0x40000000).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.midi2(0x80000000).bipolarUnitIntervalValue,  0.0) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).bipolarUnitIntervalValue,  0.5000000002328306)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).bipolarUnitIntervalValue,  1.0) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).midi1Value, 0x0000) // min
        XCTAssertEqual(Value.midi2(0x40000000).midi1Value, 0x1000)
        XCTAssertEqual(Value.midi2(0x80000000).midi1Value, 0x2000) // midpoint
        XCTAssertEqual(Value.midi2(0xC0020010).midi1Value, 0x3000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi1Value, 0x3FFF) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.midi2(0x40000000).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi2(0x80000000).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).midi2Value, 0xC0000000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi2Value, 0xFFFFFFFF) // max
        
    }
    
}

#endif
