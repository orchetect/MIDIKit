//
//  ChanVoice Value Conversions Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitCore
import Testing

@Suite struct ChanVoiceValue_Conversions_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    // MARK: - 7-Bit <--> 16-Bit
    
    @Test
    func scaled_16Bit_from_7Bit() {
        #expect(MIDIEvent.scaled16Bit(from7Bit:   0) == 0x0000) // min
        #expect(MIDIEvent.scaled16Bit(from7Bit:   1) == 0x0200)
        #expect(MIDIEvent.scaled16Bit(from7Bit:  63) == 0x7E00)
        #expect(MIDIEvent.scaled16Bit(from7Bit:  64) == 0x8000) // midpoint
        #expect(MIDIEvent.scaled16Bit(from7Bit:  65) == 0x8208)
        #expect(MIDIEvent.scaled16Bit(from7Bit: 126) == 0xFDF7)
        #expect(MIDIEvent.scaled16Bit(from7Bit: 127) == 0xFFFF) // max
    }
    
    @Test
    func scaled_7Bit_from_16Bit() {
        #expect(MIDIEvent.scaled7Bit(from16Bit: 0x0000) ==   0) // min
        #expect(MIDIEvent.scaled7Bit(from16Bit: 0x0200) ==   1)
        #expect(MIDIEvent.scaled7Bit(from16Bit: 0x7E00) ==  63)
        #expect(MIDIEvent.scaled7Bit(from16Bit: 0x8000) ==  64) // midpoint
        #expect(MIDIEvent.scaled7Bit(from16Bit: 0x8200) ==  65)
        #expect(MIDIEvent.scaled7Bit(from16Bit: 0xFDF7) == 126)
        #expect(MIDIEvent.scaled7Bit(from16Bit: 0xFFFF) == 127) // max
    }
    
    @Test
    func scaled_7Bit_16Bit_RoundTrip() {
        for value: UInt7 in 0x00 ... 0x7F {
            let scaled7BitTo16Bit = MIDIEvent.scaled16Bit(from7Bit: value)
            let scaled16BitBackTo7Bit = MIDIEvent.scaled7Bit(from16Bit: scaled7BitTo16Bit)
            
            #expect(value == scaled16BitBackTo7Bit)
        }
    }
    
    // MARK: - 7-Bit <--> 32-Bit
    
    @Test
    func scaled_32Bit_from_7Bit() {
        #expect(MIDIEvent.scaled32Bit(from7Bit:   0) == 0x0000_0000) // min
        #expect(MIDIEvent.scaled32Bit(from7Bit:   1) == 0x0200_0000)
        #expect(MIDIEvent.scaled32Bit(from7Bit:  63) == 0x7E00_0000)
        #expect(MIDIEvent.scaled32Bit(from7Bit:  64) == 0x8000_0000) // midpoint
        #expect(MIDIEvent.scaled32Bit(from7Bit:  65) == 0x8208_2082)
        #expect(MIDIEvent.scaled32Bit(from7Bit: 126) == 0xFDF7_DF7D)
        #expect(MIDIEvent.scaled32Bit(from7Bit: 127) == 0xFFFF_FFFF) // max
    }
    
    @Test
    func scaled_7Bit_from_32Bit() {
        #expect(MIDIEvent.scaled7Bit(from32Bit: 0x0000_0000) == 0) // min
        #expect(MIDIEvent.scaled7Bit(from32Bit: 0x0200_0000) == 1)
        #expect(MIDIEvent.scaled7Bit(from32Bit: 0x7E00_0000) == 63)
        #expect(MIDIEvent.scaled7Bit(from32Bit: 0x8000_0000) == 64) // midpoint
        #expect(MIDIEvent.scaled7Bit(from32Bit: 0x8208_2082) == 65)
        #expect(MIDIEvent.scaled7Bit(from32Bit: 0xFDF7_DF7D) == 126)
        #expect(MIDIEvent.scaled7Bit(from32Bit: 0xFFFF_FFFF) == 127) // max
    }
    
    @Test
    func scaled_7Bit_32Bit_RoundTrip() {
        for value: UInt7 in 0x00 ... 0x7F {
            let scaled7BitTo32Bit = MIDIEvent.scaled32Bit(from7Bit: value)
            let scaled32BitBackTo7Bit = MIDIEvent.scaled7Bit(from32Bit: scaled7BitTo32Bit)
            
            #expect(value == scaled32BitBackTo7Bit)
        }
    }
    
    // MARK: - 14-Bit <--> 32-Bit
    
    @Test
    func scaled_32Bit_from_14Bit() {
        #expect(MIDIEvent.scaled32Bit(from14Bit: 0x0000) == 0x0000_0000) // min
        #expect(MIDIEvent.scaled32Bit(from14Bit: 0x1000) == 0x4000_0000)
        #expect(MIDIEvent.scaled32Bit(from14Bit: 0x2000) == 0x8000_0000) // midpoint
        #expect(MIDIEvent.scaled32Bit(from14Bit: 0x3000) == 0xC002_0010)
        #expect(MIDIEvent.scaled32Bit(from14Bit: 0x3FFF) == 0xFFFF_FFFF) // max
    }
    
    @Test
    func scaled_14Bit_from_32Bit() {
        #expect(MIDIEvent.scaled14Bit(from32Bit: 0x0000_0000) == 0x0000) // min
        #expect(MIDIEvent.scaled14Bit(from32Bit: 0x4000_0000) == 0x1000)
        #expect(MIDIEvent.scaled14Bit(from32Bit: 0x8000_0000) == 0x2000) // midpoint
        #expect(MIDIEvent.scaled14Bit(from32Bit: 0xC002_0010) == 0x3000)
        #expect(MIDIEvent.scaled14Bit(from32Bit: 0xFFFF_FFFF) == 0x3FFF) // max
    }
    
    @Test
    func scaled_14Bit_32Bit_RoundTrip() {
        for value: UInt14 in 0x0000 ... 0x3FFF {
            let scaled14BitTo32Bit = MIDIEvent.scaled32Bit(from14Bit: value)
            let scaled32BitBackTo14Bit = MIDIEvent.scaled14Bit(from32Bit: scaled14BitTo32Bit)
            
            #expect(value == scaled32BitBackTo14Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 7-Bit
    
    @Test
    func scaled_UnitInterval_from_7Bit() {
        #expect(MIDIEvent.scaledUnitInterval(from7Bit:   0) == 0.00) // min
        #expect(MIDIEvent.scaledUnitInterval(from7Bit:  32) == 0.25)
        #expect(MIDIEvent.scaledUnitInterval(from7Bit:  64) == 0.50) // midpoint
        #expect(MIDIEvent.scaledUnitInterval(from7Bit:  96) == 0.7539682539705822)
        #expect(MIDIEvent.scaledUnitInterval(from7Bit: 127) == 1.00) // max
    }
    
    @Test
    func scaled_7Bit_from_UnitInterval() {
        #expect(MIDIEvent.scaled7Bit(fromUnitInterval: 0.00) == 0) // min
        #expect(MIDIEvent.scaled7Bit(fromUnitInterval: 0.25) == 32)
        #expect(MIDIEvent.scaled7Bit(fromUnitInterval: 0.50) == 64) // midpoint
        #expect(MIDIEvent.scaled7Bit(fromUnitInterval: 0.753968253968254) == 96)
        #expect(MIDIEvent.scaled7Bit(fromUnitInterval: 1.00) == 127) // max
    }
    
    @Test
    func scaled_7Bit_UnitInterval_RoundTrip() {
        for value: UInt7 in 0x00 ... 0x7F {
            let scaled7BitToUnitInterval = MIDIEvent.scaledUnitInterval(from7Bit: value)
            let scaledUnitIntervalBackTo7Bit = MIDIEvent
                .scaled7Bit(fromUnitInterval: scaled7BitToUnitInterval)
            
            #expect(value == scaledUnitIntervalBackTo7Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 14-Bit
    
    @Test
    func scaled_UnitInterval_from_14Bit() {
        #expect(MIDIEvent.scaledUnitInterval(from14Bit: 0x0000) == 0.00) // min
        #expect(MIDIEvent.scaledUnitInterval(from14Bit: 0x1000) == 0.25)
        #expect(MIDIEvent.scaledUnitInterval(from14Bit: 0x2000) == 0.50) // midpoint
        #expect(MIDIEvent.scaledUnitInterval(from14Bit: 0x3000) == 0.7500305213061984)
        #expect(MIDIEvent.scaledUnitInterval(from14Bit: 0x3FFE) == 0.999938957394588)
        #expect(MIDIEvent.scaledUnitInterval(from14Bit: 0x3FFF) == 1.00) // max
    }
    
    @Test
    func scaled_14Bit_from_UnitInterval() {
        #expect(MIDIEvent.scaled14Bit(fromUnitInterval: 0.00) == 0x0000) // min
        #expect(MIDIEvent.scaled14Bit(fromUnitInterval: 0.25) == 0x1000)
        #expect(MIDIEvent.scaled14Bit(fromUnitInterval: 0.50) == 0x2000) // midpoint
        #expect(MIDIEvent.scaled14Bit(fromUnitInterval: 0.75003052130388) == 0x3000)
        #expect(MIDIEvent.scaled14Bit(fromUnitInterval: 0.999938957394588) == 0x3FFE)
        #expect(MIDIEvent.scaled14Bit(fromUnitInterval: 1.00) == 0x3FFF) // max
    }
    
    @Test
    func scaled_14Bit_UnitInterval_RoundTrip() {
        for value: UInt14 in 0x0000 ... 0x3FFF {
            let scaled14BitToUnitInterval = MIDIEvent.scaledUnitInterval(from14Bit: value)
            let scaledUnitIntervalBackTo14Bit = MIDIEvent
                .scaled14Bit(fromUnitInterval: scaled14BitToUnitInterval)
            
            #expect(value == scaledUnitIntervalBackTo14Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 16-Bit
    
    @Test
    func scaled_UnitInterval_from_16Bit() {
        #expect(MIDIEvent.scaledUnitInterval(from16Bit: 0x0000) == 0.00) // min
        #expect(MIDIEvent.scaledUnitInterval(from16Bit: 0x4000) == 0.25)
        #expect(MIDIEvent.scaledUnitInterval(from16Bit: 0x8000) == 0.50) // midpoint
        #expect(MIDIEvent.scaledUnitInterval(from16Bit: 0xC000) == 0.7500076296296972)
        #expect(MIDIEvent.scaledUnitInterval(from16Bit: 0xFFFF) == 1.00) // max
    }
    
    @Test
    func scaled_16Bit_from_UnitInterval() {
        #expect(MIDIEvent.scaled16Bit(fromUnitInterval: 0.00) == 0x0000) // min
        #expect(MIDIEvent.scaled16Bit(fromUnitInterval: 0.25) == 0x4000)
        #expect(MIDIEvent.scaled16Bit(fromUnitInterval: 0.50) == 0x8000) // midpoint
        #expect(MIDIEvent.scaled16Bit(fromUnitInterval: 0.750007629627369) == 0xC000)
        #expect(MIDIEvent.scaled16Bit(fromUnitInterval: 1.00) == 0xFFFF) // max
    }
    
    @Test
    func scaled_16Bit_UnitInterval_RoundTrip() {
        for value: UInt16 in 0x0000 ... 0xFFFF {
            let scaled16BitToUnitInterval = MIDIEvent.scaledUnitInterval(from16Bit: value)
            let scaledUnitIntervalBackTo16Bit = MIDIEvent
                .scaled16Bit(fromUnitInterval: scaled16BitToUnitInterval)
            
            #expect(value == scaledUnitIntervalBackTo16Bit)
        }
    }
    
    // MARK: - Unit Interval <--> 32-Bit
    
    @Test
    func scaled_UnitInterval_from_32Bit() {
        #expect(MIDIEvent.scaledUnitInterval(from32Bit: 0x0000_0000) == 0.00) // min
        #expect(MIDIEvent.scaledUnitInterval(from32Bit: 0x4000_0000) == 0.25)
        #expect(MIDIEvent.scaledUnitInterval(from32Bit: 0x8000_0000) == 0.50) // midpoint
        #expect(MIDIEvent.scaledUnitInterval(from32Bit: 0xC000_0000) == 0.7500000001187436)
        #expect(MIDIEvent.scaledUnitInterval(from32Bit: 0xFFFF_FFFF) == 1.00) // max
    }
    
    @Test
    func scaled_32Bit_from_UnitInterval() {
        #expect(MIDIEvent.scaled32Bit(fromUnitInterval: 0.00) == 0x0000_0000) // min
        #expect(MIDIEvent.scaled32Bit(fromUnitInterval: 0.25) == 0x4000_0000)
        #expect(MIDIEvent.scaled32Bit(fromUnitInterval: 0.50) == 0x8000_0000) // midpoint
        #expect(MIDIEvent.scaled32Bit(fromUnitInterval: 0.7500000001164153) == 0xC000_0000)
        #expect(MIDIEvent.scaled32Bit(fromUnitInterval: 1.00) == 0xFFFF_FFFF) // max
    }
    
    @Test
    func scaled_32Bit_UnitInterval_RoundTrip() {
        // UInt32 is too large to test every value in a reasonable amount of time,
        // but for our needs it should be sufficient to test a few sufficiently large sample sizes
        
        let ranges: [ClosedRange<UInt32>] = [
            0x0000_0000 ... 0x0000_FFFF, // min/lower range
            0x7FFF_0000 ... 0x8000_FFFF, // midpoint/middle range
            0xFFFF_0000 ... 0xFFFF_FFFF  // max/upper range
        ]
        
        for range in ranges {
            for value: UInt32 in range {
                let scaled32BitToUnitInterval = MIDIEvent.scaledUnitInterval(from32Bit: value)
                let scaledUnitIntervalBackTo32Bit = MIDIEvent
                    .scaled32Bit(fromUnitInterval: scaled32BitToUnitInterval)
                
                #expect(value == scaledUnitIntervalBackTo32Bit)
            }
        }
    }
    
    // MARK: - Bipolar Unit Interval <--> Unit Interval
    
    @Test
    func scaled_BipolarUnitInterval_from_UnitInterval() {
        #expect(MIDIEvent.scaledBipolarUnitInterval(fromUnitInterval: 0.00) == -1.0) // min
        #expect(MIDIEvent.scaledBipolarUnitInterval(fromUnitInterval: 0.25) == -0.5)
        #expect(MIDIEvent.scaledBipolarUnitInterval(fromUnitInterval: 0.50) ==  0.0) // midpoint
        #expect(MIDIEvent.scaledBipolarUnitInterval(fromUnitInterval: 0.75) ==  0.5)
        #expect(MIDIEvent.scaledBipolarUnitInterval(fromUnitInterval: 1.00) ==  1.0) // max
    }
    
    @Test
    func scaled_UnitInterval_from_BipolarUnitInterval() {
        #expect(MIDIEvent.scaledUnitInterval(fromBipolarUnitInterval: -1.0) == 0.00) // min
        #expect(MIDIEvent.scaledUnitInterval(fromBipolarUnitInterval: -0.5) == 0.25)
        #expect(MIDIEvent.scaledUnitInterval(fromBipolarUnitInterval:  0.0) == 0.50) // midpoint
        #expect(MIDIEvent.scaledUnitInterval(fromBipolarUnitInterval:  0.5) == 0.75)
        #expect(MIDIEvent.scaledUnitInterval(fromBipolarUnitInterval:  1.0) == 1.00) // max
    }
    
    // MARK: - Bipolar Unit Interval <--> 14-Bit
    
    @Test
    func scaled_BipolarUnitInterval_from_14Bit() {
        #expect(MIDIEvent.scaledBipolarUnitInterval(from14Bit: 0x0000) == -1.0) // min
        #expect(MIDIEvent.scaledBipolarUnitInterval(from14Bit: 0x1000) == -0.5)
        #expect(MIDIEvent.scaledBipolarUnitInterval(from14Bit: 0x2000) ==  0.0) // midpoint
        #expect(MIDIEvent.scaledBipolarUnitInterval(from14Bit: 0x3000) ==  0.5000610426077402)
        #expect(MIDIEvent.scaledBipolarUnitInterval(from14Bit: 0x3FFF) ==  1.0) // max
    }
    
    @Test
    func scaled_14Bit_from_BipolarUnitInterval() {
        #expect(MIDIEvent.scaled14Bit(fromBipolarUnitInterval: -1.0) == 0x0000) // min
        #expect(MIDIEvent.scaled14Bit(fromBipolarUnitInterval: -0.5) == 0x1000)
        #expect(MIDIEvent.scaled14Bit(fromBipolarUnitInterval:  0.0) == 0x2000) // midpoint
        #expect(MIDIEvent.scaled14Bit(fromBipolarUnitInterval:  0.5000610426077402) == 0x3000)
        #expect(MIDIEvent.scaled14Bit(fromBipolarUnitInterval:  1.0) == 0x3FFF) // max
    }
    
    // MARK: - Bipolar Unit Interval <--> 32-Bit
    
    @Test
    func scaled_BipolarUnitInterval_from_32Bit() {
        #expect(MIDIEvent.scaledBipolarUnitInterval(from32Bit: 0x0000_0000) == -1.0) // min
        #expect(MIDIEvent.scaledBipolarUnitInterval(from32Bit: 0x4000_0000) == -0.5)
        #expect(MIDIEvent.scaledBipolarUnitInterval(from32Bit: 0x8000_0000) ==  0.0) // midpoint
        #expect(MIDIEvent.scaledBipolarUnitInterval(from32Bit: 0xC000_0000) ==  0.5000000002328306)
        #expect(MIDIEvent.scaledBipolarUnitInterval(from32Bit: 0xFFFF_FFFF) ==  1.0) // max
    }
    
    @Test
    func scaled_32Bit_from_BipolarUnitInterval() {
        #expect(MIDIEvent.scaled32Bit(fromBipolarUnitInterval: -1.0) == 0x0000_0000) // min
        #expect(MIDIEvent.scaled32Bit(fromBipolarUnitInterval: -0.5) == 0x4000_0000)
        #expect(MIDIEvent.scaled32Bit(fromBipolarUnitInterval:  0.0) == 0x8000_0000) // midpoint
        #expect(MIDIEvent.scaled32Bit(fromBipolarUnitInterval:  0.5000000002328306) == 0xC000_0000)
        #expect(MIDIEvent.scaled32Bit(fromBipolarUnitInterval:  1.0) == 0xFFFF_FFFF) // max
    }
}
