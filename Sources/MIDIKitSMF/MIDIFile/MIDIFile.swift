//
//  MIDIFile.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Standard MIDI Files (SMF) object. Read or write MIDI file contents.
public struct MIDIFile {
    // MARK: - Properties
    
    var header: Chunk.Header = .init()
    
    /// MIDI File Format to use when writing MIDI file.
    public var format: Format {
        get { header.format }
        set { header.format = newValue }
    }
    
    /// Specify whether the MIDI file stores time values in bars & beats (musical) or timecode
    public var timeBase: TimeBase {
        get { header.timeBase }
        set { header.timeBase = newValue }
    }
    
    /// Storage for tracks in the MIDI file.
    ///
    /// The ``Chunk/Header`` chunk is managed automatically and is not instanced as a
    /// ``MIDIFile/chunks`` member.
    public var chunks: [Chunk] = []
    
    /// Returns copies of the tracks contained in the MIDI file.
    /// (Computed convenience to filter ``chunks`` and return ``Chunk/Track`` instances.)
    /// To add new tracks or modify existing tracks, mutate the ``chunks`` collection.
    public var tracks: [Chunk.Track] {
        chunks.compactMap {
            guard case let .track(track) = $0 else { return nil }
            return track
        }
    }
    
    // Identifiable protocol conformance implementation
    public let id: UUID = .init()
    
    // MARK: - Init
    
    /// Initialize from header parameters and track chunks.
    public init(
        format: Format = .multipleTracksSynchronous,
        timeBase: TimeBase = .default(),
        chunks: [Chunk] = []
    ) {
        self.format = format
        self.timeBase = timeBase
        self.chunks = chunks
    }
    
    /// Initialize from header parameters and track chunks.
    public init(
        format: Format = .multipleTracksSynchronous,
        timeBase: TimeBase = .default(),
        chunks: some Sequence<Chunk> = []
    ) {
        self.format = format
        self.timeBase = timeBase
        self.chunks = Array(chunks)
    }
}

// Sendable must be applied in the same file as the struct for it to be compiler-checked.
extension MIDIFile: Sendable { }
