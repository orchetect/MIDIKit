//
//  MIDI1File init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Init: Raw Data

extension MIDI1File {
    /// Initialize by loading the contents of a MIDI file's raw data.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        data: some DataProtocol & Sendable,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil
    ) throws(MIDIFileDecodeError) {
        try decode(
            data: data,
            options: options,
            predicate: predicate
        )
    }
    
    /// Initialize by loading the contents of a MIDI file's raw data, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        data: some DataProtocol & Sendable,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil
    ) async throws(MIDIFileDecodeError) {
        try await decode(
            data: data,
            options: options,
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
        data: some DataProtocol & Sendable,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(MIDIFileDecodeError) {
        try await decode(
            data: data,
            options: options,
            predicate: predicate,
            parsedChunk: parsedChunk
        )
    }
}

// MARK: - Init: File Path

extension MIDI1File {
    /// Initialize by loading the contents of a MIDI file from disk.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        path: String,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil
    ) throws(MIDIFileDecodeError) {
        let url = try AnyMIDI1File.url(forFilePath: path)
        try self.init(url: url, options: options, predicate: predicate)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        path: String,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil
    ) async throws(MIDIFileDecodeError) {
        let url = try AnyMIDI1File.url(forFilePath: path)
        try await self.init(url: url, options: options, predicate: predicate)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    /// As each chunk completes parsing, a closure is called with the parsing results and the chunk's content.
    ///
    /// If the file header cannot be parsed or overall file structure is malformed, this method throws an error.
    /// Errors encountered during individual chunk parsing are returned within the result closure and not thrown from this method.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        path: String,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(MIDIFileDecodeError) {
        let url = try AnyMIDI1File.url(forFilePath: path)
        try await self.init(url: url, options: options, predicate: predicate, parsedChunk: parsedChunk)
    }
}

// MARK: - Init: File URL

extension MIDI1File {
    /// Initialize by loading the contents of a MIDI file from disk.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        url: URL,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil
    ) throws(MIDIFileDecodeError) {
        let data = try AnyMIDI1File.data(forFileURL: url)
        try decode(
            data: data,
            options: options,
            predicate: predicate
        )
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        url: URL,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil
    ) async throws(MIDIFileDecodeError) {
        let data = try AnyMIDI1File.data(forFileURL: url)
        try await decode(
            data: data,
            options: options,
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
        url: URL,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: DecodePredicate? = nil,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(MIDIFileDecodeError) {
        let data = try AnyMIDI1File.data(forFileURL: url)
        try await decode(
            data: data,
            options: options,
            predicate: predicate,
            parsedChunk: parsedChunk
        )
    }
}
