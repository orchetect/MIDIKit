//
//  BytePair Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct BytePair_Tests {
    @Test
    func init_msb_lsb() {
        let pair = BytePair(msb: 0x12, lsb: 0x34)
        
        #expect(pair.msb == 0x12)
        #expect(pair.lsb == 0x34)
    }
    
    @Test
    func init_UInt16() {
        let pair = BytePair(0x1234)
        
        #expect(pair.msb == 0x12)
        #expect(pair.lsb == 0x34)
    }
    
    @Test
    func uInt16Value_A() {
        let pair = BytePair(msb: 0xFF, lsb: 0xFF)
        
        let uInt16 = pair.uInt16Value
        
        #expect(uInt16 == UInt16.max)
    }
    
    @Test
    func uInt16Value_B() {
        let pair = BytePair(msb: 0x12, lsb: 0x34)
        
        let uInt16 = pair.uInt16Value
        
        #expect(uInt16 == 0x1234)
    }
    
    // MARK: - UInt16 Category Methods
    
    @Test
    func uInt16_Init_bytePair() {
        let pair = BytePair(msb: 0xFF, lsb: 0xFF)
        
        let uInt16 = UInt16(bytePair: pair)
        
        #expect(uInt16 == UInt16.max)
    }
    
    @Test
    func uInt16_bytePair() {
        let pair: BytePair = UInt16(0x1234).bytePair
        
        #expect(pair.msb == 0x12)
        #expect(pair.lsb == 0x34)
    }
}
