//
//  UInt7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import OTCoreTestingXCTest

final class UInt7_Tests: XCTestCase {
	
	fileprivate let _max = 0b111_1111
	
	func testInit() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt7().int, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt7(0).int, 0)
		XCTAssertEqual(MIDI.UInt7(UInt8(0)).int, 0)
		XCTAssertEqual(MIDI.UInt7(UInt16(0)).int, 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt7(1).int, 1)
		XCTAssertEqual(MIDI.UInt7(2).int, 2)
		
		// overflow
		
		expectFatalError {
			_ = MIDI.UInt7(0 - 1)
		}
		
		expectFatalError { [self] in
			_ = MIDI.UInt7(_max + 1)
		}
		
	}
	
	func testInitExactly() {
		
		// typical
		
		XCTAssertEqual(MIDI.UInt7(exactly: 0)?.int, 0)
		
		XCTAssertEqual(MIDI.UInt7(exactly: 1)?.int, 1)
		
		XCTAssertEqual(MIDI.UInt7(exactly: _max)?.int, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt7(exactly: -1))
		
		XCTAssertNil(MIDI.UInt7(exactly: _max + 1))
		
	}
	
	func testInitClamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt7(clamping: 0).int, 0)
		XCTAssertEqual(MIDI.UInt7(clamping: 1).int, 1)
		XCTAssertEqual(MIDI.UInt7(clamping: _max).int, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt7(clamping: -1).int, 0)
		XCTAssertEqual(MIDI.UInt7(clamping: _max + 1).int, _max)
		
	}
	
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt7.min.int, 0)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt7.max.int, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt7(1).int, 1)
		XCTAssertEqual(MIDI.UInt7(1).uint8, 1)
		
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
		
		XCTAssertEqual(10.midiUInt7, 10)
		
		XCTAssertEqual(Int8(10).midiUInt7, 10)
		XCTAssertEqual(UInt8(10).midiUInt7, 10)
		
		XCTAssertEqual(Int16(10).midiUInt7, 10)
		XCTAssertEqual(UInt16(10).midiUInt7, 10)
		
	}
	
    func testBinaryInteger_UInt7Exactly() {
        
        XCTAssertEqual(0b000_0000.midiUInt7Exactly, 0b000_0000)
        XCTAssertEqual(0b111_1111.midiUInt7Exactly, 0b111_1111)
        
        XCTAssertEqual(Int8(10).midiUInt7Exactly, 10)
        XCTAssertEqual(UInt8(10).midiUInt7Exactly, 10)
        
        XCTAssertEqual(Int16(10).midiUInt7Exactly, 10)
        XCTAssertEqual(UInt16(10).midiUInt7Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b1000_0000.midiUInt7Exactly)
        
    }
    
    func testBinaryInteger_Init_UInt7() {
        
        XCTAssertEqual(Int(10.midiUInt7), 10)
        XCTAssertEqual(Int(exactly: 10.midiUInt7), 10)
        
        // no BinaryInteger-conforming type in the Swift standard library is smaller than 8 bits, so we can't really test .init(exactly:) producing nil because it always succeeds (?)
        XCTAssertEqual(Int(exactly: 0b111_1111.midiUInt7), 0b111_1111)
        
    }
    
    // MARK: - Operators
    
    func testOperators() {
        
        XCTAssertEqual(1.midiUInt7 + 1           , 2.midiUInt7)
        XCTAssertEqual(1 + 1.midiUInt7           , 2.midiUInt7)
        XCTAssertEqual(1.midiUInt7 + 1.midiUInt7 , 2)
        
        XCTAssertEqual(2.midiUInt7 - 1           , 1.midiUInt7)
        XCTAssertEqual(2 - 1.midiUInt7           , 1.midiUInt7)
        XCTAssertEqual(2.midiUInt7 - 1.midiUInt7 , 1)
        
        XCTAssertEqual(2.midiUInt7 * 2           , 4.midiUInt7)
        XCTAssertEqual(2 * 2.midiUInt7           , 4.midiUInt7)
        XCTAssertEqual(2.midiUInt7 * 2.midiUInt7 , 4)
        
        XCTAssertEqual(8.midiUInt7 / 2           , 4.midiUInt7)
        XCTAssertEqual(8 / 2.midiUInt7           , 4.midiUInt7)
        XCTAssertEqual(8.midiUInt7 / 2.midiUInt7 , 4)
        
        XCTAssertEqual(8.midiUInt7 % 3           , 2.midiUInt7)
        XCTAssertEqual(8 % 3.midiUInt7           , 2.midiUInt7)
        XCTAssertEqual(8.midiUInt7 % 3.midiUInt7 , 2)
        
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

