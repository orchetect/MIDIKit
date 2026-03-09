//
//  MIDIFileParserChunkDescriptor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

struct MIDIFileParserChunkDescriptor {
    /// 4-Character Chunk type string.
    var typeString: String
    
    /// Byte offset of the start of the chunk.
    var startOffset: Int
    
    /// Byte offset of the body (data portion) of the chunk (after the chunk type and length bytes).
    var bodyByteStartOffset: Int
    
    /// Byte length (count) of the body (data portion) of the chunk (after the chunk type and length bytes).
    var bodyByteLength: Int
}

extension MIDIFileParserChunkDescriptor: Sendable { }
