//
//  Timing Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct TimeBase_Tests {
    @Test
    func initMusical() {
        let timeBase = MIDIFile.TimeBase.musical(ticksPerQuarterNote: 480)
        
        let rawData: [UInt8] = [0x01, 0xE0]
        
        #expect(timeBase.rawData.bytes == rawData)
        
        do {
            guard case let .musical(tpq) = MIDIFile
                .TimeBase(rawBytes: rawData)
            else { Issue.record(); return }
            
            #expect(tpq == 480)
        }
        
        do {
            guard case let .musical(tpq) = MIDIFile
                .TimeBase(rawData: rawData.data)
            else { Issue.record(); return }
            
            #expect(tpq == 480)
        }
    }
    
    @Test
    func initTimecode() {
        let timeBase = MIDIFile.TimeBase.timecode(smpteFormat: .fps25, ticksPerFrame: 80)
        
        let rawData: [UInt8] = [0b11100111, 0x50]
        
        #expect(timeBase.rawData.bytes == rawData)
        
        do {
            guard case let .timecode(
                smpteFormat,
                ticksPerFrame
            ) = MIDIFile.TimeBase(rawBytes: rawData)
            else { Issue.record(); return }
            
            #expect(smpteFormat == .fps25)
            #expect(ticksPerFrame == 80)
        }
        
        do {
            guard case let .timecode(
                smpteFormat,
                ticksPerFrame
            ) = MIDIFile.TimeBase(rawData: rawData.data)
            else { Issue.record(); return }
            
            #expect(smpteFormat == .fps25)
            #expect(ticksPerFrame == 80)
        }
    }
}
