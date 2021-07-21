//
//  UInt4 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import OTCoreTestingXCTest

final class UInt4_Tests: XCTestCase {
	
	fileprivate let _max = 0b1111
	
	func testInit() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt4().asInt, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt4(0).asInt, 0)
		XCTAssertEqual(MIDI.UInt4(UInt8(0)).asInt, 0)
		XCTAssertEqual(MIDI.UInt4(UInt16(0)).asInt, 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt4(1).asInt, 1)
		XCTAssertEqual(MIDI.UInt4(2).asInt, 2)
		
		// overflow
		
		expectFatalError {
			_ = MIDI.UInt4(0 - 1)
		}
		
		expectFatalError { [self] in
			_ = MIDI.UInt4(_max + 1)
		}
		
	}
	
	func testInitExactly() {
		
		// typical
		
		XCTAssertEqual(MIDI.UInt4(exactly: 0)?.asInt, 0)
		
		XCTAssertEqual(MIDI.UInt4(exactly: 1)?.asInt, 1)
		
		XCTAssertEqual(MIDI.UInt4(exactly: _max)?.asInt, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt4(exactly: -1))
		
		XCTAssertNil(MIDI.UInt4(exactly: _max + 1))
		
	}
	
	func testInitClamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt4(clamping: 0).asInt, 0)
		XCTAssertEqual(MIDI.UInt4(clamping: 1).asInt, 1)
		XCTAssertEqual(MIDI.UInt4(clamping: _max).asInt, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt4(clamping: -1).asInt, 0)
		XCTAssertEqual(MIDI.UInt4(clamping: _max + 1).asInt, _max)
		
	}
	
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt4.min.asInt, 0)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt4.max.asInt, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt4(1).asInt, 1)
		XCTAssertEqual(MIDI.UInt4(1).asUInt8, 1)
		
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
		
		XCTAssertEqual(10.midiUInt4, 10)
		
		XCTAssertEqual(Int8(10).midiUInt4, 10)
		XCTAssertEqual(UInt8(10).midiUInt4, 10)
		
		XCTAssertEqual(Int16(10).midiUInt4, 10)
		XCTAssertEqual(UInt16(10).midiUInt4, 10)
		
	}
    
    func testBinaryInteger_UInt4Exactly() {
        
        XCTAssertEqual(0b0000.midiUInt4Exactly, 0b0000)
        XCTAssertEqual(0b1111.midiUInt4Exactly, 0b1111)
        
        XCTAssertEqual(Int8(10).midiUInt4Exactly, 10)
        XCTAssertEqual(UInt8(10).midiUInt4Exactly, 10)
        
        XCTAssertEqual(Int16(10).midiUInt4Exactly, 10)
        XCTAssertEqual(UInt16(10).midiUInt4Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b1_0000.midiUInt4Exactly)
        
    }
    
    func testBinaryInteger_Init_UInt4() {
        
        XCTAssertEqual(Int(10.midiUInt4), 10)
        XCTAssertEqual(Int(exactly: 10.midiUInt4), 10)
        
        // no BinaryInteger-conforming type in the Swift standard library is smaller than 8 bits, so we can't really test .init(exactly:) producing nil because it always succeeds (?)
        XCTAssertEqual(Int(exactly: 0b1111.midiUInt4), 0b1111)
        
    }
	
}

#endif
