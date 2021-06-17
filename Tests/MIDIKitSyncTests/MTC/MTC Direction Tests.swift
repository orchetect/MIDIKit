//
//  MTC Direction Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-20.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync

import TimecodeKit

final class MTC_Direction_Tests: XCTestCase {
	
	func testMTC_Direction() {
		
		// ensure direction infer produces expected direction states
		
		// identical values produces ambiguous state
		for bits in UInt8(0b000)...UInt8(0b111) {
			XCTAssertEqual(MTC.Direction(previousQF: bits, newQF: bits), .ambiguous)
		}
		
		// sequential ascending values produces forwards
		XCTAssertEqual(MTC.Direction(previousQF: 0b000, newQF: 0b001), .forwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b001, newQF: 0b010), .forwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b010, newQF: 0b011), .forwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b011, newQF: 0b100), .forwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b100, newQF: 0b101), .forwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b101, newQF: 0b110), .forwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b110, newQF: 0b111), .forwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b111, newQF: 0b000), .forwards) // wraps
		
		// sequential ascending values produces backwards
		XCTAssertEqual(MTC.Direction(previousQF: 0b111, newQF: 0b110), .backwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b110, newQF: 0b101), .backwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b101, newQF: 0b100), .backwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b100, newQF: 0b011), .backwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b011, newQF: 0b010), .backwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b010, newQF: 0b001), .backwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b001, newQF: 0b000), .backwards)
		XCTAssertEqual(MTC.Direction(previousQF: 0b000, newQF: 0b111), .backwards) // wraps
		
		// non-sequential values produces ambiguous state
		XCTAssertEqual(MTC.Direction(previousQF: 0b000, newQF: 0b010), .ambiguous)
		XCTAssertEqual(MTC.Direction(previousQF: 0b010, newQF: 0b000), .ambiguous)
		XCTAssertEqual(MTC.Direction(previousQF: 0b000, newQF: 0b101), .ambiguous)
		XCTAssertEqual(MTC.Direction(previousQF: 0b101, newQF: 0b000), .ambiguous)
		
		// edge cases: internal UInt8 underflow/overflow failsafe test
		XCTAssertEqual(MTC.Direction(previousQF: 255, newQF: 0b000), .ambiguous)
		XCTAssertEqual(MTC.Direction(previousQF: 255, newQF: 0b001), .ambiguous)
		XCTAssertEqual(MTC.Direction(previousQF: 255, newQF: 0b111), .ambiguous)
		
	}

}

#endif
