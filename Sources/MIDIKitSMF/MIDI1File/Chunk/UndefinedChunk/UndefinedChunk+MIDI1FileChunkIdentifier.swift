//
//  UndefinedChunk+MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Undefined (non-standard) chunk identifier.
/// This identifier must be different from the header identifier (`MThd`) and the track identifier (`MTrk`).
public struct UndefinedMIDI1FileChunkIdentifier: MIDI1FileChunkIdentifier {
    public let string: String
    
    /// Initialize from an undefined (non-standard) 4-character ASCII chunk identifier.
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
    
    static var disallowedIdentifiers: [String] {
        [
            HeaderMIDI1FileChunkIdentifier().string,
            TrackMIDI1FileChunkIdentifier().string
        ]
    }
}

// MARK: - Static Constructor

extension MIDI1FileChunkIdentifier where Self == UndefinedMIDI1FileChunkIdentifier {
    /// Undefined (non-standard) chunk identifier.
    /// This identifier must be different from the header identifier (`MThd`) and the track identifier (`MTrk`).
    public static func undefined(identifier: String) -> UndefinedMIDI1FileChunkIdentifier? {
        UndefinedMIDI1FileChunkIdentifier(string: identifier)
    }
}
