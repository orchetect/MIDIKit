//
//  MIDIFile decode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile {
    mutating func decode(rawData data: Data) throws {
        // basic checks

        guard !data.isEmpty else {
            throw DecodeError.malformed(
                "MIDI data is empty / contains no bytes."
            )
        }

        // reset values to a known state

        chunks = []
        header = .init() // resets format and timeBase

        // begin parse
        
        try data.withDataReader { dataReader in
            // ____ Header ____

            guard let readHeader = try? dataReader
                .read(bytes: Chunk.Header.midi1SMFFixedRawBytesLength)
            else {
                throw MIDIFile.DecodeError.malformed(
                    "Header is not correct. File may not be a MIDI file."
                )
            }

            header = try Chunk.Header(midi1SMFRawBytes: readHeader)

            // chunks

            var tracksEncountered = 0
            var endOfFile = false

            var newChunks: [Chunk] = []

            while !endOfFile {
                // chunk header

                guard let chunkType = try? dataReader.read(bytes: 4) else {
                    throw DecodeError.malformed(
                        "There was a problem reading chunk header at byte offset \(dataReader.readOffset). Encountered end of file early."
                    )
                }

                guard let chunkLength = (try? dataReader.read(bytes: 4))?
                    .toUInt32(from: .bigEndian)
                else {
                    throw DecodeError.malformed(
                        "There was a problem reading chunk length at byte offset \(dataReader.readOffset). Encountered end of file early."
                    )
                }

                let chunkTypeString = chunkType.asciiDataToString() ?? "????"
            
                try autoreleasepool {
                    let newChunk: Chunk
                    
                    // chunk length
                    
                    guard let chunkData = try? dataReader.read(bytes: Int(chunkLength)) else {
                        throw DecodeError.malformed(
                            "There was a problem reading track data blob at byte offset \(dataReader.readOffset) for track \(tracksEncountered). Encountered end of file early."
                        )
                    }
                    
                    do {
                        switch chunkTypeString {
                        case MIDIFile.Chunk.Track.staticIdentifier:
                            tracksEncountered += 1
                            
                            let newTrack = try Chunk.Track(midi1SMFRawBytes: chunkData.bytes)
                            newChunk = .track(newTrack)
                            
                        default:
                            // as per Standard MIDI File 1.0 Spec:
                            // unrecognized chunks should be skipped and not throw an error
                            
                            let newUnrecognizedChunk = try Chunk.UnrecognizedChunk(
                                midi1SMFRawBytesStream: chunkData.bytes
                            )
                            newChunk = .other(newUnrecognizedChunk)
                        }
                    } catch let error as DecodeError {
                        // append some context for the error and rethrow it
                        switch error {
                        case let .malformed(verboseError):
                            throw DecodeError.malformed(
                                "There was a problem reading track data at byte offset \(dataReader.readOffset) for track \(tracksEncountered). " +
                                    verboseError
                            )
                            
                        default:
                            throw error
                        }
                    }
                    
                    newChunks.append(newChunk)
                }
                
                if dataReader.readOffset >= data.count {
                    endOfFile = true
                }
            }

            chunks = newChunks
        }
    }
}
