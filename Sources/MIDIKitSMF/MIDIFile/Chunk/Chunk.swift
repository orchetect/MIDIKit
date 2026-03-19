//
//  Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile {
    /// MIDI File Chunk.
    ///
    /// As of the Standard MIDI File 1.0 Spec, `MThd` (header) and `MTrk` (track) are the only
    /// defined MIDI file chunks. However, others may be defined in the future.
    ///
    /// In ``MIDIFile``, the ``Chunk/Header`` chunk is managed automatically and is not instanced as
    /// a ``MIDIFile/chunks`` member.
    public enum Chunk {
        case track(Track)
        case other(UnrecognizedChunk)
    }
}

extension MIDIFile.Chunk: Equatable { }

extension MIDIFile.Chunk: Hashable { }

extension MIDIFile.Chunk: Sendable { }

extension MIDIFile.Chunk: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .track(track):
            track.description
            
        case let .other(unrecognizedChunk):
            unrecognizedChunk.description
        }
    }
}

extension MIDIFile.Chunk: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .track(track):
            track.debugDescription
            
        case let .other(unrecognizedChunk):
            unrecognizedChunk.debugDescription
        }
    }
}

// MARK: - Properties

extension MIDIFile.Chunk {
    /// Unwraps the enum case and returns the ``MIDIFile/Chunk`` contained within, typed as
    /// ``MIDIFileChunk`` protocol.
    public var unwrappedChunk: MIDIFileChunk {
        switch self {
        case let .track(chunk):
            chunk
            
        case let .other(chunk):
            chunk
        }
    }
    
    /// MIDI file chunk type.
    public var chunkType: MIDIFile.ChunkType {
        switch self {
        case let .track(chunk): chunk.chunkType
        case let .other(chunk): chunk.chunkType
        }
    }
}
