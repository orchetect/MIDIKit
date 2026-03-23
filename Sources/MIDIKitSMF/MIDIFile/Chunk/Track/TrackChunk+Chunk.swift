//
//  TrackChunk+Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.TrackChunk: MIDIFileChunk {
    public typealias Identifier = TrackMIDIFileChunkIdentifier
    
    public var identifier: Identifier { Self.identifier }
    
    public static var identifier: Identifier { .init() }
}
