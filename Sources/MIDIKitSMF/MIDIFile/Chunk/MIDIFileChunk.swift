//
//  MIDIFileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Protocol defining a Standard MIDI File chunk.
public protocol MIDIFileChunk: Equatable, Hashable, Sendable {
    /// MIDI file chunk identifier type.
    associatedtype Identifier: MIDIFileChunkIdentifier
    
    /// MIDI file chunk identifier.
    var identifier: Identifier { get }
}
