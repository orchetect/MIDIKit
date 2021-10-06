//
//  UInt4 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import XCTestExtensions

final class UInt4_Tests: XCTestCase {
	
    fileprivate let _min      = 0b0000 // int  0, hex 0x0
    fileprivate let _midpoint = 0b1000 // int  8, hex 0x8
	fileprivate let _max      = 0b1111 // int 15, hex 0xF
	
	func testInit_BinaryInteger() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt4().intValue, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt4(0).intValue, 0)
		XCTAssertEqual(MIDI.UInt4(UInt8(0)).intValue, 0)
		XCTAssertEqual(MIDI.UInt4(UInt16(0)).intValue, 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt4(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt4(2).intValue, 2)
		
		// overflow
		
		_XCTAssertThrows { [self] in
			_ = MIDI.UInt4(_min - 1)
		}
		
        _XCTAssertThrows { [self] in
			_ = MIDI.UInt4(_max + 1)
		}
		
	}
	
	func testInit_BinaryInteger_Exactly() {
		
		// typical
		
		XCTAssertEqual(MIDI.UInt4(exactly: 0)?.intValue, 0)
		
		XCTAssertEqual(MIDI.UInt4(exactly: 1)?.intValue, 1)
		
		XCTAssertEqual(MIDI.UInt4(exactly: _max)?.intValue, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt4(exactly: -1))
		
		XCTAssertNil(MIDI.UInt4(exactly: _max + 1))
		
	}
	
	func testInitBinaryInteger_Clamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt4(clamping: 0).intValue, 0)
		XCTAssertEqual(MIDI.UInt4(clamping: 1).intValue, 1)
		XCTAssertEqual(MIDI.UInt4(clamping: _max).intValue, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt4(clamping: -1).intValue, 0)
		XCTAssertEqual(MIDI.UInt4(clamping: _max + 1).intValue, _max)
		
	}
    
    func testInit_BinaryFloatingPoint() {
        
        XCTAssertEqual(MIDI.UInt4(Double(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt4(Double(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt4(Double(5.9)).intValue, 5)
        
        XCTAssertEqual(MIDI.UInt4(Float(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt4(Float(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt4(Float(5.9)).intValue, 5)
        
        // overflow
        
        _XCTAssertThrows {
            _ = MIDI.UInt4(Double(0 - 1))
            _ = MIDI.UInt4(Float(0 - 1))
        }
        
        _XCTAssertThrows { [self] in
            _ = MIDI.UInt4(Double(_max + 1))
            _ = MIDI.UInt4(Float(_max + 1))
        }
        
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        
        // typical
        
        XCTAssertEqual(MIDI.UInt4(exactly: 0.0), 0)
        
        XCTAssertEqual(MIDI.UInt4(exactly: 1.0), 1)
        
        XCTAssertEqual(MIDI.UInt4(exactly: Double(_max))?.intValue, _max)
        
        // overflow
        
        XCTAssertNil(MIDI.UInt4(exactly: -1.0))
        
        XCTAssertNil(MIDI.UInt4(exactly: Double(_max) + 1.0))
        
    }
    
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt4.min.intValue, _min)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt4.max.intValue, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt4(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt4(1).uInt8Value, 1)
		
	}
    
    func testStrideable() {
        
        let min = MIDI.UInt4(_min)
        let max = MIDI.UInt4(_max)
        
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
		
		XCTAssertTrue(MIDI.UInt4(0) == MIDI.UInt4(0))
		XCTAssertTrue(MIDI.UInt4(1) == MIDI.UInt4(1))
		XCTAssertTrue(MIDI.UInt4(_max) == MIDI.UInt4(_max))
		
		XCTAssertTrue(MIDI.UInt4(0) != MIDI.UInt4(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDI.UInt4(0) > MIDI.UInt4(0))
		XCTAssertFalse(MIDI.UInt4(1) > MIDI.UInt4(1))
		XCTAssertFalse(MIDI.UInt4(_max) > MIDI.UInt4(_max))
		
		XCTAssertTrue(MIDI.UInt4(0) < MIDI.UInt4(1))
		XCTAssertTrue(MIDI.UInt4(1) > MIDI.UInt4(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDI.UInt4>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDI.UInt4(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt4":15}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDI.UInt4.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDI.UInt4(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_UInt4() {
		
		XCTAssertEqual(10.toMIDIUInt4, 10)
		
		XCTAssertEqual(Int8(10).toMIDIUInt4, 10)
		XCTAssertEqual(UInt8(10).toMIDIUInt4, 10)
		
		XCTAssertEqual(Int16(10).toMIDIUInt4, 10)
		XCTAssertEqual(UInt16(10).toMIDIUInt4, 10)
		
	}
    
    func testBinaryInteger_UInt4Exactly() {
        
        XCTAssertEqual(0b0000.toMIDIUInt4Exactly, 0b0000)
        XCTAssertEqual(0b1111.toMIDIUInt4Exactly, 0b1111)
        
        XCTAssertEqual(Int8(10).toMIDIUInt4Exactly, 10)
        XCTAssertEqual(UInt8(10).toMIDIUInt4Exactly, 10)
        
        XCTAssertEqual(Int16(10).toMIDIUInt4Exactly, 10)
        XCTAssertEqual(UInt16(10).toMIDIUInt4Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b1_0000.toMIDIUInt4Exactly)
        
    }
    
    func testBinaryInteger_Init_UInt4() {
        
        XCTAssertEqual(Int(10.toMIDIUInt4), 10)
        XCTAssertEqual(Int(exactly: 10.toMIDIUInt4), 10)
        
        // no BinaryInteger-conforming type in the Swift standard library is smaller than 8 bits, so we can't really test .init(exactly:) producing nil because it always succeeds (?)
        XCTAssertEqual(Int(exactly: 0b1111.toMIDIUInt4), 0b1111)
        
    }
	
    // MARK: - Operators
    
    func testOperators() {
        
        XCTAssertEqual(1.toMIDIUInt4 + 1             , 2.toMIDIUInt4)
        XCTAssertEqual(1 + 1.toMIDIUInt4             , 2.toMIDIUInt4)
        XCTAssertEqual(1.toMIDIUInt4 + 1.toMIDIUInt4 , 2)
        
        XCTAssertEqual(2.toMIDIUInt4 - 1             , 1.toMIDIUInt4)
        XCTAssertEqual(2 - 1.toMIDIUInt4             , 1.toMIDIUInt4)
        XCTAssertEqual(2.toMIDIUInt4 - 1.toMIDIUInt4 , 1)
        
        XCTAssertEqual(2.toMIDIUInt4 * 2             , 4.toMIDIUInt4)
        XCTAssertEqual(2 * 2.toMIDIUInt4             , 4.toMIDIUInt4)
        XCTAssertEqual(2.toMIDIUInt4 * 2.toMIDIUInt4 , 4)
        
        XCTAssertEqual(8.toMIDIUInt4 / 2             , 4.toMIDIUInt4)
        XCTAssertEqual(8 / 2.toMIDIUInt4             , 4.toMIDIUInt4)
        XCTAssertEqual(8.toMIDIUInt4 / 2.toMIDIUInt4 , 4)
        
        XCTAssertEqual(8.toMIDIUInt4 % 3             , 2.toMIDIUInt4)
        XCTAssertEqual(8 % 3.toMIDIUInt4             , 2.toMIDIUInt4)
        XCTAssertEqual(8.toMIDIUInt4 % 3.toMIDIUInt4 , 2)
        
    }
    
    func testAssignmentOperators() {
        
        var val = MIDI.UInt4(2)
        
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
