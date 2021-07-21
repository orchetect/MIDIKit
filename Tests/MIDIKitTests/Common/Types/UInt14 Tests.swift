//
//  UInt14 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
//import OTCoreTestingXCTest

final class UInt14_Tests: XCTestCase {
	
	fileprivate let _min = 0b0000000_0000000
	fileprivate let _midpoint = 0b1000000_0000000
	fileprivate let _max = 0b1111111_1111111
	
	func testInit() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt14().value, _midpoint)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt14(0), 0)
		XCTAssertEqual(MIDI.UInt14(UInt8(0)), 0)
		XCTAssertEqual(MIDI.UInt14(UInt16(0)), 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt14(1), 1)
		XCTAssertEqual(MIDI.UInt14(2), 2)
		
		// overflow
		
		expectFatalError { [self] in
			_ = MIDI.UInt14(_min - 1)
		}
		expectFatalError { [self] in
			_ = MIDI.UInt14(_max + 1)
		}
		
	}
	
	func testInitExactly() {
		
		// typical
		
		XCTAssertEqual(MIDI.UInt14(exactly: 0), 0)
		
		XCTAssertEqual(MIDI.UInt14(exactly: 1), 1)
		
		XCTAssertEqual(MIDI.UInt14(exactly: _max)?.asInt, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt14(exactly: -1))
		
		XCTAssertNil(MIDI.UInt14(exactly: _max + 1))
		
	}
	
	func testInitClamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt14(clamping: 0), 0)
		XCTAssertEqual(MIDI.UInt14(clamping: 1), 1)
		XCTAssertEqual(MIDI.UInt14(clamping: _max).asInt, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt14(clamping: -1).asInt, 0)
		XCTAssertEqual(MIDI.UInt14(clamping: _max + 1).asInt, _max)
		
	}
	
	func testInitZeroMidpointFloat() {
		
		XCTAssertEqual(MIDI.UInt14(zeroMidpointFloat: -1.0).asInt, _min)
		XCTAssertEqual(MIDI.UInt14(zeroMidpointFloat: -0.5).asInt, 4096)
		XCTAssertEqual(MIDI.UInt14(zeroMidpointFloat:  0.0).asInt, _midpoint)
		XCTAssertEqual(MIDI.UInt14(zeroMidpointFloat:  0.5).asInt, 12287)
		XCTAssertEqual(MIDI.UInt14(zeroMidpointFloat:  1.0).asInt, _max)
		
	}
	
	func testInitBytePair() {
		
        XCTAssertEqual(MIDI.UInt14(bytePair: MIDI.BytePair(MSB: 0x00, LSB: 0x00)).asInt, _min)
        XCTAssertEqual(MIDI.UInt14(bytePair: MIDI.BytePair(MSB: 0x40, LSB: 0x00)).asInt, _midpoint)
        XCTAssertEqual(MIDI.UInt14(bytePair: MIDI.BytePair(MSB: 0x7F, LSB: 0x7F)).asInt, _max)
		
	}
	
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt14.min.asInt, _min)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt14.max.asInt, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt14(1).asInt, 1)
		XCTAssertEqual(MIDI.UInt14(1).asUInt16, 1)
		
	}
	
	func testZeroMidpointFloat() {
		
		XCTAssertEqual(MIDI.UInt14(_min).zeroMidpointFloat, -1.0)
		XCTAssertEqual(MIDI.UInt14(4096).zeroMidpointFloat, -0.5)
		XCTAssertEqual(MIDI.UInt14(_midpoint).zeroMidpointFloat, 0.0)
		XCTAssertEqual(MIDI.UInt14(12287).zeroMidpointFloat, 0.5, accuracy: 0.0001)
		XCTAssertEqual(MIDI.UInt14(_max).zeroMidpointFloat, 1.0)
		
	}
	
	func testBytePair() {
		
		XCTAssertEqual(MIDI.UInt14(_min).bytePair.MSB, 0x00)
		XCTAssertEqual(MIDI.UInt14(_min).bytePair.LSB, 0x00)
		
		XCTAssertEqual(MIDI.UInt14(_midpoint).bytePair.MSB, 0x40)
		XCTAssertEqual(MIDI.UInt14(_midpoint).bytePair.LSB, 0x00)
		
		XCTAssertEqual(MIDI.UInt14(_max).bytePair.MSB, 0x7F)
		XCTAssertEqual(MIDI.UInt14(_max).bytePair.LSB, 0x7F)
		
	}
	
	func testEquatable() {
		
		XCTAssertTrue(MIDI.UInt14(0) == MIDI.UInt14(0))
		XCTAssertTrue(MIDI.UInt14(1) == MIDI.UInt14(1))
		XCTAssertTrue(MIDI.UInt14(_max) == MIDI.UInt14(_max))
		
		XCTAssertTrue(MIDI.UInt14(0) != MIDI.UInt14(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDI.UInt14(0) > MIDI.UInt14(0))
		XCTAssertFalse(MIDI.UInt14(1) > MIDI.UInt14(1))
		XCTAssertFalse(MIDI.UInt14(_max) > MIDI.UInt14(_max))
		
		XCTAssertTrue(MIDI.UInt14(0) < MIDI.UInt14(1))
		XCTAssertTrue(MIDI.UInt14(1) > MIDI.UInt14(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDI.UInt14>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDI.UInt14(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt14":16383}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDI.UInt14.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDI.UInt14(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_UInt14() {
		
		XCTAssertEqual(10.midiUInt14, 10)
		
		XCTAssertEqual(Int8(10).midiUInt14, 10)
		XCTAssertEqual(UInt8(10).midiUInt14, 10)
		
		XCTAssertEqual(Int16(10).midiUInt14, 10)
		XCTAssertEqual(UInt16(10).midiUInt14, 10)
		
	}
	
    func testBinaryInteger_UInt14Exactly() {
        
        XCTAssertEqual(0b00_0000_0000_0000.midiUInt14Exactly, 0b00_0000_0000_0000)
        XCTAssertEqual(0b11_1111_1111_1111.midiUInt14Exactly, 0b11_1111_1111_1111)
        
        XCTAssertEqual(Int8(10).midiUInt14Exactly, 10)
        XCTAssertEqual(UInt8(10).midiUInt14Exactly, 10)
        
        XCTAssertEqual(Int16(10).midiUInt14Exactly, 10)
        XCTAssertEqual(UInt16(10).midiUInt14Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b100_0000_0000_0000.midiUInt14Exactly)
        
    }
    
}

#endif
