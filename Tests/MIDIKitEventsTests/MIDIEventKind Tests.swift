//
//  MIDIEventKind Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-28.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitEvents
import MIDIKitTestsCommon

class MIDIEventKindTests: XCTestCase {
	
	func testEquatable() {
		
		// ensure MIDIEventKind and AnyMIDIEventKind are equatable
		
		// both 1's should be equal
		let rawKind1 = try! MIDIEvent(rawBytes: [0xFF]).kind
		let anyKind1 = AnyMIDIEventKind(try! MIDIEvent(rawBytes: [0xFF]).kind)
		
		// both 2's should be equal
		let rawKind2 = MIDIEvent(.activeSense).kind
		let anyKind2 = AnyMIDIEventKind(MIDIEvent(.activeSense).kind)
		
		// against self
		XCTAssert(rawKind1 == rawKind1)
		XCTAssert(rawKind2 == rawKind2)
		XCTAssert(anyKind1 == anyKind1)
		XCTAssert(anyKind2 == anyKind2)
		
		// == between either, reciprocating sides
		XCTAssert(rawKind1 == anyKind1)
		XCTAssert(anyKind1 == rawKind1)
		XCTAssert(rawKind2 == anyKind2)
		XCTAssert(anyKind2 == rawKind2)
		
		// != between two raw, reciprocating sides
		XCTAssert(rawKind1 != rawKind2)
		XCTAssert(rawKind2 != rawKind1)
		
		// != between two Any, reciprocating sides
		XCTAssert(anyKind1 != anyKind2)
		XCTAssert(anyKind2 != anyKind1)
		
		// != between either, reciprocating sides
		XCTAssert(rawKind1 != anyKind2)
		XCTAssert(anyKind1 != rawKind2)
		
	}
	
	func testEquals() {
		
		// both 1's should be equal
		let rawKind1 = try! MIDIEvent(rawBytes: [0xFF]).kind
		let anyKind1 = AnyMIDIEventKind(try! MIDIEvent(rawBytes: [0xFF]).kind)
		
		// both 2's should be equal
		let rawKind2 = MIDIEvent(.activeSense).kind
		let anyKind2 = AnyMIDIEventKind(MIDIEvent(.activeSense).kind)
		
		// against self
		XCTAssertTrue(rawKind1.equals(rawKind1))
		XCTAssertTrue(rawKind2.equals(rawKind2))
		XCTAssertTrue(anyKind1.equals(anyKind1))
		XCTAssertTrue(anyKind2.equals(anyKind2))

		//.equals(between either, reciprocating sides
		XCTAssertTrue(rawKind1.equals(anyKind1))
		XCTAssertTrue(anyKind1.equals(rawKind1))
		XCTAssertTrue(rawKind2.equals(anyKind2))
		XCTAssertTrue(anyKind2.equals(rawKind2))

		// != between two raw, reciprocating sides
		XCTAssertFalse(rawKind1.equals(rawKind2))
		XCTAssertFalse(rawKind2.equals(rawKind1))

		// != between two Any, reciprocating sides
		XCTAssertFalse(anyKind1.equals(anyKind2))
		XCTAssertFalse(anyKind2.equals(anyKind1))

		// != between either, reciprocating sides
		XCTAssertFalse(rawKind1.equals(anyKind2))
		XCTAssertFalse(anyKind1.equals(rawKind2))
		
	}
	
}

#endif
