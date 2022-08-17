//
//  MIDI File decode.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
@_implementationOnly import OTCore

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

        var dataReader = DataReader(data)

        // ____ Header ____

        guard let readHeader = dataReader.read(bytes: Chunk.Header.midi1SMFFixedRawBytesLength)
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

            guard let chunkType = dataReader.read(bytes: 4) else {
                throw DecodeError.malformed(
                    "There was a problem reading chunk header. Encountered end of file early."
                )
            }

            guard let chunkLength = dataReader.read(bytes: 4)?
                .toUInt32(from: .bigEndian)?
                .int
            else {
                throw DecodeError.malformed(
                    "There was a problem reading chunk length. Encountered end of file early."
                )
            }

            let chunkTypeString = chunkType.asciiDataToString() ?? "????"
            
            let newChunk: Chunk
            
            // chunk length
            
            guard let chunkData = dataReader.read(bytes: chunkLength) else {
                throw DecodeError.malformed(
                    "There was a problem reading track data blob for track \(tracksEncountered). Encountered end of file early."
                )
            }
            
            do {
                switch chunkTypeString {
                case MIDIFile.Chunk.Track.staticIdentifier:
                    tracksEncountered += 1
                    
                    let newTrack = try Chunk.Track(midi1SMFRawBytes: chunkData.bytes)
                    newChunk = .track(newTrack)
                    
                default:
                    // as per Standard MIDI File Spec 1.0,
                    // unrecognized chunks should be skipped and not throw an error
                    logger
                        .debug(
                            "Encountered unrecognized MIDI file chunk identifier: \(chunkTypeString)"
                        )
                    
                    let newUnrecognizedChunk = try Chunk
                        .UnrecognizedChunk(midi1SMFRawBytesStream: chunkData.bytes)
                    newChunk = .other(newUnrecognizedChunk)
                }
            } catch let error as DecodeError {
                // append some context for the error and rethrow it
                switch error {
                case let .malformed(verboseError):
                    throw DecodeError.malformed(
                        "There was a problem reading track data for track \(tracksEncountered). " +
                            verboseError
                    )
                    
                default:
                    throw error
                }
            }
            
            newChunks += newChunk

            if dataReader.readPosition >= dataReader.base.count {
                endOfFile = true
            }
        }

        chunks = newChunks
    }
}
