//
//  Event SequencerSpecific Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_SequencerSpecific_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_Empty() throws {
        let bytes: [UInt8] = [0xFF, 0x7F, 0x00]
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == [])
    }
    
    @Test
    func midi1SMFRawBytes_Empty() {
        let event = MIDIFileEvent.SequencerSpecific(data: [])
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x7F, 0x00])
    }
    
    @Test
    func init_midi1SMFRawBytes_OneByte() throws {
        let bytes: [UInt8] = [0xFF, 0x7F, 0x01, 0x34]
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == [0x34])
    }
    
    @Test
    func midi1SMFRawBytes_OneByte() {
        let event = MIDIFileEvent.SequencerSpecific(data: [0x34])
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x7F, 0x01, 0x34])
    }
    
    @Test
    func init_midi1SMFRawBytes_127Bytes() throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let bytes: [UInt8] =
            [0xFF, 0x7F, // header
             0x7F]       // length: 127 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == data)
    }
    
    @Test
    func midi1SMFRawBytes_127Bytes() {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let event = MIDIFileEvent.SequencerSpecific(data: data)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(
            bytes ==
                [0xFF, 0x7F, // header
                 0x7F]       // length: 127 bytes to follow
                + data   // data
        )
    }
    
    @Test
    func init_midi1SMFRawBytes_128Bytes() throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let bytes: [UInt8] =
            [0xFF, 0x7F, // header
             0x81, 0x00] // length: 128 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        #expect(event.data == data)
    }
    
    @Test
    func midi1SMFRawBytes_128Bytes() {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let event = MIDIFileEvent.SequencerSpecific(data: data)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(
            bytes ==
                [0xFF, 0x7F, // header
                 0x81, 0x00] // length: 128 bytes to follow
                + data   // data
        )
    }
}
