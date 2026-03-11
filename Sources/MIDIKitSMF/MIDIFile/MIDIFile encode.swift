//
//  MIDIFile encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Public Methods

extension MIDIFile {
    /// Returns raw MIDI file data.
    /// Throws an error if a problem occurs.
    public func rawData() throws(EncodeError) -> Data {
        try encode()
    }
    
    /// Returns raw MIDI file data, encoding chunks concurrently for improved performance.
    /// Throws an error if a problem occurs.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func rawData() async throws(EncodeError) -> Data {
        try await encode()
    }
}

// MARK: - Internal Methods

extension MIDIFile {
    /// Returns raw MIDI file data.
    /// Throws an error if a problem occurs.
    func encode() throws(EncodeError) -> Data {
        // basic validation checks

        guard chunks.count <= UInt16.max else {
            throw .internalInconsistency(
                "Chunk count exceeds maximum."
            )
        }

        var data = Data()

        // ____ Header ____

        data += try header.midi1SMFRawBytes(withChunkCount: chunks.count)

        // ____ Chunks ____

        for chunk in chunks {
            switch chunk {
            case let .track(track):
                try data.append(track.midi1SMFRawBytes(using: timebase))

            case let .other(unrecognizedChunk):
                try data.append(unrecognizedChunk.midi1SMFRawBytes(using: timebase))
            }
        }

        return data
    }
    
    /// Returns raw MIDI file data, encoding chunks concurrently for improved performance.
    /// Throws an error if a problem occurs.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func encode() async throws(EncodeError) -> Data {
        // basic validation checks
        
        guard chunks.count <= UInt16.max else {
            throw .internalInconsistency(
                "Chunk count exceeds maximum."
            )
        }
        
        var data = Data()
        
        // ____ Header ____
        
        data += try header.midi1SMFRawBytes(withChunkCount: chunks.count)
        
        // ____ Chunks ____
        
        typealias TaskResult = Result<(index: Int, data: Data), EncodeError>
        typealias GroupResult = Result<[Int: Data], EncodeError>
        let encodedChunksResult: GroupResult = await withTaskGroup(of: TaskResult.self, returning: GroupResult.self) { group in
            var encodedChunks: [Int: Data] = [:]
            
            for (index, chunk) in chunks.enumerated() {
                group.addTask {
                    do throws(EncodeError) {
                        let encodedChunkData: Data = switch chunk {
                        case let .track(track):
                            try track.midi1SMFRawBytes(using: timebase)
                            
                        case let .other(unrecognizedChunk):
                            try unrecognizedChunk.midi1SMFRawBytes(using: timebase)
                        }
                        return .success((index: index, data: encodedChunkData))
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            do throws(EncodeError) {
                for await chunkResult in group {
                    let (index, data) = try chunkResult.get()
                    encodedChunks[index] = data
                }
                return .success(encodedChunks)
            } catch {
                return .failure(error)
            }
        }
        
        let encodedChunks = try encodedChunksResult.get()
        assert(encodedChunks.count == chunks.count)
        
        for encodedChunkData in encodedChunks.sorted(by: { $0.key < $1.key }).map(\.value) {
            data.append(encodedChunkData)
        }
        
        return data
    }
}
