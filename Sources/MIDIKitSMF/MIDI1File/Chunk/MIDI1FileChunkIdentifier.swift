//
//  MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// 4-character ASCII string identifying the chunk.
///
/// For standard MIDI tracks, this is `MTrk`.
/// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
public struct MIDI1FileChunkIdentifier {
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is `MTrk`.
    /// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
    public let string: String
    
    /// Internal init.
    init(unsafe string: String) {
        assert(string.count == 4)
        self.string = string
    }
}

extension MIDI1FileChunkIdentifier: Equatable { }

extension MIDI1FileChunkIdentifier: Hashable { }

extension MIDI1FileChunkIdentifier: Sendable { }

// MARK: - Static

extension MIDI1FileChunkIdentifier {
    /// Returns reserved chunk identifiers defined in the Standard MIDI File 1.0 spec.
    public static var definedIdentifiers: [Self] {
        [
            MIDI1FileChunkIdentifier.header,
            MIDI1FileChunkIdentifier.track
        ]
    }
}

// MARK: - Inits

extension MIDI1FileChunkIdentifier {
    /// Initialize from a (non-standard) 4-character ASCII chunk identifier.
    ///
    /// - Returns: This initializer will fail if the string is not exactly four characters.
    ///   Additionally, all characters must be valid ASCII characters.
    public init?(string: String) {
        guard string.count == 4,
              string.allSatisfy(\.isASCII)
        else {
            return nil
        }
        self.string = string
    }
    
    /// Initialize from an undefined (non-standard) 4-character ASCII chunk identifier.
    /// This identifier must be different from the header identifier (`MThd`) and the track identifier (`MTrk`).
    ///
    /// - Returns: This initializer will fail if one of the reserved identifiers is used, if the identifier is not
    ///   exactly 4 characters in length, or if any characters are non-ASCII.
    public init?(undefined string: String) {
        guard !Self.definedIdentifiers.map(\.string).contains(string),
              let id = Self(string: string)
        else {
            return nil
        }
        self = id
    }
    
    /// Internal lossy non-failable init.
    init(lossy string: String) {
        if let validated = Self(string: string) {
            self = validated
        } else {
            if Self.definedIdentifiers.map(\.string).contains(string) {
                self.string = "????"
            } else {
                let validated = (string.convertToASCII() + "????")
                    .prefix(4)
                self.string = String(validated)
            }
        }
    }
}
