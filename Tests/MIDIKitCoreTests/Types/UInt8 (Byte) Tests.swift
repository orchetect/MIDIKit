//
//  UInt8 (Byte) Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct Byte_Tests {
    @Test
    func nibbles() {
        let byte = UInt8(0x12)
    
        let nibbles = byte.nibbles
    
        #expect(nibbles.high == 0x1)
        #expect(nibbles.low == 0x2)
    }
    
    @Test
    func init_Nibbles() {
        let byte = UInt8(high: 0x1, low: 0x2)
    
        #expect(byte == 0x12)
    }
}
