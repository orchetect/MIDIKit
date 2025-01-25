//
//  NoteAttribute Pitch7_9 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_NoteAttribute_Pitch7_9_Tests {
    typealias Pitch7_9 = MIDIEvent.NoteAttribute.Pitch7_9
    
    @Test
    func defaultInit() {
        #expect(Pitch7_9(coarse:   0, fine:   0).coarse == 0)
        #expect(Pitch7_9(coarse:   0, fine:   0).fine == 0)
        
        #expect(Pitch7_9(coarse: 127, fine: 511).coarse == 127)
        #expect(Pitch7_9(coarse: 127, fine: 511).fine == 511)
    }
    
    // MARK: - BytePair
    
    @Test
    func init_BytePair() {
        let pitchA = Pitch7_9(BytePair(msb: 0b00000000, lsb: 0b00000000))
        #expect(pitchA.coarse == 0)
        #expect(pitchA.fine == 0)
        
        let pitchB = Pitch7_9(BytePair(msb: 0b00000010, lsb: 0b00000001))
        #expect(pitchB.coarse == 1)
        #expect(pitchB.fine == 1)
        
        let pitchC = Pitch7_9(BytePair(msb: 0b11111111, lsb: 0b11111111))
        #expect(pitchC.coarse == 127)
        #expect(pitchC.fine == 511)
    }
    
    @Test
    func bytePair() {
        #expect(
            Pitch7_9(coarse: 0, fine: 0).bytePair ==
                .init(msb: 0b00000000, lsb: 0b00000000)
        )
        
        #expect(
            Pitch7_9(coarse: 1, fine: 1).bytePair ==
                .init(msb: 0b00000010, lsb: 0b00000001)
        )
        
        #expect(
            Pitch7_9(coarse: 127, fine: 511).bytePair ==
                .init(msb: 0b11111111, lsb: 0b11111111)
        )
    }
    
    // MARK: - UInt16
    
    @Test
    func init_UInt16() {
        let pitchA = Pitch7_9(UInt16(0b00000000_00000000))
        #expect(pitchA.coarse == 0)
        #expect(pitchA.fine == 0)
        
        let pitchB = Pitch7_9(UInt16(0b00000010_00000001))
        #expect(pitchB.coarse == 1)
        #expect(pitchB.fine == 1)
        
        let pitchC = Pitch7_9(UInt16(0b11111111_11111111))
        #expect(pitchC.coarse == 127)
        #expect(pitchC.fine == 511)
    }
    
    @Test
    func uInt16() {
        #expect(
            Pitch7_9(coarse:   0, fine:   0).uInt16Value ==
            0b00000000_00000000
        )
        
        #expect(
            Pitch7_9(coarse:   1, fine:   1).uInt16Value ==
            0b00000010_00000001
        )
        
        #expect(
            Pitch7_9(coarse: 127, fine: 511).uInt16Value ==
            0b11111111_11111111
        )
    }
    
    // MARK: - Double
    
    @Test
    func init_Double() {
        #expect(Pitch7_9(-1.5).coarse == 0)
        #expect(Pitch7_9(-1.5).fine == 0)
        
        #expect(Pitch7_9(0.0).coarse == 0)
        #expect(Pitch7_9(0.0).fine == 0)
        
        #expect(Pitch7_9(1.5).coarse == 1)
        #expect(Pitch7_9(1.5).fine == 256)
        
        #expect(Pitch7_9(127.0).coarse == 127)
        #expect(Pitch7_9(127.0).fine == 0)
        
        #expect(Pitch7_9(127.999999999999999999).coarse == 127)
        #expect(Pitch7_9(127.999999999999999999).fine == 511)
        
        #expect(Pitch7_9(128.0).coarse == 127)
        #expect(Pitch7_9(128.0).fine == 511)
    }
    
    @Test
    func double() {
        #expect(
            Pitch7_9(coarse: 0, fine: 0).doubleValue ==
            0.0
        )
        
        #expect(
            Pitch7_9(coarse: 1, fine: 256).doubleValue ==
            1.5
        )
        
        #expect(
            Pitch7_9(coarse: 127, fine: 0).doubleValue ==
            127.0
        )
        
        #expect(
            Pitch7_9(coarse: 127, fine: 511).doubleValue ==
            127.998046875
        )
    }
}
