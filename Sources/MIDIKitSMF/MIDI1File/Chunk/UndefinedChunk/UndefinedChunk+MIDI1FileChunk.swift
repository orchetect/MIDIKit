//
//  UndefinedChunk+MIDI1FileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import MIDIKitInternals

extension MIDI1File.UndefinedChunk: MIDI1FileChunk {
    // `identifier` is a stored instance property
    
    public func isEqual(to other: Self) -> Bool {
        identifier == other.identifier
            && rawData == other.rawData
    }
}

// MARK: - Static Constructors

extension MIDI1File.AnyChunk {
    /// Undefined MIDI file chunk.
    public static func undefined(
        identifier: MIDI1FileChunkIdentifier,
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
        guard let id = MIDI1FileChunkIdentifier(string: identifierString) else {
            return nil
        }
        return .undefined(.init(identifier: id, data: data))
    }
}
