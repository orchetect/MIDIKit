//
//  Event Tempo Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_Tempo_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() async throws {
        let bytes: [UInt8] = [
            0xFF, 0x51, 0x03, // header
            0x07, 0xA1, 0x20  // 24-bit tempo encoding
        ]
        
        let event = try MIDIFileEvent.Tempo(midi1SMFRawBytes: bytes)
        
        #expect(event.bpm == 120.0)
    }
    
    @Test
    func midi1SMFRawBytes_A() async {
        let event = MIDIFileEvent.Tempo(bpm: 120.0)
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [
            0xFF, 0x51, 0x03, // header
            0x07, 0xA1, 0x20  // 24-bit tempo encoding
        ])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() async throws {
        let bytes: [UInt8] = [
            0xFF, 0x51, 0x03, // header
            0x0F, 0x42, 0x40  // 24-bit tempo encoding
        ]
        
        let event = try MIDIFileEvent.Tempo(midi1SMFRawBytes: bytes)
        
        #expect(event.bpm == 60.0)
    }
    
    @Test
    func midi1SMFRawBytes_B() async {
        let event = MIDIFileEvent.Tempo(bpm: 60.0)
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [
            0xFF, 0x51, 0x03, // header
            0x0F, 0x42, 0x40  // 24-bit tempo encoding
        ])
    }
}
