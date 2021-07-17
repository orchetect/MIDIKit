//
//  MTC Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import TimecodeKit

final class MTC_Utilities_Tests: XCTestCase {
	
	func testMTCIsEqual() {
		
		XCTAssertFalse(
			MIDI.MTC.mtcIsEqual(nil, nil)
		)
		
		// test all MTC rates
		MIDI.MTC.MTCFrameRate.allCases.forEach {
			
			XCTAssertFalse(
				MIDI.MTC.mtcIsEqual((mtcComponents: TCC(), mtcFrameRate: $0),
									nil)
			)
			
			XCTAssertFalse(
				MIDI.MTC.mtcIsEqual(nil,
									(mtcComponents: TCC(), mtcFrameRate: $0))
			)
			
			// == components, == frame rate
			XCTAssertTrue(
				MIDI.MTC.mtcIsEqual((mtcComponents: TCC(), mtcFrameRate: $0),
									(mtcComponents: TCC(), mtcFrameRate: $0))
			)
			
			// == components, == frame rate
			XCTAssertTrue(
				MIDI.MTC.mtcIsEqual((mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
									(mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0))
			)
			
			// != components, == frame rate
			XCTAssertFalse(
				MIDI.MTC.mtcIsEqual((mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
									(mtcComponents: TCC(h: 1, m: 02, s: 03, f: 05), mtcFrameRate: $0))
			)
			
		}
		
		// == components, != frame rate
		XCTAssertFalse(
			MIDI.MTC.mtcIsEqual((mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc24),
								(mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc25))
		)
		
	}
	
}

#endif
