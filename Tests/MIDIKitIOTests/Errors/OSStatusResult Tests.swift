//
//  OSStatusResult Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitIO
import MIDIKitTestsCommon

final class MIDIKitIO_Errors_OSStatusResult_Tests: XCTestCase {
	
	func testRawValue() {
		
		// spot check: known constant
		
		XCTAssertEqual(
			MIDIIO.OSStatusResult(rawValue: -10830),
			.invalidClient
		)
		
		XCTAssertEqual(
			MIDIIO.OSStatusResult.invalidClient.rawValue,
			-10830
		)
		
		// other
		
		XCTAssertEqual(
			MIDIIO.OSStatusResult(rawValue: 7777),
			.other(7777)
		)
		
		XCTAssertEqual(
			MIDIIO.OSStatusResult.other(7777).rawValue,
			7777
		)
		
	}
	
	func testCustomStringConvertible() {
		
		// spot check: known constant
		
		XCTAssert(
			"\(MIDIIO.OSStatusResult.invalidClient)".contains("kMIDIInvalidClient")
		)
		
	}
	
}

#endif
