//
//  MTC Decoder Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-21.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync

import TimecodeKit

final class MTC_Receiver_Decoder_Tests: XCTestCase {
	
	func testMTC_Decoder_Default() {
		
		let mtcDec = MTC.Decoder()
		
		// check if defaults are nominal
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._30)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		XCTAssertEqual(mtcDec.localFrameRate, nil)
		XCTAssertEqual(mtcDec.direction, .forwards)
		
		// basic properties mutation
		
		// localFrameRate
		mtcDec.localFrameRate = ._29_97
		XCTAssertEqual(mtcDec.localFrameRate, ._29_97)
		
	}
	
	func testMTC_Decoder_Init_Arguments() {
		
		let mtcDec = MTC.Decoder(initialLocalFrameRate: ._29_97)
		
		XCTAssertEqual(mtcDec.localFrameRate, ._29_97)
		
	}
	
	func testMTC_Decoder_InternalState_FullFrameMessage() {
		
		// test full frame MTC messages and check that properties get updated
		
		let mtcDec = MTC.Decoder()
		
		// 01:02:03:04 @ MTC 24fps
		mtcDec.midiIn(data: kRawMIDI.MTC_FullFrame._01_02_03_04_at_24fps)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		XCTAssertEqual(mtcDec.direction, .forwards)
		
		// 00:00:00:00 @ MTC 24fps
		mtcDec.midiIn(data: kRawMIDI.MTC_FullFrame._00_00_00_00_at_24fps)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		XCTAssertEqual(mtcDec.direction, .forwards)
		
		// 02:11:17:20 @ MTC 25fps
		mtcDec.midiIn(data: kRawMIDI.MTC_FullFrame._02_11_17_20_at_25fps)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 11, s: 17, f: 20).toTimecode(at: ._25)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc25)
		XCTAssertEqual(mtcDec.direction, .forwards)
		
	}
	
	func testMTC_Decoder_InternalState_QFMessages_Typical() {
		
		// test MTC quarter-frame messages and check that properties get updated
		
		let mtcDec = MTC.Decoder()
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0110]) // QF 0
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), true)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1000]) // QF 0
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), true)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1010]) // QF 0
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 10).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
	}
	
	func testMTC_Decoder_InternalState_QFMessages_Scaled_24to48() {
		
		let mtcDec = MTC.Decoder()
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
		// scaled to 48 fps real timecode frame rate
		
		mtcDec.localFrameRate = ._48
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0110])
		mtcDec.midiIn(data: [0xF1, 0b0001_0000])
		mtcDec.midiIn(data: [0xF1, 0b0010_0100])
		mtcDec.midiIn(data: [0xF1, 0b0011_0000])
		mtcDec.midiIn(data: [0xF1, 0b0100_0011])
		mtcDec.midiIn(data: [0xF1, 0b0101_0000])
		mtcDec.midiIn(data: [0xF1, 0b0110_0010])
		mtcDec.midiIn(data: [0xF1, 0b0111_0000])
		mtcDec.midiIn(data: [0xF1, 0b0000_1000])
		
		XCTAssertEqual(mtcDec.qfBufferComplete(), true)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 16).toTimecode(at: ._48)!) // new TC
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 16).toTimecode(at: ._48)!) // unchanged
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 17).toTimecode(at: ._48)!) // new TC
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 17).toTimecode(at: ._48)!) // unchanged
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 18).toTimecode(at: ._48)!) // new TC
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 18).toTimecode(at: ._48)!) // unchanged
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 19).toTimecode(at: ._48)!) // new TC
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 19).toTimecode(at: ._48)!) // unchanged
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1010])
		
		XCTAssertEqual(mtcDec.timecode, TCC(h: 2, m: 3, s: 4, f: 20).toTimecode(at: ._48)!) // new TC
		
	}
	
	func testMTC_Decoder_InternalState_QFMessages_25FPS() {
		
		// 25 fps behaves differently from 24/29.97d/30 MTC SMPTE rates
		
		var mtcDec: MTC.Decoder
		
		
		// Starting on even frame number:
		// 25fps QFs starting at 01:00:00:00, locking at 01:00:00:02 (+ 2 MTC frame offset)
		
		mtcDec = MTC.Decoder()
		mtcDec.localFrameRate = ._25
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0000]) // QF 0
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0010]) // QF 0 MTC 01:00:00:00 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._25)!)
		
		
		// Starting on odd frame number:
		// 25fps QFs starting at 01:00:00:00, locking at 01:00:00:02 (+ 2 MTC frame offset)
		
		mtcDec = MTC.Decoder()
		mtcDec.localFrameRate = ._25
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0001]) // QF 0
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0011]) // QF 0 MTC 01:00:00:01 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 00, f: 03).toTimecode(at: ._25)!)
		
		
		// Starting on even frame number:
		// 25fps QFs starting at 01:00:00:22, locking at 01:00:00:24 (+ 2 MTC frame offset)
		
		mtcDec = MTC.Decoder()
		mtcDec.localFrameRate = ._25
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0110]) // QF 0
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_1000]) // QF 0 MTC 01:00:00:22 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 00, f: 24).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 00).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0001]) // QF 0 MTC 01:00:00:24 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 01).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0001]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 02).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0011]) // QF 0 MTC 01:00:01:01
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 03).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0001]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 04).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0101]) // QF 0 MTC 01:00:01:03 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 05).toTimecode(at: ._25)!)
		
		
		// Starting on odd frame number:
		// 25fps QFs starting at 01:00:00:22, locking at 01:00:00:24 (+ 2 MTC frame offset)
		
		mtcDec = MTC.Decoder()
		mtcDec.localFrameRate = ._25
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0101]) // QF 0
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0111]) // QF 0 MTC 01:00:00:21 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 00, f: 23).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 00, f: 24).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0000]) // QF 0 MTC 01:00:00:23 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 00).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0001]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 01).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0010]) // QF 0 MTC 01:00:01:00
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 02).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0001]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 03).toTimecode(at: ._25)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0010]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0100]) // QF 0 MTC 01:00:01:02 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 01, f: 04).toTimecode(at: ._25)!)
		
	}
	
	func testMTC_Decoder_InternalState_QFMessages_2997DropFPS() {
		
		// test for edge cases and peculiarities with 29.97 drop fps
		
		var mtcDec: MTC.Decoder
		
		// 29.97dfps QFs starting at 01:00:00;00, locking at 01:00:00;02 (+ 2 MTC frame offset)
		
		mtcDec = MTC.Decoder()
		mtcDec.localFrameRate = ._29_97_drop
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0000]) // QF 0
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0010]) // QF 0 MTC 01:00:00;00 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0100]) // QF 0 MTC 01:00:00;02 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 00, f: 04).toTimecode(at: ._29_97_drop)!)
		
		// 29.97dfps QFs starting at 01:00:59;26, locking at 01:00:59;28 (+ 2 MTC frame offset)
		
		mtcDec = MTC.Decoder()
		mtcDec.localFrameRate = ._29_97_drop
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1010]) // QF 0
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_1011]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0011]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_1100]) // QF 0 MTC 01:00:59;26 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 59, f: 28).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_1011]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0011]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0010]) // QF 0 MTC 01:00:59;28 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0001]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 03).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0100]) // QF 0 MTC 01:01:00;02
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 04).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_0000]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0001]) // QF 4 // sync qf // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 05).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0110]) // QF 0 MTC 01:01:00;04 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 06).toTimecode(at: ._29_97_drop)!)
		
		// edge case:
		// 29.97dfps QFs starting at 01:00:59;26, locking at 01:00:59;28 (+ 2 MTC frame offset)
		// with changes of direction
		
		mtcDec = MTC.Decoder()
		mtcDec.localFrameRate = ._29_97_drop
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1010]) // QF 0
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_1011]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0011]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_1100]) // QF 0 MTC 01:00:59;26 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 59, f: 28).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0001]) // QF 1
		mtcDec.midiIn(data: [0xF1, 0b0010_1011]) // QF 2
		mtcDec.midiIn(data: [0xF1, 0b0011_0011]) // QF 3
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		mtcDec.midiIn(data: [0xF1, 0b0000_0010]) // QF 0 MTC 01:00:59;28 // sync qf
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0010]) // QF 0 ** reverse direction **
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 01, s: 00, f: 02).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0100]) // QF 7
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0001]) // QF 6
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		mtcDec.midiIn(data: [0xF1, 0b0100_0000]) // QF 4
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 59, f: 29).toTimecode(at: ._29_97_drop)!)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0011]) // QF 3
		
		XCTAssertEqual(mtcDec.timecode,
					   TCC(h: 1, m: 00, s: 59, f: 28).toTimecode(at: ._29_97_drop)!)
		
	}
	
	func testMTC_Decoder_InternalState_QFMessages_Direction() {
		
		let mtcDec = MTC.Decoder()
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
		
		// sequential, forwards and backwards
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0110]) // QF 0
		XCTAssertEqual(mtcDec.direction, .ambiguous)
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0000_1000]) // QF 0
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		XCTAssertEqual(mtcDec.direction, .backwards)
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		XCTAssertEqual(mtcDec.direction, .backwards)
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		XCTAssertEqual(mtcDec.direction, .backwards)
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		XCTAssertEqual(mtcDec.direction, .backwards)
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		XCTAssertEqual(mtcDec.direction, .forwards)
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		XCTAssertEqual(mtcDec.direction, .forwards)
		
		// non-sequential (jumps)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		XCTAssertEqual(mtcDec.direction, .ambiguous)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		XCTAssertEqual(mtcDec.direction, .ambiguous)
		
	}
	
	func testMTC_Decoder_Handlers_FullFrameMessage() {
		
		// ensure expected callbacks are happening when they should,
		// and that they carry the data that they should
		
		// testing vars
		
		var _timecode: Timecode?
		var _mType: MTC.MessageType?
		var _direction: MTC.Direction?
		var _displayNeedsUpdate: Bool?
		var _mtcFR: MTC.MTCFrameRate?
		
		let mtcDec = MTC.Decoder()
		{ timecode, messageType, direction, displayNeedsUpdate in
			_timecode = timecode
			_mType = messageType
			_direction = direction
			_displayNeedsUpdate = displayNeedsUpdate
		} mtcFrameRateChanged: { mtcFrameRate in
			_mtcFR = mtcFrameRate
		}
		
		// default / initial state
		
		XCTAssertNil(_timecode)
		XCTAssertNil(_mType)
		XCTAssertNil(_direction)
		XCTAssertNil(_displayNeedsUpdate)
		XCTAssertNil(_mtcFR)
		
		// full-frame MTC messages
		
		mtcDec.midiIn(data: kRawMIDI.MTC_FullFrame._01_02_03_04_at_24fps)
		
		XCTAssertEqual(_timecode, TCC(h: 1, m: 02, s: 03, f: 04).toTimecode(at: ._24))
		XCTAssertEqual(_mType, .fullFrame)
		XCTAssertEqual(_direction, .forwards)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		
		mtcDec.midiIn(data: kRawMIDI.MTC_FullFrame._02_11_17_20_at_25fps)
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 11, s: 17, f: 20).toTimecode(at: ._25))
		XCTAssertEqual(_mType, .fullFrame)
		XCTAssertEqual(_direction, .forwards)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc25)
		
	}
	
	func testMTC_Decoder_Handlers_QFMessages() {
		
		// ensure expected callbacks are happening when they should,
		// and that they carry the data that they should
		
		// testing vars
		
		var _timecode: Timecode?
		var _mType: MTC.MessageType?
		var _direction: MTC.Direction?
		var _displayNeedsUpdate: Bool?
		var _mtcFR: MTC.MTCFrameRate?
		
		let mtcDec = MTC.Decoder()
		{ timecode, messageType, direction, displayNeedsUpdate in
			_timecode = timecode
			_mType = messageType
			_direction = direction
			_displayNeedsUpdate = displayNeedsUpdate
		} mtcFrameRateChanged: { mtcFrameRate in
			_mtcFR = mtcFrameRate
		}
		
		// default / initial state
		
		XCTAssertNil(_timecode)
		XCTAssertNil(_mType)
		XCTAssertNil(_direction)
		XCTAssertNil(_displayNeedsUpdate)
		XCTAssertNil(_mtcFR)
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0110]) // QF 0
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, nil)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, nil)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, nil)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, nil)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, nil)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, nil)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, nil)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		
		XCTAssertEqual(_timecode, nil)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, nil)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1000]) // QF 0
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1010]) // QF 0

		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 10).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)

		// reverse

		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		// forwards
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .forwards)
		
		// reverse
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1000]) // QF 0
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 7).toTimecode(at: ._24)!) // new TC
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(_timecode, TCC(h: 2, m: 3, s: 4, f: 7).toTimecode(at: ._24)!) // unchanged
		XCTAssertEqual(_mType, .quarterFrame)
		XCTAssertEqual(_displayNeedsUpdate, false)
		XCTAssertEqual(_mtcFR, .mtc24)
		XCTAssertEqual(_direction, .backwards)
		
		// non-sequential (discontinuous jumps)

		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		XCTAssertEqual(_direction, .ambiguous)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		XCTAssertEqual(_direction, .ambiguous)
		
	}
	
}

#endif
