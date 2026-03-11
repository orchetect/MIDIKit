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
        bundleRPNAndNRPNEvents: Bool,
        maxTrackEventCount: Int?,
        ignoreBytesPastEOF: Bool,
        predicate: DecodePredicate?
    ) throws(MIDIFile.DecodeError) {
        let parser = try Parser(data: rawData, ignoreBytesPastEOF: ignoreBytesPastEOF)
        
        header = parser.fileDescriptor.header
        
        let parsedChunks = try parser.chunks(
            bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
            maxTrackEventCount: maxTrackEventCount,
            predicate: predicate
        )
        chunks = parsedChunks
    }
    
    /// Decode tracks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func decode(
        rawData: some DataProtocol & Sendable,
        bundleRPNAndNRPNEvents: Bool,
        maxTrackEventCount: Int?,
        ignoreBytesPastEOF: Bool,
        predicate: DecodePredicate?
    ) async throws(MIDIFile.DecodeError) {
        let parser = try Parser(data: rawData, ignoreBytesPastEOF: ignoreBytesPastEOF)
        
        header = parser.fileDescriptor.header
        
        let parsedChunks = try await parser.chunks(
            bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
            maxTrackEventCount: maxTrackEventCount,
            predicate: predicate
        )
        chunks = parsedChunks
    }
    
    /// Decode tracks concurrently for improved performance and call a closure every time a track finishes parsing.
    ///
    /// If the file header cannot be parsed or overall file structure is malformed, this method throws an error.
    /// Errors encountered during individual chunk parsing are returned within the result closure and not thrown from this method.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func decode(
        rawData: some DataProtocol & Sendable,
        bundleRPNAndNRPNEvents: Bool,
        maxTrackEventCount: Int?,
        ignoreBytesPastEOF: Bool,
        predicate: DecodePredicate?,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(MIDIFile.DecodeError) {
        let parser = try Parser(data: rawData, ignoreBytesPastEOF: ignoreBytesPastEOF)
        
        header = parser.fileDescriptor.header
        
        var parsedChunks: [Int: Chunk] = [:]
        for await (chunkIndex, result) in parser.chunksAsyncSequence(
            bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
            maxTrackEventCount: maxTrackEventCount,
            predicate: predicate
        ) {
            // call closure asynchronously
            Task {
                parsedChunk(
                    parser.fileDescriptor.header,
                    parser.fileDescriptor.chunkDescriptors.count,
                    chunkIndex,
                    result
                )
            }
            
            // grab chunk for local storage
            if let chunk = try? result.get() { parsedChunks[chunkIndex] = chunk }
        }
        chunks = Array(parsedChunks.sorted(by: { $0.key < $1.key }).map(\.value))
    }
}
