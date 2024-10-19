//
//  ChanVoice14Bit32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import XCTest

final class ChanVoice14Bit32BitValueTests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    typealias Value = MIDIEvent.ChanVoice14Bit32BitValue
    
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
        XCTAssert(Value.midi2(0x0000_0000) == Value.midi2(0x0000_0000)) // min
        XCTAssert(Value.midi2(0x4000_0000) == Value.midi2(0x4000_0000))
        XCTAssert(Value.midi2(0x8000_0000) == Value.midi2(0x8000_0000)) // midpoint
        XCTAssert(Value.midi2(0xC000_0000) == Value.midi2(0xC000_0000))
        XCTAssert(Value.midi2(0xFFFF_FFFF) == Value.midi2(0xFFFF_FFFF)) // max
        XCTAssert(Value.midi2(0x0000_0000) != Value.midi2(0x8000_0000))
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
        XCTAssert(Value.unitInterval(0.00) == Value.midi2(0x0000_0000)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi2(0x4000_0000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi2(0x8000_0000)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.midi2(0xBFFF_FFFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi2(0xFFFF_FFFF)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi2(0x8000_0000))
    
        // bipolarUnitInterval <--> midi1
        XCTAssert(Value.bipolarUnitInterval(-1.0) == Value.midi1(0x0000)) // min
        XCTAssert(Value.bipolarUnitInterval(-0.5) == Value.midi1(0x1000))
        XCTAssert(Value.bipolarUnitInterval( 0.0) == Value.midi1(0x2000)) // midpoint
        XCTAssert(Value.bipolarUnitInterval( 0.5) == Value.midi1(0x2FFF))
        XCTAssert(Value.bipolarUnitInterval( 1.0) == Value.midi1(0x3FFF)) // max
        XCTAssert(Value.bipolarUnitInterval( 0.5) != Value.midi1(0x2000))
    
        // bipolarUnitInterval <--> midi2
        XCTAssert(Value.bipolarUnitInterval(-1.0) == Value.midi2(0x0000_0000)) // min
        XCTAssert(Value.bipolarUnitInterval(-0.5) == Value.midi2(0x4000_0000))
        XCTAssert(Value.bipolarUnitInterval( 0.0) == Value.midi2(0x8000_0000)) // midpoint
        XCTAssert(Value.bipolarUnitInterval( 0.5) == Value.midi2(0xBFFF_FFFF))
        XCTAssert(Value.bipolarUnitInterval( 1.0) == Value.midi2(0xFFFF_FFFF)) // max
        XCTAssert(Value.bipolarUnitInterval( 0.5) != Value.midi2(0xFFFF_FFFF))
    
        // midi1 <--> midi2
        XCTAssert(Value.midi1(0x0000) == Value.midi2(0x0000_0000)) // min
        XCTAssert(Value.midi1(0x1000) == Value.midi2(0x4000_0000))
        XCTAssert(Value.midi1(0x2000) == Value.midi2(0x8000_0000)) // midpoint
        XCTAssert(Value.midi1(0x3000) == Value.midi2(0xC002_0010))
        XCTAssert(Value.midi1(0x3FFF) == Value.midi2(0xFFFF_FFFF)) // max
        XCTAssert(Value.midi1(0x0000) != Value.midi2(0x8000_0000))
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
    
        XCTAssertEqual(Value.unitInterval(0.00).midi2Value, 0x0000_0000) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi2Value, 0x4000_0000)
        XCTAssertEqual(Value.unitInterval(0.50).midi2Value, 0x8000_0000) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi2Value, 0xBFFF_FFFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi2Value, 0xFFFF_FFFF) // max
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
    
        XCTAssertEqual(Value.bipolarUnitInterval(-1.0).midi2Value, 0x0000_0000) // min
        XCTAssertEqual(Value.bipolarUnitInterval(-0.5).midi2Value, 0x4000_0000)
        XCTAssertEqual(Value.bipolarUnitInterval( 0.0).midi2Value, 0x8000_0000) // midpoint
        XCTAssertEqual(Value.bipolarUnitInterval( 0.5).midi2Value, 0xBFFF_FFFF)
        XCTAssertEqual(Value.bipolarUnitInterval( 1.0).midi2Value, 0xFFFF_FFFF) // max
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
    
        XCTAssertEqual(Value.midi1(0x0000).midi2Value, 0x0000_0000) // min
        XCTAssertEqual(Value.midi1(0x1000).midi2Value, 0x4000_0000)
        XCTAssertEqual(Value.midi1(0x2000).midi2Value, 0x8000_0000) // midpoint
        XCTAssertEqual(Value.midi1(0x3000).midi2Value, 0xC002_0010)
        XCTAssertEqual(Value.midi1(0x3FFF).midi2Value, 0xFFFF_FFFF) // max
    }
    
    func testMIDI2_Values() {
        XCTAssertEqual(Value.midi2(0x0000_0000).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.midi2(0x4000_0000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi2(0x8000_0000).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.midi2(0xC000_0000).unitIntervalValue, 0.7500000001187436)
        XCTAssertEqual(Value.midi2(0xFFFF_FFFF).unitIntervalValue, 1.00) // max
    
        XCTAssertEqual(Value.midi2(0x0000_0000).bipolarUnitIntervalValue, -1.0) // min
        XCTAssertEqual(Value.midi2(0x4000_0000).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(Value.midi2(0x8000_0000).bipolarUnitIntervalValue,  0.0) // midpoint
        XCTAssertEqual(Value.midi2(0xC000_0000).bipolarUnitIntervalValue,  0.5000000002328306)
        XCTAssertEqual(Value.midi2(0xFFFF_FFFF).bipolarUnitIntervalValue,  1.0) // max
    
        XCTAssertEqual(Value.midi2(0x0000_0000).midi1Value, 0x0000) // min
        XCTAssertEqual(Value.midi2(0x4000_0000).midi1Value, 0x1000)
        XCTAssertEqual(Value.midi2(0x8000_0000).midi1Value, 0x2000) // midpoint
        XCTAssertEqual(Value.midi2(0xC002_0010).midi1Value, 0x3000)
        XCTAssertEqual(Value.midi2(0xFFFF_FFFF).midi1Value, 0x3FFF) // max
    
        XCTAssertEqual(Value.midi2(0x0000_0000).midi2Value, 0x0000_0000) // min
        XCTAssertEqual(Value.midi2(0x4000_0000).midi2Value, 0x4000_0000)
        XCTAssertEqual(Value.midi2(0x8000_0000).midi2Value, 0x8000_0000) // midpoint
        XCTAssertEqual(Value.midi2(0xC000_0000).midi2Value, 0xC000_0000)
        XCTAssertEqual(Value.midi2(0xFFFF_FFFF).midi2Value, 0xFFFF_FFFF) // max
    }
}
