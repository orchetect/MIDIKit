//
//  Parser FileDescriptor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File.Parser {
    struct FileDescriptor {
        var header: MIDI1File.Header
        var chunkDescriptors: [ChunkDescriptor]
    }
}

extension MIDI1File.Parser.FileDescriptor: Equatable { }

extension MIDI1File.Parser.FileDescriptor: Hashable { }

extension MIDI1File.Parser.FileDescriptor: Sendable { }
