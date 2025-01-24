//
//  SysExID Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct SysExID_Tests {
    // swiftformat:options --wrapcollections preserve
    
    @Test
    func Init_SysEx7_OneByte() {
        // valid conditions
        
        // min/max valid
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x01]) ==
                .manufacturer(.oneByte(0x01))
        )
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x7D]) ==
                .manufacturer(.oneByte(0x7D))
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00]) == nil
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x7E]) ==
                .universal(.nonRealTime)
        )
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x7F]) ==
                .universal(.realTime)
        )
        
        // > 0x7F is illegal
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x80]) == nil
        )
        // > 0x7F is illegal
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0xFF]) == nil
        )
    }
    
    @Test
    func Init_SysEx7_ThreeByte() {
        // valid conditions
        
        // min/max valid
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x00, 0x00]) ==
                .manufacturer(.threeByte(byte2: 0x00, byte3: 0x00))
        )
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x7F, 0x7F]) ==
                .manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
        )
        
        // invalid conditions
        
        // > 0x7F is illegal
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x00, 0x80]) == nil
        )
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x80, 0x00]) == nil
        )
        #expect(
            MIDIEvent.SysExID(sysEx7RawBytes: [0x00, 0x80, 0x80]) == nil
        )
    }
    
    @Test
    func Init_SysEx8_OneByte() {
        // valid conditions
        
        // min/max valid
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x01]) ==
                .manufacturer(.oneByte(0x01))
        )
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x7D]) ==
                .manufacturer(.oneByte(0x7D))
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x00]) == nil
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x7E]) ==
                .universal(.nonRealTime)
        )
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x7F]) ==
                .universal(.realTime)
        )
        
        // > 0x7F is illegal
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0x80]) == nil
        )
        // > 0x7F is illegal
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x00, 0xFF]) == nil
        )
    }
    
    @Test
    func Init_SysEx8_ThreeByte() {
        // valid conditions
        
        // min/max valid
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x80, 0x00]) ==
                .manufacturer(.threeByte(byte2: 0x00, byte3: 0x00))
        )
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0xFF, 0x7F]) ==
                .manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
        )
        
        // invalid conditions
        
        // > 0x7F is illegal in byte 2
        #expect(
            MIDIEvent.SysExID(sysEx8RawBytes: [0x80, 0x80]) == nil
        )
    }
    
    @Test
    func Manufacturer_sysEx7RawBytes() {
        #expect(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x01))
                .sysEx7RawBytes() ==
                [0x01]
        )
        
        #expect(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x7D))
                .sysEx7RawBytes() ==
                [0x7D]
        )
        
        #expect(
            MIDIEvent.SysExID.manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
                .sysEx7RawBytes() ==
                [0x00, 0x7F, 0x7F]
        )
    }
    
    @Test
    func Manufacturer_sysEx8RawBytes() {
        #expect(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x01))
                .sysEx8RawBytes() ==
                [0x00, 0x01]
        )
        
        #expect(
            MIDIEvent.SysExID.manufacturer(.oneByte(0x7D))
                .sysEx8RawBytes() ==
                [0x00, 0x7D]
        )
        
        #expect(
            MIDIEvent.SysExID.manufacturer(.threeByte(byte2: 0x7F, byte3: 0x7F))
                .sysEx8RawBytes() ==
                [0xFF, 0x7F]
        )
    }
    
    @Test
    func Universal_sysEx7RawBytes() {
        #expect(
            MIDIEvent.SysExID.universal(.nonRealTime)
                .sysEx7RawBytes() ==
                [0x7E]
        )
        
        #expect(
            MIDIEvent.SysExID.universal(.realTime)
                .sysEx7RawBytes() ==
                [0x7F]
        )
    }
    
    @Test
    func Universal_sysEx8RawBytes() {
        #expect(
            MIDIEvent.SysExID.universal(.nonRealTime)
                .sysEx8RawBytes() ==
                [0x00, 0x7E]
        )
        
        #expect(
            MIDIEvent.SysExID.universal(.realTime)
                .sysEx8RawBytes() ==
                [0x00, 0x7F]
        )
    }
}
