//
//  ChanVoice7Bit16BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class ChanVoice7Bit16BitValueTests: XCTestCase {
    
    typealias Value = MIDI.Event.ChanVoice7Bit16BitValue
    
    func testEquatable_unitInterval() {
        
        XCTAssert(Value.unitInterval(0.0) == Value.unitInterval(0.0))
        XCTAssert(Value.unitInterval(0.5) == Value.unitInterval(0.5))
        XCTAssert(Value.unitInterval(1.0) == Value.unitInterval(1.0))
        XCTAssert(Value.unitInterval(0.0) != Value.unitInterval(0.5))
        
    }
    
    func testEquatable_midi1() {
        
        XCTAssert(Value.midi1(  0) == Value.midi1(  0))
        XCTAssert(Value.midi1( 64) == Value.midi1( 64))
        XCTAssert(Value.midi1(127) == Value.midi1(127))
        XCTAssert(Value.midi1(  0) != Value.midi1( 64))
        
    }
    
    func testEquatable_midi2() {
        
        XCTAssert(Value.midi2(0)      == Value.midi2(0x0000))
        XCTAssert(Value.midi2(0x8000) == Value.midi2(0x8000))
        XCTAssert(Value.midi2(0xFFFF) == Value.midi2(0xFFFF))
        XCTAssert(Value.midi2(0)      != Value.midi2(0x8000))
        
    }
    
    func testEquatable_unitInterval_Converted() {
        
        // unitInterval <--> midi1
        XCTAssert(Value.unitInterval(0.00) == Value.midi1(  0))
        XCTAssert(Value.unitInterval(0.25) == Value.midi1( 32))
        XCTAssert(Value.unitInterval(0.50) == Value.midi1( 64))
        XCTAssert(Value.unitInterval(1.00) == Value.midi1(127))
        XCTAssert(Value.unitInterval(0.00) != Value.midi1( 64))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.00) == Value.midi2(0x0000))
        XCTAssert(Value.unitInterval(0.25) == Value.midi2(0x4000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi2(0x8000))
        XCTAssert(Value.unitInterval(0.75) == Value.midi2(0xBFFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi2(0xFFFF))
        XCTAssert(Value.unitInterval(0.00) != Value.midi2(0x8000))
        
        // midi1 <--> midi2
        XCTAssert(Value.midi1(  0) == Value.midi2(0x0000))
        XCTAssert(Value.midi1( 32) == Value.midi2(0x4000))
        XCTAssert(Value.midi1( 64) == Value.midi2(0x8000))
        XCTAssert(Value.midi1( 96) == Value.midi2(0xC104))
        XCTAssert(Value.midi1(127) == Value.midi2(0xFFFF))
        XCTAssert(Value.midi1(  0) != Value.midi2(0x8000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.00).unitIntervalValue, 0.00)
        XCTAssertEqual(Value.unitInterval(0.25).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.unitInterval(0.50).unitIntervalValue, 0.50)
        XCTAssertEqual(Value.unitInterval(0.75).unitIntervalValue, 0.75)
        XCTAssertEqual(Value.unitInterval(1.00).unitIntervalValue, 1.00)
        
        XCTAssertEqual(Value.unitInterval(0.00).midi1Value,   0)
        XCTAssertEqual(Value.unitInterval(0.25).midi1Value,  32)
        XCTAssertEqual(Value.unitInterval(0.50).midi1Value,  64)
        XCTAssertEqual(Value.unitInterval(0.75).midi1Value,  95)
        XCTAssertEqual(Value.unitInterval(1.00).midi1Value, 127)
        
        XCTAssertEqual(Value.unitInterval(0.00).midi2Value, 0x0000)
        XCTAssertEqual(Value.unitInterval(0.25).midi2Value, 0x4000)
        XCTAssertEqual(Value.unitInterval(0.50).midi2Value, 0x8000)
        XCTAssertEqual(Value.unitInterval(0.75).midi2Value, 0xBFFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi2Value, 0xFFFF)
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(  0).unitIntervalValue, 0.00)
        XCTAssertEqual(Value.midi1( 32).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi1( 64).unitIntervalValue, 0.50)
        XCTAssertEqual(Value.midi1( 96).unitIntervalValue, 0.7539682539705822)
        XCTAssertEqual(Value.midi1(127).unitIntervalValue, 1.00)
        
        XCTAssertEqual(Value.midi1(  0).midi1Value,   0)
        XCTAssertEqual(Value.midi1( 32).midi1Value,  32)
        XCTAssertEqual(Value.midi1( 64).midi1Value,  64)
        XCTAssertEqual(Value.midi1( 96).midi1Value,  96)
        XCTAssertEqual(Value.midi1(127).midi1Value, 127)
        
        XCTAssertEqual(Value.midi1(  0).midi2Value, 0x0000)
        XCTAssertEqual(Value.midi1( 32).midi2Value, 0x4000)
        XCTAssertEqual(Value.midi1( 64).midi2Value, 0x8000)
        XCTAssertEqual(Value.midi1( 96).midi2Value, 0xC104)
        XCTAssertEqual(Value.midi1(127).midi2Value, 0xFFFF)
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x0000).unitIntervalValue, 0.00)
        XCTAssertEqual(Value.midi2(0x4000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi2(0x8000).unitIntervalValue, 0.50)
        XCTAssertEqual(Value.midi2(0xC000).unitIntervalValue, 0.7500076296296972)
        XCTAssertEqual(Value.midi2(0xFFFF).unitIntervalValue, 1.00)
        
        XCTAssertEqual(Value.midi2(0x0000).midi1Value,   0)
        XCTAssertEqual(Value.midi2(0x4000).midi1Value,  32)
        XCTAssertEqual(Value.midi2(0x8000).midi1Value,  64)
        XCTAssertEqual(Value.midi2(0xC000).midi1Value,  96)
        XCTAssertEqual(Value.midi2(0xFFFF).midi1Value, 127)
        
        XCTAssertEqual(Value.midi2(0x0000).midi2Value, 0x0000)
        XCTAssertEqual(Value.midi2(0x4000).midi2Value, 0x4000)
        XCTAssertEqual(Value.midi2(0x8000).midi2Value, 0x8000)
        XCTAssertEqual(Value.midi2(0xC000).midi2Value, 0xC000)
        XCTAssertEqual(Value.midi2(0xFFFF).midi2Value, 0xFFFF)
        
    }
    
}

#endif
