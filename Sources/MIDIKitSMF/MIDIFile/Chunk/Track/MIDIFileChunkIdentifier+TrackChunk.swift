//
//  MIDIFileChunkIdentifier+TrackChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDIFileChunkIdentifier where Self == MIDIFile.TrackChunk.Identifier {
    /// Track: `MTrk` chunk identifier.
    public static var track: MIDIFile.TrackChunk.Identifier {
        MIDIFile.TrackChunk.Identifier()
    }
}
