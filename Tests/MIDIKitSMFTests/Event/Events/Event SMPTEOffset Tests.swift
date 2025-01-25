//
//  Event SMPTEOffset Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import TimecodeKitCore
import Testing

@Suite struct Event_SMPTEOffset_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes() throws {
        let bytes: [UInt8] = [0xFF, 0x54, 0x05,
                              0b00100001, 2, 3, 4, 5]
        
        let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: bytes)
        
        #expect(event.hours == 1)
        #expect(event.minutes == 2)
        #expect(event.seconds == 3)
        #expect(event.frames == 4)
        #expect(event.subframes == 5)
        #expect(event.frameRate == .fps25)
    }
    
    @Test
    func midi1SMFRawBytes() {
        let event = MIDIFileEvent.SMPTEOffset(
            hr: 1,
            min: 2,
            sec: 3,
            fr: 4,
            subFr: 5,
            frRate: .fps25
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x54, 0x05,
                          0b00100001, 2, 3, 4, 5])
    }
    
    @Test
    func frameRates() throws {
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b00000001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            #expect(event.frameRate == .fps24)
        }
        
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b00100001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            #expect(event.frameRate == .fps25)
        }
        
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b01000001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            #expect(event.frameRate == .fps29_97d)
        }
        
        do {
            let rawData: [UInt8] = [0xFF, 0x54, 0x05,
                                    0b01100001, 2, 3, 4, 5]
            
            let event = try MIDIFileEvent.SMPTEOffset(midi1SMFRawBytes: rawData)
            
            #expect(event.frameRate == .fps30)
        }
    }
    
    // MARK: Timecode methods
    
    @Test
    func init_Timecode() {
        // basic: four SMPTE Offset frame rates
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            #expect(smpte.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(smpte.frameRate == .fps24)
            
            #expect(smpte.timecode == tc)
            #expect(smpte.timecode.frameRate == tc.frameRate)
        }
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps25, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            #expect(smpte.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(smpte.frameRate == .fps25)
            
            #expect(smpte.timecode == tc)
            #expect(smpte.timecode.frameRate == tc.frameRate)
        }
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps29_97d, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            #expect(smpte.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(smpte.frameRate == .fps29_97d)
            
            #expect(smpte.timecode == tc)
            #expect(smpte.timecode.frameRate == tc.frameRate)
        }
        
        do {
            let tc = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps30, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            #expect(smpte.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(smpte.frameRate == .fps30)
            
            #expect(smpte.timecode == tc)
            #expect(smpte.timecode.frameRate == tc.frameRate)
        }
        
        // subframe scaling
        
        do {
            let tc = Timecode(.components(h: 1, sf: 40), at: .fps24, base: .max80SubFrames, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            #expect(smpte.components == .init(h: 1, sf: 50))
            #expect(smpte.frameRate == .fps24)
        }
        
        do {
            let tc = Timecode(.components(h: 1, sf: 50), at: .fps25, base: .max100SubFrames, by: .allowingInvalid)
            
            let smpte = MIDIFileEvent.SMPTEOffset(scaling: tc)
            
            #expect(smpte.components == .init(h: 1, sf: 50))
            #expect(smpte.frameRate == .fps25)
        }
    }
    
    @Test
    func timecode_scaledToMIDIFileSMPTEFrameRate() {
        // basic: four SMPTE Offset frame rates
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps24, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            #expect(scaled.scaledTimecode?.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(scaled.scaledTimecode?.frameRate == .fps24)
            #expect(scaled.scaledTimecode?.subFramesBase == .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps25, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            #expect(scaled.scaledTimecode?.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(scaled.scaledTimecode?.frameRate == .fps25)
            #expect(scaled.scaledTimecode?.subFramesBase == .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps29_97d, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            #expect(scaled.scaledTimecode?.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(scaled.scaledTimecode?.frameRate == .fps29_97d)
            #expect(scaled.scaledTimecode?.subFramesBase == .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, m: 2, s: 3, f: 4), at: .fps30, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            #expect(scaled.scaledTimecode?.components == .init(h: 1, m: 2, s: 3, f: 4))
            #expect(scaled.scaledTimecode?.frameRate == .fps30)
            #expect(scaled.scaledTimecode?.subFramesBase == .max100SubFrames)
        }
        
        // subframe scaling
        
        do {
            let scaled = Timecode(.components(h: 1, sf: 40), at: .fps24, base: .max80SubFrames, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            #expect(scaled.scaledTimecode?.components == .init(h: 1, sf: 50))
            #expect(scaled.scaledTimecode?.frameRate == .fps24)
            #expect(scaled.scaledTimecode?.subFramesBase == .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1, sf: 50), at: .fps25, base: .max100SubFrames, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            #expect(scaled.scaledTimecode?.components == .init(h: 1, sf: 50))
            #expect(scaled.scaledTimecode?.frameRate == .fps25)
            #expect(scaled.scaledTimecode?.subFramesBase == .max100SubFrames)
        }
        
        do {
            let scaled = Timecode(.components(h: 1), at: .fps47_952, by: .allowingInvalid)
                .scaledToMIDIFileSMPTEFrameRate
            
            #expect(
                scaled.scaledTimecode?.components ==
                .init(d: 0, h: 1, m: 0, s: 3, f: 14, sf: 40)
            )
            #expect(scaled.scaledTimecode?.frameRate == .fps24)
            #expect(scaled.scaledTimecode?.subFramesBase == .max100SubFrames)
        }
    }
}
