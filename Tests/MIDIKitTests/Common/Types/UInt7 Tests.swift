//
//  UInt7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import MIDIKitTestsCommon
import OTCoreTestingXCTest

final class UInt7_Tests: XCTestCase {
	
	fileprivate let _max = 0b111_1111
	
	func testInit() {
		
		// default
		
		XCTAssertEqual(MIDI.UInt7().asInt, 0)
		
		// different integer types
		
		XCTAssertEqual(MIDI.UInt7(0).asInt, 0)
		XCTAssertEqual(MIDI.UInt7(UInt8(0)).asInt, 0)
		XCTAssertEqual(MIDI.UInt7(UInt16(0)).asInt, 0)
		
		// values
		
		XCTAssertEqual(MIDI.UInt7(1).asInt, 1)
		XCTAssertEqual(MIDI.UInt7(2).asInt, 2)
		
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
		
		XCTAssertEqual(MIDI.UInt7(exactly: 0)?.asInt, 0)
		
		XCTAssertEqual(MIDI.UInt7(exactly: 1)?.asInt, 1)
		
		XCTAssertEqual(MIDI.UInt7(exactly: _max)?.asInt, _max)
		
		// overflow
		
		XCTAssertNil(MIDI.UInt7(exactly: -1))
		
		XCTAssertNil(MIDI.UInt7(exactly: _max + 1))
		
	}
	
	func testInitClamping() {
		
		// within range
		
		XCTAssertEqual(MIDI.UInt7(clamping: 0).asInt, 0)
		XCTAssertEqual(MIDI.UInt7(clamping: 1).asInt, 1)
		XCTAssertEqual(MIDI.UInt7(clamping: _max).asInt, _max)
		
		// overflow
		
		XCTAssertEqual(MIDI.UInt7(clamping: -1).asInt, 0)
		XCTAssertEqual(MIDI.UInt7(clamping: _max + 1).asInt, _max)
		
	}
	
	func testMin() {
		
		XCTAssertEqual(MIDI.UInt7.min.asInt, 0)
		
	}
	
	func testMax() {
		
		XCTAssertEqual(MIDI.UInt7.max.asInt, _max)
		
	}
	
	func testComputedProperties() {
		
		XCTAssertEqual(MIDI.UInt7(1).asInt, 1)
		XCTAssertEqual(MIDI.UInt7(1).asUInt8, 1)
		
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
	
}

#endif

