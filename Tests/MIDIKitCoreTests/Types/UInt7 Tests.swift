//
//  UInt7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class UInt7_Tests: XCTestCase {
    fileprivate let _min      = 0b0000000 // int   0, hex 0x00
    fileprivate let _midpoint = 0b1000000 // int  64, hex 0x40
    fileprivate let _max      = 0b1111111 // int 127, hex 0x7F
	
    func testInit_BinaryInteger() {
        // default
		
        XCTAssertEqual(UInt7().intValue, 0)
		
        // different integer types
		
        XCTAssertEqual(UInt7(0).intValue, 0)
        XCTAssertEqual(UInt7(UInt8(0)).intValue, 0)
        XCTAssertEqual(UInt7(UInt16(0)).intValue, 0)
		
        // values
		
        XCTAssertEqual(UInt7(1).intValue, 1)
        XCTAssertEqual(UInt7(2).intValue, 2)
		
        // overflow
		
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
//        _XCTAssertThrows { [self] in
        //			_ = UInt7(_min - 1)
        //		}
//
//        _XCTAssertThrows { [self] in
        //			_ = UInt7(_max + 1)
        //		}
    }
	
    func testInit_BinaryInteger_Exactly() {
        // typical
		
        XCTAssertEqual(UInt7(exactly: 0)?.intValue, 0)
		
        XCTAssertEqual(UInt7(exactly: 1)?.intValue, 1)
		
        XCTAssertEqual(UInt7(exactly: _max)?.intValue, _max)
		
        // overflow
		
        XCTAssertNil(UInt7(exactly: -1))
		
        XCTAssertNil(UInt7(exactly: _max + 1))
    }
    
    func testInit_BinaryInteger_Clamping() {
        // within range
		
        XCTAssertEqual(UInt7(clamping: 0).intValue, 0)
        XCTAssertEqual(UInt7(clamping: 1).intValue, 1)
        XCTAssertEqual(UInt7(clamping: _max).intValue, _max)
		
        // overflow
		
        XCTAssertEqual(UInt7(clamping: -1).intValue, 0)
        XCTAssertEqual(UInt7(clamping: _max + 1).intValue, _max)
    }
    
    func testInit_BinaryFloatingPoint() {
        XCTAssertEqual(UInt7(Double(0)).intValue, 0)
        XCTAssertEqual(UInt7(Double(1)).intValue, 1)
        XCTAssertEqual(UInt7(Double(5.9)).intValue, 5)
    
        XCTAssertEqual(UInt7(Float(0)).intValue, 0)
        XCTAssertEqual(UInt7(Float(1)).intValue, 1)
        XCTAssertEqual(UInt7(Float(5.9)).intValue, 5)
    
        // overflow
    
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
//        _XCTAssertThrows {
//            _ = UInt7(Double(0 - 1))
//            _ = UInt7(Float(0 - 1))
//        }
//
//        _XCTAssertThrows { [self] in
//            _ = UInt7(Double(_max + 1))
//            _ = UInt7(Float(_max + 1))
//        }
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        // typical
    
        XCTAssertEqual(UInt7(exactly: 0.0), 0)
    
        XCTAssertEqual(UInt7(exactly: 1.0), 1)
    
        XCTAssertEqual(UInt7(exactly: Double(_max))?.intValue, _max)
    
        // overflow
    
        XCTAssertNil(UInt7(exactly: -1.0))
    
        XCTAssertNil(UInt7(exactly: Double(_max) + 1.0))
    }
	
    func testMin() {
        XCTAssertEqual(UInt7.min.intValue, _min)
    }
	
    func testMax() {
        XCTAssertEqual(UInt7.max.intValue, _max)
    }
	
    func testComputedProperties() {
        XCTAssertEqual(UInt7(1).intValue, 1)
        XCTAssertEqual(UInt7(1).uInt8Value, 1)
    }
	
    func testStrideable() {
        let min = UInt7(_min)
        let max = UInt7(_max)
    
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
        XCTAssertTrue(UInt7(0) == UInt7(0))
        XCTAssertTrue(UInt7(1) == UInt7(1))
        XCTAssertTrue(UInt7(_max) == UInt7(_max))
		
        XCTAssertTrue(UInt7(0) != UInt7(1))
    }
	
    func testComparable() {
        XCTAssertFalse(UInt7(0) > UInt7(0))
        XCTAssertFalse(UInt7(1) > UInt7(1))
        XCTAssertFalse(UInt7(_max) > UInt7(_max))
		
        XCTAssertTrue(UInt7(0) < UInt7(1))
        XCTAssertTrue(UInt7(1) > UInt7(0))
    }
	
    func testHashable() {
        let set = Set<UInt7>([0, 1, 1, 2])
		
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(set == [0, 1, 2])
    }
	
    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt7(_max))
        let decoded = try decoder.decode(UInt7.self, from: encoded)
        
        XCTAssertEqual(decoded, UInt7(_max))
    }
	
    // MARK: - Standard library extensions
	
    func testBinaryInteger_UInt7() {
        XCTAssertEqual(10.toUInt7, 10)
		
        XCTAssertEqual(Int8(10).toUInt7, 10)
        XCTAssertEqual(UInt8(10).toUInt7, 10)
		
        XCTAssertEqual(Int16(10).toUInt7, 10)
        XCTAssertEqual(UInt16(10).toUInt7, 10)
    }
	
    func testBinaryInteger_UInt7Exactly() {
        XCTAssertEqual(0b0000000.toUInt7Exactly, 0b0000000)
        XCTAssertEqual(0b1111111.toUInt7Exactly, 0b1111111)
    
        XCTAssertEqual(Int8(10).toUInt7Exactly, 10)
        XCTAssertEqual(UInt8(10).toUInt7Exactly, 10)
    
        XCTAssertEqual(Int16(10).toUInt7Exactly, 10)
        XCTAssertEqual(UInt16(10).toUInt7Exactly, 10)
    
        // nil (overflow)
    
        XCTAssertNil(0b10000000.toUInt7Exactly)
    }
    
    func testBinaryInteger_Init_UInt7() {
        XCTAssertEqual(Int(10.toUInt7), 10)
        XCTAssertEqual(Int(exactly: 10.toUInt7), 10)
    
        // no BinaryInteger-conforming type in the Swift standard library
        // is smaller than 8 bits, so we can't really test .init(exactly:)
        // producing nil because it always succeeds (?)
        XCTAssertEqual(Int(exactly: 0b1111111.toUInt7), 0b1111111)
    }
    
    // MARK: - Operators
    
    func testOperators() {
        XCTAssertEqual(1.toUInt7 + 1, 2.toUInt7)
        XCTAssertEqual(1 + 1.toUInt7, 2.toUInt7)
        XCTAssertEqual(1.toUInt7 + 1.toUInt7, 2)
    
        XCTAssertEqual(2.toUInt7 - 1, 1.toUInt7)
        XCTAssertEqual(2 - 1.toUInt7, 1.toUInt7)
        XCTAssertEqual(2.toUInt7 - 1.toUInt7, 1)
    
        XCTAssertEqual(2.toUInt7 * 2, 4.toUInt7)
        XCTAssertEqual(2 * 2.toUInt7, 4.toUInt7)
        XCTAssertEqual(2.toUInt7 * 2.toUInt7, 4)
    
        XCTAssertEqual(8.toUInt7 / 2, 4.toUInt7)
        XCTAssertEqual(8 / 2.toUInt7, 4.toUInt7)
        XCTAssertEqual(8.toUInt7 / 2.toUInt7, 4)
    
        XCTAssertEqual(8.toUInt7 % 3, 2.toUInt7)
        XCTAssertEqual(8 % 3.toUInt7, 2.toUInt7)
        XCTAssertEqual(8.toUInt7 % 3.toUInt7, 2)
    }
    
    func testAssignmentOperators() {
        var val = UInt7(2)
    
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
