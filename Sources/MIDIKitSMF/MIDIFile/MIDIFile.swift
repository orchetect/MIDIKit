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
}

// Sendable must be applied in the same file as the struct for it to be compiler-checked.
extension MIDIFile: Sendable { }

// MARK: - Init: Raw Data

extension MIDIFile {
    /// Initialize by loading the contents of a MIDI file's raw data.
    @available(*, deprecated, message: "This method is less performant than its async variant. Considering calling with await.")
    public init(rawData: some DataProtocol & Sendable) throws(DecodeError) {
        try decode(rawData: rawData)
    }
    
    /// Initialize by loading the contents of a MIDI file's raw data.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(rawData: some DataProtocol & Sendable) async throws(DecodeError) {
        try await decode(rawData: rawData)
    }
}

// MARK: - Init: File Path

extension MIDIFile {
    /// Initialize by loading the contents of a MIDI file from disk.
    @available(*, deprecated, message: "This method is less performant than its async variant. Considering calling with await.")
    public init(midiFile path: String) throws(DecodeError) {
        let url = try Self.url(forFilePath: path)
        try self.init(midiFile: url)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(midiFile path: String) async throws(DecodeError) {
        let url = try Self.url(forFilePath: path)
        try await self.init(midiFile: url)
    }
    
    static func url(forFilePath path: String) throws(DecodeError) -> URL {
        guard FileManager.sendableDefault.fileExists(atPath: path) else {
            throw .fileNotFound
        }
        
        guard let url = URL(string: path) else {
            throw .malformedURL
        }
        
        return url
    }
}

// MARK: - Init: File URL

extension MIDIFile {
    /// Initialize by loading the contents of a MIDI file from disk.
    @available(*, deprecated, message: "This method is less performant than its async variant. Considering calling with await.")
    public init(midiFile url: URL) throws(DecodeError) {
        let data = try Self.data(forFileURL: url)
        try decode(rawData: data)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(midiFile url: URL) async throws(DecodeError) {
        let data = try Self.data(forFileURL: url)
        try await decode(rawData: data)
    }
    
    static func data(forFileURL url: URL) throws(DecodeError) -> Data {
        do { return try Data(contentsOf: url) }
        catch { throw .fileReadError }
    }
}

// MARK: - Properties

extension MIDIFile {
    /// Returns raw MIDI file data. Throws an error if a problem occurs.
    public func rawData() throws(EncodeError) -> Data {
        try encode()
    }
    
    // TODO: add async version of rawData() that can build file contents concurrently (encode tracks in parallel using withTaskGroup)
}

// MARK: - Utilities

extension FileManager {
    // `FileManager` is thread-safe but doesn't yet conform to Sendable,
    // so we can coerce it to be treated as Sendable.
    fileprivate static func fileManager() -> @Sendable () -> FileManager { { Self.default } }
    fileprivate static var sendableDefault: FileManager { fileManager()() }
}
