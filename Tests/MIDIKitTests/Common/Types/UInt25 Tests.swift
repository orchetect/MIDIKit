//
//  UInt25 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import XCTestExtensions

final class UInt25_Tests: XCTestCase {
	
    fileprivate let _min      = 0b0_00000000_00000000_00000000 // int        0, hex 0x0000000
    fileprivate let _midpoint = 0b1_00000000_00000000_00000000 // int 16777216, hex 0x1000000
	fileprivate let _max      = 0b1_11111111_11111111_11111111 // int 33554431, hex 0x1FFFFFF
	
	func testInit_BinaryInteger() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt25().intValue, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt25(0).intValue, 0)
		XCTAssertEqual(MIDI.UInt25(UInt8(0)).intValue, 0)
		XCTAssertEqual(MIDI.UInt25(UInt16(0)).intValue, 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt25(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt25(2).intValue, 2)
		
		// overflow
		
        _XCTAssertThrows {
			_ = MIDI.UInt25(0 - 1)
		}
		
        _XCTAssertThrows { [self] in
			_ = MIDI.UInt25(_max + 1)
		}
		
	}
	
	func testInit_BinaryInteger_Exactly() {
		
		// typical
		
		XCTAssertEqual(MIDI.UInt25(exactly: 0)?.intValue, 0)
		
		XCTAssertEqual(MIDI.UInt25(exactly: 1)?.intValue, 1)
		
		XCTAssertEqual(MIDI.UInt25(exactly: _max)?.intValue, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt25(exactly: -1))
		
		XCTAssertNil(MIDI.UInt25(exactly: _max + 1))
		
	}
    
	func testInit_BinaryInteger_Clamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt25(clamping: 0).intValue, 0)
		XCTAssertEqual(MIDI.UInt25(clamping: 1).intValue, 1)
		XCTAssertEqual(MIDI.UInt25(clamping: _max).intValue, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt25(clamping: -1).intValue, 0)
		XCTAssertEqual(MIDI.UInt25(clamping: _max + 1).intValue, _max)
		
	}
    
    func testInit_BinaryFloatingPoint() {
        
        XCTAssertEqual(MIDI.UInt25(Double(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt25(Double(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt25(Double(5.9)).intValue, 5)
        
        XCTAssertEqual(MIDI.UInt25(Float(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt25(Float(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt25(Float(5.9)).intValue, 5)
        
        // overflow
        
        _XCTAssertThrows {
            _ = MIDI.UInt25(Double(0 - 1))
            _ = MIDI.UInt25(Float(0 - 1))
        }
        
        _XCTAssertThrows { [self] in
            _ = MIDI.UInt25(Double(_max + 1))
            _ = MIDI.UInt25(Float(_max + 1))
        }
        
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        
        // typical
        
        XCTAssertEqual(MIDI.UInt25(exactly: 0.0), 0)
        
        XCTAssertEqual(MIDI.UInt25(exactly: 1.0), 1)
        
        XCTAssertEqual(MIDI.UInt25(exactly: Double(_max))?.intValue, _max)
        
        // overflow
        
        XCTAssertNil(MIDI.UInt25(exactly: -1.0))
        
        XCTAssertNil(MIDI.UInt25(exactly: Double(_max) + 1.0))
        
    }
	
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt25.min.intValue, 0)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt25.max.intValue, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt25(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt25(1).uInt32Value, 1)
		
	}
	
    func testStrideable() {
        
        let min = MIDI.UInt25(_min)
        let max = MIDI.UInt25(_max)
        
        let strideBy1 = stride(from: min, through: max, by: 1)
        _ = strideBy1
        // skip this, it takes way too long to compute ...
        //XCTAssertEqual(strideBy1.underestimatedCount, _max + 1)
        //XCTAssertTrue(strideBy1.starts(with: [min]))
        //XCTAssertEqual(strideBy1.suffix(1), [max])
        
        let range = min...max
        XCTAssertEqual(range.count, _max + 1)
        XCTAssertEqual(range.lowerBound, min)
        XCTAssertEqual(range.upperBound, max)
        
    }
    
	func testEquatable() {
		
		XCTAssertTrue(MIDI.UInt25(0) == MIDI.UInt25(0))
		XCTAssertTrue(MIDI.UInt25(1) == MIDI.UInt25(1))
		XCTAssertTrue(MIDI.UInt25(_max) == MIDI.UInt25(_max))
		
		XCTAssertTrue(MIDI.UInt25(0) != MIDI.UInt25(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDI.UInt25(0) > MIDI.UInt25(0))
		XCTAssertFalse(MIDI.UInt25(1) > MIDI.UInt25(1))
		XCTAssertFalse(MIDI.UInt25(_max) > MIDI.UInt25(_max))
		
		XCTAssertTrue(MIDI.UInt25(0) < MIDI.UInt25(1))
		XCTAssertTrue(MIDI.UInt25(1) > MIDI.UInt25(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDI.UInt25>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDI.UInt25(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt25":33554431}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDI.UInt25.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDI.UInt25(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_UInt25() {
		
		XCTAssertEqual(10.toMIDIUInt25, 10)
		
		XCTAssertEqual(Int8(10).toMIDIUInt25, 10)
		XCTAssertEqual(UInt8(10).toMIDIUInt25, 10)
		
		XCTAssertEqual(Int16(10).toMIDIUInt25, 10)
		XCTAssertEqual(UInt16(10).toMIDIUInt25, 10)
		
	}
	
    func testBinaryInteger_UInt25Exactly() {
        
        XCTAssertEqual(0b0_00000000_00000000_00000000.toMIDIUInt25Exactly,
                       0b0_00000000_00000000_00000000)
        XCTAssertEqual(0b1_11111111_11111111_11111111.toMIDIUInt25Exactly,
                       0b1_11111111_11111111_11111111)
        
        XCTAssertEqual(Int8(10).toMIDIUInt25Exactly, 10)
        XCTAssertEqual(UInt8(10).toMIDIUInt25Exactly, 10)
        
        XCTAssertEqual(Int16(10).toMIDIUInt25Exactly, 10)
        XCTAssertEqual(UInt16(10).toMIDIUInt25Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b10_00000000_00000000_00000000.toMIDIUInt25Exactly)
        
    }
    
    func testBinaryInteger_Init_UInt25() {
        
        XCTAssertEqual(Int(10.toMIDIUInt25), 10)
        XCTAssertEqual(Int(exactly: 10.toMIDIUInt25), 10)
        
        XCTAssertEqual(Int(exactly: 0b1_11111111_11111111_11111111.toMIDIUInt25),
                       0b1_11111111_11111111_11111111)
        XCTAssertNil(UInt8(exactly: 0b1_1111_1111.toMIDIUInt25))
        
    }
    
    // MARK: - Operators
    
    func testOperators() {
        
        XCTAssertEqual(1.toMIDIUInt25 + 1              , 2.toMIDIUInt25)
        XCTAssertEqual(1 + 1.toMIDIUInt25              , 2.toMIDIUInt25)
        XCTAssertEqual(1.toMIDIUInt25 + 1.toMIDIUInt25 , 2)
        
        XCTAssertEqual(2.toMIDIUInt25 - 1              , 1.toMIDIUInt25)
        XCTAssertEqual(2 - 1.toMIDIUInt25              , 1.toMIDIUInt25)
        XCTAssertEqual(2.toMIDIUInt25 - 1.toMIDIUInt25 , 1)
        
        XCTAssertEqual(2.toMIDIUInt25 * 2              , 4.toMIDIUInt25)
        XCTAssertEqual(2 * 2.toMIDIUInt25              , 4.toMIDIUInt25)
        XCTAssertEqual(2.toMIDIUInt25 * 2.toMIDIUInt25 , 4)
        
        XCTAssertEqual(8.toMIDIUInt25 / 2              , 4.toMIDIUInt25)
        XCTAssertEqual(8 / 2.toMIDIUInt25              , 4.toMIDIUInt25)
        XCTAssertEqual(8.toMIDIUInt25 / 2.toMIDIUInt25 , 4)
        
        XCTAssertEqual(8.toMIDIUInt25 % 3              , 2.toMIDIUInt25)
        XCTAssertEqual(8 % 3.toMIDIUInt25              , 2.toMIDIUInt25)
        XCTAssertEqual(8.toMIDIUInt25 % 3.toMIDIUInt25 , 2)
        
    }
    
    func testAssignmentOperators() {
        
        var val = MIDI.UInt25(2)
        
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
