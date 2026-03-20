//
//  UnrecognizedChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile.AnyChunk {
    /// Unrecognized MIDI File Chunk.
    public struct UnrecognizedChunk {
        public let identifier: Identifier

        /// Contains the raw bytes of the chunk's data portion
        /// (NOT including the 4-character identifier or the length integer.)
        public var rawData: Data
        
        /// Internal init.
        public init(identifier: Identifier, data: Data? = nil) {
            // identifier validation
            self.identifier = identifier
            
            // store raw data
            self.rawData = data ?? Data()
        }
    }
}

extension MIDIFile.AnyChunk.UnrecognizedChunk: Equatable { }

extension MIDIFile.AnyChunk.UnrecognizedChunk: Hashable { }

extension MIDIFile.AnyChunk.UnrecognizedChunk: Sendable { }

extension MIDIFile.AnyChunk.UnrecognizedChunk: CustomStringConvertible {
    public var description: String {
        var outputString = ""
        
        outputString += "UnrecognizedChunk(".newLined
        outputString += "  identifier: \(identifier)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += ")"
        
        return outputString
    }
}

extension MIDIFile.AnyChunk.UnrecognizedChunk: CustomDebugStringConvertible {
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
