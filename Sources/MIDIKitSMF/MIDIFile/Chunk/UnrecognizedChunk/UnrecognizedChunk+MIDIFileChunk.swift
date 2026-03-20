//
//  UnrecognizedChunk+MIDIFileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import MIDIKitInternals

extension MIDIFile.AnyChunk.UnrecognizedChunk: MIDIFileChunk {
    public struct Identifier: MIDIFileChunkIdentifier {
        public let string: String
        
        /// Initialize from an unrecognized (non-standard) 4-character ASCII chunk identifier.
        /// This identifier must be different from the header identifier (`MThd`) and the track identifier (`MTrk`).
        ///
        /// - Returns: This initializer will fail if one of the reserved identifiers is used, if the identifier is not
        ///   exactly 4 characters in length, or if any characters are non-ASCII.
        public init?(string: String) {
            guard !Self.disallowedIdentifiers.contains(string),
                  string.count == 4,
                  string.allSatisfy(\.isASCII)
            else {
                return nil
            }
            self.string = string
        }
        
        /// Internal lossy non-failable init.
        init(lossy string: String) {
            if let validated = Self(string: string) {
                self = validated
            } else {
                if Self.disallowedIdentifiers.contains(string) {
                    self.string = "????"
                } else {
                    let validated = (string.convertToASCII() + "????")
                        .prefix(4)
                    self.string = String(validated)
                }
            }
        }
        
        static let disallowedIdentifiers: [String] = [
            MIDIFile.HeaderChunk.identifier.string,
            MIDIFile.TrackChunk.identifier.string
        ]
    }
    
    // `identifier` is a stored property
}

// MARK: - Static Constructors

extension MIDIFile.AnyChunk {
    /// Unrecognized MIDI File Chunk.
    public static func unrecognized(
        identifier: UnrecognizedChunk.Identifier,
        data: Data? = nil
    ) -> Self {
        .unrecognized(.init(identifier: identifier, data: data))
    }
    
    /// Unrecognized MIDI File Chunk.
    @_disfavoredOverload
    public static func unrecognized(
        identifier identifierString: String,
        data: Data? = nil
    ) -> Self? {
        guard let id = UnrecognizedChunk.Identifier(string: identifierString) else {
            return nil
        }
        return .unrecognized(.init(identifier: id, data: data))
    }
}
