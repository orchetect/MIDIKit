//
//  MIDIUInt7 Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-24.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitCommon
import MIDIKitTestsCommon
import OTCoreTestingXCTest

final class MIDIUInt7_Tests: XCTestCase {
	
	fileprivate let _max = 0b111_1111
	
	func testInit() {
		
		// default
		
		XCTAssertEqual(MIDIUInt7().asInt, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDIUInt7(0).asInt, 0)
		XCTAssertEqual(MIDIUInt7(UInt8(0)).asInt, 0)
		XCTAssertEqual(MIDIUInt7(UInt16(0)).asInt, 0)
		
		// values
		
		XCTAssertEqual(MIDIUInt7(1).asInt, 1)
		XCTAssertEqual(MIDIUInt7(2).asInt, 2)
		
		// overflow
		
		expectFatalError {
			_ = MIDIUInt7(0 - 1)
		}
		
		expectFatalError { [self] in
			_ = MIDIUInt7(_max + 1)
		}
		
	}
	
	func testInitExactly() {
		
		// typical
		
		XCTAssertEqual(MIDIUInt7(exactly: 0)?.asInt, 0)
		
		XCTAssertEqual(MIDIUInt7(exactly: 1)?.asInt, 1)
		
		XCTAssertEqual(MIDIUInt7(exactly: _max)?.asInt, _max)
		
		// overflow
		
		XCTAssertNil(MIDIUInt7(exactly: -1))
		
		XCTAssertNil(MIDIUInt7(exactly: _max + 1))
		
	}
	
	func testInitClamping() {
		
		// within range
		
		XCTAssertEqual(MIDIUInt7(clamping: 0).asInt, 0)
		XCTAssertEqual(MIDIUInt7(clamping: 1).asInt, 1)
		XCTAssertEqual(MIDIUInt7(clamping: _max).asInt, _max)
		
		// overflow
		
		XCTAssertEqual(MIDIUInt7(clamping: -1).asInt, 0)
		XCTAssertEqual(MIDIUInt7(clamping: _max + 1).asInt, _max)
		
	}
	
	func testMin() {
		
		XCTAssertEqual(MIDIUInt7.min.asInt, 0)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDIUInt7.max.asInt, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDIUInt7(1).asInt, 1)
		XCTAssertEqual(MIDIUInt7(1).asUInt8, 1)
		
	}
	
	func testEquatable() {
		
		XCTAssertTrue(MIDIUInt7(0) == MIDIUInt7(0))
		XCTAssertTrue(MIDIUInt7(1) == MIDIUInt7(1))
		XCTAssertTrue(MIDIUInt7(_max) == MIDIUInt7(_max))
		
		XCTAssertTrue(MIDIUInt7(0) != MIDIUInt7(1))
		
	}
	
	func testComparable() {
		
		XCTAssertFalse(MIDIUInt7(0) > MIDIUInt7(0))
		XCTAssertFalse(MIDIUInt7(1) > MIDIUInt7(1))
		XCTAssertFalse(MIDIUInt7(_max) > MIDIUInt7(_max))
		
		XCTAssertTrue(MIDIUInt7(0) < MIDIUInt7(1))
		XCTAssertTrue(MIDIUInt7(1) > MIDIUInt7(0))
		
	}
	
	func testHashable() {
		
		let set = Set<MIDIUInt7>([0, 1, 1, 2])
		
		XCTAssertEqual(set.count, 3)
		XCTAssertTrue(set == [0,1,2])
		
	}
	
	func testCodable() {
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		// encode
		
		let encoded = try? encoder.encode(MIDIUInt7(_max))
		
		let encodedString = String(data: encoded!, encoding: .utf8)
		
		XCTAssertEqual(encodedString, #"{"UInt7":127}"#)
		
		// decode
		
		let decoded = try? decoder.decode(MIDIUInt7.self, from: encoded!)
		
		// assert value is identical to source
		
		XCTAssertEqual(decoded, MIDIUInt7(_max))
		
	}
	
	// MARK: - Standard library extensions
	
	func testBinaryInteger_midiUInt7() {
		
		XCTAssertEqual(10.midiUInt7, 10)
		
		XCTAssertEqual(Int8(10).midiUInt7, 10)
		XCTAssertEqual(UInt8(10).midiUInt7, 10)
		
		XCTAssertEqual(Int16(10).midiUInt7, 10)
		XCTAssertEqual(UInt16(10).midiUInt7, 10)
		
	}
	
}

#endif

