//
//  UnrecognizedChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile.Chunk {
    /// Unrecognized MIDI File Chunk.
    public struct UnrecognizedChunk: MIDIFileChunk, Equatable {
        static let disallowedIdentifiers: [String] = [
            Header().identifier,
            Track().identifier
        ]
        
        public let identifier: String

        /// Contains the raw bytes of the chunk's data portion
        /// (NOT including the 4-character identifier or the length integer.)
        public var rawData: Data

        public init(id: String, rawData: Data? = nil) {
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

            self.rawData = rawData ?? Data()
        }
    }
}
// MARK: - Static Constructors

extension MIDIFile.Chunk {
    /// Unrecognized MIDI File Chunk.
    public static func other(id: String, rawData: Data? = nil) -> Self {
        .other(.init(id: id, rawData: rawData))
    }
}

// MARK: - Encoding

extension MIDIFile.Chunk.UnrecognizedChunk {
    /// Init from MIDI file buffer.
    public init<D: DataProtocol>(midi1SMFRawBytesStream stream: D) throws {
        guard stream.count >= 8 else {
            throw MIDIFile.DecodeError.malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        let (id, dataBody) = try stream.withDataReader { dataReader -> (String, D.SubSequence) in
            let readChunkType = try dataReader.read(bytes: 4)
            
            guard let chunkLengthInt32 = (try? dataReader.read(bytes: 4))?
                .data.toUInt32(from: .bigEndian)
            else {
                throw MIDIFile.DecodeError.malformed(
                    "There was a problem reading chunk length."
                )
            }
            let chunkLength = Int(chunkLengthInt32)
            
            let chunkTypeString = readChunkType.asciiDataToString() ?? "????"
            
            guard !Self.disallowedIdentifiers.contains(chunkTypeString) else {
                throw MIDIFile.DecodeError.malformed(
                    "Chunk type matches known identifier \(chunkTypeString.quoted). Forming an unrecognized chunk using this identifier is not allowed."
                )
            }
            
            guard let dataBody = try? dataReader.read(bytes: chunkLength) else {
                throw MIDIFile.DecodeError.malformed(
                    "There was a problem reading chunk data blob. Encountered end of data early."
                )
            }
            
            return (id: chunkTypeString, dataBody)
        }
        
        self.init(
            id: id,
            rawData: dataBody.data
        )
    }
    
    func midi1SMFRawBytes(using timeBase: MIDIFile.TimeBase) throws -> Data {
        // assemble track body without header or length
        
        let bodyData = rawData
        
        // assemble full chunk data with header and length
        
        var data = Data()
        
        // 4-byte chunk identifier
        data += identifier.toASCIIData()
        
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
        outputString += "  identifier: \(identifier)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += ")"

        return outputString
    }

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
