//
//  UndefinedChunk+Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import MIDIKitInternals

extension MIDIFile.UndefinedChunk: MIDIFileChunk {
    public typealias Identifier = UndefinedMIDIFileChunkIdentifier
    
    // `identifier` is a stored property
}

// MARK: - Static Constructors

extension MIDIFile.AnyChunk {
    /// Undefined MIDI file chunk.
    public static func undefined(
        identifier: MIDIFile<Timebase>.UndefinedChunk.Identifier,
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
        guard let id = MIDIFile<Timebase>.UndefinedChunk.Identifier(string: identifierString) else {
            return nil
        }
        return .undefined(.init(identifier: id, data: data))
    }
}
