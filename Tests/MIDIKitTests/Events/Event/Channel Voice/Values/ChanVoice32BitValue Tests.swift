//
//  ChanVoice32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
import MIDIKit

class ChanVoice32BitValueTests: XCTestCase {
    
    typealias Value = MIDI.Event.ChanVoice32BitValue
    
    func testEquatable_unitInterval() {
        
        XCTAssert(Value.unitInterval(0.0) == Value.unitInterval(0.0))
        XCTAssert(Value.unitInterval(0.5) == Value.unitInterval(0.5))
        XCTAssert(Value.unitInterval(1.0) == Value.unitInterval(1.0))
        XCTAssert(Value.unitInterval(0.0) != Value.unitInterval(0.5))
        
    }
    
    func testEquatable_midi1() {
        
        XCTAssert(Value.midi1(sevenBit: 0  ).midi1_7BitValue == 0)
        XCTAssert(Value.midi1(sevenBit: 64 ).midi1_7BitValue == 64)
        XCTAssert(Value.midi1(sevenBit: 127).midi1_7BitValue == 127)
        XCTAssert(Value.midi1(sevenBit: 0  ).midi1_7BitValue != 64)
        
    }
    
    func testEquatable_midi2() {
        
        XCTAssert(Value.midi2(0)          == Value.midi2(0x0))
        XCTAssert(Value.midi2(0x80000000) == Value.midi2(0x80000000))
        XCTAssert(Value.midi2(0xFFFFFFFF) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.midi2(0)          != Value.midi2(0x80000000))
        
    }
    
    func testEquatable_unitInterval_Converted() {
        
        // unitInterval <--> midi1
        XCTAssert(Value.unitInterval(0.0) == Value.midi1(sevenBit: 0))
        XCTAssert(Value.unitInterval(0.5) == Value.midi1(sevenBit: 64))
        XCTAssert(Value.unitInterval(1.0) == Value.midi1(sevenBit: 127))
        XCTAssert(Value.unitInterval(0.0) != Value.midi1(sevenBit: 64))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.0) == Value.midi2(0x0))
        XCTAssert(Value.unitInterval(0.5) == Value.midi2(0x80000000))
        XCTAssert(Value.unitInterval(1.0) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.unitInterval(0.0) != Value.midi2(0x80000000))
        
        // midi1 <--> midi2
        XCTAssert(Value.midi1(sevenBit: 0)   == Value.midi2(0x0))
        XCTAssert(Value.midi1(sevenBit: 64)  == Value.midi2(0x80000000))
        XCTAssert(Value.midi1(sevenBit: 127) == Value.midi2(0xFFFFFFFF))
        XCTAssert(Value.midi1(sevenBit: 0)   != Value.midi2(0x80000000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.0).unitIntervalValue, 0.0)
        XCTAssertEqual(Value.unitInterval(0.5).unitIntervalValue, 0.5)
        XCTAssertEqual(Value.unitInterval(1.0).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.unitInterval(0.0).midi1_7BitValue, 0)
        XCTAssertEqual(Value.unitInterval(0.5).midi1_7BitValue, 64)
        XCTAssertEqual(Value.unitInterval(1.0).midi1_7BitValue, 127)
        
        XCTAssertEqual(Value.unitInterval(0.0).midi2Value, 0x0)
        XCTAssertEqual(Value.unitInterval(0.5).midi2Value, 0x80000000)
        XCTAssertEqual(Value.unitInterval(1.0).midi2Value, 0xFFFFFFFF)
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(sevenBit: 0)  .unitIntervalValue, 0.0)
        XCTAssertEqual(Value.midi1(sevenBit: 64) .unitIntervalValue, 0.5)
        XCTAssertEqual(Value.midi1(sevenBit: 127).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.midi1(sevenBit: 0)  .midi1_7BitValue, 0)
        XCTAssertEqual(Value.midi1(sevenBit: 64) .midi1_7BitValue, 64)
        XCTAssertEqual(Value.midi1(sevenBit: 127).midi1_7BitValue, 127)
        
        XCTAssertEqual(Value.midi1(sevenBit: 0)  .midi2Value, 0x0)
        XCTAssertEqual(Value.midi1(sevenBit: 64) .midi2Value, 0x80000000)
        XCTAssertEqual(Value.midi1(sevenBit: 127).midi2Value, 0xFFFFFFFF)
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x0)       .unitIntervalValue, 0.0)
        XCTAssertEqual(Value.midi2(0x80000000).unitIntervalValue, 0.5)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Value.midi2(0x0)       .midi1_7BitValue, 0)
        XCTAssertEqual(Value.midi2(0x80000000).midi1_7BitValue, 64)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi1_7BitValue, 127)
        
        XCTAssertEqual(Value.midi2(0x0)       .midi2Value, 0x0)
        XCTAssertEqual(Value.midi2(0x80000000).midi2Value, 0x80000000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi2Value, 0xFFFFFFFF)
        
    }
    
}

#endif
