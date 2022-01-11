//
//  UInt7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

final class UInt7_Tests: XCTestCase {
	
    fileprivate let _min      = 0b000_0000 // int   0, hex 0x00
    fileprivate let _midpoint = 0b100_0000 // int  64, hex 0x40
	fileprivate let _max      = 0b111_1111 // int 127, hex 0x7F
	
	func testInit_BinaryInteger() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt7().intValue, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt7(0).intValue, 0)
		XCTAssertEqual(MIDI.UInt7(UInt8(0)).intValue, 0)
		XCTAssertEqual(MIDI.UInt7(UInt16(0)).intValue, 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt7(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt7(2).intValue, 2)
		
		// overflow
		
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
//        _XCTAssertThrows { [self] in
//			_ = MIDI.UInt7(_min - 1)
//		}
//
//        _XCTAssertThrows { [self] in
//			_ = MIDI.UInt7(_max + 1)
//		}
		
	}
	
	func testInit_BinaryInteger_Exactly() {
		
		// typical
		
		XCTAssertEqual(MIDI.UInt7(exactly: 0)?.intValue, 0)
		
		XCTAssertEqual(MIDI.UInt7(exactly: 1)?.intValue, 1)
		
		XCTAssertEqual(MIDI.UInt7(exactly: _max)?.intValue, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt7(exactly: -1))
		
		XCTAssertNil(MIDI.UInt7(exactly: _max + 1))
		
	}
    
	func testInit_BinaryInteger_Clamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt7(clamping: 0).intValue, 0)
		XCTAssertEqual(MIDI.UInt7(clamping: 1).intValue, 1)
		XCTAssertEqual(MIDI.UInt7(clamping: _max).intValue, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt7(clamping: -1).intValue, 0)
		XCTAssertEqual(MIDI.UInt7(clamping: _max + 1).intValue, _max)
		
	}
    
    func testInit_BinaryFloatingPoint() {
        
        XCTAssertEqual(MIDI.UInt7(Double(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt7(Double(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt7(Double(5.9)).intValue, 5)
        
        XCTAssertEqual(MIDI.UInt7(Float(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt7(Float(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt7(Float(5.9)).intValue, 5)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
//        _XCTAssertThrows {
//            _ = MIDI.UInt7(Double(0 - 1))
//            _ = MIDI.UInt7(Float(0 - 1))
//        }
//        
//        _XCTAssertThrows { [self] in
//            _ = MIDI.UInt7(Double(_max + 1))
//            _ = MIDI.UInt7(Float(_max + 1))
//        }
        
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        
        // typical
        
        XCTAssertEqual(MIDI.UInt7(exactly: 0.0), 0)
        
        XCTAssertEqual(MIDI.UInt7(exactly: 1.0), 1)
        
        XCTAssertEqual(MIDI.UInt7(exactly: Double(_max))?.intValue, _max)
        
        // overflow
        
        XCTAssertNil(MIDI.UInt7(exactly: -1.0))
        
        XCTAssertNil(MIDI.UInt7(exactly: Double(_max) + 1.0))
        
    }
	
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt7.min.intValue, _min)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt7.max.intValue, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt7(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt7(1).uInt8Value, 1)
		
	}
	
    func testStrideable() {
        
        let min = MIDI.UInt7(_min)
        let max = MIDI.UInt7(_max)
        
        let strideBy1 = stride(from: min, through: max, by: 1)
        XCTAssertEqual(strideBy1.underestimatedCount, _max + 1)
        XCTAssertTrue(strideBy1.starts(with: [min]))
        XCTAssertEqual(strideBy1.suffix(1), [max])
        
        let range = min...max
        XCTAssertEqual(range.count, _max + 1)
        XCTAssertEqual(range.lowerBound, min)
        XCTAssertEqual(range.upperBound, max)
        
    }
    
	func testEquatable() {
		
		XCTAssertTrue(MIDI.UInt7(0) == MIDI.UInt7(0))
		XCTAssertTrue(MIDI.UInt7(1) == MIDI.UInt7(1))
		XCTAssertTrue(MIDI.UInt7(_max) == MIDI.UInt7(_max))
		
		XCTAssertTrue(MIDI.UInt7(0) != MIDI.UInt7(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDI.UInt7(0) > MIDI.UInt7(0))
		XCTAssertFalse(MIDI.UInt7(1) > MIDI.UInt7(1))
		XCTAssertFalse(MIDI.UInt7(_max) > MIDI.UInt7(_max))
		
		XCTAssertTrue(MIDI.UInt7(0) < MIDI.UInt7(1))
		XCTAssertTrue(MIDI.UInt7(1) > MIDI.UInt7(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDI.UInt7>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDI.UInt7(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt7":127}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDI.UInt7.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDI.UInt7(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_UInt7() {
		
		XCTAssertEqual(10.toMIDIUInt7, 10)
		
		XCTAssertEqual(Int8(10).toMIDIUInt7, 10)
		XCTAssertEqual(UInt8(10).toMIDIUInt7, 10)
		
		XCTAssertEqual(Int16(10).toMIDIUInt7, 10)
		XCTAssertEqual(UInt16(10).toMIDIUInt7, 10)
		
	}
	
    func testBinaryInteger_UInt7Exactly() {
        
        XCTAssertEqual(0b000_0000.toMIDIUInt7Exactly, 0b000_0000)
        XCTAssertEqual(0b111_1111.toMIDIUInt7Exactly, 0b111_1111)
        
        XCTAssertEqual(Int8(10).toMIDIUInt7Exactly, 10)
        XCTAssertEqual(UInt8(10).toMIDIUInt7Exactly, 10)
        
        XCTAssertEqual(Int16(10).toMIDIUInt7Exactly, 10)
        XCTAssertEqual(UInt16(10).toMIDIUInt7Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b1000_0000.toMIDIUInt7Exactly)
        
    }
    
    func testBinaryInteger_Init_UInt7() {
        
        XCTAssertEqual(Int(10.toMIDIUInt7), 10)
        XCTAssertEqual(Int(exactly: 10.toMIDIUInt7), 10)
        
        // no BinaryInteger-conforming type in the Swift standard library is smaller than 8 bits, so we can't really test .init(exactly:) producing nil because it always succeeds (?)
        XCTAssertEqual(Int(exactly: 0b111_1111.toMIDIUInt7), 0b111_1111)
        
    }
    
    // MARK: - Operators
    
    func testOperators() {
        
        XCTAssertEqual(1.toMIDIUInt7 + 1             , 2.toMIDIUInt7)
        XCTAssertEqual(1 + 1.toMIDIUInt7             , 2.toMIDIUInt7)
        XCTAssertEqual(1.toMIDIUInt7 + 1.toMIDIUInt7 , 2)
        
        XCTAssertEqual(2.toMIDIUInt7 - 1             , 1.toMIDIUInt7)
        XCTAssertEqual(2 - 1.toMIDIUInt7             , 1.toMIDIUInt7)
        XCTAssertEqual(2.toMIDIUInt7 - 1.toMIDIUInt7 , 1)
        
        XCTAssertEqual(2.toMIDIUInt7 * 2             , 4.toMIDIUInt7)
        XCTAssertEqual(2 * 2.toMIDIUInt7             , 4.toMIDIUInt7)
        XCTAssertEqual(2.toMIDIUInt7 * 2.toMIDIUInt7 , 4)
        
        XCTAssertEqual(8.toMIDIUInt7 / 2             , 4.toMIDIUInt7)
        XCTAssertEqual(8 / 2.toMIDIUInt7             , 4.toMIDIUInt7)
        XCTAssertEqual(8.toMIDIUInt7 / 2.toMIDIUInt7 , 4)
        
        XCTAssertEqual(8.toMIDIUInt7 % 3             , 2.toMIDIUInt7)
        XCTAssertEqual(8 % 3.toMIDIUInt7             , 2.toMIDIUInt7)
        XCTAssertEqual(8.toMIDIUInt7 % 3.toMIDIUInt7 , 2)
        
    }
    
    func testAssignmentOperators() {
        
        var val = MIDI.UInt7(2)
        
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

