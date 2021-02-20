//
//  File.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-25.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitCommon
import MIDIKitTestsCommon
//import OTCoreTestingXCTest

final class MIDIUInt14_Tests: XCTestCase {
	
	fileprivate let _min = 0b0000000_0000000
	fileprivate let _midpoint = 0b1000000_0000000
	fileprivate let _max = 0b1111111_1111111
	
	func testInit() {
		
		// default
		
		XCTAssertEqual(MIDIUInt14().value, _midpoint)
		
		// different integer types
		
		XCTAssertEqual(MIDIUInt14(0), 0)
		XCTAssertEqual(MIDIUInt14(UInt8(0)), 0)
		XCTAssertEqual(MIDIUInt14(UInt16(0)), 0)
		
		// values
		
		XCTAssertEqual(MIDIUInt14(1), 1)
		XCTAssertEqual(MIDIUInt14(2), 2)
		
		// overflow
		
		expectFatalError { [self] in
			_ = MIDIUInt14(_min - 1)
		}
		expectFatalError { [self] in
			_ = MIDIUInt14(_max + 1)
		}
		
	}
	
	func testInitExactly() {
		
		// typical
		
		XCTAssertEqual(MIDIUInt14(exactly: 0), 0)
		
		XCTAssertEqual(MIDIUInt14(exactly: 1), 1)
		
		XCTAssertEqual(MIDIUInt14(exactly: _max)?.asInt, _max)
		
		// overflow
		
		XCTAssertNil(MIDIUInt14(exactly: -1))
		
		XCTAssertNil(MIDIUInt14(exactly: _max + 1))
		
	}
	
	func testInitClamping() {
		
		// within range
		
		XCTAssertEqual(MIDIUInt14(clamping: 0), 0)
		XCTAssertEqual(MIDIUInt14(clamping: 1), 1)
		XCTAssertEqual(MIDIUInt14(clamping: _max).asInt, _max)
		
		// overflow
		
		XCTAssertEqual(MIDIUInt14(clamping: -1).asInt, 0)
		XCTAssertEqual(MIDIUInt14(clamping: _max + 1).asInt, _max)
		
	}
	
	func testInitZeroMidpointFloat() {
		
		XCTAssertEqual(MIDIUInt14(zeroMidpointFloat: -1.0).asInt, _min)
		XCTAssertEqual(MIDIUInt14(zeroMidpointFloat: -0.5).asInt, 4096)
		XCTAssertEqual(MIDIUInt14(zeroMidpointFloat:  0.0).asInt, _midpoint)
		XCTAssertEqual(MIDIUInt14(zeroMidpointFloat:  0.5).asInt, 12287)
		XCTAssertEqual(MIDIUInt14(zeroMidpointFloat:  1.0).asInt, _max)
		
	}
	
	func testInitBytePair() {
		
		XCTAssertEqual(MIDIUInt14(BytePair(MSB: 0x00, LSB: 0x00)).asInt, _min)
		XCTAssertEqual(MIDIUInt14(BytePair(MSB: 0x40, LSB: 0x00)).asInt, _midpoint)
		XCTAssertEqual(MIDIUInt14(BytePair(MSB: 0x7F, LSB: 0x7F)).asInt, _max)
		
	}
	
	func testMin() {
		
		XCTAssertEqual(MIDIUInt14.min.asInt, _min)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDIUInt14.max.asInt, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDIUInt14(1).asInt, 1)
		XCTAssertEqual(MIDIUInt14(1).asUInt16, 1)
		
	}
	
	func testZeroMidpointFloat() {
		
		XCTAssertEqual(MIDIUInt14(_min).zeroMidpointFloat, -1.0)
		XCTAssertEqual(MIDIUInt14(4096).zeroMidpointFloat, -0.5)
		XCTAssertEqual(MIDIUInt14(_midpoint).zeroMidpointFloat, 0.0)
		XCTAssertEqual(MIDIUInt14(12287).zeroMidpointFloat, 0.5, accuracy: 0.0001)
		XCTAssertEqual(MIDIUInt14(_max).zeroMidpointFloat, 1.0)
		
	}
	
	func testBytePair() {
		
		XCTAssertEqual(MIDIUInt14(_min).bytePair.MSB, 0x00)
		XCTAssertEqual(MIDIUInt14(_min).bytePair.LSB, 0x00)
		
		XCTAssertEqual(MIDIUInt14(_midpoint).bytePair.MSB, 0x40)
		XCTAssertEqual(MIDIUInt14(_midpoint).bytePair.LSB, 0x00)
		
		XCTAssertEqual(MIDIUInt14(_max).bytePair.MSB, 0x7F)
		XCTAssertEqual(MIDIUInt14(_max).bytePair.LSB, 0x7F)
		
	}
	
	func testEquatable() {
		
		XCTAssertTrue(MIDIUInt14(0) == MIDIUInt14(0))
		XCTAssertTrue(MIDIUInt14(1) == MIDIUInt14(1))
		XCTAssertTrue(MIDIUInt14(_max) == MIDIUInt14(_max))
		
		XCTAssertTrue(MIDIUInt14(0) != MIDIUInt14(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDIUInt14(0) > MIDIUInt14(0))
		XCTAssertFalse(MIDIUInt14(1) > MIDIUInt14(1))
		XCTAssertFalse(MIDIUInt14(_max) > MIDIUInt14(_max))
		
		XCTAssertTrue(MIDIUInt14(0) < MIDIUInt14(1))
		XCTAssertTrue(MIDIUInt14(1) > MIDIUInt14(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDIUInt14>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDIUInt14(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt14":16383}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDIUInt14.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDIUInt14(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_MIDIUInt14() {
		
		XCTAssertEqual(10.midiUInt14, 10)
		
		XCTAssertEqual(Int8(10).midiUInt14, 10)
		XCTAssertEqual(UInt8(10).midiUInt14, 10)
		
		XCTAssertEqual(Int16(10).midiUInt14, 10)
		XCTAssertEqual(UInt16(10).midiUInt14, 10)
		
	}
	
}

#endif
