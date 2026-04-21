//
//  Header+MIDI1FileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File.Header: MIDI1FileChunk {
    public var identifier: MIDI1FileChunkIdentifier { Self.identifier }
    
    public static var identifier: MIDI1FileChunkIdentifier { .header }
    
    public func isEqual(to other: Self) -> Bool {
        // header does not conform to Identifiable or contain an `id` property
        self == other
    }
}
