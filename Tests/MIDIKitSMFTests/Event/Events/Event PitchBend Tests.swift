//
//  Event PitchBend Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_PitchBend_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xE0, 0x00, 0x40]
        
        let event = try MIDIFileEvent.PitchBend(midi1SMFRawBytes: bytes)
        
        #expect(event.value == .midi1(.midpoint))
        #expect(event.channel == 0)
    }
    
    @Test
    func midi1SMFRawBytes_A() {
        let event = MIDIFileEvent.PitchBend(
            value: .midi1(.midpoint),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xE0, 0x00, 0x40])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xE1, 0x7F, 0x7F]
        
        let event = try MIDIFileEvent.PitchBend(midi1SMFRawBytes: bytes)
        
        #expect(event.value == .midi1(.max))
        #expect(event.channel == 1)
    }
    
    @Test
    func midi1SMFRawBytes_B() {
        let event = MIDIFileEvent.PitchBend(
            value: .midi1(.max),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xE1, 0x7F, 0x7F])
    }
}
