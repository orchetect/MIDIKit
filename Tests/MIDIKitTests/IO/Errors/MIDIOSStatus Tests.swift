//
//  MIDIOSStatus Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class Errors_MIDIOSStatus_Tests: XCTestCase {
	
	func testRawValue() {
		
		// spot check: known constant
		
		XCTAssertEqual(
			MIDI.IO.MIDIOSStatus(rawValue: -10830),
			.invalidClient
		)
		
		XCTAssertEqual(
			MIDI.IO.MIDIOSStatus.invalidClient.rawValue,
			-10830
		)
		
		// other
		
		XCTAssertEqual(
			MIDI.IO.MIDIOSStatus(rawValue: 7777),
			.other(7777)
		)
		
		XCTAssertEqual(
			MIDI.IO.MIDIOSStatus.other(7777).rawValue,
			7777
		)
		
	}
	
	func testCustomStringConvertible() {
		
		// spot check: known constant
		
		XCTAssert(
			"\(MIDI.IO.MIDIOSStatus.invalidClient)".contains("kMIDIInvalidClient")
		)
		
	}
	
}

#endif
