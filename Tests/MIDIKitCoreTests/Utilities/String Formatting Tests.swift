//
//  String Formatting Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct StringFormatting_Tests {
    // MARK: - Hex Strings
    
    @Test
    func hexString_Prefix() {
        #expect(0x0.hexString(prefix: true) == "0x0")
        #expect(0x9.hexString(prefix: true) == "0x9")
        #expect(0xA.hexString(prefix: true) == "0xA")
        #expect(0x10.hexString(prefix: true) == "0x10")
        #expect(0xFF.hexString(prefix: true) == "0xFF")
        #expect(0xFFF.hexString(prefix: true) == "0xFFF")
    }
    
    @Test
    func hexString_NoPrefix() {
        #expect(0x0.hexString(prefix: false) == "0")
        #expect(0x9.hexString(prefix: false) == "9")
        #expect(0xA.hexString(prefix: false) == "A")
        #expect(0x10.hexString(prefix: false) == "10")
        #expect(0xFF.hexString(prefix: false) == "FF")
        #expect(0xFFF.hexString(prefix: false) == "FFF")
    }
    
    @Test
    func hexString_PadTo_Prefix() {
        #expect(0x0.hexString(padTo: 0, prefix: true) == "0x0")
        #expect(0x9.hexString(padTo: 0, prefix: true) == "0x9")
        #expect(0xA.hexString(padTo: 0, prefix: true) == "0xA")
        #expect(0x10.hexString(padTo: 0, prefix: true) == "0x10")
        #expect(0xFF.hexString(padTo: 0, prefix: true) == "0xFF")
        #expect(0xFFF.hexString(padTo: 0, prefix: true) == "0xFFF")
        
        #expect(0x0.hexString(padTo: 1, prefix: true) == "0x0")
        #expect(0x9.hexString(padTo: 1, prefix: true) == "0x9")
        #expect(0xA.hexString(padTo: 1, prefix: true) == "0xA")
        #expect(0x10.hexString(padTo: 1, prefix: true) == "0x10")
        #expect(0xFF.hexString(padTo: 1, prefix: true) == "0xFF")
        #expect(0xFFF.hexString(padTo: 1, prefix: true) == "0xFFF")
        
        #expect(0x0.hexString(padTo: 2, prefix: true) == "0x00")
        #expect(0x9.hexString(padTo: 2, prefix: true) == "0x09")
        #expect(0xA.hexString(padTo: 2, prefix: true) == "0x0A")
        #expect(0x10.hexString(padTo: 2, prefix: true) == "0x10")
        #expect(0xFF.hexString(padTo: 2, prefix: true) == "0xFF")
        #expect(0xFFF.hexString(padTo: 2, prefix: true) == "0xFFF")
        
        #expect(0x0.hexString(padTo: 3, prefix: true) == "0x000")
        #expect(0x9.hexString(padTo: 3, prefix: true) == "0x009")
        #expect(0xA.hexString(padTo: 3, prefix: true) == "0x00A")
        #expect(0x10.hexString(padTo: 3, prefix: true) == "0x010")
        #expect(0xFF.hexString(padTo: 3, prefix: true) == "0x0FF")
        #expect(0xFFF.hexString(padTo: 3, prefix: true) == "0xFFF")
        
        // edge cases
        #expect(0x0.hexString(padTo: -1, prefix: true) == "0x0")
        #expect(0xF.hexString(padTo: -1, prefix: true) == "0xF")
        #expect(0xFF.hexString(padTo: -1, prefix: true) == "0xFF")
    }
    
    @Test
    func hexString_PadTo_NoPrefix() {
        #expect(0x0.hexString(padTo: 0, prefix: false) == "0")
        #expect(0x9.hexString(padTo: 0, prefix: false) == "9")
        #expect(0xA.hexString(padTo: 0, prefix: false) == "A")
        #expect(0x10.hexString(padTo: 0, prefix: false) == "10")
        #expect(0xFF.hexString(padTo: 0, prefix: false) == "FF")
        #expect(0xFFF.hexString(padTo: 0, prefix: false) == "FFF")
        
        #expect(0x0.hexString(padTo: 1, prefix: false) == "0")
        #expect(0x9.hexString(padTo: 1, prefix: false) == "9")
        #expect(0xA.hexString(padTo: 1, prefix: false) == "A")
        #expect(0x10.hexString(padTo: 1, prefix: false) == "10")
        #expect(0xFF.hexString(padTo: 1, prefix: false) == "FF")
        #expect(0xFFF.hexString(padTo: 1, prefix: false) == "FFF")
        
        #expect(0x0.hexString(padTo: 2, prefix: false) == "00")
        #expect(0x9.hexString(padTo: 2, prefix: false) == "09")
        #expect(0xA.hexString(padTo: 2, prefix: false) == "0A")
        #expect(0x10.hexString(padTo: 2, prefix: false) == "10")
        #expect(0xFF.hexString(padTo: 2, prefix: false) == "FF")
        #expect(0xFFF.hexString(padTo: 2, prefix: false) == "FFF")
        
        #expect(0x0.hexString(padTo: 3, prefix: false) == "000")
        #expect(0x9.hexString(padTo: 3, prefix: false) == "009")
        #expect(0xA.hexString(padTo: 3, prefix: false) == "00A")
        #expect(0x10.hexString(padTo: 3, prefix: false) == "010")
        #expect(0xFF.hexString(padTo: 3, prefix: false) == "0FF")
        #expect(0xFFF.hexString(padTo: 3, prefix: false) == "FFF")
        
        // edge cases
        #expect(0x0.hexString(padTo: -1, prefix: false) == "0")
        #expect(0xF.hexString(padTo: -1, prefix: false) == "F")
        #expect(0xFF.hexString(padTo: -1, prefix: false) == "FF")
    }
    
    @Test
    func collection_HexString_Prefixes() {
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(prefixes: true) ==
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
    }
    
    @Test
    func collection_HexString_NoPrefixes() {
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(prefixes: false) ==
            "0 1 9 F FF FFF"
        )
    }
    
    @Test
    func collection_HexString_PadToEach_Prefixes() {
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 0, prefixes: true) ==
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 1, prefixes: true) ==
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 2, prefixes: true) ==
            "0x00 0x01 0x09 0x0F 0xFF 0xFFF"
        )
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 3, prefixes: true) ==
            "0x000 0x001 0x009 0x00F 0x0FF 0xFFF"
        )
        
        // edge cases
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: -1, prefixes: true) ==
            "0x0 0x1 0x9 0xF 0xFF 0xFFF"
        )
    }
    
    @Test
    func collection_HexString_PadToEach_NoPrefixes() {
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 0, prefixes: false) ==
            "0 1 9 F FF FFF"
        )
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 1, prefixes: false) ==
            "0 1 9 F FF FFF"
        )
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 2, prefixes: false) ==
            "00 01 09 0F FF FFF"
        )
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: 3, prefixes: false) ==
            "000 001 009 00F 0FF FFF"
        )
        
        // edge cases
        
        #expect(
            [0x0, 0x1, 0x9, 0xF, 0xFF, 0xFFF]
                .hexString(padEachTo: -1, prefixes: false) ==
            "0 1 9 F FF FFF"
        )
    }
    
    // MARK: - Binary Strings
    
    @Test
    func binaryString_Prefix() {
        #expect(0b0.binaryString(prefix: true) == "0b0")
        #expect(0b1.binaryString(prefix: true) == "0b1")
        #expect(0b10.binaryString(prefix: true) == "0b10")
        #expect(0b11.binaryString(prefix: true) == "0b11")
        #expect(0b110.binaryString(prefix: true) == "0b110")
    }
    
    @Test
    func binaryString_NoPrefix() {
        #expect(0b0.binaryString(prefix: false) == "0")
        #expect(0b1.binaryString(prefix: false) == "1")
        #expect(0b10.binaryString(prefix: false) == "10")
        #expect(0b11.binaryString(prefix: false) == "11")
        #expect(0b110.binaryString(prefix: false) == "110")
    }
    
    @Test
    func binaryString_PadTo_Prefix() {
        #expect(0b0.binaryString(padTo: 0, prefix: true) == "0b0")
        #expect(0b1.binaryString(padTo: 0, prefix: true) == "0b1")
        #expect(0b10.binaryString(padTo: 0, prefix: true) == "0b10")
        #expect(0b11.binaryString(padTo: 0, prefix: true) == "0b11")
        #expect(0b110.binaryString(padTo: 0, prefix: true) == "0b110")
        
        #expect(0b0.binaryString(padTo: 1, prefix: true) == "0b0")
        #expect(0b1.binaryString(padTo: 1, prefix: true) == "0b1")
        #expect(0b10.binaryString(padTo: 1, prefix: true) == "0b10")
        #expect(0b11.binaryString(padTo: 1, prefix: true) == "0b11")
        #expect(0b110.binaryString(padTo: 1, prefix: true) == "0b110")
        
        #expect(0b0.binaryString(padTo: 2, prefix: true) == "0b00")
        #expect(0b1.binaryString(padTo: 2, prefix: true) == "0b01")
        #expect(0b10.binaryString(padTo: 2, prefix: true) == "0b10")
        #expect(0b11.binaryString(padTo: 2, prefix: true) == "0b11")
        #expect(0b110.binaryString(padTo: 2, prefix: true) == "0b110")
        
        #expect(0b0.binaryString(padTo: 3, prefix: true) == "0b000")
        #expect(0b1.binaryString(padTo: 3, prefix: true) == "0b001")
        #expect(0b10.binaryString(padTo: 3, prefix: true) == "0b010")
        #expect(0b11.binaryString(padTo: 3, prefix: true) == "0b011")
        #expect(0b110.binaryString(padTo: 3, prefix: true) == "0b110")
        
        // edge cases
        #expect(0b0.binaryString(padTo: -1, prefix: true) == "0b0")
        #expect(0b1.binaryString(padTo: -1, prefix: true) == "0b1")
        #expect(0b11.binaryString(padTo: -1, prefix: true) == "0b11")
    }
    
    @Test
    func binaryString_PadTo_NoPrefix() {
        #expect(0b0.binaryString(padTo: 0, prefix: false) == "0")
        #expect(0b1.binaryString(padTo: 0, prefix: false) == "1")
        #expect(0b10.binaryString(padTo: 0, prefix: false) == "10")
        #expect(0b11.binaryString(padTo: 0, prefix: false) == "11")
        #expect(0b110.binaryString(padTo: 0, prefix: false) == "110")
        
        #expect(0b0.binaryString(padTo: 1, prefix: false) == "0")
        #expect(0b1.binaryString(padTo: 1, prefix: false) == "1")
        #expect(0b10.binaryString(padTo: 1, prefix: false) == "10")
        #expect(0b11.binaryString(padTo: 1, prefix: false) == "11")
        #expect(0b110.binaryString(padTo: 1, prefix: false) == "110")
        
        #expect(0b0.binaryString(padTo: 2, prefix: false) == "00")
        #expect(0b1.binaryString(padTo: 2, prefix: false) == "01")
        #expect(0b10.binaryString(padTo: 2, prefix: false) == "10")
        #expect(0b11.binaryString(padTo: 2, prefix: false) == "11")
        #expect(0b110.binaryString(padTo: 2, prefix: false) == "110")
        
        #expect(0b0.binaryString(padTo: 3, prefix: false) == "000")
        #expect(0b1.binaryString(padTo: 3, prefix: false) == "001")
        #expect(0b10.binaryString(padTo: 3, prefix: false) == "010")
        #expect(0b11.binaryString(padTo: 3, prefix: false) == "011")
        #expect(0b110.binaryString(padTo: 3, prefix: false) == "110")
        
        // edge cases
        #expect(0b0.binaryString(padTo: -1, prefix: false) == "0")
        #expect(0b1.binaryString(padTo: -1, prefix: false) == "1")
        #expect(0b11.binaryString(padTo: -1, prefix: false) == "11")
    }
    
    @Test
    func collection_BinaryString_Prefixes() {
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(prefixes: true) ==
            "0b0 0b1 0b11 0b110"
        )
    }
    
    @Test
    func collection_BinaryString_NoPrefixes() {
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(prefixes: false) ==
            "0 1 11 110"
        )
    }
    
    @Test
    func collection_BinaryString_PadToEach_Prefixes() {
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 0, prefixes: true) ==
            "0b0 0b1 0b11 0b110"
        )
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 1, prefixes: true) ==
            "0b0 0b1 0b11 0b110"
        )
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 2, prefixes: true) ==
            "0b00 0b01 0b11 0b110"
        )
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 3, prefixes: true) ==
            "0b000 0b001 0b011 0b110"
        )
        
        // edge cases
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: -1, prefixes: true) ==
            "0b0 0b1 0b11 0b110"
        )
    }
    
    @Test
    func collection_BinaryString_PadToEach_NoPrefixes() {
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 0, prefixes: false) ==
            "0 1 11 110"
        )
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 1, prefixes: false) ==
            "0 1 11 110"
        )
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 2, prefixes: false) ==
            "00 01 11 110"
        )
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: 3, prefixes: false) ==
            "000 001 011 110"
        )
        
        // edge cases
        
        #expect(
            [0b0, 0b1, 0b11, 0b110]
                .binaryString(padEachTo: -1, prefixes: false) ==
            "0 1 11 110"
        )
    }
}
