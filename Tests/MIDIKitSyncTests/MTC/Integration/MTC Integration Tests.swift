//
//  MTC Integration Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import SwiftTimecodeCore

@Suite struct MTC_Integration_Integration_Tests {
    @Test
    func mtcIntegration_EncoderDecoder_24fps() async {
        // decoder
        
        @TestActor final class Receiver {
            var timecode: Timecode?
            func set(timecode: Timecode?) { self.timecode = timecode }
            
            var mType: MTCMessageType?
            func set(mType: MTCMessageType?) { self.mType = mType }
            
            var direction: MTCDirection?
            func set(direction: MTCDirection?) { self.direction = direction }
            
            var isFrameChanged: Bool?
            func set(isFrameChanged: Bool?) { self.isFrameChanged = isFrameChanged }
            
            var mtcFR: MTCFrameRate?
            func set(mtcFR: MTCFrameRate?) { self.mtcFR = mtcFR }
            
            nonisolated init() { }
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { [weak receiver] timecode, messageType, direction, isFrameChanged in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(timecode: timecode)
                receiver?.set(mType: messageType)
                receiver?.set(direction: direction)
                receiver?.set(isFrameChanged: isFrameChanged)
            }
        } mtcFrameRateChanged: { [weak receiver] mtcFrameRate in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(mtcFR: mtcFrameRate)
            }
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        mtcDec.localFrameRate = .fps24
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
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
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 03), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 04), at: .fps24, by: .allowingInvalid))
        for _ in 1 ... (19 * 4) {
            mtcEnc.increment()
        } // advance 19 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 00), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 25), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 6
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 50), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 7
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 75), at: .fps24, by: .allowingInvalid))
        mtcEnc.increment() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 01, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(await receiver.direction == .forwards)
        mtcEnc.decrement() // QF 7
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 75), at: .fps24, by: .allowingInvalid))
        #expect(await receiver.direction == .backwards)
        mtcEnc.decrement() // QF 6
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 50), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 5
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 25), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 4
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 23, sf: 00), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 22, sf: 75), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 22, sf: 00), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 7
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 21, sf: 75), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 21, sf: 00), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 20, sf: 75), at: .fps24, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 20, sf: 00), at: .fps24, by: .allowingInvalid))
    }
    
    @Test
    func mtcIntegration_EncoderDecoder_29_97drop() async {
        // decoder
        
        @TestActor final class Receiver {
            var timecode: Timecode?
            func set(timecode: Timecode?) { self.timecode = timecode }
            
            var mType: MTCMessageType?
            func set(mType: MTCMessageType?) { self.mType = mType }
            
            var direction: MTCDirection?
            func set(direction: MTCDirection?) { self.direction = direction }
            
            var isFrameChanged: Bool?
            func set(isFrameChanged: Bool?) { self.isFrameChanged = isFrameChanged }
            
            var mtcFR: MTCFrameRate?
            func set(mtcFR: MTCFrameRate?) { self.mtcFR = mtcFR }
            
            nonisolated init() { }
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { [weak receiver] timecode, messageType, direction, isFrameChanged in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(timecode: timecode)
                receiver?.set(mType: messageType)
                receiver?.set(direction: direction)
                receiver?.set(isFrameChanged: isFrameChanged)
            }
        } mtcFrameRateChanged: { [weak receiver] mtcFrameRate in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(mtcFR: mtcFrameRate)
            }
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        mtcDec.localFrameRate = .fps29_97d
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 59, f: 00), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            await receiver.timecode ==
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
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 03), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 04), at: .fps29_97d, by: .allowingInvalid)
        )
        for _ in 1 ... (25 * 4) {
            mtcEnc.increment()
        } // advance 25 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 25), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 6
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 50), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 7
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(await receiver.direction == .forwards)
        mtcEnc.decrement() // QF 7
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(await receiver.direction == .backwards)
        mtcEnc.decrement() // QF 6
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 50), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 5
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 25), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 4
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 7
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        
        // variant
        
        mtcDec.localFrameRate = .fps29_97d
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 59, f: 00), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            await receiver.timecode ==
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
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 1
        mtcEnc.increment() // QF 2
        mtcEnc.increment() // QF 3
        mtcEnc.increment() // QF 4
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 03), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 04), at: .fps29_97d, by: .allowingInvalid)
        )
        for _ in 1 ... (25 * 4) {
            mtcEnc.increment()
        } // advance 25 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.increment() // QF 5
        mtcEnc.increment() // QF 6
        mtcEnc.increment() // QF 7
        mtcEnc.increment() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02), at: .fps29_97d, by: .allowingInvalid)
        )
        // ** START: additional lines added for test variant **
        mtcEnc.increment() // QF 1
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02, sf: 25), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(await receiver.direction == .forwards)
        mtcEnc.decrement() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 01, s: 00, f: 02, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        #expect(await receiver.direction == .backwards)
        // ** END: additional lines added for test variant **
        mtcEnc.decrement() // QF 7
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 29, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 28, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 7
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 6
        mtcEnc.decrement() // QF 5
        mtcEnc.decrement() // QF 4
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 27, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 3
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26, sf: 75), at: .fps29_97d, by: .allowingInvalid)
        )
        mtcEnc.decrement() // QF 2
        mtcEnc.decrement() // QF 1
        mtcEnc.decrement() // QF 0
        #expect(
            await receiver.timecode ==
                Timecode(.components(h: 1, m: 00, s: 59, f: 26, sf: 00), at: .fps29_97d, by: .allowingInvalid)
        )
    }
    
    @Test
    func mtcIntegration_EncoderDecoder_48fps() async {
        // decoder
        
        @TestActor final class Receiver {
            var timecode: Timecode?
            func set(timecode: Timecode?) { self.timecode = timecode }
            
            var mType: MTCMessageType?
            func set(mType: MTCMessageType?) { self.mType = mType }
            
            var direction: MTCDirection?
            func set(direction: MTCDirection?) { self.direction = direction }
            
            var isFrameChanged: Bool?
            func set(isFrameChanged: Bool?) { self.isFrameChanged = isFrameChanged }
            
            var mtcFR: MTCFrameRate?
            func set(mtcFR: MTCFrameRate?) { self.mtcFR = mtcFR }
            
            nonisolated init() { }
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { [weak receiver] timecode, messageType, direction, isFrameChanged in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(timecode: timecode)
                receiver?.set(mType: messageType)
                receiver?.set(direction: direction)
                receiver?.set(isFrameChanged: isFrameChanged)
            }
        } mtcFrameRateChanged: { [weak receiver] mtcFrameRate in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(mtcFR: mtcFrameRate)
            }
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        mtcDec.localFrameRate = .fps48
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps48, by: .allowingInvalid))
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps48, by: .allowingInvalid))
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
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 04, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 1
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 04, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 2
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 05, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 3
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 05, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 4
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 06, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 06, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 6
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 07, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 7
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 07, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 08, sf: 00), at: .fps48, by: .allowingInvalid))
        for _ in 1 ... (19 * 4) {
            mtcEnc.increment()
        } // advance 19 frames (4 QF per frame)
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 5
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 6
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 7
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.increment() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 01, f: 00, sf: 00), at: .fps48, by: .allowingInvalid))
        #expect(await receiver.direction == .forwards)
        mtcEnc.decrement() // QF 7
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47, sf: 50), at: .fps48, by: .allowingInvalid))
        #expect(await receiver.direction == .backwards)
        mtcEnc.decrement() // QF 6
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 47, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 5
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 4
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 46, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 45, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 45, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 1
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 44, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 44, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 7
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 43, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 6
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 43, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 5
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 42, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 4
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 42, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 3
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 41, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 2
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 41, sf: 00), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 1
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 40, sf: 50), at: .fps48, by: .allowingInvalid))
        mtcEnc.decrement() // QF 0
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 40, sf: 00), at: .fps48, by: .allowingInvalid))
    }
    
    @Test
    func mtcIntegration_EncoderDecoder_fullFrameBehavior() async {
        // test expected outcomes regarding Encoder.locate() and transmitting MTC full-frame
        // messages
        
        // decoder
        
        @TestActor final class Receiver {
            var timecode: Timecode?
            func set(timecode: Timecode?) { self.timecode = timecode }
            
            var mType: MTCMessageType?
            func set(mType: MTCMessageType?) { self.mType = mType }
            
            var direction: MTCDirection?
            func set(direction: MTCDirection?) { self.direction = direction }
            
            var isFrameChanged: Bool?
            func set(isFrameChanged: Bool?) { self.isFrameChanged = isFrameChanged }
            
            var mtcFR: MTCFrameRate?
            func set(mtcFR: MTCFrameRate?) { self.mtcFR = mtcFR }
            
            nonisolated init() { }
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { [weak receiver] timecode, messageType, direction, isFrameChanged in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(timecode: timecode)
                receiver?.set(mType: messageType)
                receiver?.set(direction: direction)
                receiver?.set(isFrameChanged: isFrameChanged)
            }
        } mtcFrameRateChanged: { [weak receiver] mtcFrameRate in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(mtcFR: mtcFrameRate)
            }
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test -- basic behavior
        
        mtcDec.localFrameRate = .fps24
        
        // locate
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == true)
        
        await receiver.set(isFrameChanged: nil)
        
        // locate to same position
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == nil)
        
        // locate to same position, but force a full-frame message to transmit
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid),
            transmitFullFrame: .always
        )
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == false)
        
        // locate to new timecode
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps24, by: .allowingInvalid),
            transmitFullFrame: .always
        )
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == true)
        
        // locate to same timecode, but change frame rate
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps25, by: .allowingInvalid),
            transmitFullFrame: .always
        )
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps25, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == false)
        
        await receiver.set(isFrameChanged: nil)
        
        // locate to new timecode, but request full-frame not be transmit
        
        mtcEnc.locate(
            to: Timecode(.components(h: 1, m: 00, s: 00, f: 04), at: .fps25, by: .allowingInvalid),
            transmitFullFrame: .never
        )
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 02), at: .fps25, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == nil)
        
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
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == true)
        
        #expect(await receiver.mType == .fullFrame)
        
        mtcEnc.increment() // QF 0
        mtcEnc.increment() // QF 1
        #expect(mtcEnc.mtcQuarterFrame == 1)
        #expect(mtcEnc.lastTransmitFullFrame == nil) // brittle but only way to test this
        
        // locate to same timecode; full-frame should transmit
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        
        #expect(await receiver.timecode == Timecode(.components(h: 1, m: 00, s: 00, f: 00), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(await receiver.isFrameChanged == false)
        #expect(await receiver.mType == .fullFrame)
    }
    
    @Test
    func bruteForce() async throws {
        // decoder
        
        @TestActor final class Receiver {
            var timecode: Timecode?
            func set(timecode: Timecode?) { self.timecode = timecode }
            
            var mType: MTCMessageType?
            func set(mType: MTCMessageType?) { self.mType = mType }
            
            var direction: MTCDirection?
            func set(direction: MTCDirection?) { self.direction = direction }
            
            var isFrameChanged: Bool?
            func set(isFrameChanged: Bool?) { self.isFrameChanged = isFrameChanged }
            
            var mtcFR: MTCFrameRate?
            func set(mtcFR: MTCFrameRate?) { self.mtcFR = mtcFR }
            
            nonisolated init() { }
        }
        let receiver = Receiver()
        
        let mtcDec = MTCDecoder(initialLocalFrameRate: nil) { [weak receiver] timecode, messageType, direction, isFrameChanged in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(timecode: timecode)
                receiver?.set(mType: messageType)
                receiver?.set(direction: direction)
                receiver?.set(isFrameChanged: isFrameChanged)
            }
        } mtcFrameRateChanged: { [weak receiver] mtcFrameRate in
            // MTCEncoder does not use Task or internal dispatch queues
            Task { @TestActor in
                receiver?.set(mtcFR: mtcFrameRate)
            }
        }
        
        // encoder
        
        let mtcEnc = MTCEncoder { midiEvents in
            mtcDec.midiIn(events: midiEvents)
        }
        
        // test
        
        // iterate: each timecode frame rate
        // omit 24.98fps because it does not conform to the nature of this test
        for frameRate in TimecodeFrameRate.allCases.filter({ $0 != .fps24_98 }) {
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
                        var receiverTimecodeTruncatedSubframes = try #require(await receiver.timecode)
                        receiverTimecodeTruncatedSubframes.subFrames = 0
                        
                        #expect(receiverTimecodeTruncatedSubframes == timecode, "at: \(frameRate)")
                        
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
