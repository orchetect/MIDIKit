//
//  MIDIFileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

public protocol MIDIFileChunk: Sendable {
    /// MIDI file chunk identifier type.
    associatedtype Identifier: MIDIFileChunkIdentifier
    
    /// MIDI file chunk identifier.
    var identifier: Identifier { get }
}
