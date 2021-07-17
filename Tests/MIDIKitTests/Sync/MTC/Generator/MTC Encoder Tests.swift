//
//  MTC Encoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
@testable import TimecodeKit
import OTCoreTestingXCTest

import TimecodeKit

final class MTC_Generator_Encoder_Tests: XCTestCase {
	
	func testMTC_Encoder_Default() {
		
		// defaults
		
		let mtcEnc = MIDI.MTC.Encoder()
		
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 0, m: 0, s: 0, f: 0))
		
		let tc = mtcEnc.timecode
		XCTAssertEqual(tc.components, TCC(h: 0, m: 0, s: 0, f: 0))
		
		XCTAssertEqual(mtcEnc.localFrameRate, tc.frameRate)
		
	}
	
	func testMTC_Encoder_FrameRate() {
		
		// ensure MTC FrameRate is being updated correctly when localFrameRate is set
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		Timecode.FrameRate.allCases.forEach {
			
			mtcEnc = MIDI.MTC.Encoder()
			mtcEnc.setLocalFrameRate($0)
			
			XCTAssertEqual(mtcEnc.mtcFrameRate, $0.mtcFrameRate)
			
		}
		
	}
	
	func testMTC_Encoder_Timecode_NominalRates() {
		
		// perform a spot-check to ensure the .timecode property is returning expected Timecode for nominal (non-scaling) frame rates
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		// basic test
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.setLocalFrameRate(._30)
		
		mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 20, s: 32, f: 10))
		
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 10))
		
		// quarter frames
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.setLocalFrameRate(._30)
		mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 20, s: 32, f: 10))
		
		mtcEnc.mtcQuarterFrame = 0
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 10))
		
		mtcEnc.mtcQuarterFrame = 1
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 10))
		
		mtcEnc.mtcQuarterFrame = 2
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 10))
		
		mtcEnc.mtcQuarterFrame = 3
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 10))
		
		mtcEnc.mtcQuarterFrame = 4
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 11)) // next frame
		
		mtcEnc.mtcQuarterFrame = 5
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 11))
		
		mtcEnc.mtcQuarterFrame = 6
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 11))
		
		mtcEnc.mtcQuarterFrame = 7
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 11))
		
	}
	
	func testMTC_Encoder_Timecode_ScalingRates() {
		
		// perform a spot-check to ensure the .timecode property is scaling to localFrameRate
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		// basic test
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.setLocalFrameRate(._60)
		mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 20, s: 32, f: 10))
		
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 20))
		XCTAssertEqual(mtcEnc.timecode.frameRate, ._60)
		
		// quarter frames
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.setLocalFrameRate(._60)
		mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 20, s: 32, f: 10))
		
		XCTAssertEqual(mtcEnc.timecode.frameRate, ._60)
		
		mtcEnc.mtcQuarterFrame = 0
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 20))
		
		mtcEnc.mtcQuarterFrame = 1
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 20))
		
		mtcEnc.mtcQuarterFrame = 2
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 21)) // next frame
		
		mtcEnc.mtcQuarterFrame = 3
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 21))
		
		mtcEnc.mtcQuarterFrame = 4
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 22)) // next frame
		
		mtcEnc.mtcQuarterFrame = 5
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 22))
		
		mtcEnc.mtcQuarterFrame = 6
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 23)) // next frame
		
		mtcEnc.mtcQuarterFrame = 7
		XCTAssertEqual(mtcEnc.timecode.components, TCC(h: 1, m: 20, s: 32, f: 23))
		
	}
	
	func testMTC_Encoder_LocateTo() {
		
		// perform a spot-check to ensure .locate(to:) functions as expected
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		// nominal (non-scaling) SMPTE frame rates
		
		// 24fps
		
		mtcEnc = MIDI.MTC.Encoder()
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 10), at: ._24)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._24)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 10))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 10))
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 11), at: ._24)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._24)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 11))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 10))
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4)
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 12), at: ._24)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._24)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 12))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 12))
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		
		// scaling frame rates
		
		// 60fps
		
		mtcEnc = MIDI.MTC.Encoder()
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 20), at: ._60)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._60)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 20))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 10)) // mtc-30 fps
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 21), at: ._60)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._60)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 21))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 10)) // mtc-30 fps
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2)
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 22), at: ._60)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._60)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 22))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 10)) // mtc-30 fps
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4)
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 23), at: ._60)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._60)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 23))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 10)) // mtc-30 fps
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6)
		
		mtcEnc.locate(to: Timecode(TCC(h: 1, m: 20, s: 32, f: 24), at: ._60)!)
		XCTAssertEqual(mtcEnc.localFrameRate, ._60)
		XCTAssertEqual(mtcEnc.timecode.components,
					   TCC(h: 1, m: 20, s: 32, f: 24))
		XCTAssertEqual(mtcEnc.mtcComponents,
					   TCC(h: 1, m: 20, s: 32, f: 12)) // mtc-30 fps
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		
	}
	
	func testMTC_Encoder_Increment() {
		
		// test to ensure increment behavior is consistent across timecode frame rates
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		Timecode.FrameRate.allCases.forEach {
			
			mtcEnc = MIDI.MTC.Encoder()
			mtcEnc.setLocalFrameRate($0)
			mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 20, s: 32, f: 10))
			
			// initial state
			
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
			mtcEnc.increment() // doesn't increment; sends first quarter-frame
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
			mtcEnc.increment() // now it increments to QF 1
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 3,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 5,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 12),
						   "at: \($0)") // next even frame
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
		}
		
	}
	
	func testMTC_Encoder_Increment_DropFrame() {
		
		// spot-check: drop-frame rates
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		Timecode.FrameRate.allDrop.forEach {
			
			mtcEnc = MIDI.MTC.Encoder()
			mtcEnc.setLocalFrameRate($0)
			
			// round raw MTC frame number down to an even number, as per MTC spec
			let originFrame: Int
			
			// (include non-drop rates in switch case even though they won't be traversed, for sake of being exhaustive)
			switch $0 {
			case ._23_976, ._24, ._24_98, ._25, ._29_97, ._29_97_drop, ._30, ._30_drop:
				// 1x multiplier
				originFrame = $0.maxFrameNumberDisplayable - ($0.maxFrameNumberDisplayable % 2)
				
			case ._47_952, ._48, ._50, ._59_94, ._59_94_drop, ._60, ._60_drop:
				// 2x multiplier
				let previousEvenFrame = $0.maxFrameNumberDisplayable - ($0.maxFrameNumberDisplayable % 2)
				let diff = $0.maxFrames - previousEvenFrame
				originFrame = $0.maxFrames - (diff * 2)
				
			case ._100, ._119_88, ._119_88_drop, ._120, ._120_drop:
				// 4x multiplier
				let previousEvenFrame = $0.maxFrameNumberDisplayable - ($0.maxFrameNumberDisplayable % 2)
				let diff = $0.maxFrames - previousEvenFrame
				originFrame = $0.maxFrames - (diff * 4)
			}
			
			mtcEnc.locate(to: TCC(h: 1, m: 00, s: 59, f: originFrame))
			
			let expectedFrameA: Int
			switch mtcEnc.mtcFrameRate {
			case .mtc24:
				expectedFrameA = 22
			case .mtc25:
				expectedFrameA = 24
			case .mtc2997d, .mtc30:
				expectedFrameA = 28
			}
			
			let expectedFrameB = 2
			
			// initial state
			
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
			mtcEnc.increment() // doesn't increment; sends first quarter-frame
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
			mtcEnc.increment() // now it increments to QF 1
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 3,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 5,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 59, f: expectedFrameA),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7,
						   "at: \($0)")
			
			mtcEnc.increment()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 01, s: 00, f: expectedFrameB), // next even frame
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
		}
		
	}
	
	func testMTC_Encoder_Increment_25FPS() {
		
		// MTC-25 fps based frame rates (25, 50, 100 fps)
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		MIDI.MTC.MTCFrameRate.mtc25.derivedFrameRates.forEach {
			
			let frMult: Int
			switch $0 {
			case ._25:  frMult = 1
			case ._50:  frMult = 2
			case ._100: frMult = 4
			default:
				XCTFail("Encountered unhandled frame rate: \($0)")
				return // skips to next forEach iteration
			}
			
			// -----------------------------
			// Scenario 1: Starting on even frame number
			// -----------------------------
			
			mtcEnc = MIDI.MTC.Encoder()
			mtcEnc.setLocalFrameRate($0)
			
			mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 00, s: 00, f: 24))
			mtcEnc.mtcQuarterFrame = 0
			
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 00, f: 24),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 00, f: 24 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
			mtcEnc.increment() // sends qf 0
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 1
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 2
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 3
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 3, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 4
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 00, f: 24),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 01, f: 00 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
			mtcEnc.increment() // increments to qf 5
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 5, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 6
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 7
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 0
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 01, f: 01),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 01, f: 01 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
			
			// ----------------------------
			// Scenario 2: Starting on odd frame number
			// ----------------------------
			
			mtcEnc = MIDI.MTC.Encoder()
			mtcEnc.setLocalFrameRate($0)
			
			mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 00, s: 00, f: 23))
			mtcEnc.mtcQuarterFrame = 0
			
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 00, f: 23),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 00, f: 23 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
			mtcEnc.increment() // sends qf 0
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 1
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 2
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 3
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 3, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 4
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 00, f: 23),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 00, f: 24 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
			mtcEnc.increment() // increments to qf 5
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 5, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 6
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 7
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 0
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 01, f: 00),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 01, f: 00 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
			mtcEnc.increment() // increments to qf 1
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 2
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 3
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 3, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 4
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 01, f: 00),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 01, f: 01 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
			mtcEnc.increment() // increments to qf 5
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 5, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 6
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 7
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7, "at: \($0)")
			
			mtcEnc.increment() // increments to qf 0
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0, "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 00, s: 01, f: 02),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.timecode,
						   TCC(h: 1, m: 00, s: 01, f: 02 * frMult).toTimecode(at: $0)!,
						   "at: \($0)")
			
		}
		
	}
	
	func testMTC_Encoder_Decrement() {
		
		// test to ensure decrement behavior is consistent across timecode frame rates
		
		var mtcEnc: MIDI.MTC.Encoder!
		
		Timecode.FrameRate.allCases.forEach {
			
			mtcEnc = MIDI.MTC.Encoder()
			mtcEnc.setLocalFrameRate($0)
			mtcEnc.setMTCComponents(mtc: TCC(h: 1, m: 20, s: 32, f: 10))
			
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
			mtcEnc.decrement() // doesn't decrement; sends first quarter-frame
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 10),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
			mtcEnc.decrement() // now it decrements to QF 7
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 5,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 3,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 08),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0,
						   "at: \($0)")
			
			mtcEnc.decrement()
			XCTAssertEqual(mtcEnc.mtcComponents,
						   TCC(h: 1, m: 20, s: 32, f: 06),
						   "at: \($0)")
			XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7,
						   "at: \($0)")
			
		}
		
	}
	
	func testMTC_Encoder_Handlers_FullFrameMessage() {
		
		// ensure expected callbacks are happening when they should,
		// and that they carry the data that they should
		
		// testing vars
		
		var _midiMessage: [MIDI.Byte]?
		
		let mtcEnc = MIDI.MTC.Encoder { midiMessage in
			_midiMessage = midiMessage
		}
		
		// default / initial state
		
		XCTAssertNil(_midiMessage)
		
		// full-frame MTC messages
		
		mtcEnc.locate(to: TCC(h: 1, m: 02, s: 03, f: 4).toTimecode(at: ._24)!)
		
		XCTAssertEqual(_midiMessage, kRawMIDI.MTC_FullFrame._01_02_03_04_at_24fps)
		
		mtcEnc.locate(to: TCC(h: 2, m: 11, s: 17, f: 20).toTimecode(at: ._25)!)
		
		XCTAssertEqual(_midiMessage, kRawMIDI.MTC_FullFrame._02_11_17_20_at_25fps)
		
	}
	
	func testMTC_Encoder_Handlers_QFMessages() {
		
		// ensure expected callbacks are happening when they should,
		// and that they carry the data that they should
		
		// testing vars
		
		var _midiMessage: [MIDI.Byte]?
		
		let mtcEnc = MIDI.MTC.Encoder { midiMessage in
			_midiMessage = midiMessage
		}
		
		// default / initial state
		
		XCTAssertNil(_midiMessage)
		
		// 24fps QFs starting at 02:03:04:06, locking at 02:03:04:08 (+ 2 MTC frame offset)
		
		// start by locating to a timecode
		mtcEnc.locate(to: TCC(h: 2, m: 03, s: 04, f: 06).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		
		mtcEnc.increment() // doesn't increment; sends first quarter-frame
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0000_0110]) // QF 0
		
		mtcEnc.increment() // now it increments to QF 1
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0001_0000]) // QF 1
		
		mtcEnc.increment()
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 2)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0010_0100]) // QF 2
		
		mtcEnc.increment()
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 3)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0011_0000]) // QF 3
		
		mtcEnc.increment()
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0100_0011]) // QF 4
		
		mtcEnc.increment()
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 5)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0101_0000]) // QF 5
		
		mtcEnc.increment()
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 6)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0110_0010]) // QF 6
		
		mtcEnc.increment()
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 7)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 06))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0111_0000]) // QF 7
		
		mtcEnc.increment()
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		XCTAssertEqual(mtcEnc.mtcComponents, TCC(h: 2, m: 03, s: 04, f: 08))
		XCTAssertEqual(_midiMessage, [0xF1, 0b0000_1000]) // QF 0
		
	}
	
	func testMTC_Encoder_FullFrameMIDIMessage() {
		
		var mtcEnc: MIDI.MTC.Encoder
		
		// test each of the four MTC SMPTE base frame rates
		// and spot-check some arbitrary timecode values
		
		// non-scaling frame rates
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.locate(to: Timecode(at: ._24))
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 0, m: 00, s: 00, f: 00))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0000, // 0rrh_hhhh
						0x00, // M
						0x00, // S
						0x00, // F
						0xF7
					   ])
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.locate(to: Timecode(at: ._25))
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 0, m: 00, s: 00, f: 00))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0010_0000, // 0rrh_hhhh
						0x00, // M
						0x00, // S
						0x00, // F
						0xF7
					   ])
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.locate(to: TCC(h: 1, m: 02, s: 03, f: 04).toTimecode(at: ._29_97_drop)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 1, m: 02, s: 03, f: 04))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0100_0001, // 0rrh_hhhh
						0x02, // M
						0x03, // S
						0x04, // F
						0xF7
					   ])
		
		mtcEnc.locate(to: TCC(h: 1, m: 02, s: 03, f: 05).toTimecode(at: ._29_97_drop)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 1, m: 02, s: 03, f: 05))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0100_0001, // 0rrh_hhhh
						0x02, // M
						0x03, // S
						0x05, // F
						0xF7
					   ])
		
		mtcEnc = MIDI.MTC.Encoder()
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 08).toTimecode(at: ._30)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 08))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0110_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x08, // F
						0xF7
					   ])
		
		// scaling frame rates
		
		mtcEnc = MIDI.MTC.Encoder()
		
		// scales to MTC-24 fps
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 08).toTimecode(at: ._48)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 04))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x04, // F
						0xF7
					   ])
		
		// scales to MTC-24 fps
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 09).toTimecode(at: ._48)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 04))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x04, // F -- rounds down to 4 from 4.5 from scaling
						0xF7
					   ])
		
		// scales to MTC-24 fps
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 10).toTimecode(at: ._48)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 05))
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x05, // F
						0xF7
					   ])
		
	}
	
	func testMTC_Encoder_LocateBehavior() {
		
		var mtcEnc: MIDI.MTC.Encoder
		
		var message: [MIDI.Byte]?
		
		func initNewEnc() -> MIDI.MTC.Encoder {
			return MIDI.MTC.Encoder { midiMessage in
				message = midiMessage
			}
		}
		
		mtcEnc = initNewEnc()
		mtcEnc.locate(to: Timecode(at: ._24))
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 0, m: 00, s: 00, f: 00))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0000, // 0rrh_hhhh
						0x00, // M
						0x00, // S
						0x00, // F
						0xF7
					   ])
		
		mtcEnc = initNewEnc()
		mtcEnc.locate(to: Timecode(at: ._25))
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 0, m: 00, s: 00, f: 00))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0010_0000, // 0rrh_hhhh
						0x00, // M
						0x00, // S
						0x00, // F
						0xF7
					   ])
		
		mtcEnc = initNewEnc()
		mtcEnc.locate(to: TCC(h: 1, m: 02, s: 03, f: 04).toTimecode(at: ._29_97_drop)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 1, m: 02, s: 03, f: 04))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0100_0001, // 0rrh_hhhh
						0x02, // M
						0x03, // S
						0x04, // F
						0xF7
					   ])
		
		mtcEnc.locate(to: TCC(h: 1, m: 02, s: 03, f: 05).toTimecode(at: ._29_97_drop)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 1, m: 02, s: 03, f: 05))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0100_0001, // 0rrh_hhhh
						0x02, // M
						0x03, // S
						0x05, // F
						0xF7
					   ])
		
		mtcEnc = initNewEnc()
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 08).toTimecode(at: ._30)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 08))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0110_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x08, // F
						0xF7
					   ])
		
		// scaling frame rates
		
		mtcEnc = initNewEnc()
		
		// scales to MTC-24 fps
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 08).toTimecode(at: ._48)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 04))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x04, // F
						0xF7
					   ])
		
		// scales to MTC-24 fps
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 09).toTimecode(at: ._48)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 04))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x04, // F -- rounds down to 4 from 4.5 from scaling
						0xF7
					   ])
		
		// scales to MTC-24 fps
		mtcEnc.locate(to: TCC(h: 2, m: 04, s: 06, f: 10).toTimecode(at: ._48)!)
		
		XCTAssertEqual(mtcEnc.generateFullFrameMIDIMessage().components,
					   TCC(h: 2, m: 04, s: 06, f: 05))
		XCTAssertEqual(message,
					   [
						0xF0, 0x7F, 0x7F, 0x01, 0x01,
						0b0000_0010, // 0rrh_hhhh
						0x04, // M
						0x06, // S
						0x05, // F
						0xF7
					   ])
		
	}
	
	func testMTC_Encoder_QFMIDIMessage() {
		
		let mtcEnc = MIDI.MTC.Encoder()
		
		// test an arbitrary timecode in all timecode frame rates
		// while covering all four MTC SMPTE base frame rates
		
		Timecode.FrameRate.allCases.forEach {
			
			mtcEnc.locate(to: TCC(h: 2, m: 4, s: 6, f: 0).toTimecode(at: $0)!)
			mtcEnc.mtcComponents.f = 8
			
			mtcEnc.mtcQuarterFrame = 0
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, 0b0000_1000])
			
			mtcEnc.mtcQuarterFrame = 1
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, 0b0001_0000])
			
			mtcEnc.mtcQuarterFrame = 2
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, 0b0010_0110])
			
			mtcEnc.mtcQuarterFrame = 3
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, 0b0011_0000])
			
			mtcEnc.mtcQuarterFrame = 4
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, 0b0100_0100])
			
			mtcEnc.mtcQuarterFrame = 5
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, 0b0101_0000])
			
			mtcEnc.mtcQuarterFrame = 6
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, 0b0110_0010])
			
			mtcEnc.mtcQuarterFrame = 7
			let dataByte: MIDI.Byte
			switch $0.mtcFrameRate {
			case .mtc24:    dataByte = 0b0111_0000
			case .mtc25:    dataByte = 0b0111_0010
			case .mtc2997d: dataByte = 0b0111_0100
			case .mtc30:    dataByte = 0b0111_0110
			}
			XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
						   [0xF1, dataByte])
			
		}
		
		// edge cases
		
		// test large numbers, but still within spec
		
		mtcEnc.locate(to: TCC(h: 23, m: 59, s: 58, f: 28).toTimecode(at: ._30)!)
		
		mtcEnc.mtcQuarterFrame = 0
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0000_1100])
		
		mtcEnc.mtcQuarterFrame = 1
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0001_0001])
		
		mtcEnc.mtcQuarterFrame = 2
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0010_1010])
		
		mtcEnc.mtcQuarterFrame = 3
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0011_0011])
		
		mtcEnc.mtcQuarterFrame = 4
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0100_1011])
		
		mtcEnc.mtcQuarterFrame = 5
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0101_0011])
		
		mtcEnc.mtcQuarterFrame = 6
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0110_0111])
		
		mtcEnc.mtcQuarterFrame = 7
		XCTAssertEqual(mtcEnc.generateQuarterFrameMIDIMessage(),
					   [0xF1, 0b0111_0111])
		
	}
	
}

#endif
