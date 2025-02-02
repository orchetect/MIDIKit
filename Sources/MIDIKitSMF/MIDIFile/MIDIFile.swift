//
//  MIDIFile.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension FileManager {
    // `FileManager` is thread-safe but doesn't yet conform to Sendable,
    // so we can coerce it to be treated as Sendable.
    fileprivate static func fileManager() -> @Sendable () -> FileManager { { Self.default } }
    fileprivate static var sendableDefault: FileManager { fileManager()() }
}

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
    
    // Identifiable protocol conformance fulfilment
    public let id: UUID = .init()
    
    // MARK: - Init
    
    /// Initialize with default values.
    public init() { }
    
    /// Initialize from header parameters and track chunks.
    public init(
        format: Format = .multipleTracksSynchronous,
        timeBase: TimeBase,
        chunks: [Chunk] = []
    ) {
        self.init()
        
        self.format = format
        self.timeBase = timeBase
        self.chunks = chunks
    }
    
    /// Initialize by loading the contents of a MIDI file's raw data.
    public init(rawData: Data) throws {
        try decode(rawData: rawData)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk.
    public init(midiFile path: String) throws {
        guard FileManager.sendableDefault.fileExists(atPath: path) else {
            throw DecodeError.fileNotFound
        }
        
        guard let url = URL(string: path) else {
            throw DecodeError.malformedURL
        }
        
        try self.init(midiFile: url)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk.
    public init(midiFile url: URL) throws {
        let data = try Data(contentsOf: url)
        
        try decode(rawData: data)
    }
    
    /// Returns raw MIDI file data. Throws an error if a problem occurs.
    public func rawData() throws -> Data {
        try encode()
    }
}

// Sendable must be applied in the same file as the struct for it to be compiler-checked.
extension MIDIFile: Sendable { }
