//
//  Header+Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File.Header: MIDI1FileChunk {
    public typealias Identifier = HeaderMIDI1FileChunkIdentifier
    
    public var identifier: Identifier { Self.identifier }
    
    public static var identifier: Identifier { .init() }
}
