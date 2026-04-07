//
//  Parser ChunkDescriptor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File.Parser {
    struct ChunkDescriptor {
        /// Chunk type (4-character identifier).
        var identifier: MIDI1FileChunkIdentifier
        
        /// Byte offset of the start of the chunk.
        var startOffset: Int
        
        /// Byte offset of the body (data portion) of the chunk (after the chunk type and length bytes).
        var bodyByteStartOffset: Int
        
        /// Byte length (count) of the body (data portion) of the chunk (after the chunk type and length bytes).
        var bodyByteLength: Int
    }
}

extension MIDI1File.Parser.ChunkDescriptor: Equatable { }

extension MIDI1File.Parser.ChunkDescriptor: Hashable { }

extension MIDI1File.Parser.ChunkDescriptor: Sendable { }
