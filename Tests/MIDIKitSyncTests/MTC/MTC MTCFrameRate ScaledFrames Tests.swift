//
//  MTC MTCFrameRate ScaledFrames Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-20.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync

import TimecodeKit

extension MIDIKitSyncTests {
	
	// Local Constants
	
	fileprivate var mtc24: MTC.MTCFrameRate { .mtc24 }
	fileprivate var mtc25: MTC.MTCFrameRate { .mtc25 }
	fileprivate var mtcDF: MTC.MTCFrameRate { .mtc2997d }
	fileprivate var mtc30: MTC.MTCFrameRate { .mtc30 }
	
	func testMTC_MTCFrameRate_ScaledFrames() {
		
		// we iterate on allCases here so that the compiler will
		// throw an error in future if additional frame rates get added to TimecodeKit,
		// prompting us to add unit test cases for them below
		
		for realRate in Timecode.FrameRate.allCases {
			
			let mtcRate = realRate.mtcFrameRate
			
			// avoid testing incompatible frame rates which will fail any way
			guard mtcRate.directEquivalentFrameRate.isCompatible(with: realRate)
			else { continue }
			
			switch realRate {
			
			case ._23_976, ._24:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0  + (Double(qf)*0.25))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 12, quarterFrames: qf, to: realRate),
								   12 + (Double(qf)*0.25))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 22, quarterFrames: qf, to: realRate),
								   22 + (Double(qf)*0.25))
				}
				
			case ._24_98:
				// MTC 24 -> realRate
				// this one is the odd duck; Cubase transmits 24.98 as MTC 24
				
				XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: 0, to: realRate),
							   0)
				XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 12, quarterFrames: 0, to: realRate),
							   12.5)
				XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 22, quarterFrames: 0, to: realRate) ?? 0.0,
							   22.916666, accuracy: 0.00001)
				
			case ._25:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0  + (Double(qf)*0.25))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 12, quarterFrames: qf, to: realRate),
								   12 + (Double(qf)*0.25))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 24, quarterFrames: qf, to: realRate),
								   24 + (Double(qf)*0.25))
				}
				
				
			case ._29_97, ._29_97_drop, ._30, ._30_drop:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0  + (Double(qf)*0.25))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 15, quarterFrames: qf, to: realRate),
								   15 + (Double(qf)*0.25))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 28, quarterFrames: qf, to: realRate),
								   28 + (Double(qf)*0.25))
				}
				
				
			case ._47_952, ._48:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0  + (Double(qf)*0.5))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 12, quarterFrames: qf, to: realRate),
								   24 + (Double(qf)*0.5))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 23, quarterFrames: qf, to: realRate),
								   46 + (Double(qf)*0.5))
				}
				
			case ._50:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0  + (Double(qf)*0.5))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 12, quarterFrames: qf, to: realRate),
								   24 + (Double(qf)*0.5))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 24, quarterFrames: qf, to: realRate),
								   48 + (Double(qf)*0.5))
				}
				
			case ._59_94, ._59_94_drop, ._60, ._60_drop:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0  + (Double(qf)*0.5))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 15, quarterFrames: qf, to: realRate),
								   30 + (Double(qf)*0.5))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 29, quarterFrames: qf, to: realRate),
								   58 + (Double(qf)*0.5))
				}
				
			case ._100:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0  + (Double(qf)*1.0))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 12, quarterFrames: qf, to: realRate),
								   48 + (Double(qf)*1.0))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 24, quarterFrames: qf, to: realRate),
								   96 + (Double(qf)*1.0))
				}
				
			case ._119_88, ._119_88_drop, ._120, ._120_drop:
				for qf in UInt8(0)...7 {
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 0,  quarterFrames: qf, to: realRate),
								   0   + (Double(qf)*1.0))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 15, quarterFrames: qf, to: realRate),
								   60  + (Double(qf)*1.0))
					XCTAssertEqual(mtcRate.scaledFrames(fromRawMTCFrames: 29, quarterFrames: qf, to: realRate),
								   116 + (Double(qf)*1.0))
				}
				
				
			}
			
		}
		
	}
	
	func testMTC_MTCFrameRate_Scale_EdgeCases() {
		
		// frames underflow clamped to 0
		XCTAssertEqual(mtc30.scaledFrames(fromRawMTCFrames: -1, quarterFrames: 0, to: ._30), 0)
		
		// frames overflow allowed, even though it's not practical
		XCTAssertEqual(mtc30.scaledFrames(fromRawMTCFrames: 60, quarterFrames: 0, to: ._30), 60)
		
		// quarter-frames > 7 clamped to 7
		XCTAssertEqual(mtc30.scaledFrames(fromRawMTCFrames: 0, quarterFrames: 8, to: ._30), 0.25 * 7)
		
	}
	
}

#endif
