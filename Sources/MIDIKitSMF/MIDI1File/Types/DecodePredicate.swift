//
//  DecodePredicate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File {
    /// MIDI file decoding predicate.
    public typealias DecodePredicate = @Sendable (
        _ chunkIdentifier: any MIDI1FileChunkIdentifier,
        _ chunkIndex: Int
    ) -> Bool
}
