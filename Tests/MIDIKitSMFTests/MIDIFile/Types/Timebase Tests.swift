//
//  Timebase Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct Timebase_Tests {
    @Test
    func initMusical() async {
        let timebase = MIDIFile.Timebase.musical(ticksPerQuarterNote: 480)
        
        let rawData: [UInt8] = [0x01, 0xE0]
        
        #expect(timebase.rawData(as: [UInt8].self) == rawData)
        
        do {
            guard case let .musical(tpq) = MIDIFile.Timebase(data: rawData)
            else { Issue.record(); return }
            
            #expect(tpq == 480)
        }
        
        do {
            guard case let .musical(tpq) = MIDIFile.Timebase(data: rawData.toData())
            else { Issue.record(); return }
            
            #expect(tpq == 480)
        }
    }
    
    @Test
    func initTimecode() async {
        let timebase = MIDIFile.Timebase.timecode(smpteFormat: .fps25, ticksPerFrame: 80)
        
        let rawData: [UInt8] = [0b11100111, 0x50]
        
        #expect(timebase.rawData(as: [UInt8].self) == rawData)
        
        do {
            guard case let .timecode(
                smpteFormat,
                ticksPerFrame
            ) = MIDIFile.Timebase(data: rawData)
            else { Issue.record(); return }
            
            #expect(smpteFormat == .fps25)
            #expect(ticksPerFrame == 80)
        }
        
        do {
            guard case let .timecode(
                smpteFormat,
                ticksPerFrame
            ) = MIDIFile.Timebase(data: rawData.toData())
            else { Issue.record(); return }
            
            #expect(smpteFormat == .fps25)
            #expect(ticksPerFrame == 80)
        }
    }
}
