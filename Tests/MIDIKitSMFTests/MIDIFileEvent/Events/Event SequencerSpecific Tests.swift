//
//  Event SequencerSpecific Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_SequencerSpecific_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_Empty() async throws {
        let bytes: [UInt8] = [0xFF, 0x7F, 0x00]
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == [])
    }
    
    @Test
    func midi1SMFRawBytes_Empty() async {
        let event = MIDIFileEvent.SequencerSpecific(data: [])
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x7F, 0x00])
    }
    
    @Test
    func init_midi1SMFRawBytes_OneByte() async throws {
        let bytes: [UInt8] = [0xFF, 0x7F, 0x01, 0x34]
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == [0x34])
    }
    
    @Test
    func midi1SMFRawBytes_OneByte() async {
        let event = MIDIFileEvent.SequencerSpecific(data: [0x34])
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x7F, 0x01, 0x34])
    }
    
    @Test
    func init_midi1SMFRawBytes_127Bytes() async throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let bytes: [UInt8] =
            [0xFF, 0x7F, // header
             0x7F]       // length: 127 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == data)
    }
    
    @Test
    func midi1SMFRawBytes_127Bytes() async {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let event = MIDIFileEvent.SequencerSpecific(data: data)
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(
            bytes ==
                [0xFF, 0x7F, // header
                 0x7F]       // length: 127 bytes to follow
                + data   // data
        )
    }
    
    @Test
    func init_midi1SMFRawBytes_128Bytes() async throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let bytes: [UInt8] =
            [0xFF, 0x7F, // header
             0x81, 0x00] // length: 128 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == data)
    }
    
    @Test
    func midi1SMFRawBytes_128Bytes() async {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let event = MIDIFileEvent.SequencerSpecific(data: data)
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(
            bytes ==
                [0xFF, 0x7F, // header
                 0x81, 0x00] // length: 128 bytes to follow
                + data   // data
        )
    }
}
