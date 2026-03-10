//
//  MIDIFileParserProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

protocol MIDIFileParserProtocol {
    associatedtype DataType: DataProtocol
}

extension MIDIFileParserProtocol {
    static func parseFileDescriptor(
        fileData: some DataProtocol
    ) throws(MIDIFile.DecodeError) -> MIDIFileParserFileDescriptor {
        guard !fileData.isEmpty else {
            throw .malformed("MIDI data is empty (contains no bytes).")
        }
        
        return try fileData.withDataParser { parser throws(MIDIFile.DecodeError) in
            // ____ Header ____
            
            guard let readHeader = try? parser
                .read(bytes: MIDIFile.Chunk.Header.midi1SMFFixedRawBytesLength)
            else {
                throw .malformed(
                    "Header is not correct. File may not be a MIDI file."
                )
            }
            
            let header = try MIDIFile.Chunk.Header(midi1SMFRawBytes: readHeader)
            
            // chunks
            
            var endOfFile = false
            var chunkDescriptors: [MIDIFileParserChunkDescriptor] = []
            
            // gather chunk references before parsing their contents
            
            while !endOfFile {
                // chunk header
                let chunkStartByteOffset = parser.readOffset
                guard let chunkTypeBytes = try? parser.read(bytes: 4),
                      let chunkTypeString = chunkTypeBytes.asciiDataToString(),
                      let chunkType = MIDIFile.ChunkType(rawValue: chunkTypeString)
                else {
                    let offsetString = parser.readOffset.hexString(prefix: true)
                    throw .malformed(
                        "There was a problem reading chunk header at byte offset \(offsetString). Encountered end of file early or chunk identifier may be malformed."
                    )
                }
                
                // chunk length
                guard let chunkLength = (try? parser.read(bytes: 4))?
                    .toUInt32(from: .bigEndian)
                else {
                    let offsetString = parser.readOffset.hexString(prefix: true)
                    throw .malformed(
                        "There was a problem reading chunk length at byte offset \(offsetString)"
                    )
                }
                
                // grab body data offset
                let dataBodyOffset = parser.readOffset
                
                // advance parser
                try parser.toMIDIFileDecodeError(
                    malformedReason: "There was a problem reading chunk data at byte offset \(parser.readOffset.hexString(prefix: true)). Encountered end of file early.",
                    try parser.seek(by: Int(chunkLength))
                )
                
                // append chunk descriptor
                let chunkDescriptor = MIDIFileParserChunkDescriptor(
                    chunkType: chunkType,
                    startOffset: chunkStartByteOffset,
                    bodyByteStartOffset: dataBodyOffset,
                    bodyByteLength: Int(chunkLength)
                )
                chunkDescriptors.append(chunkDescriptor)
                
                // test for end of file
                if parser.readOffset >= fileData.count {
                    endOfFile = true
                }
            }
            
            return MIDIFileParserFileDescriptor(header: header, chunkDescriptors: chunkDescriptors)
        }
    }
    
    /// Serial chunk parser. Parses one chunk at a time.
    static func parseChunks(
        chunkDescriptors: [MIDIFileParserChunkDescriptor],
        timebase: MIDIFile.TimeBase,
        bundleRPNAndNRPNEvents: Bool,
        maxTrackEventCount: Int?,
        predicate: MIDIFile.DecodePredicate?,
        in fileData: some DataProtocol & Sendable
    ) throws(MIDIFile.DecodeError) -> [MIDIFile.Chunk] {
        var newChunks: [MIDIFile.Chunk] = []
        for (index, chunkDescriptor) in chunkDescriptors.enumerated() {
            if let predicate { guard predicate(chunkDescriptor.chunkType, index) else { continue } }
            
            let newChunk = try fileData.withDataParser { parser throws(MIDIFile.DecodeError) in
                try parser.toMIDIFileDecodeError(
                    try parser.seek(to: chunkDescriptor.bodyByteStartOffset)
                )
                let chunkData = try parser.toMIDIFileDecodeError(
                    try parser.read(bytes: chunkDescriptor.bodyByteLength)
                )
                return try parseChunk(
                    chunkDescriptor: chunkDescriptor,
                    chunkIndex: index,
                    timebase: timebase,
                    bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
                    maxTrackEventCount: maxTrackEventCount,
                    in: chunkData
                )
            }
            
            newChunks.append(newChunk)
        }
        return newChunks
    }
    
    /// Concurrent version of `parseChunks` method. Parses multiple chunks concurrently.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    static func parseChunks(
        chunkDescriptors: [MIDIFileParserChunkDescriptor],
        timebase: MIDIFile.TimeBase,
        bundleRPNAndNRPNEvents: Bool,
        maxTrackEventCount: Int?,
        predicate: MIDIFile.DecodePredicate?,
        in fileData: some DataProtocol & Sendable
    ) async throws(MIDIFile.DecodeError) -> [MIDIFile.Chunk] {
        let result: Result<[MIDIFile.Chunk], MIDIFile.DecodeError> = await withTaskGroup(
            of: Result<(index: Int, chunk: MIDIFile.Chunk), MIDIFile.DecodeError>.self,
            returning: Result<[MIDIFile.Chunk], MIDIFile.DecodeError>.self
        ) { group in
            var newChunks: [Int: MIDIFile.Chunk] = [:]
            
            for (index, chunkDescriptor) in chunkDescriptors.enumerated() {
                if let predicate { guard predicate(chunkDescriptor.chunkType, index) else { continue } }
                
                group.addTask {
                    do throws(MIDIFile.DecodeError) {
                        let chunk = try fileData.withDataParser { parser throws(MIDIFile.DecodeError) in
                            try parser.toMIDIFileDecodeError(
                                try parser.seek(to: chunkDescriptor.bodyByteStartOffset)
                            )
                            let chunkData = try parser.toMIDIFileDecodeError(
                                try parser.read(bytes: chunkDescriptor.bodyByteLength)
                            )
                            return try parseChunk(
                                chunkDescriptor: chunkDescriptor,
                                chunkIndex: index,
                                timebase: timebase,
                                bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
                                maxTrackEventCount: maxTrackEventCount,
                                in: chunkData
                            )
                        }
                        
                        return .success((index: index, chunk: chunk))
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            for await result in group {
                switch result {
                case let .success((index, chunk)):
                    newChunks[index] = chunk
                case let .failure(error):
                    return .failure(error)
                }
            }
            
            let chunks = newChunks.sorted(by: { $0.key < $1.key }).map(\.value)
            return .success(chunks)
        }
        
        return try result.get()
    }
    
    static func parseChunk(
        chunkDescriptor: MIDIFileParserChunkDescriptor,
        chunkIndex: Int,
        timebase: MIDIFile.TimeBase,
        bundleRPNAndNRPNEvents: Bool,
        maxTrackEventCount: Int?,
        in chunkData: some DataProtocol
    ) throws(MIDIFile.DecodeError) -> MIDIFile.Chunk {
        do throws(MIDIFile.DecodeError) {
            switch chunkDescriptor.chunkType {
            case .track:
                let newTrack = try MIDIFile.Chunk.Track(
                    midi1SMFRawBytes: chunkData,
                    timebase: timebase,
                    bundleRPNAndNRPNEvents: bundleRPNAndNRPNEvents,
                    maxEventCount: maxTrackEventCount
                )
                return .track(newTrack)
                
            case let .other(identifier: fourCharString):
                // as per Standard MIDI File 1.0 Spec:
                // unrecognized chunks should be skipped and not throw an error
                
                let newUnrecognizedChunk = MIDIFile.Chunk.UnrecognizedChunk(
                    id: fourCharString,
                    rawData: chunkData.toData()
                )
                return .other(newUnrecognizedChunk)
            }
        } catch {
            // append some context for the error and rethrow it
            switch error {
            case let .malformed(verboseError):
                let offsetString = chunkDescriptor.startOffset.hexString(prefix: true)
                throw .malformed(
                    "There was a problem reading track data at byte offset \(offsetString) for chunk index \(chunkIndex). \(verboseError)"
                )
                
            default:
                throw error
            }
        }
    }
}
