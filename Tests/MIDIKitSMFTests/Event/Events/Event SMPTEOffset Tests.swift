//
//  Event SMPTEOffset Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF
import TimecodeKit

final class Event_SMPTEOffset_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes() throws {
        let bytes: [Byte] = [0xFF, 0x54, 0x05,
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
            let rawData: [Byte] = [0xFF, 0x54, 0x05,
                                        0b00000001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._24fps)
        }
        
        do {
            let rawData: [Byte] = [0xFF, 0x54, 0x05,
                                        0b00100001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._25fps)
        }
        
        do {
            let rawData: [Byte] = [0xFF, 0x54, 0x05,
                                        0b01000001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._2997dfps)
        }
        
        do {
            let rawData: [Byte] = [0xFF, 0x54, 0x05,
                                        0b01100001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            XCTAssertEqual(event.frameRate, ._30fps)
        }
    }
    
    // MARK: Timecode methods
    
    func testInit_Timecode() {
        // basic: four SMPTE Offset frame rates
        
        do {
            let tc = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._24)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._24fps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        do {
            let tc = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._25)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._25fps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        do {
            let tc = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._29_97_drop)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._2997dfps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        do {
            let tc = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._30)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(smpte.frameRate, ._30fps)
            
            XCTAssertEqual(smpte.timecode, tc)
            XCTAssertEqual(smpte.timecode.frameRate, tc.frameRate)
        }
        
        // subframe scaling
        
        do {
            let tc = TCC(h: 1, sf: 40).toTimecode(rawValuesAt: ._24, base: ._80SubFrames)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, TCC(h: 1, sf: 50))
            XCTAssertEqual(smpte.frameRate, ._24fps)
        }
        
        do {
            let tc = TCC(h: 1, sf: 50).toTimecode(rawValuesAt: ._25, base: ._100SubFrames)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            XCTAssertEqual(smpte.components, TCC(h: 1, sf: 50))
            XCTAssertEqual(smpte.frameRate, ._25fps)
        }
    }
    
    func testTimecode_scaledToMIDIFileSMPTEFrameRate() {
        // basic: four SMPTE Offset frame rates
        
        do {
            let scaled = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._24)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, ._24)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, ._100SubFrames)
        }
        
        do {
            let scaled = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._25)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, ._25)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, ._100SubFrames)
        }
        
        do {
            let scaled = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._29_97_drop)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, ._29_97_drop)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, ._100SubFrames)
        }
        
        do {
            let scaled = TCC(h: 1, m: 2, s: 3, f: 4).toTimecode(rawValuesAt: ._30)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, TCC(h: 1, m: 2, s: 3, f: 4))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, ._30)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, ._100SubFrames)
        }
        
        // subframe scaling
        
        do {
            let scaled = TCC(h: 1, sf: 40).toTimecode(rawValuesAt: ._24, base: ._80SubFrames)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, TCC(h: 1, sf: 50))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, ._24)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, ._100SubFrames)
        }
        
        do {
            let scaled = TCC(h: 1, sf: 50).toTimecode(rawValuesAt: ._25, base: ._100SubFrames)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(scaled.scaledTimecode?.components, TCC(h: 1, sf: 50))
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, ._25)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, ._100SubFrames)
        }
        
        do {
            let scaled = TCC(h: 1).toTimecode(rawValuesAt: ._47_952)
                .scaledToMIDIFileSMPTEFrameRate
            
            XCTAssertEqual(
                scaled.scaledTimecode?.components,
                TCC(d: 0, h: 1, m: 0, s: 3, f: 14, sf: 40)
            )
            XCTAssertEqual(scaled.scaledTimecode?.frameRate, ._24)
            XCTAssertEqual(scaled.scaledTimecode?.subFramesBase, ._100SubFrames)
        }
    }
}

#endif
