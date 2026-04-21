//
//  AnyChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

extension MIDI1File {
    /// Type-erased box containing a specialized MIDI file chunk.
    ///
    /// As of the Standard MIDI File 1.0 Spec, `MThd` (header) and `MTrk` (track) are the only
    /// defined MIDI file chunks. However, others may be defined in the future.
    ///
    /// The ``Header`` chunk is managed automatically and is not included in this collection.
    /// Its properties can be accessed directly on the ``MIDI1File`` instance.
    public enum AnyChunk {
        case track(_ track: Track)
        case undefined(_ chunk: UndefinedChunk)
    }
}

extension MIDI1File.AnyChunk: Equatable { }

extension MIDI1File.AnyChunk: Hashable { }

extension MIDI1File.AnyChunk: Identifiable {
    public var id: UUID {
        switch self {
        case let .track(track): track.id
        case let .undefined(chunk): chunk.id
        }
    }
}

extension MIDI1File.AnyChunk: Sendable { }

extension MIDI1File.AnyChunk: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .track(track): track.description
        case let .undefined(chunk): chunk.description
        }
    }
    
    /// Generate a description of the chunk, optionally limiting the number of track events in the output for track chunks.
    public func description(maxEventCount: Int?) -> String {
        switch self {
        case let .track(track): track.description(maxEventCount: maxEventCount)
        case let .undefined(chunk): chunk.description
        }
    }
}

extension MIDI1File.AnyChunk: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .track(track): track.debugDescription
        case let .undefined(chunk): chunk.debugDescription
        }
    }
    
    /// Generate a debug description of the chunk, optionally limiting the number of track events in the output for track chunks.
    public func debugDescription(maxEventCount: Int?) -> String {
        switch self {
        case let .track(track): track.debugDescription(maxEventCount: maxEventCount)
        case let .undefined(chunk): chunk.debugDescription
        }
    }
}

// MARK: - Properties

extension MIDI1File.AnyChunk {
    /// Unwraps the enum case and returns the chunk contained within, typed as ``MIDI1FileChunk`` protocol.
    public var wrapped: any MIDI1FileChunk {
        switch self {
        case let .track(track): track
        case let .undefined(chunk): chunk
        }
    }
    
    /// Returns `true` if the chunk is a track.
    public var isTrack: Bool {
        switch self {
        case .track: true
        default: false
        }
    }
    
    /// Returns `true` if the chunk is an undefined (non-track) chunk.
    public var isUndefinedChunk: Bool {
        switch self {
        case .undefined: true
        default: false
        }
    }
}
