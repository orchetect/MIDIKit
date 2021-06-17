//
//  MIDIOSStatus Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitIO
import MIDIKitTestsCommon

final class Errors_MIDIOSStatus_Tests: XCTestCase {
	
	func testRawValue() {
		
		// spot check: known constant
		
		XCTAssertEqual(
			MIDIIO.MIDIOSStatus(rawValue: -10830),
			.invalidClient
		)
		
		XCTAssertEqual(
			MIDIIO.MIDIOSStatus.invalidClient.rawValue,
			-10830
		)
		
		// other
		
		XCTAssertEqual(
			MIDIIO.MIDIOSStatus(rawValue: 7777),
			.other(7777)
		)
		
		XCTAssertEqual(
			MIDIIO.MIDIOSStatus.other(7777).rawValue,
			7777
		)
		
	}
	
	func testCustomStringConvertible() {
		
		// spot check: known constant
		
		XCTAssert(
			"\(MIDIIO.MIDIOSStatus.invalidClient)".contains("kMIDIInvalidClient")
		)
		
	}
	
}

#endif
