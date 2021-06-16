//
//  MTC Integration Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-06-11.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync
import OTCore

import TimecodeKit

final class MTC_Integration_Integration_Tests: XCTestCase {
	
	func testMTC_Integration_EncoderDecoder_24fps() {
		
		// decoder
		
		var _timecode: Timecode?       ; _ = _timecode
		var _mType: MTC.MessageType?   ; _ = _mType
		var _direction: MTC.Direction? ; _ = _direction
		var _displayNeedsUpdate: Bool? ; _ = _displayNeedsUpdate
		var _mtcFR: MTC.MTCFrameRate?  ; _ = _mtcFR
		
		let mtcDec = MTC.Decoder(initialLocalFrameRate: nil)
		{ timecode, messageType, direction, displayNeedsUpdate in
			_timecode = timecode
			_mType = messageType
			_direction = direction
			_displayNeedsUpdate = displayNeedsUpdate
		} mtcFrameRateChanged: { mtcFrameRate in
			_mtcFR = mtcFrameRate
		}
		
		// encoder
		
		let mtcEnc = MTC.Encoder { midiMessage in
			mtcDec.midiIn(data: midiMessage)
		}
		
		// test
		
		mtcDec.localFrameRate = ._24
		mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
		
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		mtcEnc.increment() // QF 0
		mtcEnc.increment() // QF 1
		mtcEnc.increment() // QF 2
		mtcEnc.increment() // QF 3
		mtcEnc.increment() // QF 4
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._24)!)
		mtcEnc.increment() // QF 1
		mtcEnc.increment() // QF 2
		mtcEnc.increment() // QF 3
		mtcEnc.increment() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 03).toTimecode(at: ._24)!)
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 04).toTimecode(at: ._24)!)
		(19 * 4).repeatEach { mtcEnc.increment() } // advance 19 frames (4 QF per frame)
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4)
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 23).toTimecode(at: ._24)!)
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 01, f: 00).toTimecode(at: ._24)!)
		XCTAssertEqual(_direction, .forwards)
		mtcEnc.decrement() // QF 7
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 23).toTimecode(at: ._24)!)
		XCTAssertEqual(_direction, .backwards)
		mtcEnc.decrement() // QF 6
		mtcEnc.decrement() // QF 5
		mtcEnc.decrement() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 23).toTimecode(at: ._24)!)
		mtcEnc.decrement() // QF 3
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 22).toTimecode(at: ._24)!)
		mtcEnc.decrement() // QF 2
		mtcEnc.decrement() // QF 1
		mtcEnc.decrement() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 22).toTimecode(at: ._24)!)
		mtcEnc.decrement() // QF 7
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 21).toTimecode(at: ._24)!)
		mtcEnc.decrement() // QF 6
		mtcEnc.decrement() // QF 5
		mtcEnc.decrement() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 21).toTimecode(at: ._24)!)
		mtcEnc.decrement() // QF 3
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 20).toTimecode(at: ._24)!)
		mtcEnc.decrement() // QF 2
		mtcEnc.decrement() // QF 1
		mtcEnc.decrement() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 20).toTimecode(at: ._24)!)
		
	}
	
	func testMTC_Integration_EncoderDecoder_29_97drop() {
		
		// decoder
		
		var _timecode: Timecode?       ; _ = _timecode
		var _mType: MTC.MessageType?   ; _ = _mType
		var _direction: MTC.Direction? ; _ = _direction
		var _displayNeedsUpdate: Bool? ; _ = _displayNeedsUpdate
		var _mtcFR: MTC.MTCFrameRate?  ; _ = _mtcFR
		
		let mtcDec = MTC.Decoder(initialLocalFrameRate: nil)
		{ timecode, messageType, direction, displayNeedsUpdate in
			_timecode = timecode
			_mType = messageType
			_direction = direction
			_displayNeedsUpdate = displayNeedsUpdate
		} mtcFrameRateChanged: { mtcFrameRate in
			_mtcFR = mtcFrameRate
		}
		
		// encoder
		
		let mtcEnc = MTC.Encoder { midiMessage in
			mtcDec.midiIn(data: midiMessage)
		}
		
		// test
		
		mtcDec.localFrameRate = ._29_97_drop
		mtcEnc.locate(to: TCC(h: 1, m: 00, s: 59, f: 00).toTimecode(at: ._29_97_drop)!)
		
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 00).toTimecode(at: ._29_97_drop)!)
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		mtcEnc.increment() // QF 0
		mtcEnc.increment() // QF 1
		mtcEnc.increment() // QF 2
		mtcEnc.increment() // QF 3
		mtcEnc.increment() // QF 4
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 02).toTimecode(at: ._29_97_drop)!)
		mtcEnc.increment() // QF 1
		mtcEnc.increment() // QF 2
		mtcEnc.increment() // QF 3
		mtcEnc.increment() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 03).toTimecode(at: ._29_97_drop)!)
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 04).toTimecode(at: ._29_97_drop)!)
		(25 * 4).repeatEach { mtcEnc.increment() } // advance 25 frames (4 QF per frame)
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4)
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		XCTAssertEqual(_direction, .forwards)
		mtcEnc.decrement() // QF 7
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		XCTAssertEqual(_direction, .backwards)
		mtcEnc.decrement() // QF 6
		mtcEnc.decrement() // QF 5
		mtcEnc.decrement() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 3
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 28).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 2
		mtcEnc.decrement() // QF 1
		mtcEnc.decrement() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 28).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 7
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 27).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 6
		mtcEnc.decrement() // QF 5
		mtcEnc.decrement() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 27).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 3
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 26).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 2
		mtcEnc.decrement() // QF 1
		mtcEnc.decrement() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 26).toTimecode(at: ._29_97_drop)!)
		
		// variant
		
		mtcDec.localFrameRate = ._29_97_drop
		mtcEnc.locate(to: TCC(h: 1, m: 00, s: 59, f: 00).toTimecode(at: ._29_97_drop)!)
		
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 00).toTimecode(at: ._29_97_drop)!)
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
		mtcEnc.increment() // QF 0
		mtcEnc.increment() // QF 1
		mtcEnc.increment() // QF 2
		mtcEnc.increment() // QF 3
		mtcEnc.increment() // QF 4
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 02).toTimecode(at: ._29_97_drop)!)
		mtcEnc.increment() // QF 1
		mtcEnc.increment() // QF 2
		mtcEnc.increment() // QF 3
		mtcEnc.increment() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 03).toTimecode(at: ._29_97_drop)!)
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 04).toTimecode(at: ._29_97_drop)!)
		(25 * 4).repeatEach { mtcEnc.increment() } // advance 25 frames (4 QF per frame)
		XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4)
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		mtcEnc.increment() // QF 5
		mtcEnc.increment() // QF 6
		mtcEnc.increment() // QF 7
		mtcEnc.increment() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		// ** START: additional lines added for test variant **
		mtcEnc.increment() // QF 1
		XCTAssertEqual(_timecode, TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		XCTAssertEqual(_direction, .forwards)
		mtcEnc.decrement() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		XCTAssertEqual(_direction, .backwards)
		// ** END: additional lines added for test variant **
		mtcEnc.decrement() // QF 7
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 6
		mtcEnc.decrement() // QF 5
		mtcEnc.decrement() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 3
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 28).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 2
		mtcEnc.decrement() // QF 1
		mtcEnc.decrement() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 28).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 7
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 27).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 6
		mtcEnc.decrement() // QF 5
		mtcEnc.decrement() // QF 4
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 27).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 3
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 26).toTimecode(at: ._29_97_drop)!)
		mtcEnc.decrement() // QF 2
		mtcEnc.decrement() // QF 1
		mtcEnc.decrement() // QF 0
		XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 59, f: 26).toTimecode(at: ._29_97_drop)!)
		
	}
	
	func testBruteForce() {
		
		// decoder
		
		var _timecode: Timecode?       ; _ = _timecode
		var _mType: MTC.MessageType?   ; _ = _mType
		var _direction: MTC.Direction? ; _ = _direction
		var _displayNeedsUpdate: Bool? ; _ = _displayNeedsUpdate
		var _mtcFR: MTC.MTCFrameRate?  ; _ = _mtcFR
		
		let mtcDec = MTC.Decoder(initialLocalFrameRate: nil)
		{ timecode, messageType, direction, displayNeedsUpdate in
			_timecode = timecode
			_mType = messageType
			_direction = direction
			_displayNeedsUpdate = displayNeedsUpdate
		} mtcFrameRateChanged: { mtcFrameRate in
			_mtcFR = mtcFrameRate
		}
		
		// encoder
		
		let mtcEnc = MTC.Encoder { midiMessage in
			mtcDec.midiIn(data: midiMessage)
		}
		
		// test
		
		// iterate: each timecode frame rate
		// omit 24.98fps because it does not conform to the nature of this test
		Timecode.FrameRate.allCases
			.filter({ $0 != ._24_98 })
			.forEach { frameRate in
				
				// inform the decoder that our desired local frame rate has changed
				mtcDec.localFrameRate = frameRate
				
				let ranges: [ClosedRange<Timecode>]
				
				switch frameRate.mtcScaleFactor {
				case 1:
					ranges = [
						Timecode(TCC(h: 0, m: 00, s: 00, f: 02), at: frameRate)! ...
							Timecode(TCC(h: 0, m: 00, s: 04, f: 10), at: frameRate)!,
						
						Timecode(TCC(h: 1, m: 00, s: 59, f: 02), at: frameRate)! ...
							Timecode(TCC(h: 1, m: 01, s: 01, f: 10), at: frameRate)!
					]
				case 2:
					ranges = [
						Timecode(TCC(h: 0, m: 00, s: 00, f: 04), at: frameRate)! ...
							Timecode(TCC(h: 0, m: 00, s: 02, f: 10), at: frameRate)!,
						
						Timecode(TCC(h: 1, m: 00, s: 59, f: 04), at: frameRate)! ...
							Timecode(TCC(h: 1, m: 01, s: 01, f: 10), at: frameRate)!
					]
				case 4:
					ranges = [
						Timecode(TCC(h: 0, m: 00, s: 00, f: 08), at: frameRate)! ...
							Timecode(TCC(h: 0, m: 00, s: 02, f: 10), at: frameRate)!,
						
						Timecode(TCC(h: 1, m: 00, s: 59, f: 08), at: frameRate)! ...
							Timecode(TCC(h: 1, m: 01, s: 01, f: 10), at: frameRate)!
					]
				default:
					XCTFail("Unhandled frame rate")
					return // continue to next frame rate in forEach
				}
				
				// iterate: each span in the collection of test ranges
				for range in ranges {
					
					let startOffset = 2 * Int(frameRate.mtcScaleFactor)
					mtcEnc.locate(to: range.first!.subtracting(wrapping: TCC(f: startOffset)))
					
					mtcEnc.increment() // QF 0
					XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
					mtcEnc.increment() // QF 1
					XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1)
					mtcEnc.increment() // QF 2
					mtcEnc.increment() // QF 3
					mtcEnc.increment() // QF 4
					mtcEnc.increment() // QF 5
					mtcEnc.increment() // QF 6
					mtcEnc.increment() // QF 7
					mtcEnc.increment() // QF 0
					
					// iterate: each individual timecode included in the span
					for timecode in range {
						
						XCTAssertEqual(_timecode!, timecode, "at: \(frameRate)")
						
						switch frameRate.mtcScaleFactor {
						case 1:
							mtcEnc.increment()
							mtcEnc.increment()
							mtcEnc.increment()
							mtcEnc.increment()
						case 2:
							mtcEnc.increment()
							mtcEnc.increment()
						case 4:
							mtcEnc.increment()
						default:
							XCTFail("Unhandled frame rate")
							
						}
						
					}
					
				}
				
			}
		
	}
	
}

#endif
