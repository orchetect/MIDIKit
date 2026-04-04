//
//  Header+MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// MIDI file header chunk identifier (`MThd`).
public struct HeaderMIDI1FileChunkIdentifier: MIDI1FileChunkIdentifier {
    public let string: String = "MThd"
    
    public init() { }
}

// MARK: - Static Constructor

extension MIDI1FileChunkIdentifier where Self == HeaderMIDI1FileChunkIdentifier {
    /// MIDI file header chunk identifier (`MThd`).
    public static var header: HeaderMIDI1FileChunkIdentifier {
        HeaderMIDI1FileChunkIdentifier()
    }
}
