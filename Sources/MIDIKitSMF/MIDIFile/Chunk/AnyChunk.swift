//
//  AnyChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

extension MIDIFile {
    /// Type-erased box containing a specialized MIDI file chunk.
    ///
    /// As of the Standard MIDI File 1.0 Spec, `MThd` (header) and `MTrk` (track) are the only
    /// defined MIDI file chunks. However, others may be defined in the future.
    ///
    /// The ``HeaderChunk`` chunk is managed automatically and is not included in this collection.
    /// Its properties can be accessed directly on the ``MIDIFile`` instance.
    public enum AnyChunk {
        case track(_ track: TrackChunk)
        case undefined(_ chunk: UndefinedChunk)
    }
}

extension MIDIFile.AnyChunk: Equatable { }

extension MIDIFile.AnyChunk: Hashable { }

extension MIDIFile.AnyChunk: Sendable { }

extension MIDIFile.AnyChunk: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .track(track): track.description
        case let .undefined(chunk): chunk.description
        }
    }
    
    /// Generate a description of the chunk, optionally limiting the number of track events in the output for track chunks.
    public func description(maxTrackEventCount: Int?) -> String {
        switch self {
        case let .track(track): track.description(maxEventCount: maxTrackEventCount)
        case let .undefined(chunk): chunk.description
        }
    }
}

extension MIDIFile.AnyChunk: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .track(track): track.debugDescription
        case let .undefined(chunk): chunk.debugDescription
        }
    }
    
    /// Generate a debug description of the chunk, optionally limiting the number of track events in the output for track chunks.
    public func debugDescription(maxTrackEventCount: Int?) -> String {
        switch self {
        case let .track(track): track.debugDescription(maxEventCount: maxTrackEventCount)
        case let .undefined(chunk): chunk.debugDescription
        }
    }
}

// MARK: - Properties

extension MIDIFile.AnyChunk {
    /// Unwraps the enum case and returns the chunk contained within, typed as ``MIDIFileChunk`` protocol.
    public var unwrapped: any MIDIFileChunk {
        switch self {
        case let .track(track): track
        case let .undefined(chunk): chunk
        }
    }
    
    /// MIDI file chunk identifier.
    public var identifier: any MIDIFileChunkIdentifier {
        switch self {
        case let .track(track): track.identifier
        case let .undefined(chunk): chunk.identifier
        }
    }
    
    /// Returns `true` if the chunk is a track.
    public var isTrackChunk: Bool {
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
