//
//  Int7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct Int7_Tests {
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:disable spacearoundoperators
    
    private let _min      = 0b1111111 // int -64
    private let _midpoint = 0b0000000 // int   0
    private let _max      = 0b0111111 // int  63
    
    @Test
    func init_SignedInteger() {
        // by adding + 0 it prevents using init(integerLiteral:)
        #expect(Int7( 63 + 0).intValue ==  63)
        #expect(Int7(  1 + 0).intValue ==   1)
        #expect(Int7(  0 + 0).intValue ==   0)
        #expect(Int7( -1 + 0).intValue ==  -1)
        #expect(Int7(-63 + 0).intValue == -63)
        #expect(Int7(-64 + 0).intValue == -64)
        // can't test illegal values since they will throw an exception or crash
    }
    
    @Test
    func init_UnsignedInteger() {
        #expect(Int7(UInt8( 63)).intValue ==  63)
        #expect(Int7(UInt8(  1)).intValue ==   1)
        #expect(Int7(UInt8(  0)).intValue ==   0)
        // can't test illegal values since they will throw an exception or crash
    }
    
    @Test
    func initExactly_SignedInteger() {
        #expect(Int7(exactly:  64) == nil)
        #expect(Int7(exactly:  63)?.intValue ==  63)
        #expect(Int7(exactly:   1)?.intValue ==   1)
        #expect(Int7(exactly:   0)?.intValue ==   0)
        #expect(Int7(exactly:  -1)?.intValue ==  -1)
        #expect(Int7(exactly: -63)?.intValue == -63)
        #expect(Int7(exactly: -64)?.intValue == -64)
        #expect(Int7(exactly: -65) == nil)
    }
    
    @Test
    func initExactly_UnsignedInteger() {
        #expect(Int7(exactly: UInt8(64)) == nil)
        #expect(Int7(exactly: UInt8(63))?.intValue ==  63)
        #expect(Int7(exactly: UInt8( 1))?.intValue ==   1)
        #expect(Int7(exactly: UInt8( 0))?.intValue ==   0)
    }
    
    @Test
    func truncatingIfNecessary_intValue() {
        #expect(Int7(truncatingIfNecessary:  65).intValue == -63) // oob
        #expect(Int7(truncatingIfNecessary:  64).intValue == -64) // oob
        #expect(Int7(truncatingIfNecessary:  63).intValue ==  63) // valid
        #expect(Int7(truncatingIfNecessary:   1).intValue ==   1)  // valid
        #expect(Int7(truncatingIfNecessary:   0).intValue ==   0)  // valid
        #expect(Int7(truncatingIfNecessary:  -1).intValue ==  -1) // valid
        #expect(Int7(truncatingIfNecessary:  -2).intValue ==  -2) // valid
        #expect(Int7(truncatingIfNecessary: -63).intValue == -63) // valid
        #expect(Int7(truncatingIfNecessary: -64).intValue == -64) // valid
        #expect(Int7(truncatingIfNecessary: -65).intValue ==  63) // oob
        #expect(Int7(truncatingIfNecessary: -66).intValue ==  62) // oob
        
        #expect(Int7(truncatingIfNecessary: UInt8( 0)).intValue == 0)  // valid
        #expect(Int7(truncatingIfNecessary: UInt8( 1)).intValue == 1)  // valid
        #expect(Int7(truncatingIfNecessary: UInt8(63)).intValue == 63) // valid
        #expect(Int7(truncatingIfNecessary: UInt8(64)).intValue == 0)  // oob
        #expect(Int7(truncatingIfNecessary: UInt8(65)).intValue == 1)  // oob
    }
    
    @Test
    func truncatingIfNecessary_rawByte() {
        #expect(Int7(truncatingIfNecessary:  65).rawByte == 0b1000001) // wrap -63
        #expect(Int7(truncatingIfNecessary:  64).rawByte == 0b1000000) // wrap -64
        #expect(Int7(truncatingIfNecessary:  63).rawByte == 0b0111111) // max
        #expect(Int7(truncatingIfNecessary:   1).rawByte == 0b0000001)
        #expect(Int7(truncatingIfNecessary:   0).rawByte == 0b0000000)
        #expect(Int7(truncatingIfNecessary:  -1).rawByte == 0b1111111)
        #expect(Int7(truncatingIfNecessary:  -2).rawByte == 0b1111110)
        #expect(Int7(truncatingIfNecessary: -63).rawByte == 0b1000001)
        #expect(Int7(truncatingIfNecessary: -64).rawByte == 0b1000000) // min
        #expect(Int7(truncatingIfNecessary: -65).rawByte == 0b0111111) // wrap 63
        #expect(Int7(truncatingIfNecessary: -66).rawByte == 0b0111110) // wrap 62
    }
    
    @Test
    func truncatingIfNecessary_rawUInt7Byte() {
        #expect(Int7(truncatingIfNecessary:  65).rawUInt7Byte == 0b1000001) // wrap -63
        #expect(Int7(truncatingIfNecessary:  64).rawUInt7Byte == 0b1000000) // wrap -64
        #expect(Int7(truncatingIfNecessary:  63).rawUInt7Byte == 0b0111111) // max
        #expect(Int7(truncatingIfNecessary:   1).rawUInt7Byte == 0b0000001)
        #expect(Int7(truncatingIfNecessary:   0).rawUInt7Byte == 0b0000000)
        #expect(Int7(truncatingIfNecessary:  -1).rawUInt7Byte == 0b1111111)
        #expect(Int7(truncatingIfNecessary:  -2).rawUInt7Byte == 0b1111110)
        #expect(Int7(truncatingIfNecessary: -63).rawUInt7Byte == 0b1000001)
        #expect(Int7(truncatingIfNecessary: -64).rawUInt7Byte == 0b1000000) // min
        #expect(Int7(truncatingIfNecessary: -65).rawUInt7Byte == 0b0111111) // wrap 63
        #expect(Int7(truncatingIfNecessary: -66).rawUInt7Byte == 0b0111110) // wrap 62
    }
    
    @Test
    func truncatingIfNecessary_binaryString() {
        #expect(Int7(truncatingIfNecessary:  65).binaryString == "0b1000001") // wrap -63
        #expect(Int7(truncatingIfNecessary:  64).binaryString == "0b1000000") // wrap -64
        #expect(Int7(truncatingIfNecessary:  63).binaryString == "0b0111111") // max
        #expect(Int7(truncatingIfNecessary:   1).binaryString == "0b0000001")
        #expect(Int7(truncatingIfNecessary:   0).binaryString == "0b0000000")
        #expect(Int7(truncatingIfNecessary:  -1).binaryString == "0b1111111")
        #expect(Int7(truncatingIfNecessary:  -2).binaryString == "0b1111110")
        #expect(Int7(truncatingIfNecessary: -63).binaryString == "0b1000001")
        #expect(Int7(truncatingIfNecessary: -64).binaryString == "0b1000000") // min
        #expect(Int7(truncatingIfNecessary: -65).binaryString == "0b0111111") // wrap 63
        #expect(Int7(truncatingIfNecessary: -66).binaryString == "0b0111110") // wrap 62
    }
    
    @Test
    func init_BitPattern_UInt7() {
        #expect(Int7(bitPattern: UInt7(0b1000001)).intValue == -63) // wrap -63
        #expect(Int7(bitPattern: UInt7(0b1000000)).intValue == -64) // wrap -64
        #expect(Int7(bitPattern: UInt7(0b0111111)).intValue ==  63) // max
        #expect(Int7(bitPattern: UInt7(0b0000001)).intValue ==   1)
        #expect(Int7(bitPattern: UInt7(0b0000000)).intValue ==   0)
        #expect(Int7(bitPattern: UInt7(0b1111111)).intValue ==  -1)
        #expect(Int7(bitPattern: UInt7(0b1111110)).intValue ==  -2)
        #expect(Int7(bitPattern: UInt7(0b1000001)).intValue == -63)
        #expect(Int7(bitPattern: UInt7(0b1000000)).intValue == -64) // min
        #expect(Int7(bitPattern: UInt7(0b0111111)).intValue ==  63) // wrap 63
        #expect(Int7(bitPattern: UInt7(0b0111110)).intValue ==  62) // wrap 62
    }
    
    @Test
    func init_BitPattern_UInt8() {
        #expect(Int7(bitPattern: UInt8(0b1000001)).intValue == -63) // wrap -63
        #expect(Int7(bitPattern: UInt8(0b1000000)).intValue == -64) // wrap -64
        #expect(Int7(bitPattern: UInt8(0b0111111)).intValue ==  63) // max
        #expect(Int7(bitPattern: UInt8(0b0000001)).intValue ==   1)
        #expect(Int7(bitPattern: UInt8(0b0000000)).intValue ==   0)
        #expect(Int7(bitPattern: UInt8(0b1111111)).intValue ==  -1)
        #expect(Int7(bitPattern: UInt8(0b1111110)).intValue ==  -2)
        #expect(Int7(bitPattern: UInt8(0b1000001)).intValue == -63)
        #expect(Int7(bitPattern: UInt8(0b1000000)).intValue == -64) // min
        #expect(Int7(bitPattern: UInt8(0b0111111)).intValue ==  63) // wrap 63
        #expect(Int7(bitPattern: UInt8(0b0111110)).intValue ==  62) // wrap 62
    }
}
