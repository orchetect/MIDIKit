//
//  Header+MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDI1FileChunkIdentifier {
    /// MIDI file header chunk identifier (`MThd`).
    public static var header: MIDI1FileChunkIdentifier {
        .init(unsafe: "MThd")
    }
}
