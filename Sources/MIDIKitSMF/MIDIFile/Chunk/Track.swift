//
//  Track.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitEvents
@_implementationOnly import OTCore
import struct SwiftASCII.ASCIIString

// MARK: - Track

extension MIDIFile.Chunk {
    /// `MTrk` chunk type.
    public struct Track: Equatable {
        public static let staticIdentifier: ASCIIString = "MTrk"
        
        internal static let chunkEnd: [Byte] = [0xFF, 0x2F, 0x00]
        
        /// Storage for events in the track.
        public var events: [MIDIFileEvent] = []
        
        /// Instance a new empty MIDI file track.
        public init() { }
        
        public init(events: [MIDIFileEvent]) {
            self.events = events
        }
    }
}

extension MIDIFile.Chunk.Track: MIDIFileChunk {
    public var identifier: ASCIIString { Self.staticIdentifier }
}

extension MIDIFile.Chunk.Track {
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
        
        guard chunkTypeString == Self.staticIdentifier else {
            throw MIDIFile.DecodeError.malformed(
                "Chunk header does not contain track header identifier. Found \(chunkTypeString.stringValue.quoted) instead."
            )
        }
        
        guard rawBuffer.count >= 8 + chunkLength else {
            throw MIDIFile.DecodeError.malformed(
                "There was a problem reading track data blob. Encountered end of data early."
            )
        }
        
        try self.init(midi1SMFRawBytes: Array(rawBuffer[8 ..< (8 + chunkLength)]))
    }
    
    /// Init from raw data block, excluding the header identifier and length
    internal init(midi1SMFRawBytes rawData: [Byte]) throws {
        // chunk data
        
        var chunkDataReader = DataReader(rawData.data)
        
        // events
        
        var eventsCounted = 0
        var endOfChunk = false
        var newEvents: [MIDIFileEvent] = []
        
        // running status
        
        var runningStatus: MIDIFileEventPayload?
        
        while !endOfChunk {
            eventsCounted += 1
            
            // delta time
            
            guard let eventDeltaTimeRead = chunkDataReader.nonAdvancingRead(bytes: 4)?.bytes else {
                throw MIDIFile.DecodeError.malformed(
                    "Encountered end of file early."
                )
            }
            
            guard let eventDeltaTime = MIDIFile
                .decodeVariableLengthValue(from: eventDeltaTimeRead)
            else {
                throw MIDIFile.DecodeError.malformed(
                    "Delta time variable length value could not be read and may be malformed."
                )
            }
            
            chunkDataReader.advanceBy(eventDeltaTime.byteLength)
            
            // event
            
            guard var readBuffer = chunkDataReader.nonAdvancingRead() else {
                throw MIDIFile.DecodeError.malformed(
                    "Encountered end of file early."
                )
            }
            
            // first check for end of track
            
            if readBuffer.count == Self.chunkEnd.count,
               readBuffer.bytes == Self.chunkEnd
            {
                endOfChunk = true
                break
            }
            
            // check for running status
            
            var runningStatusByte: Byte?
            
            if let testForRunningStatusByte = readBuffer[safe: readBuffer.startIndex] {
                if testForRunningStatusByte.isContained(in: 0x00 ... 0x7F),
                   let getRunningStatusByte = runningStatus?.midi1SMFRawBytes[safe: 0]
                {
                    runningStatusByte = getRunningStatusByte
                }
            }
            
            // if running status byte is present, inject it into the byte buffer
            if let runningStatusByte = runningStatusByte {
                readBuffer.insert(runningStatusByte, at: readBuffer.startIndex)
            }
            
            // iterate through all known event initializers
            
            var foundEvent: (newEvent: MIDIFileEventPayload, bufferLength: Int)?
            
            for eventDef in MIDIFile.Chunk.Track.eventDecodeOrder.concreteTypes {
                if let success = try? eventDef.initFrom(midi1SMFRawBytesStream: readBuffer) {
                    foundEvent = success
                    break // break for-loop lazily
                }
            }
            
            if let foundEvent = foundEvent {
                // inject delta time into event
                let newEventDelta: MIDIFileEvent.DeltaTime = .ticks(eventDeltaTime.value.uInt32)
                
                // offset buffer length if runningStatusByte is present
                let chunkBufferLength = runningStatusByte != nil
                    ? foundEvent.bufferLength - 1
                    : foundEvent.bufferLength
                
                // add new event to new track
                newEvents += foundEvent.newEvent.smfWrappedEvent(delta: newEventDelta)
                chunkDataReader.advanceBy(chunkBufferLength)
                
                // store event in running status
                if let testForRunningStatusByte = foundEvent.newEvent.midi1SMFRawBytes[safe: 0] {
                    if testForRunningStatusByte.isContained(in: 0x80 ... 0xEF) {
                        runningStatus = foundEvent.newEvent
                    } else if testForRunningStatusByte.isContained(in: 0xF0 ... 0xF7) {
                        runningStatus = nil
                    }
                }
                
            } else {
                // throw an error since no events could be decoded and there are still bytes remaining in the chunk
                
                let byteOffsetString = chunkDataReader.readPosition
                    .hexString(padTo: 1, prefix: true)
                
                let sampleBytes = (1 ... 8)
                    .reduce([Byte]()) {
                        // read as many bytes as possible, up to range.count
                        if let getByte = chunkDataReader.nonAdvancingRead(bytes: $1) {
                            return getByte.bytes
                        }
                        return $0
                    }
                    .hexString(padEachTo: 2, prefixes: true)
                
                throw MIDIFile.DecodeError.malformed(
                    "Unexpected data encountered before end of track at track data byte offset \(byteOffsetString) (\(sampleBytes) ...)."
                )
            }
        }
        
        events = newEvents
    }
}

extension MIDIFile.Chunk.Track {
    func midi1SMFRawBytes(using timeBase: MIDIFile.TimeBase) throws -> Data {
        // assemble chunk body without header or length
        
        var bodyData = Data()
        
        for event in events {
            let unwrapped = event.smfUnwrappedEvent
            bodyData.append(deltaTime: unwrapped.delta.ticksValue(using: timeBase))
            bodyData += unwrapped.event.midi1SMFRawBytes
        }
        
        bodyData.append(deltaTime: 0)
        bodyData += Self.chunkEnd
        
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

extension MIDIFile.Chunk.Track {
    /// Determines the order in which track raw data decoding attempts to iteratively decode events
    static let eventDecodeOrder: [MIDIFileEventType] = [
        .noteOff,
        .noteOn,
        .cc,
        .pressure,
        .pitchBend,
        .notePressure,
        .programChange,
        .keySignature,
        .smpteOffset,
        .sysEx,
        .universalSysEx,
        .text,
        .timeSignature,
        .tempo,
        .sequencerSpecific,
        .sequenceNumber,
        .channelPrefix,
        .portPrefix,
        .xmfPatchTypePrefix,
        .unrecognizedMeta // this should always be last
    ]
}

extension MIDIFile.Chunk.Track: CustomStringConvertible,
CustomDebugStringConvertible {
    public var description: String {
        var outputString = ""
        
        outputString += "Track(".newLined
        outputString += "  events (\(events.count)): ".newLined
        
        events.forEach {
            let deltaString = $0.smfUnwrappedEvent.delta.description
                .padding(toLength: 15, withPad: " ", startingAt: 0)
            
            outputString += "    \(deltaString) \($0.smfUnwrappedEvent.event.smfDescription)"
                .newLined
        }
        
        outputString += ")"
        
        return outputString
    }
    
    public var debugDescription: String {
        var outputString = ""
        
        outputString += "Track(".newLined
        outputString += "  events (\(events.count)): ".newLined
        
        events.forEach {
            let deltaString = $0.smfUnwrappedEvent.delta.debugDescription
                .padding(toLength: 15 + 11, withPad: " ", startingAt: 0)
            
            outputString += "    \(deltaString) \($0.smfUnwrappedEvent.event.smfDebugDescription)"
                .newLined
        }
        
        outputString += ")"
        
        return outputString
    }
}
