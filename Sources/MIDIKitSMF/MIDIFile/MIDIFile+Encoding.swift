//
//  MIDIFile+Encoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Public Methods

extension MIDIFile {
    /// Returns encoded raw MIDI file data.
    /// Throws an error if a problem occurs.
    public func rawData() throws(MIDIFileEncodeError) -> Data {
        try encode(as: Data.self)
    }
    
    /// Returns encoded raw MIDI file data.
    /// Throws an error if a problem occurs.
    public func rawData<D: MutableDataProtocol>(as dataType: D.Type) throws(MIDIFileEncodeError) -> D {
        try encode(as: D.self)
    }
    
    /// Returns encoded raw MIDI file data, encoding chunks concurrently for improved performance.
    /// Throws an error if a problem occurs.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func rawData() async throws(MIDIFileEncodeError) -> Data {
        try await encode(as: Data.self)
    }
    
    /// Returns encoded raw MIDI file data, encoding chunks concurrently for improved performance.
    /// Throws an error if a problem occurs.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func rawData<D: MutableDataProtocol & Sendable>(as dataType: D.Type) async throws(MIDIFileEncodeError) -> D {
        try await encode(as: D.self)
    }
}

// MARK: - Internal Methods

extension MIDIFile {
    /// Returns raw MIDI file data.
    /// Throws an error if a problem occurs.
    func encode<D: MutableDataProtocol>(as dataType: D.Type) throws(MIDIFileEncodeError) -> D {
        // basic validation checks

        guard chunks.count <= UInt16.max else {
            throw .internalInconsistency(
                "Chunk count exceeds maximum."
            )
        }

        var data = D()

        // ____ Header ____

        // header encodes track chunk count only, not including non-track chunks
        data += try header.midi1SMFRawBytes(withTrackCount: tracks.count)

        // ____ Chunks ____

        for chunk in chunks {
            switch chunk {
            case let .track(track):
                try data += (track.midi1SMFRawBytes(as: D.self, using: timebase))

            case let .undefined(chunk):
                try data += (chunk.midi1SMFRawBytes(as: D.self))
            }
        }

        return data
    }
    
    /// Returns raw MIDI file data, encoding chunks concurrently for improved performance.
    /// Throws an error if a problem occurs.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func encode<D: MutableDataProtocol & Sendable>(as dataType: D.Type) async throws(MIDIFileEncodeError) -> D {
        // basic validation checks
        
        guard chunks.count <= UInt16.max else {
            throw .internalInconsistency(
                "Chunk count exceeds maximum."
            )
        }
        
        var data = D()
        
        // ____ Header ____
        
        // header encodes track chunk count only, not including non-track chunks
        data += try header.midi1SMFRawBytes(withTrackCount: tracks.count)
        
        // ____ Chunks ____
        
        typealias TaskResult = Result<(index: Int, data: D), MIDIFileEncodeError>
        typealias GroupResult = Result<[Int: D], MIDIFileEncodeError>
        let encodedChunksResult: GroupResult = await withTaskGroup(of: TaskResult.self, returning: GroupResult.self) { group in
            var encodedChunks: [Int: D] = [:]
            
            for (index, chunk) in chunks.enumerated() {
                group.addTask {
                    do throws(MIDIFileEncodeError) {
                        let encodedChunkData: D = switch chunk {
                        case let .track(track):
                            try track.midi1SMFRawBytes(as: D.self, using: timebase)
                            
                        case let .undefined(chunk):
                            try chunk.midi1SMFRawBytes(as: D.self)
                        }
                        return .success((index: index, data: encodedChunkData))
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            do throws(MIDIFileEncodeError) {
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
            data += encodedChunkData
        }
        
        return data
    }
}
