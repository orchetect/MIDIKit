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
    
    var header: AnyChunk.Header = .init()
    
    /// MIDI File Format to use when writing MIDI file.
    public var format: Format {
        get { header.format }
        set { header.format = newValue }
    }
    
    /// Specify whether the MIDI file stores time values in bars & beats (musical) or timecode
    public var timebase: Timebase {
        get { header.timebase }
        set { header.timebase = newValue }
    }
    
    /// Storage for tracks in the MIDI file.
    ///
    /// The ``AnyChunk/Header`` chunk is managed automatically and is not instanced as a
    /// ``MIDIFile/chunks`` member.
    public var chunks: [AnyChunk] = []
    
    /// Returns copies of the tracks contained in the MIDI file.
    /// (Computed convenience to filter ``chunks`` and return ``AnyChunk/Track`` instances.)
    /// To add new tracks or modify existing tracks, mutate the ``chunks`` collection.
    public var tracks: [AnyChunk.Track] {
        chunks.compactMap {
            guard case let .track(track) = $0 else { return nil }
            return track
        }
    }
    
    // Identifiable protocol conformance implementation
    public let id: UUID = .init()
    
    // MARK: - Init
    
    /// Initialize from header parameters and chunks.
    public init(
        format: Format = .multipleTracksSynchronous,
        timebase: Timebase = .default(),
        chunks: [AnyChunk] = []
    ) {
        self.format = format
        self.timebase = timebase
        self.chunks = chunks
    }
    
    /// Initialize from header parameters and chunks.
    @_disfavoredOverload
    public init(
        format: Format = .multipleTracksSynchronous,
        timebase: Timebase = .default(),
        chunks: some Sequence<AnyChunk> = []
    ) {
        self.format = format
        self.timebase = timebase
        self.chunks = Array(chunks)
    }
    
    /// Initialize from header parameters and track chunks.
    public init(
        format: Format = .multipleTracksSynchronous,
        timebase: Timebase = .default(),
        tracks: [AnyChunk.Track]
    ) {
        self.format = format
        self.timebase = timebase
        self.chunks = tracks.map { .track($0) }
    }
    
    /// Initialize from header parameters and track chunks.
    @_disfavoredOverload
    public init(
        format: Format = .multipleTracksSynchronous,
        timebase: Timebase = .default(),
        tracks: some Sequence<AnyChunk.Track>
    ) {
        self.format = format
        self.timebase = timebase
        self.chunks = Array(tracks.map { .track($0) })
    }
}

// Sendable must be applied in the same file as the struct for it to be compiler-checked.
extension MIDIFile: Sendable { }
