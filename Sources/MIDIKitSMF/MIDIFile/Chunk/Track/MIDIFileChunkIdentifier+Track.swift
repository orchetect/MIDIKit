//
//  MIDIFileChunkIdentifier+Track.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDIFileChunkIdentifier where Self == MIDIFile.AnyChunk.Track.Identifier {
    /// Track: `MTrk` chunk identifier.
    public static var track: MIDIFile.AnyChunk.Track.Identifier {
        MIDIFile.AnyChunk.Track.Identifier()
    }
}
