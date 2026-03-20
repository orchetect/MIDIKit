//
//  AnyChunk.swift
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
    /// In ``MIDIFile``, the ``AnyChunk/Header`` chunk is managed automatically and is not instanced as
    /// a ``MIDIFile/chunks`` member.
    public enum AnyChunk {
        case track(Track)
        case unrecognized(UnrecognizedChunk)
    }
}

extension MIDIFile.AnyChunk: Equatable { }

extension MIDIFile.AnyChunk: Hashable { }

extension MIDIFile.AnyChunk: Sendable { }

extension MIDIFile.AnyChunk: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .track(track):
            track.description
            
        case let .unrecognized(unrecognizedChunk):
            unrecognizedChunk.description
        }
    }
}

extension MIDIFile.AnyChunk: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .track(track):
            track.debugDescription
            
        case let .unrecognized(unrecognizedChunk):
            unrecognizedChunk.debugDescription
        }
    }
}

// MARK: - Properties

extension MIDIFile.AnyChunk {
    /// Unwraps the enum case and returns the ``MIDIFile/AnyChunk`` contained within, typed as
    /// ``MIDIFileChunk`` protocol.
    public var unwrappedChunk: any MIDIFileChunk {
        switch self {
        case let .track(chunk):
            chunk
            
        case let .unrecognized(chunk):
            chunk
        }
    }
    
    /// MIDI file chunk identifier.
    public var identifier: any MIDIFileChunkIdentifier {
        switch self {
        case let .track(chunk): chunk.identifier
        case let .unrecognized(chunk): chunk.identifier
        }
    }
}
