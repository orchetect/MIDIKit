//
//  MIDIFile decode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Internal Parsing Entry-point Methods

extension MIDIFile {
    /// Decode sequentially, without concurrency.
    mutating func decode(
        rawData: some DataProtocol & Sendable,
        bundleParameterNumbers: Bool,
        maxTrackEventCount: Int?
    ) throws(MIDIFile.DecodeError) {
        let parser = try Parser(data: rawData)
        let parsedChunks = try parser.chunks(
            bundleParameterNumbers: bundleParameterNumbers,
            maxTrackEventCount: maxTrackEventCount
        )
        header = parser.fileDescriptor.header
        chunks = parsedChunks
    }
    
    /// Decode tracks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func decode(
        rawData: some DataProtocol & Sendable,
        bundleParameterNumbers: Bool,
        maxTrackEventCount: Int?
    ) async throws(MIDIFile.DecodeError) {
        let parser = try Parser(data: rawData)
        let parsedChunks = try await parser.chunks(
            bundleParameterNumbers: bundleParameterNumbers,
            maxTrackEventCount: maxTrackEventCount
        )
        header = parser.fileDescriptor.header
        chunks = parsedChunks
    }
}
