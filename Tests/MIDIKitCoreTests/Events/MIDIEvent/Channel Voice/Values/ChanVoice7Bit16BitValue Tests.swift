//
//  ChanVoice7Bit16BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct ChanVoice7Bit16BitValueTests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    typealias Value = MIDIEvent.ChanVoice7Bit16BitValue
    
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
        #expect(Value.midi2(0x0000) == Value.midi2(0x0000)) // min
        #expect(Value.midi2(0x4000) == Value.midi2(0x4000))
        #expect(Value.midi2(0x8000) == Value.midi2(0x8000)) // midpoint
        #expect(Value.midi2(0xC000) == Value.midi2(0xC000))
        #expect(Value.midi2(0xFFFF) == Value.midi2(0xFFFF)) // max
        #expect(Value.midi2(0x0000) != Value.midi2(0x8000))
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
        #expect(Value.unitInterval(0.00) == Value.midi2(0x0000)) // min
        #expect(Value.unitInterval(0.25) == Value.midi2(0x4000))
        #expect(Value.unitInterval(0.50) == Value.midi2(0x8000)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.midi2(0xBFFF))
        #expect(Value.unitInterval(1.00) == Value.midi2(0xFFFF)) // max
        #expect(Value.unitInterval(0.00) != Value.midi2(0x8000))
        
        // midi1 <--> midi2
        #expect(Value.midi1(  0) == Value.midi2(0x0000)) // min
        #expect(Value.midi1( 32) == Value.midi2(0x4000))
        #expect(Value.midi1( 64) == Value.midi2(0x8000)) // midpoint
        #expect(Value.midi1( 96) == Value.midi2(0xC104))
        #expect(Value.midi1(127) == Value.midi2(0xFFFF)) // max
        #expect(Value.midi1(  0) != Value.midi2(0x8000))
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
        
        #expect(Value.unitInterval(0.00).midi2Value == 0x0000) // min
        #expect(Value.unitInterval(0.25).midi2Value == 0x4000)
        #expect(Value.unitInterval(0.50).midi2Value == 0x8000) // midpoint
        #expect(Value.unitInterval(0.75).midi2Value == 0xBFFF)
        #expect(Value.unitInterval(1.00).midi2Value == 0xFFFF) // max
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
        
        #expect(Value.midi1(  0).midi2Value == 0x0000) // min
        #expect(Value.midi1( 32).midi2Value == 0x4000)
        #expect(Value.midi1( 64).midi2Value == 0x8000) // midpoint
        #expect(Value.midi1( 96).midi2Value == 0xC104)
        #expect(Value.midi1(127).midi2Value == 0xFFFF) // max
    }
    
    @Test
    func midi2_Values() {
        #expect(Value.midi2(0x0000).unitIntervalValue == 0.00) // min
        #expect(Value.midi2(0x4000).unitIntervalValue == 0.25)
        #expect(Value.midi2(0x8000).unitIntervalValue == 0.50) // midpoint
        #expect(Value.midi2(0xC000).unitIntervalValue == 0.7500076296296972)
        #expect(Value.midi2(0xFFFF).unitIntervalValue == 1.00) // max
        
        #expect(Value.midi2(0x0000).midi1Value ==   0) // min
        #expect(Value.midi2(0x4000).midi1Value ==  32)
        #expect(Value.midi2(0x8000).midi1Value ==  64) // midpoint
        #expect(Value.midi2(0xC000).midi1Value ==  96)
        #expect(Value.midi2(0xFFFF).midi1Value == 127) // max
        
        #expect(Value.midi2(0x0000).midi2Value == 0x0000) // min
        #expect(Value.midi2(0x4000).midi2Value == 0x4000)
        #expect(Value.midi2(0x8000).midi2Value == 0x8000) // midpoint
        #expect(Value.midi2(0xC000).midi2Value == 0xC000)
        #expect(Value.midi2(0xFFFF).midi2Value == 0xFFFF) // max
    }
}
