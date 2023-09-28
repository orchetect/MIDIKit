//
//  Event SMPTEOffset Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSMF
import TimecodeKit
import XCTest

final class Event_SMPTEOffset_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes() throws {
        let bytes: [UInt8] = [0xFF, 0x54, 0x05,
                              0b00100001, 2, 3, 4, 5]
        
        let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.hours, 1)
        XCTAssertEqual(event.minutes, 2)
        XCTAssertEqual(event.seconds, 3)
        XCTAssertEqual(event.frames, 4)
        XCTAssertEqual(event.subframes, 5)
        XCTAssertEqual(event.frameRate, ._25fps)
    }
    
    func testMIDI1SMFRawBytes() {
        let event = MIDIFileEvent.SMPTEOffset(
            hr: 1,
            min: 2,
            sec: 3,
            fr: 4,
            subFr: 5,
            frRate: ._25fps
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x54, 0x05,
                               0b00100001, 2, 3, 4, 5])
    }
    
    func testFrameRates() throws {
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b00000001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._24fps)
        }
        
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b00100001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._25fps)
        }
        
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b01000001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._2997dfps)
        }
        
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b01100001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._30fps)
        }
    }
    
    // MARK: Timecode methods
    
    func testInit_Timecode() {
        // basic: four SMPTE Offset frame rates
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._24fps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps25, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._25fps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps29_97d, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._2997dfps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps30, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._30fps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        // subframe scaling
        
        do {
            let tc = Timecode(.components(h: 1, sf: 40), at: .fps24, base: .max80SubFrames, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, .init(h: 1, sf: 50))
            XCTAssertEqual(smpte.frameRate, ._24fps)
        }
        
        do {
            let tc = Timecode(.components(h: 1, sf: 50), at: .fps25, base: .max100SubFrames, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, .init(h: 1, sf: 50))
            XCTAssertEqual(smpte.frameRate, ._25fps)
        }
    }
    
    func testTimecode_scaledToMIDIFileSMPTEFrameRate() {
        // basic: four SMPTE Offset frame rates
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, .fps24)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps25, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, .fps25)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps29_97d, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, .fps29_97d)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps30, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, .init(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, .fps30)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, .max100SubFrames)
        }
        
        // subframe scaling
        
        do {
            let scaled = Timecode(.components(h: 1, sf: 40), at: .fps24, base: .max80SubFrames, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, .init(h: 1, sf: 50))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, .fps24)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, sf: 50), at: .fps25, base: .max100SubFrames, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, .init(h: 1, sf: 50))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, .fps25)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1), at: .fps47_952, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(
                scaled.scaledTimecode?.components,
                .init(d: 0, h: 1, m: 0, s: 3, f: 14, sf: 40)
            )
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, .fps24)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, .max100SubFrames)
        }
    }
}

#endif
