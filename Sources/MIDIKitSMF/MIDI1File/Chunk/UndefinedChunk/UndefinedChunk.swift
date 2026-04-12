//
//  UndefinedChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDI1File {
    /// Unrecognized MIDI File Chunk.
    public struct UndefinedChunk {
        // MARK: - Identifiable
        
        public let id = UUID()
        
        // MARK: - Properties
        
        public let identifier: MIDI1FileChunkIdentifier

        /// Contains the raw bytes of the chunk's data portion
        /// (NOT including the 4-character identifier or the length integer.)
        public var rawData: Data
        
        /// Internal init.
        public init(identifier: MIDI1FileChunkIdentifier, data: Data? = nil) {
            // identifier validation
            assert(identifier != .header, "Undefined chunk cannot use the identifier reserved for the MIDI file header chunk.")
            assert(identifier != .track, "Undefined chunk cannot use the identifier reserved for MIDI file track chunks.")
            self.identifier = identifier
            
            // store raw data
            self.rawData = data ?? Data()
        }
    }
}

extension MIDI1File.UndefinedChunk: Equatable { }

extension MIDI1File.UndefinedChunk: Hashable { }

extension MIDI1File.UndefinedChunk: Identifiable {
    // `id` is a stored instance property
}

extension MIDI1File.UndefinedChunk: Sendable { }

extension MIDI1File.UndefinedChunk: CustomStringConvertible {
    public var description: String {
        var outputString = ""
        
        outputString += "UndefinedChunk(".newLined
        outputString += "  identifier: \(identifier)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += ")"
        
        return outputString
    }
}

extension MIDI1File.UndefinedChunk: CustomDebugStringConvertible {
    public var debugDescription: String {
        let rawDataBlock = rawData
            .hexString(padEachTo: 2, prefixes: false)
            .split(every: 3 * 16) // 16 bytes wide
            .reduce("") {
                $0 + "      " + $1.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        
        var outputString = ""
        
        outputString += "UndefinedChunk(".newLined
        outputString += "  identifier: \(identifier)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += "    ("
        outputString += rawDataBlock
        outputString += "    )"
        outputString += ")"
        
        return outputString
    }
}
