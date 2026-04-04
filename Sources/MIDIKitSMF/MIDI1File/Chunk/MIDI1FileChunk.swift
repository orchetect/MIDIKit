//
//  MIDI1FileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Protocol defining a Standard MIDI File chunk.
public protocol MIDI1FileChunk: Equatable, Hashable, Sendable {
    /// MIDI file chunk identifier.
    var identifier: MIDI1FileChunkIdentifier { get }
}
