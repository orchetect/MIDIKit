//
//  Int7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import MIDIKitCore
import XCTest

final class Int7_Tests: XCTestCase {
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:disable spacearoundoperators
    
    fileprivate let _min      = 0b1111111 // int -64
    fileprivate let _midpoint = 0b0000000 // int   0
    fileprivate let _max      = 0b0111111 // int  63
	
    func testInit_SignedInteger() {
        // by adding + 0 it prevents using init(integerLiteral:)
        XCTAssertEqual(Int7( 63 + 0).intValue,  63)
        XCTAssertEqual(Int7(  1 + 0).intValue,   1)
        XCTAssertEqual(Int7(  0 + 0).intValue,   0)
        XCTAssertEqual(Int7( -1 + 0).intValue,  -1)
        XCTAssertEqual(Int7(-63 + 0).intValue, -63)
        XCTAssertEqual(Int7(-64 + 0).intValue, -64)
        // can't test illegal values since they will throw an exception or crash
    }
    
    func testInit_UnsignedInteger() {
        XCTAssertEqual(Int7(UInt8( 63)).intValue,  63)
        XCTAssertEqual(Int7(UInt8(  1)).intValue,   1)
        XCTAssertEqual(Int7(UInt8(  0)).intValue,   0)
        // can't test illegal values since they will throw an exception or crash
    }
    
    func testInitExactly_SignedInteger() {
        XCTAssertNil(Int7(exactly:    64))
        XCTAssertEqual(Int7(exactly:  63)?.intValue,  63)
        XCTAssertEqual(Int7(exactly:   1)?.intValue,   1)
        XCTAssertEqual(Int7(exactly:   0)?.intValue,   0)
        XCTAssertEqual(Int7(exactly:  -1)?.intValue,  -1)
        XCTAssertEqual(Int7(exactly: -63)?.intValue, -63)
        XCTAssertEqual(Int7(exactly: -64)?.intValue, -64)
        XCTAssertNil(Int7(exactly:   -65))
    }
    
    func testInitExactly_UnsignedInteger() {
        XCTAssertNil(Int7(exactly:   UInt8(64)))
        XCTAssertEqual(Int7(exactly: UInt8(63))?.intValue,  63)
        XCTAssertEqual(Int7(exactly: UInt8( 1))?.intValue,   1)
        XCTAssertEqual(Int7(exactly: UInt8( 0))?.intValue,   0)
    }
    
    func testTruncatingIfNecessary_intValue() {
        XCTAssertEqual(Int7(truncatingIfNecessary:  65).intValue, -63) // oob
        XCTAssertEqual(Int7(truncatingIfNecessary:  64).intValue, -64) // oob
        XCTAssertEqual(Int7(truncatingIfNecessary:  63).intValue,  63) // valid
        XCTAssertEqual(Int7(truncatingIfNecessary:   1).intValue,   1)  // valid
        XCTAssertEqual(Int7(truncatingIfNecessary:   0).intValue,   0)  // valid
        XCTAssertEqual(Int7(truncatingIfNecessary:  -1).intValue,  -1) // valid
        XCTAssertEqual(Int7(truncatingIfNecessary:  -2).intValue,  -2) // valid
        XCTAssertEqual(Int7(truncatingIfNecessary: -63).intValue, -63) // valid
        XCTAssertEqual(Int7(truncatingIfNecessary: -64).intValue, -64) // valid
        XCTAssertEqual(Int7(truncatingIfNecessary: -65).intValue,  63) // oob
        XCTAssertEqual(Int7(truncatingIfNecessary: -66).intValue,  62) // oob
        
        XCTAssertEqual(Int7(truncatingIfNecessary: UInt8(0)).intValue, 0)  // valid
        XCTAssertEqual(Int7(truncatingIfNecessary: UInt8(1)).intValue, 1)  // valid
        XCTAssertEqual(Int7(truncatingIfNecessary: UInt8(63)).intValue, 63) // valid
        XCTAssertEqual(Int7(truncatingIfNecessary: UInt8(64)).intValue, 0)  // oob
        XCTAssertEqual(Int7(truncatingIfNecessary: UInt8(65)).intValue, 1)  // oob
    }
    
    func testTruncatingIfNecessary_rawByte() {
        XCTAssertEqual(Int7(truncatingIfNecessary:  65).rawByte, 0b1000001) // wrap -63
        XCTAssertEqual(Int7(truncatingIfNecessary:  64).rawByte, 0b1000000) // wrap -64
        XCTAssertEqual(Int7(truncatingIfNecessary:  63).rawByte, 0b0111111) // max
        XCTAssertEqual(Int7(truncatingIfNecessary:   1).rawByte, 0b0000001)
        XCTAssertEqual(Int7(truncatingIfNecessary:   0).rawByte, 0b0000000)
        XCTAssertEqual(Int7(truncatingIfNecessary:  -1).rawByte, 0b1111111)
        XCTAssertEqual(Int7(truncatingIfNecessary:  -2).rawByte, 0b1111110)
        XCTAssertEqual(Int7(truncatingIfNecessary: -63).rawByte, 0b1000001)
        XCTAssertEqual(Int7(truncatingIfNecessary: -64).rawByte, 0b1000000) // min
        XCTAssertEqual(Int7(truncatingIfNecessary: -65).rawByte, 0b0111111) // wrap 63
        XCTAssertEqual(Int7(truncatingIfNecessary: -66).rawByte, 0b0111110) // wrap 62
    }
    
    func testTruncatingIfNecessary_rawUInt7Byte() {
        XCTAssertEqual(Int7(truncatingIfNecessary:  65).rawUInt7Byte, 0b1000001) // wrap -63
        XCTAssertEqual(Int7(truncatingIfNecessary:  64).rawUInt7Byte, 0b1000000) // wrap -64
        XCTAssertEqual(Int7(truncatingIfNecessary:  63).rawUInt7Byte, 0b0111111) // max
        XCTAssertEqual(Int7(truncatingIfNecessary:   1).rawUInt7Byte, 0b0000001)
        XCTAssertEqual(Int7(truncatingIfNecessary:   0).rawUInt7Byte, 0b0000000)
        XCTAssertEqual(Int7(truncatingIfNecessary:  -1).rawUInt7Byte, 0b1111111)
        XCTAssertEqual(Int7(truncatingIfNecessary:  -2).rawUInt7Byte, 0b1111110)
        XCTAssertEqual(Int7(truncatingIfNecessary: -63).rawUInt7Byte, 0b1000001)
        XCTAssertEqual(Int7(truncatingIfNecessary: -64).rawUInt7Byte, 0b1000000) // min
        XCTAssertEqual(Int7(truncatingIfNecessary: -65).rawUInt7Byte, 0b0111111) // wrap 63
        XCTAssertEqual(Int7(truncatingIfNecessary: -66).rawUInt7Byte, 0b0111110) // wrap 62
    }
    
    func testTruncatingIfNecessary_binaryString() {
        XCTAssertEqual(Int7(truncatingIfNecessary:  65).binaryString, "0b1000001") // wrap -63
        XCTAssertEqual(Int7(truncatingIfNecessary:  64).binaryString, "0b1000000") // wrap -64
        XCTAssertEqual(Int7(truncatingIfNecessary:  63).binaryString, "0b0111111") // max
        XCTAssertEqual(Int7(truncatingIfNecessary:   1).binaryString, "0b0000001")
        XCTAssertEqual(Int7(truncatingIfNecessary:   0).binaryString, "0b0000000")
        XCTAssertEqual(Int7(truncatingIfNecessary:  -1).binaryString, "0b1111111")
        XCTAssertEqual(Int7(truncatingIfNecessary:  -2).binaryString, "0b1111110")
        XCTAssertEqual(Int7(truncatingIfNecessary: -63).binaryString, "0b1000001")
        XCTAssertEqual(Int7(truncatingIfNecessary: -64).binaryString, "0b1000000") // min
        XCTAssertEqual(Int7(truncatingIfNecessary: -65).binaryString, "0b0111111") // wrap 63
        XCTAssertEqual(Int7(truncatingIfNecessary: -66).binaryString, "0b0111110") // wrap 62
    }
    
    func testInit_BitPattern_UInt7() {
        XCTAssertEqual(Int7(bitPattern: UInt7(0b1000001)).intValue, -63) // wrap -63
        XCTAssertEqual(Int7(bitPattern: UInt7(0b1000000)).intValue, -64) // wrap -64
        XCTAssertEqual(Int7(bitPattern: UInt7(0b0111111)).intValue,  63) // max
        XCTAssertEqual(Int7(bitPattern: UInt7(0b0000001)).intValue,   1)
        XCTAssertEqual(Int7(bitPattern: UInt7(0b0000000)).intValue,   0)
        XCTAssertEqual(Int7(bitPattern: UInt7(0b1111111)).intValue,  -1)
        XCTAssertEqual(Int7(bitPattern: UInt7(0b1111110)).intValue,  -2)
        XCTAssertEqual(Int7(bitPattern: UInt7(0b1000001)).intValue, -63)
        XCTAssertEqual(Int7(bitPattern: UInt7(0b1000000)).intValue, -64) // min
        XCTAssertEqual(Int7(bitPattern: UInt7(0b0111111)).intValue,  63) // wrap 63
        XCTAssertEqual(Int7(bitPattern: UInt7(0b0111110)).intValue,  62) // wrap 62
    }
    
    func testInit_BitPattern_UInt8() {
        XCTAssertEqual(Int7(bitPattern: UInt8(0b1000001)).intValue, -63) // wrap -63
        XCTAssertEqual(Int7(bitPattern: UInt8(0b1000000)).intValue, -64) // wrap -64
        XCTAssertEqual(Int7(bitPattern: UInt8(0b0111111)).intValue,  63) // max
        XCTAssertEqual(Int7(bitPattern: UInt8(0b0000001)).intValue,   1)
        XCTAssertEqual(Int7(bitPattern: UInt8(0b0000000)).intValue,   0)
        XCTAssertEqual(Int7(bitPattern: UInt8(0b1111111)).intValue,  -1)
        XCTAssertEqual(Int7(bitPattern: UInt8(0b1111110)).intValue,  -2)
        XCTAssertEqual(Int7(bitPattern: UInt8(0b1000001)).intValue, -63)
        XCTAssertEqual(Int7(bitPattern: UInt8(0b1000000)).intValue, -64) // min
        XCTAssertEqual(Int7(bitPattern: UInt8(0b0111111)).intValue,  63) // wrap 63
        XCTAssertEqual(Int7(bitPattern: UInt8(0b0111110)).intValue,  62) // wrap 62
    }
}

#endif
