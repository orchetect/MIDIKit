//
//  UnrecognizedChunk.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import struct SwiftASCII.ASCIIString

extension MIDIFile.Chunk {
    public struct UnrecognizedChunk: MIDIFileChunk, Equatable {
        static let disallowedIdentifiers: [ASCIIString] = [
            Header().identifier,
            Track().identifier
        ]
        
        public let identifier: ASCIIString

        /// Contains the raw bytes of the chunk's data portion
        /// (NOT including the 4-character identifier or the length integer.)
        public var rawData: Data

        public init(id: ASCIIString, rawData: Data? = nil) {
            // identifier validation

            if Self.disallowedIdentifiers.contains(id) {
                // don't allow non-track chunks to use SMF header or track identifier
                identifier = "----"
            } else if id.stringValue.count < 4 {
                identifier =
                    id.stringValue
                        .appending(String(
                            repeating: "-",
                            count: 4 - id.stringValue.count
                        ))
                        .asciiStringLossy

            } else if id.stringValue.count > 4 {
                identifier =
                    id.stringValue
                        .prefix(4)
                        .asciiStringLossy

            } else {
                identifier = id
            }

            // store raw data

            self.rawData = rawData ?? Data()
        }
    }
}

extension MIDIFile.Chunk.UnrecognizedChunk {
    /// Init from MIDI file buffer.
    public init(midi1SMFRawBytesStream rawBuffer: [Byte]) throws {
        guard rawBuffer.count >= 8 else {
            throw MIDIFile.DecodeError.malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        let readChunkType = rawBuffer[0 ... 3].data
        
        guard let chunkLength = rawBuffer[4 ... 7].data.toUInt32(from: .bigEndian)?.int else {
            throw MIDIFile.DecodeError.malformed(
                "There was a problem reading chunk length."
            )
        }
        
        let chunkTypeString = ASCIIString(exactly: readChunkType) ?? "????"
        
        guard !Self.disallowedIdentifiers.contains(chunkTypeString) else {
            throw MIDIFile.DecodeError.malformed(
                "Chunk type matches known identifier  \(chunkTypeString.stringValue.quoted). Forming an unrecognized chunk using this identifier is not allowed."
            )
        }
        
        guard rawBuffer.count >= 8 + chunkLength else {
            throw MIDIFile.DecodeError.malformed(
                "There was a problem reading chunk data blob. Encountered end of data early."
            )
        }
        
        self.init(
            id: chunkTypeString,
            rawData: Data(rawBuffer[8 ..< (8 + chunkLength)])
        )
    }
    
    func midi1SMFRawBytes(using timeBase: MIDIFile.TimeBase) throws -> Data {
        // assemble track body without header or length
        
        let bodyData = rawData
        
        // assemble full chunk data with header and length
        
        var data = Data()
        
        // 4-byte chunk identifier
        data += identifier.rawData
        
        // chunk data length (32-bit 4 byte big endian integer)
        if let trackLength = UInt32(exactly: bodyData.count) {
            data += trackLength.toData(.bigEndian)
        } else {
            // track length overflows max length integer size
            // maximum track data size is 4.294967296 GB (UInt32.max bytes)
            throw MIDIFile.EncodeError.internalInconsistency(
                "Chunk length overflowed maximum size."
            )
        }
        
        data += bodyData
        
        return data
    }
}

extension MIDIFile.Chunk.UnrecognizedChunk: CustomStringConvertible,
                                            CustomDebugStringConvertible {
    public var description: String {
        var outputString = ""

        outputString += "UnrecognizedChunk(".newLined
        outputString += "  identifier: \(identifier.stringValue)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += ")"

        return outputString
    }

    public var debugDescription: String {
        let rawDataBlock = rawData
            .hexString(padEachTo: 2, prefixes: false)
            .split(every: 3 * 16) // 16 bytes wide
            .reduce("") {
                $0 + "      " + $1.trimmed
            }

        var outputString = ""

        outputString += "UnrecognizedChunk(".newLined
        outputString += "  identifier: \(identifier.stringValue)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += "    ("
        outputString += rawDataBlock
        outputString += "    )"
        outputString += ")"

        return outputString
    }
}
