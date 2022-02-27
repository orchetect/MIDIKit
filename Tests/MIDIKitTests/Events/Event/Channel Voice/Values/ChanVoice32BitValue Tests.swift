//
//  ChanVoice32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class ChanVoice32BitValueTests: XCTestCase {
    
    typealias Value = MIDI.Event.ChanVoice32BitValue
    
    func testEquatable_unitInterval() {
        
        XCTAssert(Value.unitInterval(0.00) == Value.unitInterval(0.00)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.unitInterval(0.25))
        XCTAssert(Value.unitInterval(0.50) == Value.unitInterval(0.50)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.unitInterval(0.75))
        XCTAssert(Value.unitInterval(1.00) == Value.unitInterval(1.00)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.unitInterval(0.50))
        
    }
    
    func testEquatable_midi1() {
        
        XCTAssert(Value.midi1(sevenBit:   0).midi1_7BitValue ==   0) // min
        XCTAssert(Value.midi1(sevenBit:  32).midi1_7BitValue ==  32)
        XCTAssert(Value.midi1(sevenBit:  64).midi1_7BitValue ==  64) // midpoint
        XCTAssert(Value.midi1(sevenBit:  96).midi1_7BitValue ==  96)
        XCTAssert(Value.midi1(sevenBit: 127).midi1_7BitValue == 127) // max
        XCTAssert(Value.midi1(sevenBit:   0).midi1_7BitValue !=  64)
        
        XCTAssert(Value.midi1(fourteenBit: 0x0000).midi1_14BitValue == 0x0000) // min
        XCTAssert(Value.midi1(fourteenBit: 0x1000).midi1_14BitValue == 0x1000)
        XCTAssert(Value.midi1(fourteenBit: 0x2000).midi1_14BitValue == 0x2000) // midpoint
        XCTAssert(Value.midi1(fourteenBit: 0x3000).midi1_14BitValue == 0x3000)
        XCTAssert(Value.midi1(fourteenBit: 0x3FFF).midi1_14BitValue == 0x3FFF) // max
        XCTAssert(Value.midi1(fourteenBit: 0x0000).midi1_14BitValue != 0x2000)
        
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
        
        // we will omit some midi1 three-quarter point tests here.
        // internally, an upscaled midi2 value is being used for equality comparison
        // for any midi1 values passed in (midi1 values are not an enum case for this type).
        // because of the upper-half scaling algorithms, it's unlikely/impossible
        // to get 7-bit and 14-bit values to line up when upscaled to 32-bit
        
        // unitInterval <--> midi1 7bit
        XCTAssert(Value.unitInterval(0.00) == Value.midi1(sevenBit:   0)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi1(sevenBit:  32))
        XCTAssert(Value.unitInterval(0.50) == Value.midi1(sevenBit:  64)) // midpoint
        //XCTAssert(Value.unitInterval(0.75) == Value.midi1(sevenBit:  95)) // (omit)
        XCTAssert(Value.unitInterval(1.00) == Value.midi1(sevenBit: 127)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi1(sevenBit:  64))
        
        // unitInterval <--> midi1 14bit
        XCTAssert(Value.unitInterval(0.00) == Value.midi1(fourteenBit: 0x0000)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi1(fourteenBit: 0x1000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi1(fourteenBit: 0x2000)) // midpoint
        //XCTAssert(Value.unitInterval(0.75) == Value.midi1(fourteenBit: 0x2FFF)) // (omit)
        XCTAssert(Value.unitInterval(1.00) == Value.midi1(fourteenBit: 0x3FFF)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi1(fourteenBit: 0x2000))
        
        // unitInterval <--> midi2
        XCTAssert(Value.unitInterval(0.00) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.unitInterval(0.25) == Value.midi2(0x40000000))
        XCTAssert(Value.unitInterval(0.50) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.unitInterval(0.75) == Value.midi2(0xBFFFFFFF))
        XCTAssert(Value.unitInterval(1.00) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.unitInterval(0.00) != Value.midi2(0x80000000))
        
        // midi1 7bit <--> midi1 14bit
        XCTAssert(Value.midi1(sevenBit:   0) == Value.midi1(fourteenBit: 0x0000)) // min
        XCTAssert(Value.midi1(sevenBit:  32) == Value.midi1(fourteenBit: 0x1000))
        XCTAssert(Value.midi1(sevenBit:  64) == Value.midi1(fourteenBit: 0x2000)) // midpoint
        //XCTAssert(Value.midi1(sevenBit:  96) == Value.midi1(fourteenBit: 0x3041)) // (omit)
        XCTAssert(Value.midi1(sevenBit: 127) == Value.midi1(fourteenBit: 0x3FFF)) // max
        XCTAssert(Value.midi1(sevenBit:   0) != Value.midi1(fourteenBit: 0x2000))
        
        // midi1 7bit <--> midi2
        XCTAssert(Value.midi1(sevenBit:   0) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.midi1(sevenBit:  32) == Value.midi2(0x40000000))
        XCTAssert(Value.midi1(sevenBit:  64) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.midi1(sevenBit:  96) == Value.midi2(0xC1041041))
        XCTAssert(Value.midi1(sevenBit: 127) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.midi1(sevenBit:   0) != Value.midi2(0x80000000))
        
        // midi1 14bit <--> midi2
        XCTAssert(Value.midi1(sevenBit:   0) == Value.midi2(0x00000000)) // min
        XCTAssert(Value.midi1(sevenBit:  32) == Value.midi2(0x40000000))
        XCTAssert(Value.midi1(sevenBit:  64) == Value.midi2(0x80000000)) // midpoint
        XCTAssert(Value.midi1(sevenBit:  96) == Value.midi2(0xC1041041))
        XCTAssert(Value.midi1(sevenBit: 127) == Value.midi2(0xFFFFFFFF)) // max
        XCTAssert(Value.midi1(sevenBit:   0) != Value.midi2(0x80000000))
        
    }
    
    func testUnitInterval_Values() {
        
        XCTAssertEqual(Value.unitInterval(0.00).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.unitInterval(0.25).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.unitInterval(0.50).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).unitIntervalValue, 0.75)
        XCTAssertEqual(Value.unitInterval(1.00).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).midi1_7BitValue,   0) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi1_7BitValue,  32)
        XCTAssertEqual(Value.unitInterval(0.50).midi1_7BitValue,  64) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi1_7BitValue,  95)
        XCTAssertEqual(Value.unitInterval(1.00).midi1_7BitValue, 127) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).midi1_14BitValue, 0x0000) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi1_14BitValue, 0x1000)
        XCTAssertEqual(Value.unitInterval(0.50).midi1_14BitValue, 0x2000) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi1_14BitValue, 0x2FFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi1_14BitValue, 0x3FFF) // max
        
        XCTAssertEqual(Value.unitInterval(0.00).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.unitInterval(0.25).midi2Value, 0x40000000)
        XCTAssertEqual(Value.unitInterval(0.50).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.unitInterval(0.75).midi2Value, 0xBFFFFFFF)
        XCTAssertEqual(Value.unitInterval(1.00).midi2Value, 0xFFFFFFFF) // max
        
    }
    
    func testMIDI1_Values() {
        
        XCTAssertEqual(Value.midi1(sevenBit:   0).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.midi1(sevenBit:  32).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi1(sevenBit:  64).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.midi1(sevenBit:  96).unitIntervalValue, 0.7539682540851497)
        XCTAssertEqual(Value.midi1(sevenBit: 127).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.midi1(sevenBit:   0).midi1_7BitValue,   0) // min
        XCTAssertEqual(Value.midi1(sevenBit:  32).midi1_7BitValue,  32)
        XCTAssertEqual(Value.midi1(sevenBit:  64).midi1_7BitValue,  64) // midpoint
        XCTAssertEqual(Value.midi1(sevenBit:  96).midi1_7BitValue,  96)
        XCTAssertEqual(Value.midi1(sevenBit: 127).midi1_7BitValue, 127) // max
        
        XCTAssertEqual(Value.midi1(sevenBit:   0).midi1_14BitValue, 0x0000) // min
        XCTAssertEqual(Value.midi1(sevenBit:  32).midi1_14BitValue, 0x1000)
        XCTAssertEqual(Value.midi1(sevenBit:  64).midi1_14BitValue, 0x2000) // midpoint
        XCTAssertEqual(Value.midi1(sevenBit:  96).midi1_14BitValue, 0x3041)
        XCTAssertEqual(Value.midi1(sevenBit: 127).midi1_14BitValue, 0x3FFF) // max
        
        XCTAssertEqual(Value.midi1(sevenBit:   0).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.midi1(sevenBit:  32).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi1(sevenBit:  64).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.midi1(sevenBit:  96).midi2Value, 0xC1041041)
        XCTAssertEqual(Value.midi1(sevenBit: 127).midi2Value, 0xFFFFFFFF) // max
        
    }
    
    func testMIDI2_Values() {
        
        XCTAssertEqual(Value.midi2(0x00000000).unitIntervalValue, 0.00) // min
        XCTAssertEqual(Value.midi2(0x40000000).unitIntervalValue, 0.25)
        XCTAssertEqual(Value.midi2(0x80000000).unitIntervalValue, 0.50) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).unitIntervalValue, 0.7500000001187436)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).unitIntervalValue, 1.00) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).midi1_7BitValue,   0) // min
        XCTAssertEqual(Value.midi2(0x40000000).midi1_7BitValue,  32)
        XCTAssertEqual(Value.midi2(0x80000000).midi1_7BitValue,  64) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).midi1_7BitValue,  96)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi1_7BitValue, 127) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).midi1_14BitValue, 0x0000) // min
        XCTAssertEqual(Value.midi2(0x40000000).midi1_14BitValue, 0x1000)
        XCTAssertEqual(Value.midi2(0x80000000).midi1_14BitValue, 0x2000) // midpoint
        XCTAssertEqual(Value.midi2(0xC0020010).midi1_14BitValue, 0x3000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi1_14BitValue, 0x3FFF) // max
        
        XCTAssertEqual(Value.midi2(0x00000000).midi2Value, 0x00000000) // min
        XCTAssertEqual(Value.midi2(0x40000000).midi2Value, 0x40000000)
        XCTAssertEqual(Value.midi2(0x80000000).midi2Value, 0x80000000) // midpoint
        XCTAssertEqual(Value.midi2(0xC0000000).midi2Value, 0xC0000000)
        XCTAssertEqual(Value.midi2(0xFFFFFFFF).midi2Value, 0xFFFFFFFF) // max
        
    }
    
}

#endif
