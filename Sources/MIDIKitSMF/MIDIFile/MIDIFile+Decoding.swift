//
//  MIDIFile+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Internal Parsing Entry-point Methods

extension MIDIFile {
    /// Decode chunks sequentially, without concurrency.
    mutating func decode(
        data: some DataProtocol & Sendable,
        options: MIDIFileDecodeOptions,
        predicate: DecodePredicate?
    ) throws(MIDIFileDecodeError) {
        let parser = try Parser(data: data, options: options)
        
        header = parser.fileDescriptor.header
        
        let parsedChunks = try parser.chunks(
            options: options,
            predicate: predicate
        )
        chunks = parsedChunks
    }
    
    /// Decode chunks concurrently for improved performance.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func decode(
        data: some DataProtocol & Sendable,
        options: MIDIFileDecodeOptions,
        predicate: DecodePredicate?
    ) async throws(MIDIFileDecodeError) {
        let parser = try Parser(data: data, options: options)
        
        header = parser.fileDescriptor.header
        
        let parsedChunks = try await parser.chunks(
            options: options,
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
        data: some DataProtocol & Sendable,
        options: MIDIFileDecodeOptions,
        predicate: DecodePredicate?,
        parsedChunk: @escaping ChunkDecodeBlock
    ) async throws(MIDIFileDecodeError) {
        let parser = try Parser(data: data, options: options)
        
        header = parser.fileDescriptor.header
        
        let parsedChunks: [Int: AnyChunk] = await withTaskGroup(of: Void.self, returning: [Int: AnyChunk].self) { group in
            var parsedChunks: [Int: AnyChunk] = [:]
            for await (chunkIndex, result) in parser.chunksAsyncSequence(
                options: options,
                predicate: predicate
            ) {
                // call closure asynchronously
                group.addTask {
                    parsedChunk(
                        parser.fileDescriptor.header,
                        chunkIndex,
                        parser.fileDescriptor.chunkDescriptors.count,
                        result
                    )
                }
                
                // grab chunk for local storage
                if let chunk = try? result.get() { parsedChunks[chunkIndex] = chunk }
            }
            
            await group.waitForAll()
            return parsedChunks
        }
        
        chunks = Array(parsedChunks.sorted(by: { $0.key < $1.key }).map(\.value))
    }
}
