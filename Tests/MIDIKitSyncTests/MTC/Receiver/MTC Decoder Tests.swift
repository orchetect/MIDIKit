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

extension MIDIKitSyncTests {
	
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
		
		let mtcDec = MTC.Decoder(localFrameRate: ._29_97)
		
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
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0110]) // QF 0
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0001_0000]) // QF 1
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0010_0100]) // QF 2
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0100_0011]) // QF 4
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0110_0010]) // QF 6
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), false)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), true)
		XCTAssertEqual(mtcDec.timecode, TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(at: ._24)!)
		XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
		
		mtcDec.midiIn(data: [0xF1, 0b0000_1000]) // QF 0
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), true)
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
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
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
		
		XCTAssertEqual(mtcDec.QFBufferComplete(), true)
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
	
	func testMTC_Decoder_InternalState_QFMessages_Direction() {
		
		let mtcDec = MTC.Decoder()
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
		
		// sequential, forwards and backwards
		
		mtcDec.midiIn(data: [0xF1, 0b0000_0110]) // QF 0
		XCTAssertEqual(mtcDec.direction, .forwards)
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
		XCTAssertEqual(mtcDec.direction, .forwards) // default to forwards
		
		mtcDec.midiIn(data: [0xF1, 0b0111_0000]) // QF 7
		XCTAssertEqual(mtcDec.direction, .forwards) // default to forwards
		
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
		
		// full-frame MTC message
		
		mtcDec.midiIn(data: kRawMIDI.MTC_FullFrame._01_02_03_04_at_24fps)
		
		XCTAssertEqual(_timecode, TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(at: ._24))
		XCTAssertEqual(_mType, .fullFrame)
		XCTAssertEqual(_direction, .forwards)
		XCTAssertEqual(_displayNeedsUpdate, true)
		XCTAssertEqual(_mtcFR, .mtc24)
		
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
		
		// 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
		
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
		XCTAssertEqual(_direction, .forwards)
		XCTAssertEqual(_mtcFR, .mtc24)
		
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
		XCTAssertEqual(_direction, .backwards)
		mtcDec.midiIn(data: [0xF1, 0b0000_1010]) // QF 0
		XCTAssertEqual(_direction, .forwards)
		
		// non-sequential (discontinuous jumps)
		
		mtcDec.midiIn(data: [0xF1, 0b0011_0000]) // QF 3
		XCTAssertEqual(_direction, .forwards) // default to forwards
		mtcDec.midiIn(data: [0xF1, 0b0101_0000]) // QF 5
		XCTAssertEqual(_direction, .forwards) // default to forwards
		
	}
	
}

#endif
