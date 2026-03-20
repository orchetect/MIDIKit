//
//  Parser FileDescriptor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.Parser {
    struct FileDescriptor {
        var header: MIDIFile.HeaderChunk
        var chunkDescriptors: [ChunkDescriptor]
    }
}

extension MIDIFile.Parser.FileDescriptor: Equatable { }

extension MIDIFile.Parser.FileDescriptor: Hashable { }

extension MIDIFile.Parser.FileDescriptor: Sendable { }
