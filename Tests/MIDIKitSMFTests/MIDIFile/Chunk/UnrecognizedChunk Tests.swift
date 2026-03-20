//
//  UnrecognizedChunk Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct Chunk_UnrecognizedChunk_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func emptyData() async throws {
        let id: MIDIFile.AnyChunk.UnrecognizedChunk.Identifier = .unrecognized(identifier: "ABCD")!
        
        let chunk = MIDIFile.AnyChunk.UnrecognizedChunk(identifier: id)
        
        #expect(chunk.identifier == id)
        
        let bytes: [UInt8] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x00 // length: 0 bytes to follow
        ]
        
        // generate raw bytes
        
        let generatedBytes = try chunk.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(generatedBytes == bytes)
        
        // parse raw bytes
        
        let parsedChunk = try MIDIFile.AnyChunk
            .UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        #expect(parsedChunk == parsedChunk)
    }
    
    @Test
    func withData() async throws {
        let data: [UInt8] = [0x12, 0x34, 0x56, 0x78]
        
        let id: MIDIFile.AnyChunk.UnrecognizedChunk.Identifier = .unrecognized(identifier: "ABCD")!
        
        let chunk = MIDIFile.AnyChunk.UnrecognizedChunk(
            identifier: id,
            data: data.toData()
        )
        
        #expect(chunk.identifier == id)
        
        let bytes: [UInt8] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x04 // length: 4 bytes to follow
        ] + data  // data bytes
        
        // generate raw bytes
        
        let generatedBytes = try chunk.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(generatedBytes == bytes)
        
        // parse raw bytes
        
        let parsedChunk = try MIDIFile.AnyChunk
            .UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        #expect(parsedChunk == parsedChunk)
    }
}
