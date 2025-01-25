//
//  Event SequenceNumber Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_SequenceNumber_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xFF, 0x00, 0x02, 0x00, 0x00]
        
        let event = try MIDIFileEvent.SequenceNumber(midi1SMFRawBytes: bytes)
        
        #expect(event.sequence == 0x00)
    }
    
    @Test
    func midi1SMFRawBytes_A() {
        let event = MIDIFileEvent.SequenceNumber(sequence: 0x00)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x00, 0x02, 0x00, 0x00])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xFF, 0x00, 0x02, 0x7F, 0xFF]
        
        let event = try MIDIFileEvent.SequenceNumber(midi1SMFRawBytes: bytes)
        
        #expect(event.sequence == 0x7FFF)
    }
    
    @Test
    func midi1SMFRawBytes_B() {
        let event = MIDIFileEvent.SequenceNumber(sequence: 0x7FFF)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x00, 0x02, 0x7F, 0xFF])
    }
}
