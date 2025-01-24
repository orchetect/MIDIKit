//
//  SysExManufacturer Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct SysExManufacturer_Tests {
    @Test
    func oneByte() {
        // valid conditions
        
        // min/max valid
        #expect(
            MIDIEvent.SysExManufacturer.oneByte(0x01).isValid
        )
        #expect(
            MIDIEvent.SysExManufacturer.oneByte(0x7D).isValid
        )
        
        // invalid conditions
        
        // 0x00 is reserved as first byte of 3-byte IDs
        #expect(
            !MIDIEvent.SysExManufacturer.oneByte(0x00).isValid
        )
        
        // 0x7E and 0x7F are reserved for universal sys ex
        #expect(
            !MIDIEvent.SysExManufacturer.oneByte(0x7E).isValid
        )
        #expect(
            !MIDIEvent.SysExManufacturer.oneByte(0x7F).isValid
        )
    }
    
    @Test
    func threeByte() {
        // valid conditions
        
        // min/max valid
        #expect(
            !MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x00).isValid
        )
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x01, byte3: 0x00).isValid
        )
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x01).isValid
        )
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x7F, byte3: 0x7F).isValid
        )
    }
    
    @Test
    func name() {
        // spot-check: manufacturer name lookup
        // test first and last manufacturer in each section
        
        // single byte ID
        
        #expect(
            MIDIEvent.SysExManufacturer.oneByte(0x01).name ==
            "Sequential Circuits"
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.oneByte(0x3F).name ==
            "Quasimidi"
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.oneByte(0x40).name ==
            "Kawai Musical Instruments MFG. CO. Ltd"
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.oneByte(0x5F).name ==
            "SD Card Association"
        )
        
        // 3-byte ID
        
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x58).name ==
            "Atari Corporation"
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x00, byte3: 0x58).name ==
            "Atari Corporation"
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x02, byte3: 0x3B).name ==
            "Sonoclast, LLC"
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x20, byte3: 0x00).name ==
            "Dream SAS"
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x21, byte3: 0x59).name ==
            "Robkoo Information & Technologies Co., Ltd."
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x40, byte3: 0x00).name ==
            "Crimson Technology Inc."
        )
        
        #expect(
            MIDIEvent.SysExManufacturer.threeByte(byte2: 0x40, byte3: 0x07).name ==
            "Slik Corporation"
        )
    }
}
