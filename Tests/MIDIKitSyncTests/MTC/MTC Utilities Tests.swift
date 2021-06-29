//
//  MTC Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync

import TimecodeKit

final class MTC_Utilities_Tests: XCTestCase {
	
	func testMTCIsEqual() {
		
		XCTAssertFalse(
			MTC.mtcIsEqual(nil, nil)
		)
		
		// test all MTC rates
		MTC.MTCFrameRate.allCases.forEach {
			
			XCTAssertFalse(
				MTC.mtcIsEqual((mtcComponents: TCC(), mtcFrameRate: $0),
							   nil)
			)
			
			XCTAssertFalse(
				MTC.mtcIsEqual(nil,
							   (mtcComponents: TCC(), mtcFrameRate: $0))
			)
			
			// == components, == frame rate
			XCTAssertTrue(
				MTC.mtcIsEqual((mtcComponents: TCC(), mtcFrameRate: $0),
							   (mtcComponents: TCC(), mtcFrameRate: $0))
			)
			
			// == components, == frame rate
			XCTAssertTrue(
				MTC.mtcIsEqual((mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
							   (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0))
			)
			
			// != components, == frame rate
			XCTAssertFalse(
				MTC.mtcIsEqual((mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
							   (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 05), mtcFrameRate: $0))
			)
			
		}
		
		// == components, != frame rate
		XCTAssertFalse(
			MTC.mtcIsEqual((mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc24),
						   (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc25))
		)
		
	}
	
}

#endif
