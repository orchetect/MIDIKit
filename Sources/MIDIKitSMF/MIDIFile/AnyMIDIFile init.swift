//
//  AnyMIDIFile init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Init: Raw Data

extension AnyMIDIFile {
    /// Initialize by loading the contents of a MIDI file's raw data.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        data: some DataProtocol & Sendable,
        options: MIDIFileDecodeOptions = MIDIFileDecodeOptions(),
        predicate: MIDIFile.DecodePredicate? = nil
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
        options: MIDIFileDecodeOptions = MIDIFileDecodeOptions(),
        predicate: MIDIFile.DecodePredicate? = nil
    ) async throws(MIDIFileDecodeError) {
        self = try await Self.decode(
            data: data,
            options: options,
            predicate: predicate
        )
    }
}

// MARK: - Init: File Path

extension AnyMIDIFile {
    /// Initialize by loading the contents of a MIDI file from disk.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        path: String,
        options: MIDIFileDecodeOptions = MIDIFileDecodeOptions(),
        predicate: MIDIFile.DecodePredicate? = nil
    ) throws(MIDIFileDecodeError) {
        let url = try Self.url(forFilePath: path)
        try self.init(url: url, options: options, predicate: predicate)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk, parsing chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        path: String,
        options: MIDIFileDecodeOptions = MIDIFileDecodeOptions(),
        predicate: MIDIFile.DecodePredicate? = nil
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

extension AnyMIDIFile {
    /// Initialize by loading the contents of a MIDI file from disk.
    ///
    /// - Tip: Consider using the `async` overload of this initializer, as it is much more performant.
    public init(
        url: URL,
        options: MIDIFileDecodeOptions = MIDIFileDecodeOptions(),
        predicate: MIDIFile.DecodePredicate? = nil
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
        options: MIDIFileDecodeOptions = MIDIFileDecodeOptions(),
        predicate: MIDIFile.DecodePredicate? = nil
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

extension AnyMIDIFile {
    /// Decode chunks sequentially, without concurrency.
    static func decode(
        data: some DataProtocol & Sendable,
        options: MIDIFileDecodeOptions,
        predicate: MIDIFile.DecodePredicate?
    ) throws(MIDIFileDecodeError) -> AnyMIDIFile {
        let header = try AnyMIDIFileHeaderChunk.initFrom(
            midi1SMFRawBytesStream: data,
            allowMultiTrackFormat0: options.allowMultiTrackFormat0
        )
        
        switch header.header.timebase {
        case .musical(_):
            let midiFile = try MusicalMIDIFile(data: data, options: options, predicate: predicate)
            return .musical(midiFile)
        case .smpte(_):
            let midiFile = try SMPTEMIDIFile(data: data, options: options, predicate: predicate)
            return .smpte(midiFile)
        }
    }
    
    /// Decode chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    static func decode(
        data: some DataProtocol & Sendable,
        options: MIDIFileDecodeOptions,
        predicate: MIDIFile.DecodePredicate?
    ) async throws(MIDIFileDecodeError) -> AnyMIDIFile {
        let header = try AnyMIDIFileHeaderChunk.initFrom(
            midi1SMFRawBytesStream: data,
            allowMultiTrackFormat0: options.allowMultiTrackFormat0
        )
        
        switch header.header.timebase {
        case .musical(_):
            let midiFile = try await MusicalMIDIFile(data: data, options: options, predicate: predicate)
            return .musical(midiFile)
        case .smpte(_):
            let midiFile = try await SMPTEMIDIFile(data: data, options: options, predicate: predicate)
            return .smpte(midiFile)
        }
    }
}

// MARK: - Utilities

extension AnyMIDIFile {
    nonisolated
    static func data(forFileURL url: URL) throws(MIDIFileDecodeError) -> Data {
        do { return try Data(contentsOf: url) }
        catch { throw .fileReadError }
    }
}
