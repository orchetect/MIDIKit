//
//  AnyMIDI1File init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Init: Raw Data

extension AnyMIDI1File {
    /// Initialize by loading the contents of a MIDI file's raw data.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        data: some DataProtocol & Sendable,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: MIDI1File.DecodePredicate? = nil
    ) throws(MIDIFileDecodeError) {
        self = try Self.decode(
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
        predicate: MIDI1File.DecodePredicate? = nil
    ) async throws(MIDIFileDecodeError) {
        self = try await Self.decode(
            data: data,
            options: options,
            predicate: predicate
        )
    }
}

// MARK: - Init: File Path

extension AnyMIDI1File {
    /// Initialize by loading the contents of a MIDI file from disk.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        path: String,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: MIDI1File.DecodePredicate? = nil
    ) throws(MIDIFileDecodeError) {
        let url = try Self.url(forFilePath: path)
        try self.init(url: url, options: options, predicate: predicate)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        path: String,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: MIDI1File.DecodePredicate? = nil
    ) async throws(MIDIFileDecodeError) {
        let url = try Self.url(forFilePath: path)
        try await self.init(url: url, options: options, predicate: predicate)
    }
    
    static func url(forFilePath path: String) throws(MIDIFileDecodeError) -> URL {
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

extension AnyMIDI1File {
    /// Initialize by loading the contents of a MIDI file from disk.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        url: URL,
        options: MIDI1FileDecodeOptions = MIDI1FileDecodeOptions(),
        predicate: MIDI1File.DecodePredicate? = nil
    ) throws(MIDIFileDecodeError) {
        let data = try Self.data(forFileURL: url)
        self = try Self.decode(
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
        predicate: MIDI1File.DecodePredicate? = nil
    ) async throws(MIDIFileDecodeError) {
        let data = try Self.data(forFileURL: url)
        self = try await Self.decode(
            data: data,
            options: options,
            predicate: predicate
        )
    }
}

// MARK: - Parsing

extension AnyMIDI1File {
    /// Decode chunks sequentially, without concurrency.
    static func decode(
        data: some DataProtocol & Sendable,
        options: MIDI1FileDecodeOptions,
        predicate: MIDI1File.DecodePredicate?
    ) throws(MIDIFileDecodeError) -> AnyMIDI1File {
        let header = try AnyMIDI1FileHeaderChunk.initFrom(
            midi1FileRawBytesStream: data,
            allowMultiTrackFormat0: options.allowMultiTrackFormat0
        )
        
        switch header.header.timebase {
        case .musical(_):
            let midiFile = try MusicalMIDI1File(data: data, options: options, predicate: predicate)
            return .musical(midiFile)
        case .smpte(_):
            let midiFile = try SMPTEMIDI1File(data: data, options: options, predicate: predicate)
            return .smpte(midiFile)
        }
    }
    
    /// Decode chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    static func decode(
        data: some DataProtocol & Sendable,
        options: MIDI1FileDecodeOptions,
        predicate: MIDI1File.DecodePredicate?
    ) async throws(MIDIFileDecodeError) -> AnyMIDI1File {
        let header = try AnyMIDI1FileHeaderChunk.initFrom(
            midi1FileRawBytesStream: data,
            allowMultiTrackFormat0: options.allowMultiTrackFormat0
        )
        
        switch header.header.timebase {
        case .musical(_):
            let midiFile = try await MusicalMIDI1File(data: data, options: options, predicate: predicate)
            return .musical(midiFile)
        case .smpte(_):
            let midiFile = try await SMPTEMIDI1File(data: data, options: options, predicate: predicate)
            return .smpte(midiFile)
        }
    }
}

// MARK: - Utilities

extension AnyMIDI1File {
    nonisolated
    static func data(forFileURL url: URL) throws(MIDIFileDecodeError) -> Data {
        do { return try Data(contentsOf: url) }
        catch { throw .fileReadError }
    }
}
