//
//  Parser ChunkDescriptor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.Parser {
    struct ChunkDescriptor {
        /// Chunk type (4-character identifier).
        var identifier: any MIDIFile.ChunkIdentifier
        
        /// Byte offset of the start of the chunk.
        var startOffset: Int
        
        /// Byte offset of the body (data portion) of the chunk (after the chunk type and length bytes).
        var bodyByteStartOffset: Int
        
        /// Byte length (count) of the body (data portion) of the chunk (after the chunk type and length bytes).
        var bodyByteLength: Int
    }
}

extension MIDIFile.Parser.ChunkDescriptor: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier.string == rhs.identifier.string
            && lhs.startOffset == rhs.startOffset
            && lhs.bodyByteStartOffset == rhs.bodyByteStartOffset
            && lhs.bodyByteLength == rhs.bodyByteLength
    }
}

extension MIDIFile.Parser.ChunkDescriptor: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier.string)
        hasher.combine(startOffset)
        hasher.combine(bodyByteStartOffset)
        hasher.combine(bodyByteLength)
    }
}

extension MIDIFile.Parser.ChunkDescriptor: Sendable { }
