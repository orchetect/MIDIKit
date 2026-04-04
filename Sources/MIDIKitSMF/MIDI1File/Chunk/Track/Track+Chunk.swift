//
//  Track+Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File.Track: MIDI1FileChunk {
    public typealias Identifier = TrackMIDI1FileChunkIdentifier
    
    public var identifier: Identifier { Self.identifier }
    
    public static var identifier: Identifier { .init() }
}
