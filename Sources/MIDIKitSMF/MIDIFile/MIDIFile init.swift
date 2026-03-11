//
//  MIDIFile init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Init: Raw Data

extension MIDIFile {
    /// Initialize by loading the contents of a MIDI file's raw data.
    public init(
        rawData: some DataProtocol & Sendable,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) throws(DecodeError) {
        try decode(
            rawData: rawData,
            bundleRPNAndNRPNEvents: options.bundleRPNAndNRPNEvents,
            maxTrackEventCount: options.maxTrackEventCount,
            predicate: predicate
        )
    }
    
    /// Initialize by loading the contents of a MIDI file's raw data, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        rawData: some DataProtocol & Sendable,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) async throws(DecodeError) {
        try await decode(
            rawData: rawData,
            bundleRPNAndNRPNEvents: options.bundleRPNAndNRPNEvents,
            maxTrackEventCount: options.maxTrackEventCount,
            predicate: predicate
        )
    }
    
    /// Initialize by loading the contents of a MIDI file's raw data, parsing chunks concurrently for improved performance.
    /// As each chunk completes parsing, a closure is called with the parsing results and the chunk's content.
    ///
    /// If the file header cannot be parsed or overall file structure is malformed, this method throws an error.
    /// Errors encountered during individual chunk parsing are returned within the result closure and not thrown from this method.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        rawData: some DataProtocol & Sendable,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(DecodeError) {
        try await decode(
            rawData: rawData,
            bundleRPNAndNRPNEvents: options.bundleRPNAndNRPNEvents,
            maxTrackEventCount: options.maxTrackEventCount,
            predicate: predicate,
            parsedChunk: parsedChunk
        )
    }
}

// MARK: - Init: File Path

extension MIDIFile {
    /// Initialize by loading the contents of a MIDI file from disk.
    public init(
        midiFile path: String,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) throws(DecodeError) {
        let url = try Self.url(forFilePath: path)
        try self.init(midiFile: url, options: options, predicate: predicate)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        midiFile path: String,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) async throws(DecodeError) {
        let url = try Self.url(forFilePath: path)
        try await self.init(midiFile: url, options: options, predicate: predicate)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    /// As each chunk completes parsing, a closure is called with the parsing results and the chunk's content.
    ///
    /// If the file header cannot be parsed or overall file structure is malformed, this method throws an error.
    /// Errors encountered during individual chunk parsing are returned within the result closure and not thrown from this method.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        midiFile path: String,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(DecodeError) {
        let url = try Self.url(forFilePath: path)
        try await self.init(midiFile: url, options: options, predicate: predicate, parsedChunk: parsedChunk)
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
    public init(
        midiFile url: URL,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) throws(DecodeError) {
        let data = try Self.data(forFileURL: url)
        try decode(
            rawData: data,
            bundleRPNAndNRPNEvents: options.bundleRPNAndNRPNEvents,
            maxTrackEventCount: options.maxTrackEventCount,
            predicate: predicate
        )
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        midiFile url: URL,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) async throws(DecodeError) {
        let data = try Self.data(forFileURL: url)
        try await decode(
            rawData: data,
            bundleRPNAndNRPNEvents: options.bundleRPNAndNRPNEvents,
            maxTrackEventCount: options.maxTrackEventCount,
            predicate: predicate
        )
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    /// As each chunk completes parsing, a closure is called with the parsing results and the chunk's content.
    ///
    /// If the file header cannot be parsed or overall file structure is malformed, this method throws an error.
    /// Errors encountered during individual chunk parsing are returned within the result closure and not thrown from this method.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        midiFile url: URL,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(DecodeError) {
        let data = try Self.data(forFileURL: url)
        try await decode(
            rawData: data,
            bundleRPNAndNRPNEvents: options.bundleRPNAndNRPNEvents,
            maxTrackEventCount: options.maxTrackEventCount,
            predicate: predicate,
            parsedChunk: parsedChunk
        )
    }
    
    static func data(forFileURL url: URL) throws(DecodeError) -> Data {
        do { return try Data(contentsOf: url) }
        catch { throw .fileReadError }
    }
}
