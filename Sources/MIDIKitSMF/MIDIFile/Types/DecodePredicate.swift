//
//  DecodePredicate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file decoding predicate.
    public typealias DecodePredicate = @Sendable (_ chunkType: ChunkType, _ chunkIndex: Int) -> Bool
}
