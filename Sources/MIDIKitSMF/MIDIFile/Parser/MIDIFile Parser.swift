//
//  MIDIFile Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIFile {
    struct Parser<DataType: DataProtocol> where DataType: Sendable {
        let data: DataType
        
        let fileDescriptor: MIDIFileParserFileDescriptor
        
        init(data: DataType) throws(MIDIFile.DecodeError) {
            self.data = data
            fileDescriptor = try Self.parseFileDescriptor(fileData: data)
            
            // print("Chunk descriptors:")
            // print(
            //     fileDescriptor.chunkDescriptors
            //         .map { "\($0.typeString) @ \($0.startOffset) (\($0.bodyByteLength) body bytes)" }
            //         .joined(separator: "\n")
            // )
        }
        
        func chunks(
            bundleRPNAndNRPNEvents: Bool,
            maxTrackEventCount: Int?
        ) throws(MIDIFile.DecodeError) -> [MIDIFile.Chunk] {
            try Self.parseChunks(
                chunkDescriptors: fileDescriptor.chunkDescriptors,
                timebase: fileDescriptor.header.timeBase,
                bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
                maxTrackEventCount: maxTrackEventCount,
                in: data
            )
        }
        
        /// Concurrent version of `chunks` method.
        @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
        func chunks(
            bundleRPNAndNRPNEvents: Bool,
            maxTrackEventCount: Int?
        ) async throws(MIDIFile.DecodeError) -> [MIDIFile.Chunk] {
            try await Self.parseChunks(
                chunkDescriptors: fileDescriptor.chunkDescriptors,
                timebase: fileDescriptor.header.timeBase,
                bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
                maxTrackEventCount: maxTrackEventCount,
                in: data
            )
        }
    }
}

extension MIDIFile.Parser: Sendable { }

extension MIDIFile.Parser: MIDIFileParserProtocol { }
