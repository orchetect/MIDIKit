//
//  Track+MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDI1FileChunkIdentifier {
    /// MIDI file track chunk identifier (`MTrk`).
    public static var track: MIDI1FileChunkIdentifier {
        .init(unsafe: "MTrk")
    }
}
