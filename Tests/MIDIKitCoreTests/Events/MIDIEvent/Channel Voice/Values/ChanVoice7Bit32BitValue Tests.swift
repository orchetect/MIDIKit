//
//  ChanVoice7Bit32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct ChanVoice7Bit32BitValueTests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    typealias Value = MIDIEvent.ChanVoice7Bit32BitValue
    
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
        #expect(Value.midi1(  0) == Value.midi1(  0)) // min
        #expect(Value.midi1( 32) == Value.midi1( 32))
        #expect(Value.midi1( 64) == Value.midi1( 64)) // midpoint
        #expect(Value.midi1( 96) == Value.midi1( 96))
        #expect(Value.midi1(127) == Value.midi1(127)) // max
        #expect(Value.midi1(  0) != Value.midi1( 64))
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
        // unitInterval <--> midi1
        #expect(Value.unitInterval(0.00) == Value.midi1(  0)) // min
        #expect(Value.unitInterval(0.25) == Value.midi1( 32))
        #expect(Value.unitInterval(0.50) == Value.midi1( 64)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.midi1( 95))
        #expect(Value.unitInterval(1.00) == Value.midi1(127)) // max
        #expect(Value.unitInterval(0.00) != Value.midi1( 64))
        
        // unitInterval <--> midi2
        #expect(Value.unitInterval(0.00) == Value.midi2(0x0000_0000)) // min
        #expect(Value.unitInterval(0.25) == Value.midi2(0x4000_0000))
        #expect(Value.unitInterval(0.50) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.midi2(0xBFFF_FFFF))
        #expect(Value.unitInterval(1.00) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.unitInterval(0.00) != Value.midi2(0x8000_0000))
        
        // midi1 <--> midi2
        #expect(Value.midi1(  0) == Value.midi2(0x0000_0000)) // min
        #expect(Value.midi1( 32) == Value.midi2(0x4000_0000))
        #expect(Value.midi1( 64) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.midi1( 96) == Value.midi2(0xC104_1041))
        #expect(Value.midi1(127) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.midi1(  0) != Value.midi2(0x8000_0000))
    }
    
    @Test
    func unitInterval_Values() {
        #expect(Value.unitInterval(0.00).unitIntervalValue == 0.00) // min
        #expect(Value.unitInterval(0.25).unitIntervalValue == 0.25)
        #expect(Value.unitInterval(0.50).unitIntervalValue == 0.50) // midpoint
        #expect(Value.unitInterval(0.75).unitIntervalValue == 0.75)
        #expect(Value.unitInterval(1.00).unitIntervalValue == 1.00) // max
        
        #expect(Value.unitInterval(0.00).midi1Value ==   0) // min
        #expect(Value.unitInterval(0.25).midi1Value ==  32)
        #expect(Value.unitInterval(0.50).midi1Value ==  64) // midpoint
        #expect(Value.unitInterval(0.75).midi1Value ==  95)
        #expect(Value.unitInterval(1.00).midi1Value == 127) // max
        
        #expect(Value.unitInterval(0.00).midi2Value == 0x0000_0000) // min
        #expect(Value.unitInterval(0.25).midi2Value == 0x4000_0000)
        #expect(Value.unitInterval(0.50).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.unitInterval(0.75).midi2Value == 0xBFFF_FFFF)
        #expect(Value.unitInterval(1.00).midi2Value == 0xFFFF_FFFF) // max
    }
    
    @Test
    func midi1_Values() {
        #expect(Value.midi1(  0).unitIntervalValue == 0.00) // min
        #expect(Value.midi1( 32).unitIntervalValue == 0.25)
        #expect(Value.midi1( 64).unitIntervalValue == 0.50) // midpoint
        #expect(Value.midi1( 96).unitIntervalValue == 0.7539682539705822)
        #expect(Value.midi1(127).unitIntervalValue == 1.00) // max
        
        #expect(Value.midi1(  0).midi1Value ==   0) // min
        #expect(Value.midi1( 32).midi1Value ==  32)
        #expect(Value.midi1( 64).midi1Value ==  64) // midpoint
        #expect(Value.midi1( 96).midi1Value ==  96)
        #expect(Value.midi1(127).midi1Value == 127) // max
        
        #expect(Value.midi1(  0).midi2Value == 0x0000_0000) // min
        #expect(Value.midi1( 32).midi2Value == 0x4000_0000)
        #expect(Value.midi1( 64).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.midi1( 96).midi2Value == 0xC104_1041)
        #expect(Value.midi1(127).midi2Value == 0xFFFF_FFFF) // max
    }
    
    @Test
    func midi2_Values() {
        #expect(Value.midi2(0x0000_0000).unitIntervalValue == 0.00) // min
        #expect(Value.midi2(0x4000_0000).unitIntervalValue == 0.25)
        #expect(Value.midi2(0x8000_0000).unitIntervalValue == 0.50) // midpoint
        #expect(Value.midi2(0xC000_0000).unitIntervalValue == 0.7500000001187436)
        #expect(Value.midi2(0xFFFF_FFFF).unitIntervalValue == 1.00) // max
        
        #expect(Value.midi2(0x0000_0000).midi1Value ==   0) // min
        #expect(Value.midi2(0x4000_0000).midi1Value ==  32)
        #expect(Value.midi2(0x8000_0000).midi1Value ==  64) // midpoint
        #expect(Value.midi2(0xC000_0000).midi1Value ==  96)
        #expect(Value.midi2(0xFFFF_FFFF).midi1Value == 127) // max
        
        #expect(Value.midi2(0x0000_0000).midi2Value == 0x0000_0000) // min
        #expect(Value.midi2(0x4000_0000).midi2Value == 0x4000_0000)
        #expect(Value.midi2(0x8000_0000).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.midi2(0xC000_0000).midi2Value == 0xC000_0000)
        #expect(Value.midi2(0xFFFF_FFFF).midi2Value == 0xFFFF_FFFF) // max
    }
}
