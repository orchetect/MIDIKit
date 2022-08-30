//
//  UInt9 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class UInt9_Tests: XCTestCase {
    fileprivate let _min      = 0b0_00000000 // int   0, hex 0x000
    fileprivate let _midpoint = 0b1_00000000 // int 256, hex 0x0FF
    fileprivate let _max      = 0b1_11111111 // int 511, hex 0x1FF
	
    func testInit_BinaryInteger() {
        // default
		
        XCTAssertEqual(UInt9().intValue, 0)
		
        // different integer types
		
        XCTAssertEqual(UInt9(0).intValue, 0)
        XCTAssertEqual(UInt9(UInt8(0)).intValue, 0)
        XCTAssertEqual(UInt9(UInt16(0)).intValue, 0)
		
        // values
		
        XCTAssertEqual(UInt9(1).intValue, 1)
        XCTAssertEqual(UInt9(2).intValue, 2)
		
        // overflow
		
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
    
        // _XCTAssertThrows { [self] in
        //    _ = UInt9(_min - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //    _ = UInt9(_max + 1)
        // }
    }
	
    func testInit_BinaryInteger_Exactly() {
        // typical
		
        XCTAssertEqual(UInt9(exactly: 0)?.intValue, 0)
		
        XCTAssertEqual(UInt9(exactly: 1)?.intValue, 1)
		
        XCTAssertEqual(UInt9(exactly: _max)?.intValue, _max)
		
        // overflow
		
        XCTAssertNil(UInt9(exactly: -1))
		
        XCTAssertNil(UInt9(exactly: _max + 1))
    }
    
    func testInit_BinaryInteger_Clamping() {
        // within range
		
        XCTAssertEqual(UInt9(clamping: 0).intValue, 0)
        XCTAssertEqual(UInt9(clamping: 1).intValue, 1)
        XCTAssertEqual(UInt9(clamping: _max).intValue, _max)
		
        // overflow
		
        XCTAssertEqual(UInt9(clamping: -1).intValue, 0)
        XCTAssertEqual(UInt9(clamping: _max + 1).intValue, _max)
    }
    
    func testInit_BinaryFloatingPoint() {
        XCTAssertEqual(UInt9(Double(0)).intValue, 0)
        XCTAssertEqual(UInt9(Double(1)).intValue, 1)
        XCTAssertEqual(UInt9(Double(5.9)).intValue, 5)
    
        XCTAssertEqual(UInt9(Float(0)).intValue, 0)
        XCTAssertEqual(UInt9(Float(1)).intValue, 1)
        XCTAssertEqual(UInt9(Float(5.9)).intValue, 5)
    
        // overflow
    
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
    
        // _XCTAssertThrows {
        //    _ = UInt9(Double(0 - 1))
        //    _ = UInt9(Float(0 - 1))
        // }
        //
        // _XCTAssertThrows { [self] in
        //    _ = UInt9(Double(_max + 1))
        //    _ = UInt9(Float(_max + 1))
        // }
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        // typical
    
        XCTAssertEqual(UInt9(exactly: 0.0), 0)
    
        XCTAssertEqual(UInt9(exactly: 1.0), 1)
    
        XCTAssertEqual(UInt9(exactly: Double(_max))?.intValue, _max)
    
        // overflow
    
        XCTAssertNil(UInt9(exactly: -1.0))
    
        XCTAssertNil(UInt9(exactly: Double(_max) + 1.0))
    }
	
    func testMin() {
        XCTAssertEqual(UInt9.min.intValue, _min)
    }
	
    func testMax() {
        XCTAssertEqual(UInt9.max.intValue, _max)
    }
	
    func testComputedProperties() {
        XCTAssertEqual(UInt9(1).intValue, 1)
        XCTAssertEqual(UInt9(1).uInt16Value, 1)
    }
	
    func testStrideable() {
        let min = UInt9(_min)
        let max = UInt9(_max)
    
        let strideBy1 = stride(from: min, through: max, by: 1)
        XCTAssertEqual(strideBy1.underestimatedCount, _max + 1)
        XCTAssertTrue(strideBy1.starts(with: [min]))
        XCTAssertEqual(strideBy1.suffix(1), [max])
    
        let range = min ... max
        XCTAssertEqual(range.count, _max + 1)
        XCTAssertEqual(range.lowerBound, min)
        XCTAssertEqual(range.upperBound, max)
    }
    
    func testEquatable() {
        XCTAssertTrue(UInt9(0) == UInt9(0))
        XCTAssertTrue(UInt9(1) == UInt9(1))
        XCTAssertTrue(UInt9(_max) == UInt9(_max))
		
        XCTAssertTrue(UInt9(0) != UInt9(1))
    }
	
    func testComparable() {
        XCTAssertFalse(UInt9(0) > UInt9(0))
        XCTAssertFalse(UInt9(1) > UInt9(1))
        XCTAssertFalse(UInt9(_max) > UInt9(_max))
		
        XCTAssertTrue(UInt9(0) < UInt9(1))
        XCTAssertTrue(UInt9(1) > UInt9(0))
    }
	
    func testHashable() {
        let set = Set<UInt9>([0, 1, 1, 2])
		
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(set == [0, 1, 2])
    }
	
    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt9(_max))
        let decoded = try decoder.decode(UInt9.self, from: encoded)
        
        XCTAssertEqual(decoded, UInt9(_max))
    }
	
    // MARK: - Standard library extensions
	
    func testBinaryInteger_UInt9() {
        XCTAssertEqual(10.toUInt9, 10)
		
        XCTAssertEqual(Int8(10).toUInt9, 10)
        XCTAssertEqual(UInt8(10).toUInt9, 10)
		
        XCTAssertEqual(Int16(10).toUInt9, 10)
        XCTAssertEqual(UInt16(10).toUInt9, 10)
    }
	
    func testBinaryInteger_UInt9Exactly() {
        XCTAssertEqual(0b0_00000000.toUInt9Exactly, 0b0_00000000)
        XCTAssertEqual(0b1_11111111.toUInt9Exactly, 0b1_11111111)
    
        XCTAssertEqual(Int8(10).toUInt9Exactly, 10)
        XCTAssertEqual(UInt8(10).toUInt9Exactly, 10)
    
        XCTAssertEqual(Int16(10).toUInt9Exactly, 10)
        XCTAssertEqual(UInt16(10).toUInt9Exactly, 10)
    
        // nil (overflow)
    
        XCTAssertNil(0b10_00000000.toUInt9Exactly)
    }
    
    func testBinaryInteger_Init_UInt9() {
        XCTAssertEqual(Int(10.toUInt9), 10)
        XCTAssertEqual(Int(exactly: 10.toUInt9), 10)
    
        XCTAssertEqual(Int(exactly: 0b1_11111111.toUInt9), 0b1_11111111)
        XCTAssertNil(UInt8(exactly: 0b1_11111111.toUInt9))
    }
    
    // MARK: - Operators
    
    func testOperators() {
        XCTAssertEqual(1.toUInt9 + 1, 2.toUInt9)
        XCTAssertEqual(1 + 1.toUInt9, 2.toUInt9)
        XCTAssertEqual(1.toUInt9 + 1.toUInt9, 2)
    
        XCTAssertEqual(2.toUInt9 - 1, 1.toUInt9)
        XCTAssertEqual(2 - 1.toUInt9, 1.toUInt9)
        XCTAssertEqual(2.toUInt9 - 1.toUInt9, 1)
    
        XCTAssertEqual(2.toUInt9 * 2, 4.toUInt9)
        XCTAssertEqual(2 * 2.toUInt9, 4.toUInt9)
        XCTAssertEqual(2.toUInt9 * 2.toUInt9, 4)
    
        XCTAssertEqual(8.toUInt9 / 2, 4.toUInt9)
        XCTAssertEqual(8 / 2.toUInt9, 4.toUInt9)
        XCTAssertEqual(8.toUInt9 / 2.toUInt9, 4)
    
        XCTAssertEqual(8.toUInt9 % 3, 2.toUInt9)
        XCTAssertEqual(8 % 3.toUInt9, 2.toUInt9)
        XCTAssertEqual(8.toUInt9 % 3.toUInt9, 2)
    }
    
    func testAssignmentOperators() {
        var val = UInt9(2)
    
        val += 5
        XCTAssertEqual(val, 7)
    
        val -= 5
        XCTAssertEqual(val, 2)
    
        val *= 3
        XCTAssertEqual(val, 6)
    
        val /= 3
        XCTAssertEqual(val, 2)
    }
}

#endif
