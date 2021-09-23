//
//  Note Velocity Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class NoteVelocityTests: XCTestCase {
    
    typealias Velocity = MIDI.Event.Note.Velocity
    
    func testEquatable_unitInterval() {
        
        XCTAssert(Velocity.unitInterval(0.0) == Velocity.unitInterval(0.0))
        XCTAssert(Velocity.unitInterval(0.5) == Velocity.unitInterval(0.5))
        XCTAssert(Velocity.unitInterval(1.0) == Velocity.unitInterval(1.0))
        XCTAssert(Velocity.unitInterval(0.0) != Velocity.unitInterval(0.5))
        
    }
    
    func testEquatable_midi1() {
        
        XCTAssert(Velocity.midi1(0)   == Velocity.midi1(0))
        XCTAssert(Velocity.midi1(64)  == Velocity.midi1(64))
        XCTAssert(Velocity.midi1(127) == Velocity.midi1(127))
        XCTAssert(Velocity.midi1(0)   != Velocity.midi1(64))
        
    }
    
    func testEquatable_midi2() {
        
        XCTAssert(Velocity.midi2(0)      == Velocity.midi2(0x0))
        XCTAssert(Velocity.midi2(0x7FFF) == Velocity.midi2(0x7FFF))
        XCTAssert(Velocity.midi2(0xFFFF) == Velocity.midi2(0xFFFF))
        XCTAssert(Velocity.midi2(0)      != Velocity.midi2(0x7FFF))
        
    }
    
    func testEquatable_unitInterval_Converted() {
        
        // unitInterval <--> midi1
        XCTAssert(Velocity.unitInterval(0.0)                == Velocity.midi1(0))
        XCTAssert(Velocity.unitInterval(0.5039370078740157) == Velocity.midi1(64))
        XCTAssert(Velocity.unitInterval(1.0)                == Velocity.midi1(127))
        XCTAssert(Velocity.unitInterval(0.0)                != Velocity.midi1(64))
        
        // unitInterval <--> midi2
        XCTAssert(Velocity.unitInterval(0.0)                 == Velocity.midi2(0x0))
        XCTAssert(Velocity.unitInterval(0.49999237048905165) == Velocity.midi2(0x7FFF))
        XCTAssert(Velocity.unitInterval(1.0)                 == Velocity.midi2(0xFFFF))
        XCTAssert(Velocity.unitInterval(0.0)                 != Velocity.midi2(0x7FFF))
        
        // midi1 <--> midi2
        XCTAssert(Velocity.midi1(0)   == Velocity.midi2(0x0))
        XCTAssert(Velocity.midi1(64)  == Velocity.midi2(0x8101))
        XCTAssert(Velocity.midi1(127) == Velocity.midi2(0xFFFF))
        XCTAssert(Velocity.midi1(0)   != Velocity.midi2(0x7FFF))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Velocity.unitInterval(0.0).unitIntervalValue, 0.0)
        XCTAssertEqual(Velocity.unitInterval(0.5).unitIntervalValue, 0.5)
        XCTAssertEqual(Velocity.unitInterval(1.0).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Velocity.unitInterval(0.0).midi1Value, 0)
        XCTAssertEqual(Velocity.unitInterval(0.5).midi1Value, 63) // 63.5
        XCTAssertEqual(Velocity.unitInterval(1.0).midi1Value, 127)
        
        XCTAssertEqual(Velocity.unitInterval(0.0).midi2Value, 0x0)
        XCTAssertEqual(Velocity.unitInterval(0.5).midi2Value, 0x7FFF) // 32767.2
        XCTAssertEqual(Velocity.unitInterval(1.0).midi2Value, 0xFFFF)
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Velocity.midi1(0)  .unitIntervalValue, 0.0)
        XCTAssertEqual(Velocity.midi1(64) .unitIntervalValue, 0.5039370078740157)
        XCTAssertEqual(Velocity.midi1(127).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Velocity.midi1(0)  .midi1Value, 0)
        XCTAssertEqual(Velocity.midi1(64) .midi1Value, 64)
        XCTAssertEqual(Velocity.midi1(127).midi1Value, 127)
        
        XCTAssertEqual(Velocity.midi1(0)  .midi2Value, 0x0)
        XCTAssertEqual(Velocity.midi1(64) .midi2Value, 0x8101)
        XCTAssertEqual(Velocity.midi1(127).midi2Value, 0xFFFF)
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Velocity.midi2(0x0)   .unitIntervalValue, 0.0)
        XCTAssertEqual(Velocity.midi2(0x7FFF).unitIntervalValue, 0.49999237048905165)
        XCTAssertEqual(Velocity.midi2(0xFFFF).unitIntervalValue, 1.0)
        
        XCTAssertEqual(Velocity.midi2(0x0)   .midi1Value, 0)
        XCTAssertEqual(Velocity.midi2(0x7FFF).midi1Value, 63) // 63.5
        XCTAssertEqual(Velocity.midi2(0xFFFF).midi1Value, 127)
        
        XCTAssertEqual(Velocity.midi2(0x0)   .midi2Value, 0x0)
        XCTAssertEqual(Velocity.midi2(0x7FFF).midi2Value, 0x7FFF)
        XCTAssertEqual(Velocity.midi2(0xFFFF).midi2Value, 0xFFFF)
        
    }
    
}

#endif
