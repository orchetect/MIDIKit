//
//  Chunk.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile {
    public enum Chunk: Equatable {
        case track(Track)
        case other(UnrecognizedChunk)
    }
}

extension MIDIFile.Chunk {
    public static func track(_ events: [MIDIFileEvent]) -> Self {
        .track(.init(events: events))
    }
    
    public static func other(id: String, rawData: Data? = nil) -> Self {
        .other(.init(id: id, rawData: rawData))
    }
}

extension MIDIFile.Chunk: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case let .track(track):
            return track.description
            
        case let .other(unrecognizedChunk):
            return unrecognizedChunk.description
        }
    }
    
    public var debugDescription: String {
        switch self {
        case let .track(track):
            return track.debugDescription
            
        case let .other(unrecognizedChunk):
            return unrecognizedChunk.debugDescription
        }
    }
}

extension MIDIFile.Chunk {
    /// Unwraps the enum case and returns the `MIDIFile.Chunk` contained within, typed as `MIDIFileChunk` protocol.
    public var unwrappedChunk: MIDIFileChunk {
        switch self {
        case let .track(chunk):
            return chunk
            
        case let .other(chunk):
            return chunk
        }
    }
}

extension MIDIFileChunk {
    /// Wraps the concrete struct in its corresponding `MIDIFile.Chunk` enum case wrapper.
    public var wrappedChunk: MIDIFile.Chunk {
        switch self {
        case let chunk as MIDIFile.Chunk.Track:
            return .track(chunk)
            
        case let chunk as MIDIFile.Chunk.UnrecognizedChunk:
            return .other(chunk)
            
        default:
            fatalError()
        }
    }
}
