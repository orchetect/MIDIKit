//
//  HeaderChunk+Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.HeaderChunk: MIDIFileChunk {
    public typealias Identifier = HeaderMIDIFileChunkIdentifier
    
    public var identifier: Identifier { Self.identifier }
    
    public static var identifier: Identifier { .init() }
}
