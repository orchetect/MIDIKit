//
//  MIDIFileChunkIdentifier+UnrecognizedChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDIFile.ChunkIdentifier where Self == MIDIFile.UnrecognizedChunk.Identifier {
    /// Initialize from an unrecognized (non-standard) chunk identifier.
    /// This identifier must be different from the header identifier (`MThd`) and the track identifier (`MTrk`).
    public static func unrecognized(identifier: String) -> MIDIFile.UnrecognizedChunk.Identifier? {
        MIDIFile.UnrecognizedChunk.Identifier(string: identifier)
    }
}
