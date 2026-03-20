//
//  MIDIFileChunkIdentifier+Header.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Static Constructor

extension MIDIFileChunkIdentifier where Self == MIDIFile.AnyChunk.Header.Identifier {
    /// Header: `MThd` chunk identifier.
    public static var header: MIDIFile.AnyChunk.Header.Identifier {
        MIDIFile.AnyChunk.Header.Identifier()
    }
}
