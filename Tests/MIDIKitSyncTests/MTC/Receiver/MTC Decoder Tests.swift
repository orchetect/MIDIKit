//
//  MTC Decoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSync
import TimecodeKit
import XCTest

final class MTC_Receiver_Decoder_Tests: XCTestCase {
    // swiftformat:options --maxwidth none
    
    func testMTC_Decoder_Default() {
        let mtcDec = MTCDecoder()
        
        // check if defaults are nominal
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps30, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        XCTAssertEqual(mtcDec.localFrameRate, nil)
        XCTAssertEqual(mtcDec.direction, .forwards)
        
        // basic properties mutation
        
        // localFrameRate
        mtcDec.localFrameRate = .fps29_97
        XCTAssertEqual(mtcDec.localFrameRate, .fps29_97)
    }
    
    func testMTC_Decoder_Init_Arguments() {
        let mtcDec = MTCDecoder(initialLocalFrameRate: .fps29_97)
        
        XCTAssertEqual(mtcDec.localFrameRate, .fps29_97)
    }
    
    func testMTC_Decoder_InternalState_FullFrameMessage() {
        // test full frame MTC messages and check that properties get updated
        
        let mtcDec = MTCDecoder()
        
        // 01:02:03:04 @ MTC 24fps
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        XCTAssertEqual(mtcDec.direction, .forwards)
        
        // 00:00:00:00 @ MTC 24fps
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        XCTAssertEqual(mtcDec.direction, .forwards)
        
        // 02:11:17:20 @ MTC 25fps
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc25)
        XCTAssertEqual(mtcDec.direction, .forwards)
    }
    
    func testMTC_Decoder_InternalState_QFMessages_Typical() {
        // test MTC quarter-frame messages and check that properties get updated
        
        let mtcDec = MTCDecoder()
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), false)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), false)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), false)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), false)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), false)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), false)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), false)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), true)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), true)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 10), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
    }
    
    func testMTC_Decoder_InternalState_QFMessages_Scaled_24to48() {
        let mtcDec = MTCDecoder()
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
        // scaled to 48 fps real timecode frame rate
        
        mtcDec.localFrameRate = .fps48
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000))
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000))
        
        XCTAssertEqual(mtcDec.qfBufferComplete(), true)
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 16), at: .fps48, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(mtcDec.mtcFrameRate, .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 16), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 17), at: .fps48, by: .allowingInvalid)
        ) // new TC
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 17), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 18), at: .fps48, by: .allowingInvalid)
        ) // new TC
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 18), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 19), at: .fps48, by: .allowingInvalid)
        ) // new TC
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 19), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010))
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 20), at: .fps48, by: .allowingInvalid)
        ) // new TC
    }
    
    func testMTC_Decoder_InternalState_QFMessages_25FPS() {
        // swiftformat:disable wrap
        // swiftformat:disable wrapSingleLineComments
        
        // 25 fps behaves differently from 24/29.97d/30 MTC SMPTE rates
        
        var mtcDec: MTCDecoder
        
        // Starting on even frame number:
        // 25fps QFs starting at 01:00:00:00, locking at 01:00:00:02 (+ 2 MTC frame offset)
        
        mtcDec = MTCDecoder()
        mtcDec.localFrameRate = .fps25
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000000)) // QF 0
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:00:00 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps25, by: .allowingInvalid)
        )
        
        // Starting on odd frame number:
        // 25fps QFs starting at 01:00:00:00, locking at 01:00:00:02 (+ 2 MTC frame offset)
        
        mtcDec = MTCDecoder()
        mtcDec.localFrameRate = .fps25
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000001)) // QF 0
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000011)) // QF 0 MTC 01:00:00:01 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 00, f: 03), at: .fps25, by: .allowingInvalid)
        )
        
        // Starting on even frame number:
        // 25fps QFs starting at 01:00:00:22, locking at 01:00:00:24 (+ 2 MTC frame offset)
        
        mtcDec = MTCDecoder()
        mtcDec.localFrameRate = .fps25
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0 MTC 01:00:00:22 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 00, f: 24), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 00), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000001)) // QF 0 MTC 01:00:00:24 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 01), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 02), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000011)) // QF 0 MTC 01:00:01:01
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 03), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 04), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000101)) // QF 0 MTC 01:00:01:03 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 05), at: .fps25, by: .allowingInvalid)
        )
        
        // Starting on odd frame number:
        // 25fps QFs starting at 01:00:00:22, locking at 01:00:00:24 (+ 2 MTC frame offset)
        
        mtcDec = MTCDecoder()
        mtcDec.localFrameRate = .fps25
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000101)) // QF 0
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000111)) // QF 0 MTC 01:00:00:21 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 00, f: 23), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 00, f: 24), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000000)) // QF 0 MTC 01:00:00:23 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 00), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 01), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:01:00
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 02), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 03), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000100)) // QF 0 MTC 01:00:01:02 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 01, f: 04), at: .fps25, by: .allowingInvalid)
        )
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    
    func testMTC_Decoder_InternalState_QFMessages_2997DropFPS() {
        // swiftformat:disable wrap
        // swiftformat:disable wrapSingleLineComments
        
        // test for edge cases and peculiarities with 29.97 drop fps
        
        var mtcDec: MTCDecoder
        
        // 29.97dfps QFs starting at 01:00:00;00, locking at 01:00:00;02 (+ 2 MTC frame offset)
        
        mtcDec = MTCDecoder()
        mtcDec.localFrameRate = .fps29_97d
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000000)) // QF 0
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:00;00 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000100)) // QF 0 MTC 01:00:00;02 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 00, f: 04), at: .fps29_97d, by: .allowingInvalid)
        )
        
        // 29.97dfps QFs starting at 01:00:59;26, locking at 01:00:59;28 (+ 2 MTC frame offset)
        
        mtcDec = MTCDecoder()
        mtcDec.localFrameRate = .fps29_97d
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00101011)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001100)) // QF 0 MTC 01:00:59;26 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00101011)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:59;28 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000001)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 03), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000100)) // QF 0 MTC 01:01:00;02
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 04), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000001)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 05), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0 MTC 01:01:00;04 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 06), at: .fps29_97d, by: .allowingInvalid)
        )
        
        // edge case:
        // 29.97dfps QFs starting at 01:00:59;26, locking at 01:00:59;28 (+ 2 MTC frame offset)
        // with changes of direction
        
        mtcDec = MTCDecoder()
        mtcDec.localFrameRate = .fps29_97d
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00101011)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001100)) // QF 0 MTC 01:00:59;26 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00101011)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:59;28 - sync qf
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec
            .midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 ** reverse direction **
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        
        XCTAssertEqual(
            mtcDec.timecode,
            Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    
    func testMTC_Decoder_InternalState_QFMessages_Direction() {
        // swiftformat:disable wrap
        // swiftformat:disable wrapSingleLineComments
        
        let mtcDec = MTCDecoder()
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
        
        // sequential, forwards and backwards
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        XCTAssertEqual(mtcDec.direction, .ambiguous)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        XCTAssertEqual(mtcDec.direction, .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        XCTAssertEqual(mtcDec.direction, .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        XCTAssertEqual(mtcDec.direction, .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        XCTAssertEqual(mtcDec.direction, .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        XCTAssertEqual(mtcDec.direction, .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        XCTAssertEqual(mtcDec.direction, .forwards)
        
        // non-sequential (jumps)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        XCTAssertEqual(mtcDec.direction, .ambiguous)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        XCTAssertEqual(mtcDec.direction, .ambiguous)
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    
    func testMTC_Decoder_Handlers_FullFrameMessage() {
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // testing vars
        
        var _timecode: Timecode?
        var _mType: MTCMessageType?
        var _direction: MTCDirection?
        var _displayNeedsUpdate: Bool?
        var _mtcFR: MTCFrameRate?
        
        let mtcDec = MTCDecoder() { timecode, messageType, direction, displayNeedsUpdate in
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
        
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        
        XCTAssertEqual(_timecode, Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: .fps24, by: .allowingInvalid))
        XCTAssertEqual(_mType, .fullFrame)
        XCTAssertEqual(_direction, .forwards)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        
        XCTAssertEqual(_timecode, Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid))
        XCTAssertEqual(_mType, .fullFrame)
        XCTAssertEqual(_direction, .forwards)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc25)
    }
    
    func testMTC_Decoder_Handlers_QFMessages() {
        // swiftformat:disable wrapSingleLineComments
        
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // testing vars
        
        var _timecode: Timecode?
        var _mType: MTCMessageType?
        var _direction: MTCDirection?
        var _displayNeedsUpdate: Bool?
        var _mtcFR: MTCFrameRate?
        
        let mtcDec = MTCDecoder() { timecode, messageType, direction, displayNeedsUpdate in
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
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 10), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        // reverse
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        // forwards
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .forwards)
        
        // reverse
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 7), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        XCTAssertEqual(
            _timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 7), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mtcFR, .mtc24)
        XCTAssertEqual(_direction, .backwards)
        
        // non-sequential (discontinuous jumps)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        XCTAssertEqual(_direction, .ambiguous)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        XCTAssertEqual(_direction, .ambiguous)
        
        // swiftformat:enable wrapSingleLineComments
    }
}

#endif
