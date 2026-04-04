//
//  UndefinedChunk+MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDI1FileChunkIdentifier {
    /// Undefined (non-standard) chunk identifier.
    /// This identifier must be different from the header identifier (`MThd`) and the track identifier (`MTrk`).
    public static func undefined(identifier: String) -> MIDI1FileChunkIdentifier? {
        MIDI1FileChunkIdentifier(string: identifier)
    }
}
