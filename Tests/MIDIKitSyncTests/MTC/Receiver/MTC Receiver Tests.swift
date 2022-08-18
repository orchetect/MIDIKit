//
//  MTC Receiver Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import XCTestUtils
@testable import MIDIKitSync
import TimecodeKit

final class MTC_Receiver_Receiver_Tests: XCTestCase {
    func testMTC_Receiver_Default() {
        let mtcRec = MTCReceiver(name: "test")
        
        // check if defaults are nominal
        
        XCTAssertEqual(mtcRec.name, "test")
        XCTAssertEqual(mtcRec.state, .idle)
        XCTAssertEqual(mtcRec.timecode, Timecode(at: ._30))
        XCTAssertEqual(mtcRec.localFrameRate, nil)
        // (skip syncPolicy, it has its own unit tests)
        
        // basic properties mutation
        
        // localFrameRate
        mtcRec.localFrameRate = ._29_97
        XCTAssertEqual(mtcRec.localFrameRate, ._29_97)
        XCTAssertEqual(mtcRec.decoder.localFrameRate, ._29_97)
    }
    
    func testMTC_Receiver_Init_Arguments() {
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: ._48,
            syncPolicy: .init(
                lockFrames: 20,
                dropOutFrames: 22
            )
        )
        
        // check if defaults are nominal
        
        XCTAssertEqual(mtcRec.name, "test")
        XCTAssertEqual(mtcRec.timecode, Timecode(at: ._48))
        XCTAssertEqual(mtcRec.localFrameRate, ._48)
        XCTAssertEqual(mtcRec.decoder.localFrameRate, ._48)
        XCTAssertEqual(mtcRec.syncPolicy, .init(
            lockFrames: 20,
            dropOutFrames: 22
        ))
    }
    
    func testMTC_Receiver_InternalState_NoLocalFrameRate_FullFrameMessage() {
        // test full frame MTC messages and check that properties get updated
        
        // init with no local frame rate
        let mtcRec = MTCReceiver(name: "test")
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        wait(sec: 0.050)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._24)
        )
        
        // 00:00:00:00 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        wait(sec: 0.050)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(rawValuesAt: ._24)
        )
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        wait(sec: 0.050)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 2, m: 11, s: 17, f: 20).toTimecode(rawValuesAt: ._25)
        )
    }
    
    func testMTC_Receiver_InternalState_FullFrameMessage() {
        // test full frame MTC messages and check that properties get updated
        
        // (Receiver.midiIn() is async internally so we need to wait for property updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: ._24)
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        wait(sec: 0.050)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._24)
        )
        
        // 00:00:00:00 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        wait(sec: 0.050)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 0, m: 0, s: 0, f: 0).toTimecode(rawValuesAt: ._24)
        )
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        wait(sec: 0.050)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 2, m: 11, s: 17, f: 20)
                .toTimecode(rawValuesAt: ._25)
        ) // local real rate still 24fps
        
        mtcRec.localFrameRate = ._25 // sync
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        wait(sec: 0.050)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 2, m: 11, s: 17, f: 20).toTimecode(rawValuesAt: ._25)
        )
    }
    
    func testMTC_Receiver_InternalState_FullFrameMessage_IncompatibleFrameRate() {
        // test state does not become .incompatibleFrameRate when localFrameRate is present but not compatible with the MTC frame rate being received by the receiver
        
        // (Receiver.midiIn() is async internally so we need to wait for property updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: ._29_97)
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        wait(sec: 0.050)
        
        // state should not change to .incompatibleFrameRate for full frame messages, only quarter frames
        XCTAssertEqual(mtcRec.state, .idle)
        
        // timecode remains unchanged
        XCTAssertEqual(mtcRec.timecode.frameRate, ._29_97)
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 0, m: 0, s: 0, f: 0)
                .toTimecode(rawValuesAt: ._29_97)
        ) // default MTC-30fps
    }
    
    func testMTC_Receiver_InternalState_QFMessages_Typical() {
        // swiftformat:disable wrap
        
        // test MTC quarter-frame messages and check that properties get updated
        
        // (Receiver.midiIn() is async internally so we need to wait for property updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: ._24)
        
        XCTAssertEqual(mtcRec.state, .idle)
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        wait(sec: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        let waitTime = 0.005
        wait(sec: waitTime)
        
        XCTAssertEqual(
            mtcRec.timecode,
            TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(rawValuesAt: ._24)
        )
        
        let preSyncFrames = Timecode(
            wrapping: TCC(f: mtcRec.syncPolicy.lockFrames),
            at: ._24
        )
        let prerollDuration = Int(preSyncFrames.realTimeValue * 1_000_000) // microseconds
        
        let now = DispatchTime.now() // same as DispatchTime(rawValue: mach_absolute_time())
        let durationUntilLock = DispatchTimeInterval.microseconds(prerollDuration)
        let futureTime = now + durationUntilLock
        
        let lockTimecode = TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(rawValuesAt: ._24)
            .advanced(by: mtcRec.syncPolicy.lockFrames)
        
        guard case let .preSync(
            predictedLockTime: preSyncLockTime,
            lockTimecode: preSyncTimecode
        ) = mtcRec.state else {
            XCTFail("Expected receiver state is preSync, but is a different state.")
            return
        }
        
        // depending on the system running these tests, this test may be too brittle/restrictive and the accuracy may need to be bumped up at some point in the future
        
        XCTAssertEqual(
            (Double(preSyncLockTime.rawValue) / 10e8) + waitTime,
            Double(futureTime.rawValue) / 10e8,
            accuracy: 0.005
        )
        
        XCTAssertEqual(preSyncTimecode, lockTimecode)
        
        // swiftformat:enable wrap
    }
    
    func testMTC_Receiver_Handlers_FullFrameMessage() {
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // (Receiver.midiIn() is async internally so we need to wait for property updates to occur before reading them)
        
        // testing vars
        
        var _timecode: Timecode?
        var _mType: MTCMessageType?
        var _direction: MTCDirection?
        var _displayNeedsUpdate: Bool?
        var _state: MTCReceiver.State?
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: ._24)
            { timecode, messageType, direction, displayNeedsUpdate in
                _timecode = timecode
                _mType = messageType
                _direction = direction
                _displayNeedsUpdate = displayNeedsUpdate
            } stateChanged: { state in
                _state = state
            }
        
        // default / initial state
        
        XCTAssertNil(_timecode)
        XCTAssertNil(_mType)
        XCTAssertNil(_direction)
        XCTAssertNil(_displayNeedsUpdate)
        XCTAssertNil(_state)
        
        // full-frame MTC message
        
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        
        wait(sec: 0.050)
        
        XCTAssertEqual(_timecode, TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._24))
        XCTAssertEqual(_mType, .fullFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        XCTAssertEqual(_state, nil)
    }
    
    func testMTC_Receiver_Handlers_QFMessages() {
        // swiftformat:disable wrap
        
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // note: the only reason why this works reliably in a test case is because the MTCReceiver allows receiving quarter-frame messages as fast as possible. this may change in future or become more rigid depending on how the library evolves.
        
        // testing vars
        
        var _timecode: Timecode?
        var _mType: MTCMessageType?
        var _direction: MTCDirection?
        var _displayNeedsUpdate: Bool?
        var _state: MTCReceiver.State?
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: ._24)
            { timecode, messageType, direction, displayNeedsUpdate in
                _timecode = timecode
                _mType = messageType
                _direction = direction
                _displayNeedsUpdate = displayNeedsUpdate
            } stateChanged: { state in
                _state = state
            }
        
        // default / initial state
        
        XCTAssertNil(_timecode)
        XCTAssertNil(_mType)
        XCTAssertNil(_direction)
        XCTAssertNil(_displayNeedsUpdate)
        XCTAssertNil(_state)
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_timecode, nil)
        XCTAssertEqual(_direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(rawValuesAt: ._24)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(rawValuesAt: ._24)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(rawValuesAt: ._24)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 8).toTimecode(rawValuesAt: ._24)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(rawValuesAt: ._24)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(rawValuesAt: ._24)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(rawValuesAt: ._24)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 9).toTimecode(rawValuesAt: ._24)
        ) // unchanged
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, false)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            _timecode,
            TCC(h: 2, m: 3, s: 4, f: 10).toTimecode(rawValuesAt: ._24)
        ) // new TC
        XCTAssertEqual(_mType, .quarterFrame)
        XCTAssertEqual(_displayNeedsUpdate, true)
        XCTAssertEqual(_timecode?.frameRate, ._24)
        XCTAssertEqual(_direction, .forwards)
        
        // reverse
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_direction, .backwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_direction, .forwards)
        
        // non-sequential (jumps)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_direction, .ambiguous)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(_direction, .ambiguous)
        
        // swiftformat:enable wrap
    }
}

#endif
