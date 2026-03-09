//
//  MIDIFile decode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Parse Entry-point Methods

extension MIDIFile {
    mutating func decode(
        rawData: some DataProtocol & Sendable,
        bundleParameterNumbers: Bool
    ) throws(MIDIFile.DecodeError) {
        let parser = try Parser(data: rawData)
        let parsedChunks = try parser.chunks(bundleParameterNumbers: bundleParameterNumbers)
        header = parser.fileDescriptor.header
        chunks = parsedChunks
    }
    
    /// Concurrent version of `decode(rawData:)` method.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func decode(
        rawData: some DataProtocol & Sendable,
        bundleParameterNumbers: Bool
    ) async throws(MIDIFile.DecodeError) {
        let parser = try Parser(data: rawData)
        let parsedChunks = try await parser.chunks(bundleParameterNumbers: bundleParameterNumbers)
        header = parser.fileDescriptor.header
        chunks = parsedChunks
    }
}
