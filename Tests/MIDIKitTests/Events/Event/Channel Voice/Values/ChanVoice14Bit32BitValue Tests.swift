//
//  PitchBend Value Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
import MIDIKit

class ChanVoice14Bit32BitValueTests: XCTestCase {
    
    typealias Value = MIDI.Event.ChanVoice14Bit32BitValue
    
    func testEquatable_unitInterval() {
        
        XCTAssert(Value.unitInterval(0.0) == Value.unitInterval(0.0))
        XCTAssert(Value.unitInterval(0.5) == Value.unitInterval(0.5))
        XCTAssert(Value.unitInterval(1.0) == Value.unitInterval(1.0))
        XCTAssert(Value.unitInterval(0.0) != Value.unitInterval(0.5))
        
    }
    
    func testEquatable_bipolarUnitInterval() {
        
        XCTAssert(Value.bipolarUnitInterval(-1.0) == Value.bipolarUnitInterval(-1.0))
        XCTAssert(Value.bipolarUnitInterval(-0.5) == Value.bipolarUnitInterval(-0.5))
        XCTAssert(Value.bipolarUnitInterval( 0.0) == Value.bipolarUnitInterval( 0.0))
        XCTAssert(Value.bipolarUnitInterval( 0.5) == Value.bipolarUnitInterval( 0.5))
        XCTAssert(Value.bipolarUnitInterval( 1.0) == Value.bipolarUnitInterval( 1.0))
        XCTAssert(Value.bipolarUnitInterval( 0.0) != Value.bipolarUnitInterval( 0.5))
        
    }
    
    func testEquatable_midi1() {
        
        XCTAssert(Value.midi1(0x0000) == Value.midi1(0x0000))
        XCTAssert(Value.midi1(0x2000) == Value.midi1(0x2000))
        XCTAssert(Value.midi1(0x3FFF) == Value.midi1(0x3FFF))
        XCTAssert(Value.midi1(0x0000) != Value.midi1(0x2000))
        
    }
    
    func testEquatable_midi2() {
        
        XCTAssert(Value.midi2(0x00000000) == Value.midi2(0x00000000))
        XCTAssert(Value.midi2(0x80000000) == Value.midi2(0x80000000))
        XCTAssert(Value.midi2(0xFFFFFFFF) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.midi2(0x00000000) != Value.midi2(0x80000000))
        
    }
    
    func testEquatable_unitInterval_Converted() {
        
        // unitInterval <--> bipolarUnitInterval
        XCTAssert(Value.unitInterval(0.00) == Value.bipolarUnitInterval(-1.0))
        XCTAssert(Value.unitInterval(0.25) == Value.bipolarUnitInterval(-0.5))
        XCTAssert(Value.unitInterval(0.50) == Value.bipolarUnitInterval( 0.0))
        XCTAssert(Value.unitInterval(0.75) == Value.bipolarUnitInterval( 0.5))
        XCTAssert(Value.unitInterval(1.00) == Value.bipolarUnitInterval( 1.0))
        XCTAssert(Value.unitInterval(0.00) != Value.bipolarUnitInterval( 0.5))
        
        // unitInterval <--> midi1
        XCTAssert(Value.unitInterval(0.00) == Value.midi1(0x0000))
        XCTAssert(Value.unitInterval(0.25) == Value.midi1(0x1000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi1(0x2000))
        XCTAssert(Value.unitInterval(0.75) == Value.midi1(0x2FFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi1(0x3FFF))
        XCTAssert(Value.unitInterval(0.00) != Value.midi1(0x2000))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.00) == Value.midi2(0x00000000))
        XCTAssert(Value.unitInterval(0.25) == Value.midi2(0x40000000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi2(0x80000000))
        XCTAssert(Value.unitInterval(0.75) == Value.midi2(0xBFFFFFFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.unitInterval(0.00) != Value.midi2(0x80000000))
        
        // bipolarUnitInterval <--> midi1
        #warning("> write test")
        
        // bipolarUnitInterval <--> midi2
        #warning("> write test")
        
        // midi1 <--> midi2
        XCTAssert(Value.midi1(0x0000) == Value.midi2(0x00000000))
        XCTAssert(Value.midi1(0x1000) == Value.midi2(0x40000000))
        XCTAssert(Value.midi1(0x2000) == Value.midi2(0x80000000))
        XCTAssert(Value.midi1(0x3000) == Value.midi2(0xC0020010))
        XCTAssert(Value.midi1(0x3FFF) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.midi1(0x0000) != Value.midi2(0x80000000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.00).unitIntervalValue, 0.00)
        XCTAssertEqual(Value.unitInterval(0.25).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.unitInterval(0.50).unitIntervalValue, 0.50)
        XCTAssertEqual(Value.unitInterval(0.75).unitIntervalValue, 0.75)
        XCTAssertEqual(Value.unitInterval(1.00).unitIntervalValue, 1.00)
        
        XCTAssertEqual(Value.unitInterval(0.00).bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(Value.unitInterval(0.25).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.unitInterval(0.50).bipolarUnitIntervalValue,  0.0)
        XCTAssertEqual(Value.unitInterval(0.75).bipolarUnitIntervalValue,  0.5)
        XCTAssertEqual(Value.unitInterval(1.00).bipolarUnitIntervalValue,  1.0)
        
        XCTAssertEqual(Value.unitInterval(0.00).midi1Value, 0x0000)
        XCTAssertEqual(Value.unitInterval(0.25).midi1Value, 0x1000)
        XCTAssertEqual(Value.unitInterval(0.50).midi1Value, 0x2000)
        XCTAssertEqual(Value.unitInterval(0.75).midi1Value, 0x2FFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi1Value, 0x3FFF)
        
        XCTAssertEqual(Value.unitInterval(0.00).midi2Value, 0x00000000)
        XCTAssertEqual(Value.unitInterval(0.25).midi2Value, 0x40000000)
        XCTAssertEqual(Value.unitInterval(0.50).midi2Value, 0x80000000)
        XCTAssertEqual(Value.unitInterval(0.75).midi2Value, 0xBFFFFFFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi2Value, 0xFFFFFFFF)
        
    }
    
    func testBipolarUnitInterval_Values() {
        
        #warning("> write test")
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(0x0000).unitIntervalValue, 0.00)
        XCTAssertEqual(Value.midi1(0x1000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi1(0x2000).unitIntervalValue, 0.50)
        XCTAssertEqual(Value.midi1(0x3000).unitIntervalValue, 0.7500305213061984)
        XCTAssertEqual(Value.midi1(0x3FFF).unitIntervalValue, 1.00)
        
        XCTAssertEqual(Value.midi1(0x0000).bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(Value.midi1(0x1000).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.midi1(0x2000).bipolarUnitIntervalValue,  0.0)
        XCTAssertEqual(Value.midi1(0x3000).bipolarUnitIntervalValue,  0.5000610426077402)
        XCTAssertEqual(Value.midi1(0x3FFF).bipolarUnitIntervalValue,  1.0)
        
        XCTAssertEqual(Value.midi1(0x0000).midi1Value, 0x0000)
        XCTAssertEqual(Value.midi1(0x1000).midi1Value, 0x1000)
        XCTAssertEqual(Value.midi1(0x2000).midi1Value, 0x2000)
        XCTAssertEqual(Value.midi1(0x3000).midi1Value, 0x3000)
        XCTAssertEqual(Value.midi1(0x3FFF).midi1Value, 0x3FFF)
        
        XCTAssertEqual(Value.midi1(0x0000).midi2Value, 0x00000000)
        XCTAssertEqual(Value.midi1(0x1000).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi1(0x2000).midi2Value, 0x80000000)
        XCTAssertEqual(Value.midi1(0x3000).midi2Value, 0xC0020010)
        XCTAssertEqual(Value.midi1(0x3FFF).midi2Value, 0xFFFFFFFF)
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x00000000).unitIntervalValue, 0.00)
        XCTAssertEqual(Value.midi2(0x40000000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi2(0x80000000).unitIntervalValue, 0.50)
        XCTAssertEqual(Value.midi2(0xC0000000).unitIntervalValue, 0.7500000001187436)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).unitIntervalValue, 1.00)
        
        XCTAssertEqual(Value.midi2(0x00000000).bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(Value.midi2(0x40000000).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.midi2(0x80000000).bipolarUnitIntervalValue,  0.0)
        XCTAssertEqual(Value.midi2(0xC0000000).bipolarUnitIntervalValue,  0.5000000002328306)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).bipolarUnitIntervalValue,  1.0)
        
        XCTAssertEqual(Value.midi2(0x00000000).midi1Value, 0x0000)
        XCTAssertEqual(Value.midi2(0x40000000).midi1Value, 0x1000)
        XCTAssertEqual(Value.midi2(0x80000000).midi1Value, 0x2000)
        XCTAssertEqual(Value.midi2(0xC0020010).midi1Value, 0x3000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi1Value, 0x3FFF)
        
        XCTAssertEqual(Value.midi2(0x00000000).midi2Value, 0x00000000)
        XCTAssertEqual(Value.midi2(0x40000000).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi2(0x80000000).midi2Value, 0x80000000)
        XCTAssertEqual(Value.midi2(0xC0000000).midi2Value, 0xC0000000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi2Value, 0xFFFFFFFF)
        
    }
    
}

#endif
