//
//  UInt25 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class UInt25_Tests: XCTestCase {
    fileprivate let _min      = 0b0_00000000_00000000_00000000 // int        0, hex 0x0000000
    fileprivate let _midpoint = 0b1_00000000_00000000_00000000 // int 16777216, hex 0x1000000
    fileprivate let _max      = 0b1_11111111_11111111_11111111 // int 33554431, hex 0x1FFFFFF
	
    func testInit_BinaryInteger() {
        // default
		
        XCTAssertEqual(UInt25().intValue, 0)
		
        // different integer types
		
        XCTAssertEqual(UInt25(0).intValue, 0)
        XCTAssertEqual(UInt25(UInt8(0)).intValue, 0)
        XCTAssertEqual(UInt25(UInt16(0)).intValue, 0)
		
        // values
		
        XCTAssertEqual(UInt25(1).intValue, 1)
        XCTAssertEqual(UInt25(2).intValue, 2)
		
        // overflow
		
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
    
        // _XCTAssertThrows {
        //    _ = UInt25(0 - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //    _ = UInt25(_max + 1)
        // }
    }
	
    func testInit_BinaryInteger_Exactly() {
        // typical
		
        XCTAssertEqual(UInt25(exactly: 0)?.intValue, 0)
		
        XCTAssertEqual(UInt25(exactly: 1)?.intValue, 1)
		
        XCTAssertEqual(UInt25(exactly: _max)?.intValue, _max)
		
        // overflow
		
        XCTAssertNil(UInt25(exactly: -1))
		
        XCTAssertNil(UInt25(exactly: _max + 1))
    }
    
    func testInit_BinaryInteger_Clamping() {
        // within range
		
        XCTAssertEqual(UInt25(clamping: 0).intValue, 0)
        XCTAssertEqual(UInt25(clamping: 1).intValue, 1)
        XCTAssertEqual(UInt25(clamping: _max).intValue, _max)
		
        // overflow
		
        XCTAssertEqual(UInt25(clamping: -1).intValue, 0)
        XCTAssertEqual(UInt25(clamping: _max + 1).intValue, _max)
    }
    
    func testInit_BinaryFloatingPoint() {
        XCTAssertEqual(UInt25(Double(0)).intValue, 0)
        XCTAssertEqual(UInt25(Double(1)).intValue, 1)
        XCTAssertEqual(UInt25(Double(5.9)).intValue, 5)
    
        XCTAssertEqual(UInt25(Float(0)).intValue, 0)
        XCTAssertEqual(UInt25(Float(1)).intValue, 1)
        XCTAssertEqual(UInt25(Float(5.9)).intValue, 5)
    
        // overflow
    
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
    
        // _XCTAssertThrows {
        //    _ = UInt25(Double(0 - 1))
        //    _ = UInt25(Float(0 - 1))
        // }

        // _XCTAssertThrows { [self] in
        //    _ = UInt25(Double(_max + 1))
        //    _ = UInt25(Float(_max + 1))
        // }
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        // typical
    
        XCTAssertEqual(UInt25(exactly: 0.0), 0)
    
        XCTAssertEqual(UInt25(exactly: 1.0), 1)
    
        XCTAssertEqual(UInt25(exactly: Double(_max))?.intValue, _max)
    
        // overflow
    
        XCTAssertNil(UInt25(exactly: -1.0))
    
        XCTAssertNil(UInt25(exactly: Double(_max) + 1.0))
    }
	
    func testMin() {
        XCTAssertEqual(UInt25.min.intValue, 0)
    }
	
    func testMax() {
        XCTAssertEqual(UInt25.max.intValue, _max)
    }
	
    func testComputedProperties() {
        XCTAssertEqual(UInt25(1).intValue, 1)
        XCTAssertEqual(UInt25(1).uInt32Value, 1)
    }
	
    func testStrideable() {
        let min = UInt25(_min)
        let max = UInt25(_max)
    
        let strideBy1 = stride(from: min, through: max, by: 1)
        _ = strideBy1
        // skip this, it takes way too long to compute ...
        // XCTAssertEqual(strideBy1.underestimatedCount, _max + 1)
        // XCTAssertTrue(strideBy1.starts(with: [min]))
        // XCTAssertEqual(strideBy1.suffix(1), [max])
    
        let range = min ... max
        XCTAssertEqual(range.count, _max + 1)
        XCTAssertEqual(range.lowerBound, min)
        XCTAssertEqual(range.upperBound, max)
    }
    
    func testEquatable() {
        XCTAssertTrue(UInt25(0) == UInt25(0))
        XCTAssertTrue(UInt25(1) == UInt25(1))
        XCTAssertTrue(UInt25(_max) == UInt25(_max))
		
        XCTAssertTrue(UInt25(0) != UInt25(1))
    }
	
    func testComparable() {
        XCTAssertFalse(UInt25(0) > UInt25(0))
        XCTAssertFalse(UInt25(1) > UInt25(1))
        XCTAssertFalse(UInt25(_max) > UInt25(_max))
		
        XCTAssertTrue(UInt25(0) < UInt25(1))
        XCTAssertTrue(UInt25(1) > UInt25(0))
    }
	
    func testHashable() {
        let set = Set<UInt25>([0, 1, 1, 2])
		
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(set == [0, 1, 2])
    }
	
    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt25(_max))
        let decoded = try decoder.decode(UInt25.self, from: encoded)
        
        XCTAssertEqual(decoded, UInt25(_max))
    }
	
    // MARK: - Standard library extensions
	
    func testBinaryInteger_UInt25() {
        XCTAssertEqual(10.toUInt25, 10)
		
        XCTAssertEqual(Int8(10).toUInt25, 10)
        XCTAssertEqual(UInt8(10).toUInt25, 10)
		
        XCTAssertEqual(Int16(10).toUInt25, 10)
        XCTAssertEqual(UInt16(10).toUInt25, 10)
    }
	
    func testBinaryInteger_UInt25Exactly() {
        XCTAssertEqual(
            0b0_00000000_00000000_00000000.toUInt25Exactly,
            0b0_00000000_00000000_00000000
        )
        XCTAssertEqual(
            0b1_11111111_11111111_11111111.toUInt25Exactly,
            0b1_11111111_11111111_11111111
        )
    
        XCTAssertEqual(Int8(10).toUInt25Exactly, 10)
        XCTAssertEqual(UInt8(10).toUInt25Exactly, 10)
    
        XCTAssertEqual(Int16(10).toUInt25Exactly, 10)
        XCTAssertEqual(UInt16(10).toUInt25Exactly, 10)
    
        // nil (overflow)
    
        XCTAssertNil(0b10_00000000_00000000_00000000.toUInt25Exactly)
    }
    
    func testBinaryInteger_Init_UInt25() {
        XCTAssertEqual(Int(10.toUInt25), 10)
        XCTAssertEqual(Int(exactly: 10.toUInt25), 10)
    
        XCTAssertEqual(
            Int(exactly: 0b1_11111111_11111111_11111111.toUInt25),
            0b1_11111111_11111111_11111111
        )
        XCTAssertNil(UInt8(exactly: 0b1_11111111.toUInt25))
    }
    
    // MARK: - Operators
    
    func testOperators() {
        XCTAssertEqual(1.toUInt25 + 1, 2.toUInt25)
        XCTAssertEqual(1 + 1.toUInt25, 2.toUInt25)
        XCTAssertEqual(1.toUInt25 + 1.toUInt25, 2)
    
        XCTAssertEqual(2.toUInt25 - 1, 1.toUInt25)
        XCTAssertEqual(2 - 1.toUInt25, 1.toUInt25)
        XCTAssertEqual(2.toUInt25 - 1.toUInt25, 1)
    
        XCTAssertEqual(2.toUInt25 * 2, 4.toUInt25)
        XCTAssertEqual(2 * 2.toUInt25, 4.toUInt25)
        XCTAssertEqual(2.toUInt25 * 2.toUInt25, 4)
    
        XCTAssertEqual(8.toUInt25 / 2, 4.toUInt25)
        XCTAssertEqual(8 / 2.toUInt25, 4.toUInt25)
        XCTAssertEqual(8.toUInt25 / 2.toUInt25, 4)
    
        XCTAssertEqual(8.toUInt25 % 3, 2.toUInt25)
        XCTAssertEqual(8 % 3.toUInt25, 2.toUInt25)
        XCTAssertEqual(8.toUInt25 % 3.toUInt25, 2)
    }
    
    func testAssignmentOperators() {
        var val = UInt25(2)
    
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
