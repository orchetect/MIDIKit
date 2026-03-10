//
//  MIDIFile encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Public Methods

extension MIDIFile {
    /// Returns raw MIDI file data. Throws an error if a problem occurs.
    public func rawData() throws(EncodeError) -> Data {
        try encode()
    }
    
    // TODO: add async version of rawData() that can build file contents concurrently (encode tracks in parallel using withTaskGroup)
}

// MARK: - Internal Methods

extension MIDIFile {
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
                try data.append(track.midi1SMFRawBytes(using: timeBase))

            case let .other(unrecognizedChunk):
                try data.append(unrecognizedChunk.midi1SMFRawBytes(using: timeBase))
            }
        }

        return data
    }
}
