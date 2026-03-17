//
//  UnrecognizedChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile.Chunk {
    /// Unrecognized MIDI File Chunk.
    public struct UnrecognizedChunk {
        public let identifier: String

        /// Contains the raw bytes of the chunk's data portion
        /// (NOT including the 4-character identifier or the length integer.)
        public var rawData: Data

        public init(id: String, data: Data? = nil) {
            // identifier validation

            if Self.disallowedIdentifiers.contains(id) {
                // don't allow non-track chunks to use SMF header or track identifier
                identifier = "----"
            } else if id.count < 4 {
                identifier =
                    id.appending(String(
                        repeating: "-",
                        count: 4 - id.count
                    ))
                    .convertToASCII()

            } else if id.count > 4 {
                identifier =
                    id.prefix(4)
                    .convertToASCII()

            } else {
                identifier = id
            }

            // store raw data

            self.rawData = data ?? Data()
        }
    }
}

extension MIDIFile.Chunk.UnrecognizedChunk: Equatable { }

extension MIDIFile.Chunk.UnrecognizedChunk: Hashable { }

extension MIDIFile.Chunk.UnrecognizedChunk: Sendable { }

extension MIDIFile.Chunk.UnrecognizedChunk: CustomStringConvertible {
    public var description: String {
        var outputString = ""
        
        outputString += "UnrecognizedChunk(".newLined
        outputString += "  identifier: \(identifier)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += ")"
        
        return outputString
    }
}

extension MIDIFile.Chunk.UnrecognizedChunk: CustomDebugStringConvertible {
    public var debugDescription: String {
        let rawDataBlock = rawData
            .hexString(padEachTo: 2, prefixes: false)
            .split(every: 3 * 16) // 16 bytes wide
            .reduce("") {
                $0 + "      " + $1.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        
        var outputString = ""
        
        outputString += "UnrecognizedChunk(".newLined
        outputString += "  identifier: \(identifier)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += "    ("
        outputString += rawDataBlock
        outputString += "    )"
        outputString += ")"
        
        return outputString
    }
}

extension MIDIFile.Chunk.UnrecognizedChunk: MIDIFileChunk {
    // `identifier` is a stored instance property
    
    public var chunkType: MIDIFile.ChunkType { .other(identifier: identifier) }
}

// MARK: - Static

extension MIDIFile.Chunk.UnrecognizedChunk {
    static let disallowedIdentifiers: [String] = [
        MIDIFile.Chunk.Header.staticIdentifier,
        MIDIFile.Chunk.Track.staticIdentifier
    ]
}

// MARK: - Static Constructors

extension MIDIFile.Chunk {
    /// Unrecognized MIDI File Chunk.
    public static func other(id: String, data: Data? = nil) -> Self {
        .other(.init(id: id, data: data))
    }
}
