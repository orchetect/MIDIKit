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
    
    var header: HeaderChunk = .init()
    
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
    
    /// Chunks contained in the MIDI file.
    /// This includes tracks and non-track chunks if present.
    /// (If only tracks access is desired, accessing the ``tracks`` property to read and write track data is more convenient.)
    ///
    /// The ``HeaderChunk`` chunk is managed automatically and is not included in this collection.
    /// Its properties can be accessed directly on the ``MIDIFile`` instance.
    public var chunks: [AnyChunk] {
        _read { yield _chunks }
        _modify {
            yield &_chunks
            _tracks = Array(_chunks.tracks)
        }
        set {
            _chunks = newValue
            _tracks = Array(newValue.tracks)
        }
    }
    private var _chunks: [AnyChunk] = []
        
    /// Access the track chunks contained in ``chunks``.
    /// Indexes are rebased to zero when accessing this collection.
    /// 
    /// Updating this collection automatically updates the corresponding track chunks in ``chunks``.
    public var tracks: [TrackChunk] {
        _read { yield _tracks }
        _modify {
            yield &_tracks
            _chunks.updateTracks(with: _tracks)
        }
        set {
            _tracks = newValue
            _chunks.updateTracks(with: newValue)
        }
    }
    private var _tracks: [TrackChunk] = []
        
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
        tracks: [TrackChunk]
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
        tracks: some Sequence<TrackChunk>
    ) {
        self.format = format
        self.timebase = timebase
        self.chunks = Array(tracks.map { .track($0) })
    }
}

// Sendable must be applied in the same file as the struct for it to be compiler-checked.
extension MIDIFile: Sendable { }
