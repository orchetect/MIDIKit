//
//  ChanVoice Value Conversions Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class ChanVoiceValueConversionsTests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    // MARK: - 7-Bit <--> 16-Bit
    
    func testScaled_16Bit_from_7Bit() {
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit:   0), 0x0000) // min
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit:   1), 0x0200)
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit:  63), 0x7E00)
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit:  64), 0x8000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit:  65), 0x8208)
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit: 126), 0xFDF7)
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit: 127), 0xFFFF) // max
    }
    
    func testScaled_7Bit_from_16Bit() {
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0x0000),   0) // min
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0x0200),   1)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0x7E00),  63)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0x8000),  64) // midpoint
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0x8200),  65)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0xFDF7), 126)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0xFFFF), 127) // max
    }
    
    func testScaled_7Bit_16Bit_RoundTrip() {
        for value: MIDI.UInt7 in 0x00 ... 0x7F {
            let scaled7BitTo16Bit = MIDI.Event.scaled16Bit(from7Bit: value)
            let scaled16BitBackTo7Bit = MIDI.Event.scaled7Bit(from16Bit: scaled7BitTo16Bit)
            
            XCTAssertEqual(value, scaled16BitBackTo7Bit)
        }
    }
    
    // MARK: - 7-Bit <--> 32-Bit
    
    func testScaled_32Bit_from_7Bit() {
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit:   0), 0x0000_0000) // min
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit:   1), 0x0200_0000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit:  63), 0x7E00_0000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit:  64), 0x8000_0000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit:  65), 0x8208_2082)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit: 126), 0xFDF7_DF7D)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit: 127), 0xFFFF_FFFF) // max
    }
    
    func testScaled_7Bit_from_32Bit() {
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0x0000_0000), 0) // min
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0x0200_0000), 1)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0x7E00_0000), 63)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0x8000_0000), 64) // midpoint
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0x8208_2082), 65)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0xFDF7_DF7D), 126)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0xFFFF_FFFF), 127) // max
    }
    
    func testScaled_7Bit_32Bit_RoundTrip() {
        for value: MIDI.UInt7 in 0x00 ... 0x7F {
            let scaled7BitTo32Bit = MIDI.Event.scaled32Bit(from7Bit: value)
            let scaled32BitBackTo7Bit = MIDI.Event.scaled7Bit(from32Bit: scaled7BitTo32Bit)
            
            XCTAssertEqual(value, scaled32BitBackTo7Bit)
        }
    }
    
    // MARK: - 14-Bit <--> 32-Bit
    
    func testScaled_32Bit_from_14Bit() {
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x0000), 0x0000_0000) // min
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x1000), 0x4000_0000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x2000), 0x8000_0000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x3000), 0xC002_0010)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x3FFF), 0xFFFF_FFFF) // max
    }
    
    func testScaled_14Bit_from_32Bit() {
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0x0000_0000), 0x0000) // min
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0x4000_0000), 0x1000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0x8000_0000), 0x2000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0xC002_0010), 0x3000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0xFFFF_FFFF), 0x3FFF) // max
    }
    
    func testScaled_14Bit_32Bit_RoundTrip() {
        for value: MIDI.UInt14 in 0x0000 ... 0x3FFF {
            let scaled14BitTo32Bit = MIDI.Event.scaled32Bit(from14Bit: value)
            let scaled32BitBackTo14Bit = MIDI.Event.scaled14Bit(from32Bit: scaled14BitTo32Bit)
            
            XCTAssertEqual(value, scaled32BitBackTo14Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 7-Bit
    
    func testScaled_UnitInterval_from_7Bit() {
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit:   0), 0.00) // min
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit:  32), 0.25)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit:  64), 0.50) // midpoint
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit:  96), 0.7539682539705822)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit: 127), 1.00) // max
    }
    
    func testScaled_7Bit_from_UnitInterval() {
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 0.00), 0) // min
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 0.25), 32)
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 0.50), 64) // midpoint
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 0.753968253968254), 96)
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 1.00), 127) // max
    }
    
    func testScaled_7Bit_UnitInterval_RoundTrip() {
        for value: MIDI.UInt7 in 0x00 ... 0x7F {
            let scaled7BitToUnitInterval = MIDI.Event.scaledUnitInterval(from7Bit: value)
            let scaledUnitIntervalBackTo7Bit = MIDI.Event
                .scaled7Bit(fromUnitInterval: scaled7BitToUnitInterval)
            
            XCTAssertEqual(value, scaledUnitIntervalBackTo7Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 14-Bit
    
    func testScaled_UnitInterval_from_14Bit() {
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x0000), 0.00) // min
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x1000), 0.25)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x2000), 0.50) // midpoint
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x3000), 0.7500305213061984)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x3FFE), 0.999938957394588)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x3FFF), 1.00) // max
    }
    
    func testScaled_14Bit_from_UnitInterval() {
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 0.00), 0x0000) // min
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 0.25), 0x1000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 0.50), 0x2000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 0.75003052130388), 0x3000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 0.999938957394588), 0x3FFE)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 1.00), 0x3FFF) // max
    }
    
    func testScaled_14Bit_UnitInterval_RoundTrip() {
        for value: MIDI.UInt14 in 0x0000 ... 0x3FFF {
            let scaled14BitToUnitInterval = MIDI.Event.scaledUnitInterval(from14Bit: value)
            let scaledUnitIntervalBackTo14Bit = MIDI.Event
                .scaled14Bit(fromUnitInterval: scaled14BitToUnitInterval)
            
            XCTAssertEqual(value, scaledUnitIntervalBackTo14Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 16-Bit
    
    func testScaled_UnitInterval_from_16Bit() {
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0x0000), 0.00) // min
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0x4000), 0.25)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0x8000), 0.50) // midpoint
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0xC000), 0.7500076296296972)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0xFFFF), 1.00) // max
    }
    
    func testScaled_16Bit_from_UnitInterval() {
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 0.00), 0x0000) // min
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 0.25), 0x4000)
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 0.50), 0x8000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 0.750007629627369), 0xC000)
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 1.00), 0xFFFF) // max
    }
    
    func testScaled_16Bit_UnitInterval_RoundTrip() {
        for value: UInt16 in 0x0000 ... 0xFFFF {
            let scaled16BitToUnitInterval = MIDI.Event.scaledUnitInterval(from16Bit: value)
            let scaledUnitIntervalBackTo16Bit = MIDI.Event
                .scaled16Bit(fromUnitInterval: scaled16BitToUnitInterval)
            
            XCTAssertEqual(value, scaledUnitIntervalBackTo16Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 32-Bit
    
    func testScaled_UnitInterval_from_32Bit() {
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0x0000_0000), 0.00) // min
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0x4000_0000), 0.25)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0x8000_0000), 0.50) // midpoint
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0xC000_0000), 0.7500000001187436)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0xFFFF_FFFF), 1.00) // max
    }
    
    func testScaled_32Bit_from_UnitInterval() {
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 0.00), 0x0000_0000) // min
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 0.25), 0x4000_0000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 0.50), 0x8000_0000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 0.7500000001164153), 0xC000_0000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 1.00), 0xFFFF_FFFF) // max
    }
    
    func testScaled_32Bit_UnitInterval_RoundTrip() {
        // UInt32 is too large to test every value in a reasonable amount of time,
        // but for our needs it should be sufficient to test a few sufficiently large sample sizes
        
        let ranges: [ClosedRange<UInt32>] = [
            0x0000_0000 ... 0x0000_FFFF, // min/lower range
            0x7FFF_0000 ... 0x8000_FFFF, // midpoint/middle range
            0xFFFF_0000 ... 0xFFFF_FFFF  // max/upper range
        ]
        
        for range in ranges {
            for value: UInt32 in range {
                let scaled32BitToUnitInterval = MIDI.Event.scaledUnitInterval(from32Bit: value)
                let scaledUnitIntervalBackTo32Bit = MIDI.Event
                    .scaled32Bit(fromUnitInterval: scaled32BitToUnitInterval)
                
                XCTAssertEqual(value, scaledUnitIntervalBackTo32Bit)
            }
        }
    }
    
    // MARK: - Bipolar Unit Interval <--> Unit Interval
    
    func testScaled_BipolarUnitInterval_from_UnitInterval() {
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.00), -1.0) // min
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.25), -0.5)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.50),  0.0) // midpoint
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.75),  0.5)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 1.00),  1.0) // max
    }
    
    func testScaled_UnitInterval_from_BipolarUnitInterval() {
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval: -1.0), 0.00) // min
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval: -0.5), 0.25)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval:  0.0), 0.50) // midpoint
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval:  0.5), 0.75)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval:  1.0), 1.00) // max
    }
    
    // MARK: - Bipolar Unit Interval <--> 14-Bit
    
    func testScaled_BipolarUnitInterval_from_14Bit() {
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x0000), -1.0) // min
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x1000), -0.5)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x2000),  0.0) // midpoint
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x3000),  0.5000610426077402)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x3FFF),  1.0) // max
    }
    
    func testScaled_14Bit_from_BipolarUnitInterval() {
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval: -1.0), 0x0000) // min
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval: -0.5), 0x1000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval:  0.0), 0x2000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval:  0.5000610426077402), 0x3000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval:  1.0), 0x3FFF) // max
    }
    
    // MARK: - Bipolar Unit Interval <--> 32-Bit
    
    func testScaled_BipolarUnitInterval_from_32Bit() {
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0x0000_0000), -1.0) // min
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0x4000_0000), -0.5)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0x8000_0000),  0.0) // midpoint
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0xC000_0000),  0.5000000002328306)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0xFFFF_FFFF),  1.0) // max
    }
    
    func testScaled_32Bit_from_BipolarUnitInterval() {
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval: -1.0), 0x0000_0000) // min
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval: -0.5), 0x4000_0000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval:  0.0), 0x8000_0000) // midpoint
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval:  0.5000000002328306), 0xC000_0000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval:  1.0), 0xFFFF_FFFF) // max
    }
}

#endif
