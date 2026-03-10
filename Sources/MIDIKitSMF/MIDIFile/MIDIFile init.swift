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
    @available(*, deprecated, message: "This method is less performant than its async variant. Considering calling with await.")
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
    
    /// Initialize by loading the contents of a MIDI file's raw data.
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
}

// MARK: - Init: File Path

extension MIDIFile {
    /// Initialize by loading the contents of a MIDI file from disk.
    @available(*, deprecated, message: "This method is less performant than its async variant. Considering calling with await.")
    public init(
        midiFile path: String,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) throws(DecodeError) {
        let url = try Self.url(forFilePath: path)
        try self.init(midiFile: url, options: options, predicate: predicate)
    }
    
    /// Initialize by loading the contents of a MIDI file from disk.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        midiFile path: String,
        options: DecodeOptions = DecodeOptions(),
        predicate: DecodePredicate? = nil
    ) async throws(DecodeError) {
        let url = try Self.url(forFilePath: path)
        try await self.init(midiFile: url, options: options, predicate: predicate)
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
    
    /// Initialize by loading the contents of a MIDI file from disk.
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
    
    static func data(forFileURL url: URL) throws(DecodeError) -> Data {
        do { return try Data(contentsOf: url) }
        catch { throw .fileReadError }
    }
}
