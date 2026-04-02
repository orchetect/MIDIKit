//
//  UndefinedChunk+Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import MIDIKitInternals

extension MIDI1File.UndefinedChunk: MIDI1FileChunk {
    public typealias Identifier = UndefinedMIDI1FileChunkIdentifier
    
    // `identifier` is a stored property
}

// MARK: - Static Constructors

extension MIDI1File.AnyChunk {
    /// Undefined MIDI file chunk.
    public static func undefined(
        identifier: MIDI1File<Timebase>.UndefinedChunk.Identifier,
        data: Data? = nil
    ) -> Self {
        .undefined(.init(identifier: identifier, data: data))
    }
    
    /// Undefined MIDI file chunk.
    @_disfavoredOverload
    public static func undefined(
        identifier identifierString: String,
        data: Data? = nil
    ) -> Self? {
        guard let id = MIDI1File<Timebase>.UndefinedChunk.Identifier(string: identifierString) else {
            return nil
        }
        return .undefined(.init(identifier: id, data: data))
    }
}
