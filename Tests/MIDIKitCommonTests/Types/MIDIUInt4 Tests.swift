//
//  MIDIUInt4 Tests.swift
//  MIDIKitCommonTests
//
//  Created by Steffan Andrews on 2021-01-24.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitCommon
import MIDIKitTestsCommon
import OTCoreTestingXCTest

final class MIDIUint4_Tests: XCTestCase {
	
	fileprivate let _max = 0b1111
	
	func testInit() {
		
		// default
		
		XCTAssertEqual(MIDIUInt4().asInt, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDIUInt4(0).asInt, 0)
		XCTAssertEqual(MIDIUInt4(UInt8(0)).asInt, 0)
		XCTAssertEqual(MIDIUInt4(UInt16(0)).asInt, 0)
		
		// values
		
		XCTAssertEqual(MIDIUInt4(1).asInt, 1)
		XCTAssertEqual(MIDIUInt4(2).asInt, 2)
		
		// overflow
		
		expectFatalError {
			_ = MIDIUInt4(0 - 1)
		}
		
		expectFatalError { [self] in
			_ = MIDIUInt4(_max + 1)
		}
		
	}
	
	func testInitExactly() {
		
		// typical
		
		XCTAssertEqual(MIDIUInt4(exactly: 0)?.asInt, 0)
		
		XCTAssertEqual(MIDIUInt4(exactly: 1)?.asInt, 1)
		
		XCTAssertEqual(MIDIUInt4(exactly: _max)?.asInt, _max)
		
		// overflow
		
		XCTAssertNil(MIDIUInt4(exactly: -1))
		
		XCTAssertNil(MIDIUInt4(exactly: _max + 1))
		
	}
	
	func testInitClamping() {
		
		// within range
		
		XCTAssertEqual(MIDIUInt4(clamping: 0).asInt, 0)
		XCTAssertEqual(MIDIUInt4(clamping: 1).asInt, 1)
		XCTAssertEqual(MIDIUInt4(clamping: _max).asInt, _max)
		
		// overflow
		
		XCTAssertEqual(MIDIUInt4(clamping: -1).asInt, 0)
		XCTAssertEqual(MIDIUInt4(clamping: _max + 1).asInt, _max)
		
	}
	
	func testMin() {
		
		XCTAssertEqual(MIDIUInt4.min.asInt, 0)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDIUInt4.max.asInt, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDIUInt4(1).asInt, 1)
		XCTAssertEqual(MIDIUInt4(1).asUInt8, 1)
		
	}
	
	func testEquatable() {
		
		XCTAssertTrue(MIDIUInt4(0) == MIDIUInt4(0))
		XCTAssertTrue(MIDIUInt4(1) == MIDIUInt4(1))
		XCTAssertTrue(MIDIUInt4(_max) == MIDIUInt4(_max))
		
		XCTAssertTrue(MIDIUInt4(0) != MIDIUInt4(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDIUInt4(0) > MIDIUInt4(0))
		XCTAssertFalse(MIDIUInt4(1) > MIDIUInt4(1))
		XCTAssertFalse(MIDIUInt4(_max) > MIDIUInt4(_max))
		
		XCTAssertTrue(MIDIUInt4(0) < MIDIUInt4(1))
		XCTAssertTrue(MIDIUInt4(1) > MIDIUInt4(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDIUInt4>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDIUInt4(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt4":15}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDIUInt4.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDIUInt4(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_midiUInt4() {
		
		XCTAssertEqual(10.midiUInt4, 10)
		
		XCTAssertEqual(Int8(10).midiUInt4, 10)
		XCTAssertEqual(UInt8(10).midiUInt4, 10)
		
		XCTAssertEqual(Int16(10).midiUInt4, 10)
		XCTAssertEqual(UInt16(10).midiUInt4, 10)
		
	}
	
}

#endif
