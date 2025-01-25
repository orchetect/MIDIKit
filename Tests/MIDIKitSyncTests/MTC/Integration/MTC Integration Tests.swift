//
//  MTC Integration Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite struct MTC_Integration_Integration_Tests {
    @Test @MainActor
    func mtcIntegration_EncoderDecoder_24fps() {
        // decoder
        
        final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var displayNeedsUpdate: Bool?
            var mtcFR: MTCFrameRate?
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { timecode, messageType, direction, displayNeedsUpdate in
            receiver.timecode = timecode
            receiver.mType = messageType
            receiver.direction = direction
            receiver.displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            receiver.mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        mtcDec.localFrameRate = .fps24
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        mtcEnc.increment() // QF 0
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 03), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 04), at: .fps24, by: .allowingInvalid))
        for _ in 1 ... (19 * 4) {
            mtcEnc.increment()
        } // advance 19 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 01, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(receiver.direction == .forwards)
        mtcEnc.decrement() // QF 7
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23), at: .fps24, by: .allowingInvalid))
        #expect(receiver.direction == .backwards)
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 22), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 22), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 7
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 21), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 21), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 20), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 20), at: .fps24, by: .allowingInvalid))
    }
    
    @Test @MainActor
    func mtcIntegration_EncoderDecoder_29_97drop() {
        // decoder
        
        final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var displayNeedsUpdate: Bool?
            var mtcFR: MTCFrameRate?
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { timecode, messageType, direction, displayNeedsUpdate in
            receiver.timecode = timecode
            receiver.mType = messageType
            receiver.direction = direction
            receiver.displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            receiver.mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        mtcDec.localFrameRate = .fps29_97d
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 59, f: 00), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(mtcEnc.mtcQuarterFrame == 0)
        mtcEnc.increment() // QF 0
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 03), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 04), at: .fps29_97d, by: .allowingInvalid)
        )
        for _ in 1 ... (25 * 4) {
            mtcEnc.increment()
        } // advance 25 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(receiver.direction == .forwards)
        mtcEnc.decrement() // QF 7
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(receiver.direction == .backwards)
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 7
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26), at: .fps29_97d, by: .allowingInvalid)
        )
        
        // variant
        
        mtcDec.localFrameRate = .fps29_97d
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 59, f: 00), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(mtcEnc.mtcQuarterFrame == 0)
        mtcEnc.increment() // QF 0
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 03), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 04), at: .fps29_97d, by: .allowingInvalid)
        )
        for _ in 1 ... (25 * 4) {
            mtcEnc.increment()
        } // advance 25 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        // ** START: additional lines added for test variant **
        mtcEnc.increment() // QF 1
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(receiver.direction == .forwards)
        mtcEnc.decrement() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(receiver.direction == .backwards)
        // ** END: additional lines added for test variant **
        mtcEnc.decrement() // QF 7
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 7
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26), at: .fps29_97d, by: .allowingInvalid)
        )
    }
    
    @Test
    func mtcIntegration_EncoderDecoder_48fps() {
        // decoder
        
        final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var displayNeedsUpdate: Bool?
            var mtcFR: MTCFrameRate?
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { timecode, messageType, direction, displayNeedsUpdate in
            receiver.timecode = timecode
            receiver.mType = messageType
            receiver.direction = direction
            receiver.displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            receiver.mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        mtcDec.localFrameRate = .fps48
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps48, by: .allowingInvalid))
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps48, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        mtcEnc.increment() // QF 0
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 04), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 1
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 04), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 2
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 05), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 3
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 05), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 4
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 06), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 06), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 6
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 07), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 7
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 07), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 08), at: .fps48, by: .allowingInvalid))
        for _ in 1 ... (19 * 4) {
            mtcEnc.increment()
        } // advance 19 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 6
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 7
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 01, f: 00), at: .fps48, by: .allowingInvalid))
        #expect(receiver.direction == .forwards)
        mtcEnc.decrement() // QF 7
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47), at: .fps48, by: .allowingInvalid))
        #expect(receiver.direction == .backwards)
        mtcEnc.decrement() // QF 6
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 5
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 4
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 45), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 45), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 1
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 44), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 44), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 7
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 43), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 6
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 43), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 5
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 42), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 4
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 42), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 41), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 41), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 1
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 40), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 0
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 40), at: .fps48, by: .allowingInvalid))
    }
    
    @Test
    func mtcIntegration_EncoderDecoder_fullFrameBehavior() {
        // test expected outcomes regarding Encoder.locate() and transmitting MTC full-frame
        // messages
        
        // decoder
        
        final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var displayNeedsUpdate: Bool?
            var mtcFR: MTCFrameRate?
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { timecode, messageType, direction, displayNeedsUpdate in
            receiver.timecode = timecode
            receiver.mType = messageType
            receiver.direction = direction
            receiver.displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            receiver.mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test -- basic behavior
        
        mtcDec.localFrameRate = .fps24
        
        // locate
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == true)
        
        receiver.displayNeedsUpdate = nil
        
        // locate to same position
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == nil)
        
        // locate to same position, but force a full-frame message to transmit
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid),
            transmitFullFrame: .always
        )
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == false)
        
        // locate to new timecode
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps24, by: .allowingInvalid),
            transmitFullFrame: .always
        )
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == true)
        
        // locate to same timecode, but change frame rate
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps25, by: .allowingInvalid),
            transmitFullFrame: .always
        )
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps25, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == false)
        
        receiver.displayNeedsUpdate = nil
        
        // locate to new timecode, but request full-frame not be transmit
        
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 04), at: .fps25, by: .allowingInvalid),
            transmitFullFrame: .never
        )
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps25, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == nil)
        
        // edge cases
        
        // quarter-frame invalidation of last full-frame cache
        // edge case: where the Encoder has locateBehavior == .ifDifferent, if the encoder produces
        // quarter-frame messages it should clear its cache of last full-frame message produced so
        // that in the rare case that we locate to the same full-frame message as the last
        // full-frame
        // message sent it succeeds instead of errantly preventing the message
        
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid),
            transmitFullFrame: .always
        )
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == true)
        
        #expect(receiver.mType == .fullFrame)
        
        mtcEnc.increment() // QF 0
        mtcEnc.increment() // QF 1
        #expect(mtcEnc.mtcQuarterFrame == 1)
        #expect(mtcEnc.lastTransmitFullFrame == nil) // brittle but only way to test this
        
        // locate to same timecode; full-frame should transmit
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(receiver.displayNeedsUpdate == false)
        #expect(receiver.mType == .fullFrame)
    }
    
    @Test
    func bruteForce() throws {
        // decoder
        
        final class Receiver {
            var timecode: Timecode?
            var mType: MTCMessageType?
            var direction: MTCDirection?
            var displayNeedsUpdate: Bool?
            var mtcFR: MTCFrameRate?
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { timecode, messageType, direction, displayNeedsUpdate in
            receiver.timecode = timecode
            receiver.mType = messageType
            receiver.direction = direction
            receiver.displayNeedsUpdate = displayNeedsUpdate
        } mtcFrameRateChanged: { mtcFrameRate in
            receiver.mtcFR = mtcFrameRate
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        // iterate: each timecode frame rate
        // omit 24.98fps because it does not conform to the nature of this test
        try TimecodeFrameRate.allCases
            .filter { $0 != .fps24_98 }
            .forEach { frameRate in
                
                // inform the decoder that our desired local frame rate has changed
                mtcDec.localFrameRate = frameRate
                
                let ranges: [ClosedRange<Timecode>]
                
                switch frameRate.mtcScaleFactor {
                case 1:
                    ranges = [
                        Timecode(.components(h: 0, m: 00, s: 00, f: 02), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 0, m: 00, s: 04, f: 10), at: frameRate, by: .allowingInvalid),
                        
                        Timecode(.components(h: 1, m: 00, s: 59, f: 02), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 1, m: 01, s: 01, f: 10), at: frameRate, by: .allowingInvalid)
                    ]
                case 2:
                    ranges = [
                        Timecode(.components(h: 0, m: 00, s: 00, f: 04), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 0, m: 00, s: 02, f: 10), at: frameRate, by: .allowingInvalid),
                        
                        Timecode(.components(h: 1, m: 00, s: 59, f: 04), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 1, m: 01, s: 01, f: 10), at: frameRate, by: .allowingInvalid)
                    ]
                case 3:
                    ranges = [
                        Timecode(.components(h: 0, m: 00, s: 00, f: 06), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 0, m: 00, s: 02, f: 10), at: frameRate, by: .allowingInvalid),
                        
                        Timecode(.components(h: 1, m: 00, s: 59, f: 06), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 1, m: 01, s: 01, f: 10), at: frameRate, by: .allowingInvalid)
                    ]
                case 4:
                    ranges = [
                        Timecode(.components(h: 0, m: 00, s: 00, f: 08), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 0, m: 00, s: 02, f: 10), at: frameRate, by: .allowingInvalid),
                        
                        Timecode(.components(h: 1, m: 00, s: 59, f: 08), at: frameRate, by: .allowingInvalid) ...
                            Timecode(.components(h: 1, m: 01, s: 01, f: 10), at: frameRate, by: .allowingInvalid)
                    ]
                default:
                    Issue.record("Unhandled frame rate")
                    return // continue to next frame rate in forEach
                }
                
                // iterate: each span in the collection of test ranges
                for range in ranges {
                    let startOffset = 2 * Int(frameRate.mtcScaleFactor)
                    try mtcEnc.locate(to: range.first!.subtracting(.components(f: startOffset), by: .wrapping))
                    
                    mtcEnc.increment() // QF 0
                    #expect(mtcEnc.mtcQuarterFrame == 0)
                    mtcEnc.increment() // QF 1
                    #expect(mtcEnc.mtcQuarterFrame == 1)
                    mtcEnc.increment() // QF 2
                    mtcEnc.increment() // QF 3
                    mtcEnc.increment() // QF 4
                    mtcEnc.increment() // QF 5
                    mtcEnc.increment() // QF 6
                    mtcEnc.increment() // QF 7
                    mtcEnc.increment() // QF 0
                    
                    // iterate: each individual timecode included in the span
                    for timecode in range {
                        #expect(receiver.timecode! == timecode, "at: \(frameRate)")
                        
                        switch frameRate.mtcScaleFactor {
                        case 1:
                            mtcEnc.increment()
                            mtcEnc.increment()
                            mtcEnc.increment()
                            mtcEnc.increment()
                        case 2:
                            mtcEnc.increment()
                            mtcEnc.increment()
                        case 3:
                            mtcEnc.increment()
                            if timecode.frames.isMultiple(of: 3) { mtcEnc.increment() }
                        case 4:
                            mtcEnc.increment()
                        default:
                            Issue.record("Unhandled frame rate")
                        }
                    }
                }
            }
    }
}
