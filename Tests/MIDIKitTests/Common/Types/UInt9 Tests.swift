//
//  UInt9 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import XCTestExtensions

final class UInt9_Tests: XCTestCase {
	
    fileprivate let _min      = 0b0_0000_0000 // int   0, hex 0x000
    fileprivate let _midpoint = 0b1_0000_0000 // int 256, hex 0x0FF
	fileprivate let _max      = 0b1_1111_1111 // int 511, hex 0x1FF
	
	func testInit_BinaryInteger() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt9().intValue, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt9(0).intValue, 0)
		XCTAssertEqual(MIDI.UInt9(UInt8(0)).intValue, 0)
		XCTAssertEqual(MIDI.UInt9(UInt16(0)).intValue, 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt9(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt9(2).intValue, 2)
		
		// overflow
		
        _XCTAssertThrows { [self] in
			_ = MIDI.UInt9(_min - 1)
		}
		
        _XCTAssertThrows { [self] in
			_ = MIDI.UInt9(_max + 1)
		}
		
	}
	
	func testInit_BinaryInteger_Exactly() {
		
		// typical
		
		XCTAssertEqual(MIDI.UInt9(exactly: 0)?.intValue, 0)
		
		XCTAssertEqual(MIDI.UInt9(exactly: 1)?.intValue, 1)
		
		XCTAssertEqual(MIDI.UInt9(exactly: _max)?.intValue, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt9(exactly: -1))
		
		XCTAssertNil(MIDI.UInt9(exactly: _max + 1))
		
	}
    
	func testInit_BinaryInteger_Clamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt9(clamping: 0).intValue, 0)
		XCTAssertEqual(MIDI.UInt9(clamping: 1).intValue, 1)
		XCTAssertEqual(MIDI.UInt9(clamping: _max).intValue, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt9(clamping: -1).intValue, 0)
		XCTAssertEqual(MIDI.UInt9(clamping: _max + 1).intValue, _max)
		
	}
    
    func testInit_BinaryFloatingPoint() {
        
        XCTAssertEqual(MIDI.UInt9(Double(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt9(Double(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt9(Double(5.9)).intValue, 5)
        
        XCTAssertEqual(MIDI.UInt9(Float(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt9(Float(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt9(Float(5.9)).intValue, 5)
        
        // overflow
        
        _XCTAssertThrows {
            _ = MIDI.UInt9(Double(0 - 1))
            _ = MIDI.UInt9(Float(0 - 1))
        }
        
        _XCTAssertThrows { [self] in
            _ = MIDI.UInt9(Double(_max + 1))
            _ = MIDI.UInt9(Float(_max + 1))
        }
        
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        
        // typical
        
        XCTAssertEqual(MIDI.UInt9(exactly: 0.0), 0)
        
        XCTAssertEqual(MIDI.UInt9(exactly: 1.0), 1)
        
        XCTAssertEqual(MIDI.UInt9(exactly: Double(_max))?.intValue, _max)
        
        // overflow
        
        XCTAssertNil(MIDI.UInt9(exactly: -1.0))
        
        XCTAssertNil(MIDI.UInt9(exactly: Double(_max) + 1.0))
        
    }
	
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt9.min.intValue, _min)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt9.max.intValue, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt9(1).intValue, 1)
		XCTAssertEqual(MIDI.UInt9(1).uInt16Value, 1)
		
	}
	
	func testEquatable() {
		
		XCTAssertTrue(MIDI.UInt9(0) == MIDI.UInt9(0))
		XCTAssertTrue(MIDI.UInt9(1) == MIDI.UInt9(1))
		XCTAssertTrue(MIDI.UInt9(_max) == MIDI.UInt9(_max))
		
		XCTAssertTrue(MIDI.UInt9(0) != MIDI.UInt9(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDI.UInt9(0) > MIDI.UInt9(0))
		XCTAssertFalse(MIDI.UInt9(1) > MIDI.UInt9(1))
		XCTAssertFalse(MIDI.UInt9(_max) > MIDI.UInt9(_max))
		
		XCTAssertTrue(MIDI.UInt9(0) < MIDI.UInt9(1))
		XCTAssertTrue(MIDI.UInt9(1) > MIDI.UInt9(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDI.UInt9>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDI.UInt9(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt9":511}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDI.UInt9.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDI.UInt9(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_UInt9() {
		
		XCTAssertEqual(10.toMIDIUInt9, 10)
		
		XCTAssertEqual(Int8(10).toMIDIUInt9, 10)
		XCTAssertEqual(UInt8(10).toMIDIUInt9, 10)
		
		XCTAssertEqual(Int16(10).toMIDIUInt9, 10)
		XCTAssertEqual(UInt16(10).toMIDIUInt9, 10)
		
	}
	
    func testBinaryInteger_UInt9Exactly() {
        
        XCTAssertEqual(0b0_0000_0000.toMIDIUInt9Exactly, 0b0_0000_0000)
        XCTAssertEqual(0b1_1111_1111.toMIDIUInt9Exactly, 0b1_1111_1111)
        
        XCTAssertEqual(Int8(10).toMIDIUInt9Exactly, 10)
        XCTAssertEqual(UInt8(10).toMIDIUInt9Exactly, 10)
        
        XCTAssertEqual(Int16(10).toMIDIUInt9Exactly, 10)
        XCTAssertEqual(UInt16(10).toMIDIUInt9Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b10_0000_0000.toMIDIUInt9Exactly)
        
    }
    
    func testBinaryInteger_Init_UInt9() {
        
        XCTAssertEqual(Int(10.toMIDIUInt9), 10)
        XCTAssertEqual(Int(exactly: 10.toMIDIUInt9), 10)
        
        XCTAssertEqual(Int(exactly: 0b1_1111_1111.toMIDIUInt9), 0b1_1111_1111)
        XCTAssertNil(UInt8(exactly: 0b1_1111_1111.toMIDIUInt9))
        
    }
    
    // MARK: - Operators
    
    func testOperators() {
        
        XCTAssertEqual(1.toMIDIUInt9 + 1             , 2.toMIDIUInt9)
        XCTAssertEqual(1 + 1.toMIDIUInt9             , 2.toMIDIUInt9)
        XCTAssertEqual(1.toMIDIUInt9 + 1.toMIDIUInt9 , 2)
        
        XCTAssertEqual(2.toMIDIUInt9 - 1             , 1.toMIDIUInt9)
        XCTAssertEqual(2 - 1.toMIDIUInt9             , 1.toMIDIUInt9)
        XCTAssertEqual(2.toMIDIUInt9 - 1.toMIDIUInt9 , 1)
        
        XCTAssertEqual(2.toMIDIUInt9 * 2             , 4.toMIDIUInt9)
        XCTAssertEqual(2 * 2.toMIDIUInt9             , 4.toMIDIUInt9)
        XCTAssertEqual(2.toMIDIUInt9 * 2.toMIDIUInt9 , 4)
        
        XCTAssertEqual(8.toMIDIUInt9 / 2             , 4.toMIDIUInt9)
        XCTAssertEqual(8 / 2.toMIDIUInt9             , 4.toMIDIUInt9)
        XCTAssertEqual(8.toMIDIUInt9 / 2.toMIDIUInt9 , 4)
        
        XCTAssertEqual(8.toMIDIUInt9 % 3             , 2.toMIDIUInt9)
        XCTAssertEqual(8 % 3.toMIDIUInt9             , 2.toMIDIUInt9)
        XCTAssertEqual(8.toMIDIUInt9 % 3.toMIDIUInt9 , 2)
        
    }
    
    func testAssignmentOperators() {
        
        var val = MIDI.UInt9(2)
        
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

