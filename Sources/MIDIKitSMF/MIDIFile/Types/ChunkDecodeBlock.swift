//
//  ChunkDecodeBlock.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file chunk decode result block.
    public typealias ChunkDecodeBlock = @Sendable (
        _ fileHeader: HeaderChunk,
        _ chunkCount: Int,
        _ chunkIndex: Int,
        _ result: Result<AnyChunk, DecodeError>
    ) -> Void
}
