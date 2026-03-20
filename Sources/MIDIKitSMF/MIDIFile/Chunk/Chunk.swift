//
//  Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    public protocol Chunk: Sendable {
        /// MIDI file chunk identifier type.
        associatedtype Identifier: ChunkIdentifier
        
        /// MIDI file chunk identifier.
        var identifier: Identifier { get }
    }
}
