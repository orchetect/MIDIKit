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
        
        XCTAssert(Value.midi1(0)      == Value.midi1(0))
        XCTAssert(Value.midi1(0x2000) == Value.midi1(0x2000))
        XCTAssert(Value.midi1(0x3FFF) == Value.midi1(0x3FFF))
        XCTAssert(Value.midi1(0)      != Value.midi1(0x2000))
        
    }
    
    func testEquatable_midi2() {
        
        XCTAssert(Value.midi2(0)          == Value.midi2(0x0))
        XCTAssert(Value.midi2(0x80000000) == Value.midi2(0x80000000))
        XCTAssert(Value.midi2(0xFFFFFFFF) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.midi2(0)          != Value.midi2(0x80000000))
        
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
        XCTAssert(Value.unitInterval(0.0) == Value.midi1(0))
        XCTAssert(Value.unitInterval(0.5) == Value.midi1(0x2000))
        XCTAssert(Value.unitInterval(1.0) == Value.midi1(0x3FFF))
        XCTAssert(Value.unitInterval(0.0) != Value.midi1(0x2000))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.0) == Value.midi2(0x0))
        XCTAssert(Value.unitInterval(0.5) == Value.midi2(0x80000000))
        XCTAssert(Value.unitInterval(1.0) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.unitInterval(0.0) != Value.midi2(0x80000000))
        
        // bipolarUnitInterval <--> midi1
        #warning("> write test")
        
        // bipolarUnitInterval <--> midi2
        #warning("> write test")
        
        // midi1 <--> midi2
        XCTAssert(Value.midi1(0)      == Value.midi2(0x0))
        XCTAssert(Value.midi1(0x2000) == Value.midi2(0x80000000))
        XCTAssert(Value.midi1(0x3FFF) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.midi1(0)      != Value.midi2(0x80000000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.0).unitIntervalValue, 0.0)
        XCTAssertEqual(Value.unitInterval(0.5).unitIntervalValue, 0.5)
        XCTAssertEqual(Value.unitInterval(1.0).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.unitInterval(0.00).bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(Value.unitInterval(0.25).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.unitInterval(0.50).bipolarUnitIntervalValue,  0.0)
        XCTAssertEqual(Value.unitInterval(0.75).bipolarUnitIntervalValue,  0.5)
        XCTAssertEqual(Value.unitInterval(1.00).bipolarUnitIntervalValue,  1.0)
        
        XCTAssertEqual(Value.unitInterval(0.0).midi1Value, 0)
        XCTAssertEqual(Value.unitInterval(0.5).midi1Value, 0x2000)
        XCTAssertEqual(Value.unitInterval(1.0).midi1Value, 0x3FFF)
        
        XCTAssertEqual(Value.unitInterval(0.0).midi2Value, 0x0)
        XCTAssertEqual(Value.unitInterval(0.5).midi2Value, 0x80000000)
        XCTAssertEqual(Value.unitInterval(1.0).midi2Value, 0xFFFFFFFF)
        
    }
    
    func testBipolarUnitInterval_Values() {
        
        #warning("> write test")
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(0)     .unitIntervalValue, 0.0)
        XCTAssertEqual(Value.midi1(0x2000).unitIntervalValue, 0.5)
        XCTAssertEqual(Value.midi1(0x3FFF).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.midi1(0)     .bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(Value.midi1(0x2000).bipolarUnitIntervalValue,  0.0)
        XCTAssertEqual(Value.midi1(0x3FFF).bipolarUnitIntervalValue,  1.0)
        
        XCTAssertEqual(Value.midi1(0)     .midi1Value, 0)
        XCTAssertEqual(Value.midi1(0x2000).midi1Value, 0x2000)
        XCTAssertEqual(Value.midi1(0x3FFF).midi1Value, 0x3FFF)
        
        XCTAssertEqual(Value.midi1(0)     .midi2Value, 0x0)
        XCTAssertEqual(Value.midi1(0x2000).midi2Value, 0x80000000)
        XCTAssertEqual(Value.midi1(0x3FFF).midi2Value, 0xFFFFFFFF)
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x0)       .unitIntervalValue, 0.0)
        XCTAssertEqual(Value.midi2(0x80000000).unitIntervalValue, 0.5)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.midi2(0x0)       .bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(Value.midi2(0x80000000).bipolarUnitIntervalValue,  0.0)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).bipolarUnitIntervalValue,  1.0)
        
        XCTAssertEqual(Value.midi2(0x0)       .midi1Value, 0)
        XCTAssertEqual(Value.midi2(0x80000000).midi1Value, 0x2000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi1Value, 0x3FFF)
        
        XCTAssertEqual(Value.midi2(0x0)       .midi2Value, 0x0)
        XCTAssertEqual(Value.midi2(0x80000000).midi2Value, 0x80000000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi2Value, 0xFFFFFFFF)
        
    }
    
}

#endif
