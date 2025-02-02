//
//  ChanVoice32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct ChanVoice32BitValueTests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    typealias Value = MIDIEvent.ChanVoice32BitValue
    
    @Test
    func equatable_unitInterval() {
        #expect(Value.unitInterval(0.00) == Value.unitInterval(0.00)) // min
        #expect(Value.unitInterval(0.25) == Value.unitInterval(0.25))
        #expect(Value.unitInterval(0.50) == Value.unitInterval(0.50)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.unitInterval(0.75))
        #expect(Value.unitInterval(1.00) == Value.unitInterval(1.00)) // max
        #expect(Value.unitInterval(0.00) != Value.unitInterval(0.50))
    }
    
    @Test
    func equatable_midi1() {
        #expect(Value.midi1(sevenBit:   0).midi1_7BitValue ==   0) // min
        #expect(Value.midi1(sevenBit:  32).midi1_7BitValue ==  32)
        #expect(Value.midi1(sevenBit:  64).midi1_7BitValue ==  64) // midpoint
        #expect(Value.midi1(sevenBit:  96).midi1_7BitValue ==  96)
        #expect(Value.midi1(sevenBit: 127).midi1_7BitValue == 127) // max
        #expect(Value.midi1(sevenBit:   0).midi1_7BitValue !=  64)
        
        #expect(Value.midi1(fourteenBit: 0x0000).midi1_14BitValue == 0x0000) // min
        #expect(Value.midi1(fourteenBit: 0x1000).midi1_14BitValue == 0x1000)
        #expect(Value.midi1(fourteenBit: 0x2000).midi1_14BitValue == 0x2000) // midpoint
        #expect(Value.midi1(fourteenBit: 0x3000).midi1_14BitValue == 0x3000)
        #expect(Value.midi1(fourteenBit: 0x3FFF).midi1_14BitValue == 0x3FFF) // max
        #expect(Value.midi1(fourteenBit: 0x0000).midi1_14BitValue != 0x2000)
    }
    
    @Test
    func equatable_midi2() {
        #expect(Value.midi2(0x0000_0000) == Value.midi2(0x0000_0000)) // min
        #expect(Value.midi2(0x4000_0000) == Value.midi2(0x4000_0000))
        #expect(Value.midi2(0x8000_0000) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.midi2(0xC000_0000) == Value.midi2(0xC000_0000))
        #expect(Value.midi2(0xFFFF_FFFF) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.midi2(0x0000_0000) != Value.midi2(0x8000_0000))
    }
    
    @Test
    func equatable_unitInterval_Converted() {
        // we will omit some midi1 three-quarter point tests here.
        // internally, an upscaled midi2 value is being used for equality comparison
        // for any midi1 values passed in (midi1 values are not an enum case for this type).
        // because of the upper-half scaling algorithms, it's unlikely/impossible
        // to get 7-bit and 14-bit values to line up when upscaled to 32-bit
        
        // unitInterval <--> midi1 7bit
        #expect(Value.unitInterval(0.00) == Value.midi1(sevenBit:   0)) // min
        #expect(Value.unitInterval(0.25) == Value.midi1(sevenBit:  32))
        #expect(Value.unitInterval(0.50) == Value.midi1(sevenBit:  64)) // midpoint
        // #expect(Value.unitInterval(0.75) == Value.midi1(sevenBit:  95)) // (omit)
        #expect(Value.unitInterval(1.00) == Value.midi1(sevenBit: 127)) // max
        #expect(Value.unitInterval(0.00) != Value.midi1(sevenBit:  64))
        
        // unitInterval <--> midi1 14bit
        #expect(Value.unitInterval(0.00) == Value.midi1(fourteenBit: 0x0000)) // min
        #expect(Value.unitInterval(0.25) == Value.midi1(fourteenBit: 0x1000))
        #expect(Value.unitInterval(0.50) == Value.midi1(fourteenBit: 0x2000)) // midpoint
        // #expect(Value.unitInterval(0.75) == Value.midi1(fourteenBit: 0x2FFF)) // (omit)
        #expect(Value.unitInterval(1.00) == Value.midi1(fourteenBit: 0x3FFF)) // max
        #expect(Value.unitInterval(0.00) != Value.midi1(fourteenBit: 0x2000))
        
        // unitInterval <--> midi2
        #expect(Value.unitInterval(0.00) == Value.midi2(0x0000_0000)) // min
        #expect(Value.unitInterval(0.25) == Value.midi2(0x4000_0000))
        #expect(Value.unitInterval(0.50) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.midi2(0xBFFF_FFFF))
        #expect(Value.unitInterval(1.00) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.unitInterval(0.00) != Value.midi2(0x8000_0000))
        
        // midi1 7bit <--> midi1 14bit
        #expect(Value.midi1(sevenBit:   0) == Value.midi1(fourteenBit: 0x0000)) // min
        #expect(Value.midi1(sevenBit:  32) == Value.midi1(fourteenBit: 0x1000))
        #expect(Value.midi1(sevenBit:  64) == Value.midi1(fourteenBit: 0x2000)) // midpoint
        // #expect(Value.midi1(sevenBit:  96) == Value.midi1(fourteenBit: 0x3041)) // (omit)
        #expect(Value.midi1(sevenBit: 127) == Value.midi1(fourteenBit: 0x3FFF)) // max
        #expect(Value.midi1(sevenBit:   0) != Value.midi1(fourteenBit: 0x2000))
        
        // midi1 7bit <--> midi2
        #expect(Value.midi1(sevenBit:   0) == Value.midi2(0x0000_0000)) // min
        #expect(Value.midi1(sevenBit:  32) == Value.midi2(0x4000_0000))
        #expect(Value.midi1(sevenBit:  64) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.midi1(sevenBit:  96) == Value.midi2(0xC104_1041))
        #expect(Value.midi1(sevenBit: 127) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.midi1(sevenBit:   0) != Value.midi2(0x8000_0000))
        
        // midi1 14bit <--> midi2
        #expect(Value.midi1(sevenBit:   0) == Value.midi2(0x0000_0000)) // min
        #expect(Value.midi1(sevenBit:  32) == Value.midi2(0x4000_0000))
        #expect(Value.midi1(sevenBit:  64) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.midi1(sevenBit:  96) == Value.midi2(0xC104_1041))
        #expect(Value.midi1(sevenBit: 127) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.midi1(sevenBit:   0) != Value.midi2(0x8000_0000))
    }
    
    @Test
    func unitInterval_Values() {
        #expect(Value.unitInterval(0.00).unitIntervalValue == 0.00) // min
        #expect(Value.unitInterval(0.25).unitIntervalValue == 0.25)
        #expect(Value.unitInterval(0.50).unitIntervalValue == 0.50) // midpoint
        #expect(Value.unitInterval(0.75).unitIntervalValue == 0.75)
        #expect(Value.unitInterval(1.00).unitIntervalValue == 1.00) // max
        
        #expect(Value.unitInterval(0.00).midi1_7BitValue ==   0) // min
        #expect(Value.unitInterval(0.25).midi1_7BitValue ==  32)
        #expect(Value.unitInterval(0.50).midi1_7BitValue ==  64) // midpoint
        #expect(Value.unitInterval(0.75).midi1_7BitValue ==  95)
        #expect(Value.unitInterval(1.00).midi1_7BitValue == 127) // max
        
        #expect(Value.unitInterval(0.00).midi1_14BitValue == 0x0000) // min
        #expect(Value.unitInterval(0.25).midi1_14BitValue == 0x1000)
        #expect(Value.unitInterval(0.50).midi1_14BitValue == 0x2000) // midpoint
        #expect(Value.unitInterval(0.75).midi1_14BitValue == 0x2FFF)
        #expect(Value.unitInterval(1.00).midi1_14BitValue == 0x3FFF) // max
        
        #expect(Value.unitInterval(0.00).midi2Value == 0x0000_0000) // min
        #expect(Value.unitInterval(0.25).midi2Value == 0x4000_0000)
        #expect(Value.unitInterval(0.50).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.unitInterval(0.75).midi2Value == 0xBFFF_FFFF)
        #expect(Value.unitInterval(1.00).midi2Value == 0xFFFF_FFFF) // max
    }
    
    @Test
    func midi1_Values() {
        #expect(Value.midi1(sevenBit:   0).unitIntervalValue == 0.00) // min
        #expect(Value.midi1(sevenBit:  32).unitIntervalValue == 0.25)
        #expect(Value.midi1(sevenBit:  64).unitIntervalValue == 0.50) // midpoint
        #expect(Value.midi1(sevenBit:  96).unitIntervalValue == 0.7539682540851497)
        #expect(Value.midi1(sevenBit: 127).unitIntervalValue == 1.00) // max
        
        #expect(Value.midi1(sevenBit:   0).midi1_7BitValue ==   0) // min
        #expect(Value.midi1(sevenBit:  32).midi1_7BitValue ==  32)
        #expect(Value.midi1(sevenBit:  64).midi1_7BitValue ==  64) // midpoint
        #expect(Value.midi1(sevenBit:  96).midi1_7BitValue ==  96)
        #expect(Value.midi1(sevenBit: 127).midi1_7BitValue == 127) // max
        
        #expect(Value.midi1(sevenBit:   0).midi1_14BitValue == 0x0000) // min
        #expect(Value.midi1(sevenBit:  32).midi1_14BitValue == 0x1000)
        #expect(Value.midi1(sevenBit:  64).midi1_14BitValue == 0x2000) // midpoint
        #expect(Value.midi1(sevenBit:  96).midi1_14BitValue == 0x3041)
        #expect(Value.midi1(sevenBit: 127).midi1_14BitValue == 0x3FFF) // max
        
        #expect(Value.midi1(sevenBit:   0).midi2Value == 0x0000_0000) // min
        #expect(Value.midi1(sevenBit:  32).midi2Value == 0x4000_0000)
        #expect(Value.midi1(sevenBit:  64).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.midi1(sevenBit:  96).midi2Value == 0xC104_1041)
        #expect(Value.midi1(sevenBit: 127).midi2Value == 0xFFFF_FFFF) // max
    }
    
    @Test
    func midi2_Values() {
        #expect(Value.midi2(0x0000_0000).unitIntervalValue == 0.00) // min
        #expect(Value.midi2(0x4000_0000).unitIntervalValue == 0.25)
        #expect(Value.midi2(0x8000_0000).unitIntervalValue == 0.50) // midpoint
        #expect(Value.midi2(0xC000_0000).unitIntervalValue == 0.7500000001187436)
        #expect(Value.midi2(0xFFFF_FFFF).unitIntervalValue == 1.00) // max
        
        #expect(Value.midi2(0x0000_0000).midi1_7BitValue ==   0) // min
        #expect(Value.midi2(0x4000_0000).midi1_7BitValue ==  32)
        #expect(Value.midi2(0x8000_0000).midi1_7BitValue ==  64) // midpoint
        #expect(Value.midi2(0xC000_0000).midi1_7BitValue ==  96)
        #expect(Value.midi2(0xFFFF_FFFF).midi1_7BitValue == 127) // max
        
        #expect(Value.midi2(0x0000_0000).midi1_14BitValue == 0x0000) // min
        #expect(Value.midi2(0x4000_0000).midi1_14BitValue == 0x1000)
        #expect(Value.midi2(0x8000_0000).midi1_14BitValue == 0x2000) // midpoint
        #expect(Value.midi2(0xC002_0010).midi1_14BitValue == 0x3000)
        #expect(Value.midi2(0xFFFF_FFFF).midi1_14BitValue == 0x3FFF) // max
        
        #expect(Value.midi2(0x0000_0000).midi2Value == 0x0000_0000) // min
        #expect(Value.midi2(0x4000_0000).midi2Value == 0x4000_0000)
        #expect(Value.midi2(0x8000_0000).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.midi2(0xC000_0000).midi2Value == 0xC000_0000)
        #expect(Value.midi2(0xFFFF_FFFF).midi2Value == 0xFFFF_FFFF) // max
    }
}
