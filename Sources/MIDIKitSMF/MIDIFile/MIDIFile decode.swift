//
//  MIDIFile decode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

extension MIDIFile {
    mutating func decode(rawData data: Data) throws(DecodeError) {
        // basic checks

        guard !data.isEmpty else {
            throw .malformed(
                "MIDI data is empty / contains no bytes."
            )
        }

        // reset values to a known state

        chunks = []
        header = .init() // resets format and timeBase

        // begin parse
        
        try data.withDataParser { parser throws(DecodeError) in
            // ____ Header ____

            guard let readHeader = try? parser
                .read(bytes: Chunk.Header.midi1SMFFixedRawBytesLength)
            else {
                throw .malformed(
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

                guard let chunkType = try? parser.read(bytes: 4) else {
                    throw .malformed(
                        "There was a problem reading chunk header at byte offset \(parser.readOffset). Encountered end of file early."
                    )
                }

                guard let chunkLength = (try? parser.read(bytes: 4))?
                    .toUInt32(from: .bigEndian)
                else {
                    throw .malformed(
                        "There was a problem reading chunk length at byte offset \(parser.readOffset). Encountered end of file early."
                    )
                }

                let chunkTypeString = chunkType.asciiDataToString() ?? "????"
            
                try autoreleasepool { () throws(DecodeError) -> Void in
                    let newChunk: Chunk
                    
                    // chunk length
                    
                    guard let chunkData = try? parser.read(bytes: Int(chunkLength)) else {
                        throw .malformed(
                            "There was a problem reading track data blob at byte offset \(parser.readOffset) for track \(tracksEncountered). Encountered end of file early."
                        )
                    }
                    
                    do throws(MIDIFile.DecodeError) {
                        switch chunkTypeString {
                        case MIDIFile.Chunk.Track.staticIdentifier:
                            tracksEncountered += 1
                            
                            let newTrack = try Chunk.Track(midi1SMFRawBytes: chunkData)
                            newChunk = .track(newTrack)
                            
                        default:
                            // as per Standard MIDI File 1.0 Spec:
                            // unrecognized chunks should be skipped and not throw an error
                            
                            let newUnrecognizedChunk = Chunk.UnrecognizedChunk(id: chunkTypeString, rawData: chunkData.toData())
                            newChunk = .other(newUnrecognizedChunk)
                        }
                    } catch {
                        // append some context for the error and rethrow it
                        switch error {
                        case let .malformed(verboseError):
                            throw .malformed(
                                "There was a problem reading track data at byte offset \(parser.readOffset) for track \(tracksEncountered). \(verboseError)"
                            )
                            
                        default:
                            throw error
                        }
                    }
                    
                    newChunks.append(newChunk)
                }
                
                if parser.readOffset >= data.count {
                    endOfFile = true
                }
            }

            chunks = newChunks
        }
    }
}
