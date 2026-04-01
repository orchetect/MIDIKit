//
//  HeaderChunk+MIDIFileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// MIDI file header chunk identifier (`MThd`).
public struct HeaderMIDIFileChunkIdentifier: MIDIFileChunkIdentifier {
    public let string: String = "MThd"
    
    public init() { }
}

// MARK: - Static Constructor

extension MIDIFileChunkIdentifier where Self == HeaderMIDIFileChunkIdentifier {
    /// MIDI file header chunk identifier (`MThd`).
    public static var header: HeaderMIDIFileChunkIdentifier {
        HeaderMIDIFileChunkIdentifier()
    }
}
