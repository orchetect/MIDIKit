//
//  MIDIFileChunkIdentifier+HeaderChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDIFile.ChunkIdentifier where Self == MIDIFile.HeaderChunk.Identifier {
    /// Header: `MThd` chunk identifier.
    public static var header: MIDIFile.HeaderChunk.Identifier {
        MIDIFile.HeaderChunk.Identifier()
    }
}
