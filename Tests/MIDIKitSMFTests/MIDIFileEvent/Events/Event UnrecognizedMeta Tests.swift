//
//  Event UnrecognizedMeta Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_UnrecognizedMeta_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1FileRawBytes_EmptyData() async throws {
        let bytes: [UInt8] = [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x00        // length: 0 bytes to follow
        ]
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1FileRawBytes: bytes)
        
        #expect(event.metaType == 0x30)
        #expect(event.data == [])
    }
    
    @Test
    func midi1FileRawBytes_EmptyData() async {
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: []
        )
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(bytes == [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x00        // length: 0 bytes to follow
        ])
    }
    
    @Test
    func init_midi1FileRawBytes_WithData() async throws {
        let bytes: [UInt8] = [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x01,       // length: 1 bytes to follow
            0x12        // data byte
        ]
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1FileRawBytes: bytes)
        
        #expect(event.metaType == 0x30)
        #expect(event.data == [0x12])
    }
    
    @Test
    func midi1FileRawBytes_WithData() async {
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: [0x12]
        )
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(bytes == [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x01,       // length: 1 bytes to follow
            0x12        // data byte
        ])
    }
    
    @Test
    func Init_midi1FileRawBytes_127Bytes() async throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let bytes: [UInt8] =
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x7F]       // length: 127 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1FileRawBytes: bytes)
        
        #expect(event.metaType == 0x30)
        #expect(event.data == data)
    }
    
    @Test
    func MIDI1SMFRawBytes_127Bytes() async {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: data
        )
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(
            bytes ==
                [0xFF, 0x30, // unknown/undefined meta type 0x30
                 0x7F]       // length: 127 bytes to follow
                + data   // data
        )
    }
    
    @Test
    func Init_midi1FileRawBytes_128Bytes() async throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let bytes: [UInt8] =
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x81, 0x00] // length: 128 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1FileRawBytes: bytes)
        
        #expect(event.metaType == 0x30)
        #expect(event.data == data)
    }
    
    @Test
    func MIDI1SMFRawBytes_128Bytes() async {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: data
        )
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(
            bytes ==
                [0xFF, 0x30, // unknown/undefined meta type 0x30
                 0x81, 0x00] // length: 128 bytes to follow
                + data   // data
        )
    }
}
