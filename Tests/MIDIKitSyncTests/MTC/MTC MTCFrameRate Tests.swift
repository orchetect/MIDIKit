//
//  MTC MTCFrameRate Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-21.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync

import TimecodeKit

extension MIDIKitSyncTests {
	
	func testMTC_MTCFrameRate_Init_TimecodeFrameRate() {
		
		// test is pedantic, but worth having
		
		Timecode.FrameRate.allCases.forEach {
			
			XCTAssertEqual(MTC.MTCFrameRate($0), $0.mtcFrameRate)
			
		}
		
	}
	
}

#endif
