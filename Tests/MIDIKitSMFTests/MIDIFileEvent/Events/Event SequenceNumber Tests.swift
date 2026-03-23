//
//  Event SequenceNumber Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_SequenceNumber_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() async throws {
        let bytes: [UInt8] = [0xFF, 0x00, 0x02, 0x00, 0x00]
        
        let event = try MIDIFileTrackEvent.SequenceNumber(midi1SMFRawBytes: bytes)
        
        #expect(event.sequence == 0x00)
    }
    
    @Test
    func midi1SMFRawBytes_A() async {
        let event = MIDIFileTrackEvent.SequenceNumber(sequence: 0x00)
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x00, 0x02, 0x00, 0x00])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() async throws {
        let bytes: [UInt8] = [0xFF, 0x00, 0x02, 0x7F, 0xFF]
        
        let event = try MIDIFileTrackEvent.SequenceNumber(midi1SMFRawBytes: bytes)
        
        #expect(event.sequence == 0x7FFF)
    }
    
    @Test
    func midi1SMFRawBytes_B() async {
        let event = MIDIFileTrackEvent.SequenceNumber(sequence: 0x7FFF)
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x00, 0x02, 0x7F, 0xFF])
    }
}
