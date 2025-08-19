//
//  MTC Decoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite struct MTC_Receiver_Decoder_Tests {
    // swiftformat:options --maxwidth none
    
    @Test
    func mtcDecoder_Default() {
        let mtcDec = MTCDecoder()
        
        // check if defaults are nominal
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps30, by: .allowingInvalid)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        #expect(mtcDec.localFrameRate == nil)
        #expect(mtcDec.direction == .forwards)
        
        // basic properties mutation
        
        // localFrameRate
        mtcDec.localFrameRate = .fps29_97
        #expect(mtcDec.localFrameRate == .fps29_97)
    }
    
    @Test
    func mtcDecoder_Init_Arguments() {
        let mtcDec = MTCDecoder(initialLocalFrameRate: .fps29_97)
        
        #expect(mtcDec.localFrameRate == .fps29_97)
    }
    
    @Test
    func mtcDecoder_InternalState_FullFrameMessage() {
        // test full frame MTC messages and check that properties get updated
        
        let mtcDec = MTCDecoder()
        
        // 01:02:03:04 @ MTC 24fps
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
        )
        #expect(mtcDec.mtcFrameRate == .mtc24)
        #expect(mtcDec.direction == .forwards)
        
        // 00:00:00:00 @ MTC 24fps
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        #expect(mtcDec.mtcFrameRate == .mtc24)
        #expect(mtcDec.direction == .forwards)
        
        // 02:11:17:20 @ MTC 25fps
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        )
        #expect(mtcDec.mtcFrameRate == .mtc25)
        #expect(mtcDec.direction == .forwards)
    }
    
    @Test
    func mtcDecoder_InternalState_QFMessages_Typical() {
        // test MTC quarter-frame messages and check that properties get updated
        
        let mtcDec = MTCDecoder()
        #expect(mtcDec.localFrameRate == nil) // sanity check
        #expect(mtcDec.mtcFrameRate == .mtc30) // sanity check: MTCDecoder defaults to 30fps
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        
        #expect(mtcDec.qfBufferComplete() == false)
        #expect(mtcDec.mtcFrameRate == .mtc30) // still default
        #expect(mtcDec.timecode.frameRate == .fps30) // still default
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        #expect(mtcDec.qfBufferComplete() == false)
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        #expect(mtcDec.qfBufferComplete() == false)
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        #expect(mtcDec.qfBufferComplete() == false)
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        #expect(mtcDec.qfBufferComplete() == false)
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        #expect(mtcDec.qfBufferComplete() == false)
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(mtcDec.qfBufferComplete() == false)
        #expect(mtcDec.timecode.frameRate == .fps30) // still default
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc30)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        #expect(mtcDec.qfBufferComplete() == true)
        #expect(mtcDec.mtcFrameRate == .mtc24) // finally received fps info
        #expect(mtcDec.timecode.frameRate == .fps30) // TODO: this should probably be fps24
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 0, m: 0, s: 0, f: 0)
        )
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        #expect(mtcDec.qfBufferComplete() == true)
        #expect(mtcDec.mtcFrameRate == .mtc24)
        #expect(mtcDec.timecode.frameRate == .fps24)
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 8, sf: 00)
        ) // new TC
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 8, sf: 25)
        ) // unchanged
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 8, sf: 50)
        ) // unchanged
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 8, sf: 75)
        ) // unchanged
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 9, sf: 00)
        ) // new TC
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 9, sf: 25)
        ) // unchanged
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 9, sf: 50)
        ) // unchanged
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 9, sf: 75)
        ) // unchanged
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        
        #expect(
            mtcDec.timecode.components ==
                Timecode.Components(h: 2, m: 3, s: 4, f: 10, sf: 00)
        ) // new TC
        #expect(mtcDec.mtcFrameRate == .mtc24)
    }
    
    @Test
    func mtcDecoder_InternalState_QFMessages_Scaled_24to48() {
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
        
        #expect(mtcDec.qfBufferComplete() == true)
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 16, sf: 00), at: .fps48, by: .allowingInvalid)
        ) // new TC
        #expect(mtcDec.mtcFrameRate == .mtc24)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 16, sf: 50), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 17, sf: 00), at: .fps48, by: .allowingInvalid)
        ) // new TC
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 17, sf: 50), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 18, sf: 00), at: .fps48, by: .allowingInvalid)
        ) // new TC
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 18, sf: 50), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 19, sf: 00), at: .fps48, by: .allowingInvalid)
        ) // new TC
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 19, sf: 50), at: .fps48, by: .allowingInvalid)
        ) // unchanged
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010))
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 20, sf: 00), at: .fps48, by: .allowingInvalid)
        ) // new TC
    }
    
    @Test
    func mtcDecoder_InternalState_QFMessages_25FPS() {
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
        
        #expect(
            mtcDec.timecode ==
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
        
        #expect(
            mtcDec.timecode ==
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
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 00, f: 24), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 00), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000001)) // QF 0 MTC 01:00:00:24 - sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 01), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 02), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000011)) // QF 0 MTC 01:00:01:01
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 03), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 04), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000101)) // QF 0 MTC 01:00:01:03 - sync qf
        
        #expect(
            mtcDec.timecode ==
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
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 00, f: 23), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 00, f: 24), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000000)) // QF 0 MTC 01:00:00:23 - sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 00), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 01), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:01:00
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 02), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100001)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 03), at: .fps25, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110010)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000100)) // QF 0 MTC 01:00:01:02 - sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 01, f: 04), at: .fps25, by: .allowingInvalid)
        )
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    
    @Test
    func mtcDecoder_InternalState_QFMessages_2997DropFPS() {
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
        
        #expect(
            mtcDec.timecode ==
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
        
        #expect(
            mtcDec.timecode ==
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
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00101011)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:59;28 - sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000001)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 03), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000100)) // QF 0 MTC 01:01:00;02
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 04), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100000)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000001)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 05), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0 MTC 01:01:00;04 - sync qf
        
        #expect(
            mtcDec.timecode ==
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
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010001)) // QF 1
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00101011)) // QF 2
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4 // sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 MTC 01:00:59;28 - sync qf
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02, sf: 25), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec
            .midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000010)) // QF 0 ** reverse direction **
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110100)) // QF 7
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100001)) // QF 6
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000000)) // QF 4
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110011)) // QF 3
        
        #expect(
            mtcDec.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    
    @Test
    func mtcDecoder_InternalState_QFMessages_Direction() {
        // swiftformat:disable wrap
        // swiftformat:disable wrapSingleLineComments
        
        let mtcDec = MTCDecoder()
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
        
        // sequential, forwards and backwards
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        #expect(mtcDec.direction == .ambiguous)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        #expect(mtcDec.direction == .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        #expect(mtcDec.direction == .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        #expect(mtcDec.direction == .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        #expect(mtcDec.direction == .backwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        #expect(mtcDec.direction == .forwards)
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        #expect(mtcDec.direction == .forwards)
        
        // non-sequential (jumps)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        #expect(mtcDec.direction == .ambiguous)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        #expect(mtcDec.direction == .ambiguous)
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    
    @Test @MainActor // using main actor just for simplicity, otherwise we need to do a bunch of async waiting
    func mtcDecoder_Handlers_FullFrameMessage() {
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // testing vars
        
        @MainActor final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var isFrameChanged: Bool?
            var mtcFR: MTCFrameRate?
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder() { timecode, messageType, direction, isFrameChanged in
            // MTCEncoder does not use Task or internal dispatch queues
            MainActor.assumeIsolated {
                receiver.timecode = timecode
                receiver.mType = messageType
                receiver.direction = direction
                receiver.isFrameChanged = isFrameChanged
            }
        } mtcFrameRateChanged: { mtcFrameRate in
            // MTCEncoder does not use Task or internal dispatch queues
            MainActor.assumeIsolated {
                receiver.mtcFR = mtcFrameRate
            }
        }
        
        // default / initial state
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mType == nil)
        #expect(receiver.direction == nil)
        #expect(receiver.isFrameChanged == nil)
        #expect(receiver.mtcFR == nil)
        
        // full-frame MTC messages
        
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: .fps24, by: .allowingInvalid))
        #expect(receiver.mType == .fullFrame)
        #expect(receiver.direction == .forwards)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        
        mtcDec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        
        #expect(receiver.timecode == Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid))
        #expect(receiver.mType == .fullFrame)
        #expect(receiver.direction == .forwards)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc25)
    }
    
    @Test @MainActor // using main actor just for simplicity, otherwise we need to do a bunch of async waiting
    func mtcDecoder_Handlers_QFMessages() {
        // swiftformat:disable wrapSingleLineComments
        
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // testing vars
        
        @MainActor final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var isFrameChanged: Bool?
            var mtcFR: MTCFrameRate?
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder() { timecode, messageType, direction, isFrameChanged in
            // MTCEncoder does not use Task or internal dispatch queues
            MainActor.assumeIsolated {
                receiver.timecode = timecode
                receiver.mType = messageType
                receiver.direction = direction
                receiver.isFrameChanged = isFrameChanged
            }
        } mtcFrameRateChanged: { mtcFrameRate in
            // MTCEncoder does not use Task or internal dispatch queues
            MainActor.assumeIsolated {
                receiver.mtcFR = mtcFrameRate
            }
        }
        
        // default / initial state
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mType == nil)
        #expect(receiver.direction == nil)
        #expect(receiver.isFrameChanged == nil)
        #expect(receiver.mtcFR == nil)
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 (+ 2 MTC frame offset)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == nil)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == nil)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == nil)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == nil)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == nil)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == nil)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == nil)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        #expect(receiver.timecode == nil)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == nil)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // new TC frame
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 25), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 75), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // new TC frame
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 25), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 75), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 10, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // new TC frame
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        // reverse
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 75), at: .fps24, by: .allowingInvalid)
        ) // new TC frame
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 25), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 00), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 75), at: .fps24, by: .allowingInvalid)
        ) // new TC frame
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 25), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        // forwards
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 75), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // new TC frame
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 25), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 75), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .forwards)
        
        // reverse
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 25), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 00), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 75), at: .fps24, by: .allowingInvalid)
        ) // new TC frame
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 50), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 25), at: .fps24, by: .allowingInvalid)
        )
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 7, sf: 75), at: .fps24, by: .allowingInvalid)
        ) // new TC
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == true)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 7, sf: 50), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(receiver.mType == .quarterFrame)
        #expect(receiver.isFrameChanged == false)
        #expect(receiver.mtcFR == .mtc24)
        #expect(receiver.direction == .backwards)
        
        // non-sequential (discontinuous jumps)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        #expect(receiver.direction == .ambiguous)
        
        mtcDec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        #expect(receiver.direction == .ambiguous)
        
        // swiftformat:enable wrapSingleLineComments
    }
}
