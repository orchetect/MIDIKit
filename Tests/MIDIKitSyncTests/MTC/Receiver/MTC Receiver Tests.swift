//
//  MTC Receiver Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite struct MTC_Receiver_Receiver_Tests {
    @Test
    func mtcReceiver_Default() async {
        let mtcRec = MTCReceiver(name: "test")
        
        // check if defaults are nominal
        
        #expect(mtcRec.name == "test")
        #expect(mtcRec.state == .idle)
        #expect(mtcRec.timecode == Timecode(.zero, at: .fps30))
        #expect(mtcRec.localFrameRate == nil)
        // (skip syncPolicy, it has its own unit tests)
        
        // basic properties mutation
        
        // localFrameRate
        mtcRec.setLocalFrameRate(.fps29_97)
        #expect(mtcRec.localFrameRate == .fps29_97)
        #expect(mtcRec.decoder.localFrameRate == .fps29_97)
    }
    
    @Test
    func mtcReceiver_Init_Arguments() async {
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: .fps48,
            syncPolicy: .init(
                lockFrames: 20,
                dropOutFrames: 22
            )
        )
        
        // check if defaults are nominal
        
        #expect(mtcRec.name == "test")
        #expect(mtcRec.timecode == Timecode(.zero, at: .fps48))
        #expect(mtcRec.localFrameRate == .fps48)
        #expect(mtcRec.decoder.localFrameRate == .fps48)
        #expect(mtcRec.syncPolicy == .init(
            lockFrames: 20,
            dropOutFrames: 22
        ))
    }
    
    @Test
    func mtcReceiver_InternalState_NoLocalFrameRate_FullFrameMessage() async throws {
        // test full frame MTC messages and check that properties get updated
        
        // init with no local frame rate
        let mtcRec = MTCReceiver(name: "test")
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        try await Task.sleep(seconds: 0.050)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
        )
        
        // 00:00:00:00 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        try await Task.sleep(seconds: 0.050)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        try await Task.sleep(seconds: 0.050)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        )
    }
    
    @Test
    func mtcReceiver_InternalState_FullFrameMessage() async throws {
        // test full frame MTC messages and check that properties get updated
        
        // (Receiver.midiIn() is async internally so we need to wait for property
        // updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: .fps24)
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        try await Task.sleep(seconds: 0.050)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
        )
        
        // 00:00:00:00 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._00_00_00_00_at_24fps)
        try await Task.sleep(seconds: 0.050)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps24, by: .allowingInvalid)
        )
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        try await Task.sleep(seconds: 0.050)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        ) // local real rate still 24fps
        
        mtcRec.setLocalFrameRate(.fps25) // sync
        
        // 02:11:17:20 @ MTC 25fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps)
        try await Task.sleep(seconds: 0.050)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid)
        )
    }
    
    @Test
    func mtcReceiver_InternalState_FullFrameMessage_IncompatibleFrameRate() async throws {
        // test state does not become .incompatibleFrameRate when localFrameRate is present
        // but not compatible with the MTC frame rate being received by the receiver
        
        // (Receiver.midiIn() is async internally so we need to wait for property
        // updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: .fps29_97)
        
        // 01:02:03:04 @ MTC 24fps
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        try await Task.sleep(seconds: 0.050)
        
        // state should not change to .incompatibleFrameRate for full frame messages, only quarter
        // frames
        #expect(mtcRec.state == .idle)
        
        // timecode remains unchanged
        #expect(mtcRec.timecode.frameRate == .fps29_97)
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 0, m: 0, s: 0, f: 0), at: .fps29_97, by: .allowingInvalid)
        ) // default MTC-30fps
    }
    
    @Test(.enabled(if: isSystemTimingStable()))
    func mtcReceiver_InternalState_QFMessages_Typical_Deflake() async throws {
        var testRepeatCount = 0
        
        for _ in 1 ... 5 {
            testRepeatCount += 1
            if try await runMTC_Receiver_InternalState_QFMessages_Typical() {
                print("De-flake: Succeeded after \(testRepeatCount) attempts.")
                return
            }
        }
        
        Issue.record("De-flake: Failed after \(testRepeatCount) attempts.")
    }
}

extension MTC_Receiver_Receiver_Tests {
    func runMTC_Receiver_InternalState_QFMessages_Typical() async throws -> Bool {
        // swiftformat:disable wrap
        
        // test MTC quarter-frame messages and check that properties get updated
        
        // (Receiver.midiIn() is async internally so we need to wait for property
        // updates to occur before reading them)
        
        var isSuccess = false
        var asyncDoneExp = false
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: .fps24)
        
        #expect(mtcRec.state == .idle)
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        try await Task.sleep(seconds: 0.0103) // approx time between QFs @ 24fps
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        
        let waitTime: TimeInterval = 0.005
        try await Task.sleep(seconds: waitTime)
        
        #expect(
            mtcRec.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
        )
        
        let preSyncFrames = Timecode(
            .components(f: mtcRec.syncPolicy.lockFrames),
            at: .fps24,
            by: .wrapping
        )
        let prerollDuration = Int(preSyncFrames.realTimeValue * 1_000_000) // microseconds
        
        let now = DispatchTime.now() // same as DispatchTime(rawValue: mach_absolute_time())
        let durationUntilLock = DispatchTimeInterval.microseconds(prerollDuration)
        let futureTime = now + durationUntilLock
        
        let lockTimecode = Timecode(.components(h: 2, m: 3, s: 4, f: 8), at: .fps24, by: .allowingInvalid)
            .advanced(by: mtcRec.syncPolicy.lockFrames)
        
        guard case let .preSync(
            predictedLockTime: preSyncLockTime,
            lockTimecode: preSyncTimecode
        ) = mtcRec.state else {
            Issue.record("Expected preSync receiver state.")
            asyncDoneExp = true
            return false
        }
        
        #expect(preSyncTimecode == lockTimecode)
        
        // depending on the system running these tests, this test may be too
        // brittle/restrictive and the accuracy may need to be bumped up at some point in the
        // future
        
        let lhs = (Double(preSyncLockTime.rawValue) / 10e8) + waitTime
        let rhs = Double(futureTime.rawValue) / 10e8
        
        // XCTAssertEqual(lhs, rhs, accuracy: 0.005)
        isSuccess = (lhs - 0.01 ... lhs + 0.01).contains(rhs)
        
        asyncDoneExp = true
        
        #expect(asyncDoneExp)
        
        return isSuccess
        
        // swiftformat:enable wrap
    }
}

extension MTC_Receiver_Receiver_Tests {
    @Test(.enabled(if: isSystemTimingStable()))
    func mtcReceiver_Handlers_FullFrameMessage() async throws {
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // (Receiver.midiIn() is async internally so we need to wait for
        // property updates to occur before reading them)
        
        // testing vars
        
        @TestActor final class Receiver {
            var timecode: Timecode?
            func set(timecode: Timecode?) { self.timecode = timecode }
            
            var mType: MTCMessageType?
            func set(mType: MTCMessageType?) { self.mType = mType }
            
            var direction: MTCDirection?
            func set(direction: MTCDirection?) { self.direction = direction }
            
            var isFrameChanged: Bool?
            func set(isFrameChanged: Bool?) { self.isFrameChanged = isFrameChanged }
            
            var state: MTCReceiver.State?
            func set(state: MTCReceiver.State?) { self.state = state }
            
            nonisolated init() { }
        }
        let receiver = Receiver()
        
        // init with local frame rate
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: .fps24
        ) { timecode, messageType, direction, isFrameChanged in
            Task { @TestActor in
                receiver.set(timecode: timecode)
                receiver.set(mType: messageType)
                receiver.set(direction: direction)
                receiver.set(isFrameChanged: isFrameChanged)
            }
        } stateChanged: { state in
            Task { @TestActor in
                receiver.set(state: state)
            }
        }
        
        // default / initial state
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.mType == nil)
        #expect(await receiver.direction == nil)
        #expect(await receiver.isFrameChanged == nil)
        #expect(await receiver.state == nil)
        
        // full-frame MTC message
        
        mtcRec.midiIn(event: kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps)
        
        try await Task.sleep(seconds: 0.050)
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid))
        #expect(await receiver.mType == .fullFrame)
        #expect(await receiver.isFrameChanged == true)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        #expect(await receiver.state == nil)
    }
    
    // skip this test on other platforms; flaky and we don't need to run it
    #if os(macOS)
    @Test(.enabled(if: isSystemTimingStable()))
    func mtcReceiver_Handlers_QFMessages() async throws {
        // swiftformat:disable wrap
        // swiftformat:disable wrapSingleLineComments
        
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // note: the only reason why this works reliably in a test case is because the MTCReceiver allows receiving
        // quarter-frame messages as fast as possible. this may change in future or become more rigid depending on how the library evolves.
        
        // testing vars
        
        @TestActor final class Receiver {
            var timecode: Timecode?
            func set(timecode: Timecode?) { self.timecode = timecode }
            
            var mType: MTCMessageType?
            func set(mType: MTCMessageType?) { self.mType = mType }
            
            var direction: MTCDirection?
            func set(direction: MTCDirection?) { self.direction = direction }
            
            var isFrameChanged: Bool?
            func set(isFrameChanged: Bool?) { self.isFrameChanged = isFrameChanged }
            
            var state: MTCReceiver.State?
            func set(state: MTCReceiver.State?) { self.state = state }
            
            nonisolated init() { }
        }
        let receiver = Receiver()
        
        // init with local frame rate
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: .fps24
        ) { timecode, messageType, direction, isFrameChanged in
            Task { @TestActor in
                receiver.set(timecode: timecode)
                receiver.set(mType: messageType)
                receiver.set(direction: direction)
                receiver.set(isFrameChanged: isFrameChanged)
            }
        } stateChanged: { state in
            Task { @TestActor in
                receiver.set(state: state)
            }
        }
        
        // default / initial state
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.mType == nil)
        #expect(await receiver.direction == nil)
        #expect(await receiver.isFrameChanged == nil)
        #expect(await receiver.state == nil)
        
        // 24fps QFs starting at 02:03:04:04, locking at 02:03:04:06 + 2 MTC frame offset
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00000110)) // QF 0
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.timecode == nil)
        #expect(await receiver.direction == nil)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001000)) // QF 0
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // new TC
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == true)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00010000)) // QF 1
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 25), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == false)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00100100)) // QF 2
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 50), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == false)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 8, sf: 75), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == false)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01000011)) // QF 4
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // new TC
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == true)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 25), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == false)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01100010)) // QF 6
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 50), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == false)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 9, sf: 75), at: .fps24, by: .allowingInvalid)
        ) // unchanged
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == false)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 2, m: 3, s: 4, f: 10, sf: 00), at: .fps24, by: .allowingInvalid)
        ) // new TC
        #expect(await receiver.mType == .quarterFrame)
        #expect(await receiver.isFrameChanged == true)
        #expect(await receiver.timecode?.frameRate == .fps24)
        #expect(await receiver.direction == .forwards)
        
        // reverse
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01110000)) // QF 7
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.direction == .backwards)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00001010)) // QF 0
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.direction == .forwards)
        
        // non-sequential (jumps)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b00110000)) // QF 3
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.direction == .ambiguous)
        
        mtcRec.midiIn(event: .timecodeQuarterFrame(dataByte: 0b01010000)) // QF 5
        try await Task.sleep(seconds: 0.005) // approx 1/2 the time between QFs @ 24fps, to allow for test compute cycles
        
        #expect(await receiver.direction == .ambiguous)
        
        // swiftformat:enable wrap
        // swiftformat:enable wrapSingleLineComments
    }
    #endif
}
