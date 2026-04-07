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
        let timebase: any MIDIFileTimebase = .musical(ticksPerQuarterNote: 480)
        
        let rawData: [UInt8] = [0x01, 0xE0]
        
        #expect(timebase.midi1FileRawBytes(as: [UInt8].self) == rawData)
        
        do {
            guard case let .musical(ppq) = AnyMIDIFileTimebase(midi1FileRawBytes: rawData)
            else { Issue.record(); return }
            
            #expect(ppq.ticksPerQuarterNote == 480)
        }
        
        do {
            guard case let .musical(ppq) = AnyMIDIFileTimebase(midi1FileRawBytes: rawData.toData())
            else { Issue.record(); return }
            
            #expect(ppq.ticksPerQuarterNote == 480)
        }
    }
    
    @Test
    func initSMPTE() async {
        let timebase: any MIDIFileTimebase = .smpte(frameRate: .fps25, ticksPerFrame: 80)
        
        let rawData: [UInt8] = [0b11100111, 0x50]
        
        #expect(timebase.midi1FileRawBytes(as: [UInt8].self) == rawData)
        
        do {
            guard case let .smpte(smpteTimebase) = AnyMIDIFileTimebase(midi1FileRawBytes: rawData)
            else { Issue.record(); return }
            
            #expect(smpteTimebase.frameRate == .fps25)
            #expect(smpteTimebase.ticksPerFrame == 80)
        }
        
        do {
            guard case let .smpte(smpteTimebase) = AnyMIDIFileTimebase(midi1FileRawBytes: rawData.toData())
            else { Issue.record(); return }
            
            #expect(smpteTimebase.frameRate == .fps25)
            #expect(smpteTimebase.ticksPerFrame == 80)
        }
    }
}
