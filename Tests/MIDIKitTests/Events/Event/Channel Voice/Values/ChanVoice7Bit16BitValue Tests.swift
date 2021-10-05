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
        
        XCTAssert(Value.midi1(0)   == Value.midi1(0))
        XCTAssert(Value.midi1(64)  == Value.midi1(64))
        XCTAssert(Value.midi1(127) == Value.midi1(127))
        XCTAssert(Value.midi1(0)   != Value.midi1(64))
        
    }
    
    func testEquatable_midi2() {
        
        XCTAssert(Value.midi2(0)      == Value.midi2(0x0))
        XCTAssert(Value.midi2(0x8000) == Value.midi2(0x8000))
        XCTAssert(Value.midi2(0xFFFF) == Value.midi2(0xFFFF))
        XCTAssert(Value.midi2(0)      != Value.midi2(0x8000))
        
    }
    
    func testEquatable_unitInterval_Converted() {
        
        // unitInterval <--> midi1
        XCTAssert(Value.unitInterval(0.0) == Value.midi1(0))
        XCTAssert(Value.unitInterval(0.5) == Value.midi1(64))
        XCTAssert(Value.unitInterval(1.0) == Value.midi1(127))
        XCTAssert(Value.unitInterval(0.0) != Value.midi1(64))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.0) == Value.midi2(0x0))
        XCTAssert(Value.unitInterval(0.5) == Value.midi2(0x8000))
        XCTAssert(Value.unitInterval(1.0) == Value.midi2(0xFFFF))
        XCTAssert(Value.unitInterval(0.0) != Value.midi2(0x8000))
        
        // midi1 <--> midi2
        XCTAssert(Value.midi1(0)   == Value.midi2(0x0))
        XCTAssert(Value.midi1(64)  == Value.midi2(0x8000))
        XCTAssert(Value.midi1(127) == Value.midi2(0xFFFF))
        XCTAssert(Value.midi1(0)   != Value.midi2(0x8000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.0).unitIntervalValue, 0.0)
        XCTAssertEqual(Value.unitInterval(0.5).unitIntervalValue, 0.5)
        XCTAssertEqual(Value.unitInterval(1.0).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.unitInterval(0.0).midi1Value, 0)
        XCTAssertEqual(Value.unitInterval(0.5).midi1Value, 64)
        XCTAssertEqual(Value.unitInterval(1.0).midi1Value, 127)
        
        XCTAssertEqual(Value.unitInterval(0.0).midi2Value, 0x0)
        XCTAssertEqual(Value.unitInterval(0.5).midi2Value, 0x8000)
        XCTAssertEqual(Value.unitInterval(1.0).midi2Value, 0xFFFF)
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(0)  .unitIntervalValue, 0.0)
        XCTAssertEqual(Value.midi1(64) .unitIntervalValue, 0.5)
        XCTAssertEqual(Value.midi1(127).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.midi1(0)  .midi1Value, 0)
        XCTAssertEqual(Value.midi1(64) .midi1Value, 64)
        XCTAssertEqual(Value.midi1(127).midi1Value, 127)
        
        XCTAssertEqual(Value.midi1(0)  .midi2Value, 0x0)
        XCTAssertEqual(Value.midi1(64) .midi2Value, 0x8102)
        XCTAssertEqual(Value.midi1(127).midi2Value, 0xFFFF)
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x0)   .unitIntervalValue, 0.0)
        XCTAssertEqual(Value.midi2(0x8000).unitIntervalValue, 0.5)
        XCTAssertEqual(Value.midi2(0xFFFF).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.midi2(0x0)   .midi1Value, 0)
        XCTAssertEqual(Value.midi2(0x8000).midi1Value, 64)
        XCTAssertEqual(Value.midi2(0xFFFF).midi1Value, 127)
        
        XCTAssertEqual(Value.midi2(0x0)   .midi2Value, 0x0)
        XCTAssertEqual(Value.midi2(0x8000).midi2Value, 0x8000)
        XCTAssertEqual(Value.midi2(0xFFFF).midi2Value, 0xFFFF)
        
    }
    
}

#endif
