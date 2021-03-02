//
//  MTC MTCFrameRate Translation Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-11.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync

import TimecodeKit

extension MIDIKitSyncTests {
	
	func testMTC_MTCFrameRate_derivedFrameRates() {
		
		// these tests may be pedantic, but we'll put them in any way since this acts as our source of truth
		
		// ensure all four MTC frame rate families return the correct matching derived timecode frame rates
		
		// MTC: 24
		
		XCTAssertEqual(
			MTC.MTCFrameRate.mtc24.derivedFrameRates,
			
			[
				._23_976,
				._24,
				._24_98,
				._47_952,
				._48
			]
		)
		
		// MTC: 25
		
		XCTAssertEqual(
			MTC.MTCFrameRate.mtc25.derivedFrameRates,
			
			[
				._25,
				._50,
				._100
			]
		)
		
		// MTC: drop
		
		XCTAssertEqual(
			MTC.MTCFrameRate.mtc2997d.derivedFrameRates,
			
			[
				._29_97_drop,
				._30_drop,
				._59_94_drop,
				._60_drop,
				._119_88_drop,
				._120_drop
			]
		)
		
		// MTC: drop
		
		XCTAssertEqual(
			MTC.MTCFrameRate.mtc30.derivedFrameRates,
			
			[
				._29_97,
				._30,
				._59_94,
				._60,
				._119_88,
				._120
			]
		)
		
	}
	
}

#endif
