//
//  MTC Receiver Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import TimecodeKitCore
import XCTest
import XCTestUtils

final class MTC_Receiver_Receiver_Tests: XCTestCase {
    func testMTC_Receiver_Default() async {
        let mtcRec = MTCReceiver(name: "test")
        
        // check if defaults are nominal
        
        await _XCTAssertEqual(await mtcRec.name, "test")
        await _XCTAssertEqual(await mtcRec.state, .idle)
        await _XCTAssertEqual(await mtcRec.timecode, Timecode(.zero, at: .fps30))
        await _XCTAssertEqual(await mtcRec.localFrameRate, nil)
        // (skip syncPolicy, it has its own unit tests)
        
        // basic properties mutation
        
        // localFrameRate
        await mtcRec.setLocalFrameRate(.fps29_97)
        await _XCTAssertEqual(await mtcRec.localFrameRate, .fps29_97)
        await _XCTAssertEqual(await mtcRec.decoder.localFrameRate, .fps29_97)
    }
    
    func testMTC_Receiver_Init_Arguments() async {
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: .fps48,
            syncPolicy: .init(
                lockFrames: 20,
                dropOutFrames: 22
            )
        )
        
        // check if defaults are nominal
        
        await _XCTAssertEqual(await mtcRec.name, "test")
        await _XCTAssertEqual(await mtcRec.timecode, Timecode(.zero, at: .fps48))
        await _XCTAssertEqual(await mtcRec.localFrameRate, .fps48)
        await _XCTAssertEqual(await mtcRec.decoder.localFrameRate, .fps48)
        await _XCTAssertEqual(await mtcRec.syncPolicy, .init(
            lockFrames: 20,
            dropOutFrames: 22
        ))
    }
    
    func testMTC_Receiver_InternalState_NoLocalFrameRate_FullFrameMessage() async {
        // test full frame MTC messages and check that properties get updated
        
        // init with no local frame rate
        let mtcRec = MTCReceiver(name: "test")
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        wait(sec: 0.050)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
        )
        
        // 00:00:00:00 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        wait(sec: 0.050)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        wait(sec: 0.050)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        )
    }
    
    func testMTC_Receiver_InternalState_FullFrameMessage() async {
        // test full frame MTC messages and check that properties get updated
        
        // (Receiver.midiIn() is async internally so we need to wait for property
        // updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: .fps24)
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        wait(sec: 0.050)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
        )
        
        // 00:00:00:00 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        wait(sec: 0.050)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        wait(sec: 0.050)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        ) // local real rate still 24fps
        
        await mtcRec.setLocalFrameRate(.fps25) // sync
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        wait(sec: 0.050)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        )
    }
    
    func testMTC_Receiver_InternalState_FullFrameMessage_IncompatibleFrameRate() async {
        // test state does not become .incompatibleFrameRate when localFrameRate is present
        // but not compatible with the MTC frame rate being received by the receiver
        
        // (Receiver.midiIn() is async internally so we need to wait for property
        // updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: .fps29_97)
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        wait(sec: 0.050)
        
        // state should not change to .incompatibleFrameRate for full frame messages, only quarter
        // frames
        await _XCTAssertEqual(await mtcRec.state, .idle)
        
        // timecode remains unchanged
        await _XCTAssertEqual(await mtcRec.timecode.frameRate, .fps29_97)
        await _XCTAssertEqual(
            await mtcRec.timecode,
            Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps29_97, by: .allowingInvalid)
        ) // default MTC-30fps
    }
    
    func testMTC_Receiver_InternalState_QFMessages_Typical_Deflake() {
        var testRepeatCount = 0
        
        for _ in 1 ... 5 {
            testRepeatCount += 1
            if runMTC_Receiver_InternalState_QFMessages_Typical() {
                print("De-flake: Succeeded after \(testRepeatCount) attempts.")
                return
            }
        }
        
        XCTFail("De-flake: Failed after \(testRepeatCount) attempts.")
    }
    
    func runMTC_Receiver_InternalState_QFMessages_Typical() -> Bool {
        // swiftformat:disable wrap
        
        // test MTC quarter-frame messages and check that properties get updated
        
        // (Receiver.midiIn() is async internally so we need to wait for property
        // updates to occur before reading them)
        
        var isSuccess = false
        let asyncDoneExp = expectation(description: "Async test completed")
        
        // elevate thread priority for latency-sensitive tests
        Task { [self] in
            // init with local frame rate
            let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: .fps24)
        
            await _XCTAssertEqual(await mtcRec.state, .idle)
        
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
        
            await _XCTAssertEqual(
                await mtcRec.timecode,
                Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
            )
        
            let preSyncFrames = Timecode(
                .components(f: await mtcRec.syncPolicy.lockFrames),
                at: .fps24,
                by: .wrapping
            )
            let prerollDuration = Int(preSyncFrames.realTimeValue * 1_000_000) // microseconds
        
            let now = DispatchTime.now() // same as DispatchTime(rawValue: mach_absolute_time())
            let durationUntilLock = DispatchTimeInterval.microseconds(prerollDuration)
            let futureTime = now + durationUntilLock
        
            let lockTimecode = Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
                .advanced(by: await mtcRec.syncPolicy.lockFrames)
        
            guard case let .preSync(
                predictedLockTime: preSyncLockTime,
                lockTimecode: preSyncTimecode
            ) = await mtcRec.state else {
                XCTFail("Expected preSync receiver state.")
                asyncDoneExp.fulfill()
                return
            }
        
            XCTAssertEqual(preSyncTimecode, lockTimecode)
            
            // depending on the system running these tests, this test may be too
            // brittle/restrictive and the accuracy may need to be bumped up at some point in the
            // future
        
            let lhs = (Double(preSyncLockTime.rawValue) / 10e8) + waitTime
            let rhs = Double(futureTime.rawValue) / 10e8
            
            // XCTAssertEqual(lhs, rhs, accuracy: 0.005)
            isSuccess = (lhs - 0.01 ... lhs + 0.01).contains(rhs)
            
            asyncDoneExp.fulfill()
        }
        
        wait(for: [asyncDoneExp], timeout: 10.0)
        
        return isSuccess
        
        // swiftformat:enable wrap
    }
    
    @MainActor
    func testMTC_Receiver_Handlers_FullFrameMessage() {
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // (Receiver.midiIn() is async internally so we need to wait for
        // property updates to occur before reading them)
        
        // testing vars
        
        final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var displayNeedsUpdate: Bool?
            var state: MTCReceiver.State?
        }
        let receiver = Receiver()
        
        // init with local frame rate
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: .fps24
        ) { timecode, messageType, direction, displayNeedsUpdate in
            receiver.timecode = timecode
            receiver.mType = messageType
            receiver.direction = direction
            receiver.displayNeedsUpdate = displayNeedsUpdate
        } stateChanged: { state in
            receiver.state = state
        }
        
        // default / initial state
        
        XCTAssertNil(receiver.timecode)
        XCTAssertNil(receiver.mType)
        XCTAssertNil(receiver.direction)
        XCTAssertNil(receiver.displayNeedsUpdate)
        XCTAssertNil(receiver.state)
        
        // full-frame MTC message
        
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        
        wait(sec: 0.050)
        
        XCTAssertEqual(receiver.timecode, Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid))
        XCTAssertEqual(receiver.mType, .fullFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, true)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        XCTAssertEqual(receiver.state, nil)
    }
    
    // skip this test on other platforms; flaky and we don't need to run it
    #if os(macOS)
    func testMTC_Receiver_Handlers_QFMessages() {
        // swiftformat:disable wrap
        // swiftformat:disable wrapSingleLineComments
        
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // note: the only reason why this works reliably in a test case is because the MTCReceiver allows receiving quarter-frame messages as fast as possible. this may change in future or become more rigid depending on how the library evolves.
        
        // testing vars
        
        final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var displayNeedsUpdate: Bool?
            var state: MTCReceiver.State?
        }
        let receiver = Receiver()
        
        // init with local frame rate
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: .fps24
        ) { timecode, messageType, direction, displayNeedsUpdate in
            receiver.timecode = timecode
            receiver.mType = messageType
            receiver.direction = direction
            receiver.displayNeedsUpdate = displayNeedsUpdate
        } stateChanged: { state in
            receiver.state = state
        }
        
        // default / initial state
        
        XCTAssertNil(receiver.timecode)
        XCTAssertNil(receiver.mType)
        XCTAssertNil(receiver.direction)
        XCTAssertNil(receiver.displayNeedsUpdate)
        XCTAssertNil(receiver.state)
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.timecode, nil)
        XCTAssertEqual(receiver.direction, nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, true)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, false)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, false)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, false)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, true)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, false)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, false)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 9), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, false)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(
            receiver.timecode,
            Timecode(.components(h: 2, m: 3, s: 4, f: 10), at: .fps24, by: .allowingInvalid)
        ) // new TC
        XCTAssertEqual(receiver.mType, .quarterFrame)
        XCTAssertEqual(receiver.displayNeedsUpdate, true)
        XCTAssertEqual(receiver.timecode?.frameRate, .fps24)
        XCTAssertEqual(receiver.direction, .forwards)
        
        // reverse
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.direction, .backwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.direction, .forwards)
        
        // non-sequential (jumps)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.direction, .ambiguous)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        wait(sec: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        XCTAssertEqual(receiver.direction, .ambiguous)
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    #endif
}
