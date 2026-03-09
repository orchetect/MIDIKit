//
//  MIDIFileParserFileDescriptor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

struct MIDIFileParserFileDescriptor {
    var header: MIDIFile.Chunk.Header
    var chunkDescriptors: [MIDIFileParserChunkDescriptor]
}

extension MIDIFileParserFileDescriptor: Sendable { }
