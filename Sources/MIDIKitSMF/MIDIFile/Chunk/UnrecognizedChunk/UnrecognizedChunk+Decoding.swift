//
//  UnrecognizedChunk+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

extension MIDIFile.Chunk.UnrecognizedChunk {
    /// Init from MIDI file buffer.
    public init<D: DataProtocol>(midi1SMFRawBytesStream stream: D) throws(MIDIFile.DecodeError) {
        guard stream.count >= 8 else {
            throw .malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        let (id, dataBody) = try stream.withDataParser { parser throws(MIDIFile.DecodeError) -> (String, Data) in
            let readChunkType = try parser.toMIDIFileDecodeError(
                malformedReason: "Missing chunk type identifier.",
                try parser.read(bytes: 4)
            )
            
            guard let chunkLengthInt32 = (try? parser.read(bytes: 4))?
                .toUInt32(from: .bigEndian)
            else {
                throw .malformed(
                    "There was a problem reading chunk length."
                )
            }
            let chunkLength = Int(chunkLengthInt32)
            
            let chunkTypeString = readChunkType.asciiDataToString() ?? "????"
            
            guard !Self.disallowedIdentifiers.contains(chunkTypeString) else {
                throw .malformed(
                    "Chunk type matches known identifier \(chunkTypeString.quoted). Forming an unrecognized chunk using this identifier is not allowed."
                )
            }
            
            guard let dataBody = try? parser.read(bytes: chunkLength) else {
                throw .malformed(
                    "There was a problem reading chunk data blob. Encountered end of data early."
                )
            }
            
            // we can't pass pointer ranges outside of the data reader closure,
            // so we must use them within the closure
            return (id: chunkTypeString, dataBody.toData())
        }
        
        self.init(
            id: id,
            data: dataBody
        )
    }
}
