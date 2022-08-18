//
//  UnrecognizedChunk Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Chunk_UnrecognizedChunk_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    func testEmptyData() throws {
        let id: String = "ABCD"
        
        let track = MIDIFile.Chunk.UnrecognizedChunk(id: id)
        
        XCTAssertEqual(track.identifier, id)
        
        let bytes: [Byte] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x00 // length: 0 bytes to follow
        ]
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        XCTAssertEqual(generatedBytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk
            .UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        XCTAssertEqual(parsedTrack, parsedTrack)
    }
    
    func testWithData() throws {
        let data: [Byte] = [0x12, 0x34, 0x56, 0x78]
        
        let id: String = "ABCD"
        
        let track = MIDIFile.Chunk.UnrecognizedChunk(
            id: id,
            rawData: data.data
        )
        
        XCTAssertEqual(track.identifier, id)
        
        let bytes: [Byte] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x04 // length: 4 bytes to follow
        ] + data  // data bytes
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        XCTAssertEqual(generatedBytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk
            .UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        XCTAssertEqual(parsedTrack, parsedTrack)
    }
    
    // MARK: - Edge Cases
}

#endif
