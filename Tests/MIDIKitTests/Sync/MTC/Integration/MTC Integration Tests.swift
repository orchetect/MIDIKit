//
//  MTC Integration Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import OTCore
import TimecodeKit

final class MTC_Integration_Integration_Tests: XCTestCase {
    
    func testMTC_Integration_EncoderDecoder_24fps() {
        
        // decoder
        
        var _timecode: Timecode?            ; _ = _timecode
        var _mType: MIDI.MTC.MessageType?   ; _ = _mType
        var _direction: MIDI.MTC.Direction? ; _ = _direction
        var _displayNeedsUpdate: Bool?      ; _ = _displayNeedsUpdate
        var _mtcFR: MIDI.MTC.MTCFrameRate?  ; _ = _mtcFR
        
        let mtcDec = MIDI.MTC.Decoder(initialLocalFrameRate: nil)
        { timecode, messageType, direction, displayNeedsUpdate in
            _timecode = timecode
            _mType = messageType
            _direction = direction
            _displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            _mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MIDI.MTC.Encoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
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
        
        var _timecode: Timecode?            ; _ = _timecode
        var _mType: MIDI.MTC.MessageType?   ; _ = _mType
        var _direction: MIDI.MTC.Direction? ; _ = _direction
        var _displayNeedsUpdate: Bool?      ; _ = _displayNeedsUpdate
        var _mtcFR: MIDI.MTC.MTCFrameRate?  ; _ = _mtcFR
        
        let mtcDec = MIDI.MTC.Decoder(initialLocalFrameRate: nil)
        { timecode, messageType, direction, displayNeedsUpdate in
            _timecode = timecode
            _mType = messageType
            _direction = direction
            _displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            _mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MIDI.MTC.Encoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
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
    
    func testMTC_Integration_EncoderDecoder_48fps() {
        
        // decoder
        
        var _timecode: Timecode?            ; _ = _timecode
        var _mType: MIDI.MTC.MessageType?   ; _ = _mType
        var _direction: MIDI.MTC.Direction? ; _ = _direction
        var _displayNeedsUpdate: Bool?      ; _ = _displayNeedsUpdate
        var _mtcFR: MIDI.MTC.MTCFrameRate?  ; _ = _mtcFR
        
        let mtcDec = MIDI.MTC.Decoder(initialLocalFrameRate: nil)
        { timecode, messageType, direction, displayNeedsUpdate in
            _timecode = timecode
            _mType = messageType
            _direction = direction
            _displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            _mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MIDI.MTC.Encoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        mtcDec.localFrameRate = ._48
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._48)!)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._48)!)
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
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 04).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 1
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 04).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 2
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 05).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 3
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 05).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 4
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 06).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 5
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 06).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 6
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 07).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 7
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 07).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 0
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 08).toTimecode(at: ._48)!)
        (19 * 4).repeatEach { mtcEnc.increment() } // advance 19 frames (4 QF per frame)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 4)
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 46).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 5
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 46).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 6
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 47).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 7
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 47).toTimecode(at: ._48)!)
        mtcEnc.increment() // QF 0
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 01, f: 00).toTimecode(at: ._48)!)
        XCTAssertEqual(_direction, .forwards)
        mtcEnc.decrement() // QF 7
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 47).toTimecode(at: ._48)!)
        XCTAssertEqual(_direction, .backwards)
        mtcEnc.decrement() // QF 6
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 47).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 5
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 46).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 4
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 46).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 3
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 45).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 2
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 45).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 1
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 44).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 0
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 44).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 7
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 43).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 6
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 43).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 5
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 42).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 4
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 42).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 3
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 41).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 2
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 41).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 1
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 40).toTimecode(at: ._48)!)
        mtcEnc.decrement() // QF 0
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 40).toTimecode(at: ._48)!)
        
    }
    
    func testMTC_Integration_EncoderDecoder_fullFrameBehavior() {
        
        // test expected outcomes regarding Encoder.locate() and transmitting MTC full-frame messages
        
        // decoder
        
        var _timecode: Timecode?            ; _ = _timecode
        var _mType: MIDI.MTC.MessageType?   ; _ = _mType
        var _direction: MIDI.MTC.Direction? ; _ = _direction
        var _displayNeedsUpdate: Bool?      ; _ = _displayNeedsUpdate
        var _mtcFR: MIDI.MTC.MTCFrameRate?  ; _ = _mtcFR
        
        let mtcDec = MIDI.MTC.Decoder(initialLocalFrameRate: nil)
        { timecode, messageType, direction, displayNeedsUpdate in
            _timecode = timecode
            _mType = messageType
            _direction = direction
            _displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            _mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MIDI.MTC.Encoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test -- basic behavior
        
        mtcDec.localFrameRate = ._24
        
        // locate
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, true)
        
        _displayNeedsUpdate = nil
        
        // locate to same position
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, nil)
        
        // locate to same position, but force a full-frame message to transmit
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!,
                      transmitFullFrame: .always)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, false)
        
        // locate to new timecode
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._24)!,
                      transmitFullFrame: .always)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._24)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, true)
        
        // locate to same timecode, but change frame rate
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._25)!,
                      transmitFullFrame: .always)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._25)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, false)
        
        _displayNeedsUpdate = nil
        
        // locate to new timecode, but request full-frame not be transmit
        
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 04).toTimecode(at: ._25)!,
                      transmitFullFrame: .never)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 02).toTimecode(at: ._25)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, nil)
        
        // edge cases
        
        // quarter-frame invalidation of last full-frame cache
        // edge case: where the Encoder has locateBehavior == .ifDifferent, if the encoder produces quarter-frame messages it should clear its cache of last full-frame message produced so that in the rare case that we locate to the same full-frame message as the last full-frame message sent it succeeds instead of errantly preventing the message
        
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!,
                      transmitFullFrame: .always)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, true)
        
        XCTAssertEqual(_mType, .fullFrame)
        
        mtcEnc.increment() // QF 0
        mtcEnc.increment() // QF 1
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 1)
        XCTAssertNil(mtcEnc.lastTransmitFullFrame) // brittle but only way to test this
        
        // locate to same timecode; full-frame should transmit
        mtcEnc.locate(to: TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 00, s: 00, f: 00).toTimecode(at: ._24)!)
        XCTAssertEqual(mtcEnc.mtcQuarterFrame, 0)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_mType, .fullFrame)
        
    }
    
    func testBruteForce() {
        
        // decoder
        
        var _timecode: Timecode?            ; _ = _timecode
        var _mType: MIDI.MTC.MessageType?   ; _ = _mType
        var _direction: MIDI.MTC.Direction? ; _ = _direction
        var _displayNeedsUpdate: Bool?      ; _ = _displayNeedsUpdate
        var _mtcFR: MIDI.MTC.MTCFrameRate?  ; _ = _mtcFR
        
        let mtcDec = MIDI.MTC.Decoder(initialLocalFrameRate: nil)
        { timecode, messageType, direction, displayNeedsUpdate in
            _timecode = timecode
            _mType = messageType
            _direction = direction
            _displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            _mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MIDI.MTC.Encoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
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
