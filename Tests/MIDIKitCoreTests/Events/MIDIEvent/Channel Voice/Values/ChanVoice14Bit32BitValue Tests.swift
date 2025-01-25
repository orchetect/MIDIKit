//
//  ChanVoice14Bit32BitValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct ChanVoice14Bit32BitValueTests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    typealias Value = MIDIEvent.ChanVoice14Bit32BitValue
    
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
    func equatable_bipolarUnitInterval() {
        #expect(Value.bipolarUnitInterval(-1.0) == Value.bipolarUnitInterval(-1.0)) // min
        #expect(Value.bipolarUnitInterval(-0.5) == Value.bipolarUnitInterval(-0.5))
        #expect(Value.bipolarUnitInterval( 0.0) == Value.bipolarUnitInterval( 0.0)) // midpoint
        #expect(Value.bipolarUnitInterval( 0.5) == Value.bipolarUnitInterval( 0.5))
        #expect(Value.bipolarUnitInterval( 1.0) == Value.bipolarUnitInterval( 1.0)) // max
        #expect(Value.bipolarUnitInterval( 0.0) != Value.bipolarUnitInterval( 0.5))
    }
    
    @Test
    func equatable_midi1() {
        #expect(Value.midi1(0x0000) == Value.midi1(0x0000)) // min
        #expect(Value.midi1(0x1000) == Value.midi1(0x1000))
        #expect(Value.midi1(0x2000) == Value.midi1(0x2000)) // midpoint
        #expect(Value.midi1(0x3000) == Value.midi1(0x3000))
        #expect(Value.midi1(0x3FFF) == Value.midi1(0x3FFF)) // max
        #expect(Value.midi1(0x0000) != Value.midi1(0x2000))
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
        // unitInterval <--> bipolarUnitInterval
        #expect(Value.unitInterval(0.00) == Value.bipolarUnitInterval(-1.0)) // min
        #expect(Value.unitInterval(0.25) == Value.bipolarUnitInterval(-0.5))
        #expect(Value.unitInterval(0.50) == Value.bipolarUnitInterval( 0.0)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.bipolarUnitInterval( 0.5))
        #expect(Value.unitInterval(1.00) == Value.bipolarUnitInterval( 1.0)) // max
        #expect(Value.unitInterval(0.00) != Value.bipolarUnitInterval( 0.5))
        
        // unitInterval <--> midi1
        #expect(Value.unitInterval(0.00) == Value.midi1(0x0000)) // min
        #expect(Value.unitInterval(0.25) == Value.midi1(0x1000))
        #expect(Value.unitInterval(0.50) == Value.midi1(0x2000)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.midi1(0x2FFF))
        #expect(Value.unitInterval(1.00) == Value.midi1(0x3FFF)) // max
        #expect(Value.unitInterval(0.00) != Value.midi1(0x2000))
        
        // unitInterval <--> midi2
        #expect(Value.unitInterval(0.00) == Value.midi2(0x0000_0000)) // min
        #expect(Value.unitInterval(0.25) == Value.midi2(0x4000_0000))
        #expect(Value.unitInterval(0.50) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.unitInterval(0.75) == Value.midi2(0xBFFF_FFFF))
        #expect(Value.unitInterval(1.00) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.unitInterval(0.00) != Value.midi2(0x8000_0000))
        
        // bipolarUnitInterval <--> midi1
        #expect(Value.bipolarUnitInterval(-1.0) == Value.midi1(0x0000)) // min
        #expect(Value.bipolarUnitInterval(-0.5) == Value.midi1(0x1000))
        #expect(Value.bipolarUnitInterval( 0.0) == Value.midi1(0x2000)) // midpoint
        #expect(Value.bipolarUnitInterval( 0.5) == Value.midi1(0x2FFF))
        #expect(Value.bipolarUnitInterval( 1.0) == Value.midi1(0x3FFF)) // max
        #expect(Value.bipolarUnitInterval( 0.5) != Value.midi1(0x2000))
        
        // bipolarUnitInterval <--> midi2
        #expect(Value.bipolarUnitInterval(-1.0) == Value.midi2(0x0000_0000)) // min
        #expect(Value.bipolarUnitInterval(-0.5) == Value.midi2(0x4000_0000))
        #expect(Value.bipolarUnitInterval( 0.0) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.bipolarUnitInterval( 0.5) == Value.midi2(0xBFFF_FFFF))
        #expect(Value.bipolarUnitInterval( 1.0) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.bipolarUnitInterval( 0.5) != Value.midi2(0xFFFF_FFFF))
        
        // midi1 <--> midi2
        #expect(Value.midi1(0x0000) == Value.midi2(0x0000_0000)) // min
        #expect(Value.midi1(0x1000) == Value.midi2(0x4000_0000))
        #expect(Value.midi1(0x2000) == Value.midi2(0x8000_0000)) // midpoint
        #expect(Value.midi1(0x3000) == Value.midi2(0xC002_0010))
        #expect(Value.midi1(0x3FFF) == Value.midi2(0xFFFF_FFFF)) // max
        #expect(Value.midi1(0x0000) != Value.midi2(0x8000_0000))
    }
    
    @Test
    func unitInterval_Values() {
        #expect(Value.unitInterval(0.00).unitIntervalValue == 0.00) // min
        #expect(Value.unitInterval(0.25).unitIntervalValue == 0.25)
        #expect(Value.unitInterval(0.50).unitIntervalValue == 0.50) // midpoint
        #expect(Value.unitInterval(0.75).unitIntervalValue == 0.75)
        #expect(Value.unitInterval(1.00).unitIntervalValue == 1.00) // max
        
        #expect(Value.unitInterval(0.00).bipolarUnitIntervalValue == -1.0) // min
        #expect(Value.unitInterval(0.25).bipolarUnitIntervalValue == -0.5)
        #expect(Value.unitInterval(0.50).bipolarUnitIntervalValue ==  0.0) // midpoint
        #expect(Value.unitInterval(0.75).bipolarUnitIntervalValue ==  0.5)
        #expect(Value.unitInterval(1.00).bipolarUnitIntervalValue ==  1.0) // max
        
        #expect(Value.unitInterval(0.00).midi1Value == 0x0000) // min
        #expect(Value.unitInterval(0.25).midi1Value == 0x1000)
        #expect(Value.unitInterval(0.50).midi1Value == 0x2000) // midpoint
        #expect(Value.unitInterval(0.75).midi1Value == 0x2FFF)
        #expect(Value.unitInterval(1.00).midi1Value == 0x3FFF) // max
        
        #expect(Value.unitInterval(0.00).midi2Value == 0x0000_0000) // min
        #expect(Value.unitInterval(0.25).midi2Value == 0x4000_0000)
        #expect(Value.unitInterval(0.50).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.unitInterval(0.75).midi2Value == 0xBFFF_FFFF)
        #expect(Value.unitInterval(1.00).midi2Value == 0xFFFF_FFFF) // max
    }
    
    @Test
    func bipolarUnitInterval_Values() {
        #expect(Value.bipolarUnitInterval(-1.0).unitIntervalValue == 0.00) // min
        #expect(Value.bipolarUnitInterval(-0.5).unitIntervalValue == 0.25)
        #expect(Value.bipolarUnitInterval( 0.0).unitIntervalValue == 0.50) // midpoint
        #expect(Value.bipolarUnitInterval( 0.5).unitIntervalValue == 0.75)
        #expect(Value.bipolarUnitInterval( 1.0).unitIntervalValue == 1.00) // max
        
        #expect(Value.bipolarUnitInterval(-1.0).bipolarUnitIntervalValue == -1.0) // min
        #expect(Value.bipolarUnitInterval(-0.5).bipolarUnitIntervalValue == -0.5)
        #expect(Value.bipolarUnitInterval( 0.0).bipolarUnitIntervalValue ==  0.0) // midpoint
        #expect(Value.bipolarUnitInterval( 0.5).bipolarUnitIntervalValue ==  0.5)
        #expect(Value.bipolarUnitInterval( 1.0).bipolarUnitIntervalValue ==  1.0) // max
        
        #expect(Value.bipolarUnitInterval(-1.0).midi1Value == 0x0000) // min
        #expect(Value.bipolarUnitInterval(-0.5).midi1Value == 0x1000)
        #expect(Value.bipolarUnitInterval( 0.0).midi1Value == 0x2000) // midpoint
        #expect(Value.bipolarUnitInterval( 0.5).midi1Value == 0x2FFF)
        #expect(Value.bipolarUnitInterval( 1.0).midi1Value == 0x3FFF) // max
        
        #expect(Value.bipolarUnitInterval(-1.0).midi2Value == 0x0000_0000) // min
        #expect(Value.bipolarUnitInterval(-0.5).midi2Value == 0x4000_0000)
        #expect(Value.bipolarUnitInterval( 0.0).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.bipolarUnitInterval( 0.5).midi2Value == 0xBFFF_FFFF)
        #expect(Value.bipolarUnitInterval( 1.0).midi2Value == 0xFFFF_FFFF) // max
    }
    
    @Test
    func midi1_Values() {
        #expect(Value.midi1(0x0000).unitIntervalValue == 0.00) // min
        #expect(Value.midi1(0x1000).unitIntervalValue == 0.25)
        #expect(Value.midi1(0x2000).unitIntervalValue == 0.50) // midpoint
        #expect(Value.midi1(0x3000).unitIntervalValue == 0.7500305213061984)
        #expect(Value.midi1(0x3FFF).unitIntervalValue == 1.00) // max
        
        #expect(Value.midi1(0x0000).bipolarUnitIntervalValue == -1.0) // min
        #expect(Value.midi1(0x1000).bipolarUnitIntervalValue == -0.5)
        #expect(Value.midi1(0x2000).bipolarUnitIntervalValue ==  0.0) // midpoint
        #expect(Value.midi1(0x3000).bipolarUnitIntervalValue ==  0.5000610426077402)
        #expect(Value.midi1(0x3FFF).bipolarUnitIntervalValue ==  1.0) // max
        
        #expect(Value.midi1(0x0000).midi1Value == 0x0000) // min
        #expect(Value.midi1(0x1000).midi1Value == 0x1000)
        #expect(Value.midi1(0x2000).midi1Value == 0x2000) // midpoint
        #expect(Value.midi1(0x3000).midi1Value == 0x3000)
        #expect(Value.midi1(0x3FFF).midi1Value == 0x3FFF) // max
        
        #expect(Value.midi1(0x0000).midi2Value == 0x0000_0000) // min
        #expect(Value.midi1(0x1000).midi2Value == 0x4000_0000)
        #expect(Value.midi1(0x2000).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.midi1(0x3000).midi2Value == 0xC002_0010)
        #expect(Value.midi1(0x3FFF).midi2Value == 0xFFFF_FFFF) // max
    }
    
    @Test
    func midi2_Values() {
        #expect(Value.midi2(0x0000_0000).unitIntervalValue == 0.00) // min
        #expect(Value.midi2(0x4000_0000).unitIntervalValue == 0.25)
        #expect(Value.midi2(0x8000_0000).unitIntervalValue == 0.50) // midpoint
        #expect(Value.midi2(0xC000_0000).unitIntervalValue == 0.7500000001187436)
        #expect(Value.midi2(0xFFFF_FFFF).unitIntervalValue == 1.00) // max
        
        #expect(Value.midi2(0x0000_0000).bipolarUnitIntervalValue == -1.0) // min
        #expect(Value.midi2(0x4000_0000).bipolarUnitIntervalValue == -0.5)
        #expect(Value.midi2(0x8000_0000).bipolarUnitIntervalValue ==  0.0) // midpoint
        #expect(Value.midi2(0xC000_0000).bipolarUnitIntervalValue ==  0.5000000002328306)
        #expect(Value.midi2(0xFFFF_FFFF).bipolarUnitIntervalValue ==  1.0) // max
        
        #expect(Value.midi2(0x0000_0000).midi1Value == 0x0000) // min
        #expect(Value.midi2(0x4000_0000).midi1Value == 0x1000)
        #expect(Value.midi2(0x8000_0000).midi1Value == 0x2000) // midpoint
        #expect(Value.midi2(0xC002_0010).midi1Value == 0x3000)
        #expect(Value.midi2(0xFFFF_FFFF).midi1Value == 0x3FFF) // max
        
        #expect(Value.midi2(0x0000_0000).midi2Value == 0x0000_0000) // min
        #expect(Value.midi2(0x4000_0000).midi2Value == 0x4000_0000)
        #expect(Value.midi2(0x8000_0000).midi2Value == 0x8000_0000) // midpoint
        #expect(Value.midi2(0xC000_0000).midi2Value == 0xC000_0000)
        #expect(Value.midi2(0xFFFF_FFFF).midi2Value == 0xFFFF_FFFF) // max
    }
}
