//
//  MTC MTCFrameRate Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import TimecodeKit

final class MTC_MTCFrameRate_Tests: XCTestCase {
	
	func testMTC_MTCFrameRate_Init_TimecodeFrameRate() {
		
		// test is pedantic, but worth having
		
		Timecode.FrameRate.allCases.forEach {
			
			XCTAssertEqual(MIDI.MTC.MTCFrameRate($0), $0.mtcFrameRate)
			
		}
		
	}
	
}

#endif
