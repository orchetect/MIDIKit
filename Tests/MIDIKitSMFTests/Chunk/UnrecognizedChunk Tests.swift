//
//  UnrecognizedChunk Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Chunk_UnrecognizedChunk_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func emptyData() throws {
        let id = "ABCD"
        
        let track = MIDIFile.Chunk.UnrecognizedChunk(id: id)
        
        #expect(track.identifier == id)
        
        let bytes: [UInt8] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x00 // length: 0 bytes to follow
        ]
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        #expect(generatedBytes == bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk
            .UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        #expect(parsedTrack == parsedTrack)
    }
    
    @Test
    func withData() throws {
        let data: [UInt8] = [0x12, 0x34, 0x56, 0x78]
        
        let id = "ABCD"
        
        let track = MIDIFile.Chunk.UnrecognizedChunk(
            id: id,
            rawData: data.data
        )
        
        #expect(track.identifier == id)
        
        let bytes: [UInt8] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x04 // length: 4 bytes to follow
        ] + data  // data bytes
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        #expect(generatedBytes == bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk
            .UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        #expect(parsedTrack == parsedTrack)
    }
}
