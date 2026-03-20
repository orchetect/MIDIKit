//
//  MIDIFileChunkIdentifier+Track.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDIFileChunkIdentifier where Self == MIDIFile.Chunk.Track.Identifier {
    /// Track: `MTrk` chunk identifier.
    public static var track: MIDIFile.Chunk.Track.Identifier {
        MIDIFile.Chunk.Track.Identifier()
    }
}
