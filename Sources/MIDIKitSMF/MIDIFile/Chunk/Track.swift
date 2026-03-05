//
//  Track.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Track

extension MIDIFile.Chunk {
    /// Track: `MTrk` chunk type.
    public struct Track {
        /// Storage for events in the track.
        public var events: [MIDIFileEvent] = []
        
        /// Instance a new empty MIDI file track.
        public init() { }
        
        public init(events: [MIDIFileEvent]) {
            self.events = events
        }
    }
}

extension MIDIFile.Chunk.Track: Equatable { }

extension MIDIFile.Chunk.Track: Hashable { }

extension MIDIFile.Chunk.Track: Sendable { }

extension MIDIFile.Chunk.Track: CustomStringConvertible {
    public var description: String {
        var outputString = ""
        
        outputString += "Track(".newLined
        outputString += "  events (\(events.count)): ".newLined
        
        for event in events {
            let deltaString = event.smfUnwrappedEvent.delta.description
                .padding(toLength: 15, withPad: " ", startingAt: 0)
            
            outputString += "    \(deltaString) \(event.smfUnwrappedEvent.event.smfDescription)"
                .newLined
        }
        
        outputString += ")"
        
        return outputString
    }
}

extension MIDIFile.Chunk.Track: CustomDebugStringConvertible {
    public var debugDescription: String {
        var outputString = ""
        
        outputString += "Track(".newLined
        outputString += "  events (\(events.count)): ".newLined
        
        for event in events {
            let deltaString = event.smfUnwrappedEvent.delta.debugDescription
                .padding(toLength: 15 + 11, withPad: " ", startingAt: 0)
            
            outputString += "    \(deltaString) \(event.smfUnwrappedEvent.event.smfDebugDescription)"
                .newLined
        }
        
        outputString += ")"
        
        return outputString
    }
}

extension MIDIFile.Chunk.Track: MIDIFileChunk {
    public var identifier: String { Self.staticIdentifier }
}

// MARK: - Static

extension MIDIFile.Chunk.Track {
    public static let staticIdentifier: String = "MTrk"
    
    static let chunkEnd: [UInt8] = [0xFF, 0x2F, 0x00]
}

// MARK: - Static Constructors

extension MIDIFile.Chunk {
    /// Track: `MTrk` chunk type.
    public static func track(_ events: [MIDIFileEvent]) -> Self {
        .track(.init(events: events))
    }
}

// MARK: - Encoding

extension MIDIFile.Chunk.Track {
    /// Init from MIDI file data stream.
    public init<D: MutableDataProtocol>(midi1SMFRawBytesStream stream: D) throws(MIDIFile.DecodeError) {
        guard stream.count >= 8 else {
            throw .malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        self = try stream.withDataReader { dataReader throws(MIDIFile.DecodeError) in
            let chunkTypeString = try dataReader.toMIDIFileDecodeError(
                malformedReason: "Missing chunk type bytes.",
                try dataReader.read(bytes: 4).asciiDataToString() ?? "????"
            )
        
            guard let chunkLengthInt32 = (try? dataReader.read(bytes: 4))?
                .toUInt32(from: .bigEndian)
            else {
                throw .malformed(
                    "There was a problem reading chunk length."
                )
            }
            let chunkLength = Int(chunkLengthInt32)
            
            guard chunkTypeString == Self.staticIdentifier else {
                throw .malformed(
                    "Chunk header does not contain track header identifier. Found \(chunkTypeString.quoted) instead."
                )
            }
        
            guard dataReader.remainingByteCount >= chunkLength else {
                throw .malformed(
                    "There was a problem reading track data blob. Encountered end of data early."
                )
            }
            
            guard let readChunk = try? dataReader.read(bytes: chunkLength) else {
                throw .malformed(
                    "There was a problem reading track data blob. Encountered end of data early."
                )
            }
            
            // we can't pass pointer ranges outside of the data reader closure,
            // so we must use them within the closure
            return try Self(midi1SMFRawBytes: readChunk)
        }
    }
    
    /// Init from raw data stream, excluding the header identifier and length.
    init<D: DataProtocol>(midi1SMFRawBytes rawData: D) throws(MIDIFile.DecodeError) {
        // chunk data
        
        try rawData.withDataReader { dataReader throws(MIDIFile.DecodeError) in
            // events
        
            var eventsCounted = 0
            var endOfChunk = false
            var newEvents: [MIDIFileEvent] = []
        
            // running status
        
            var runningStatus: MIDIFileEventPayload?
        
            while !endOfChunk {
                eventsCounted += 1
                
                // delta time
                
                let eventDeltaTimeRead = try dataReader.toMIDIFileDecodeError(
                    malformedReason: "Encountered end of file early.",
                    try dataReader.nonAdvancingRead(bytes: 4)
                )
                
                guard let eventDeltaTime = MIDIFile
                    .decodeVariableLengthValue(from: eventDeltaTimeRead)
                else {
                    throw .malformed(
                        "Delta time variable length value could not be read and may be malformed."
                    )
                }
            
                dataReader.advanceBy(eventDeltaTime.byteLength)
                
                // event
                
                let readBuffer = try dataReader.toMIDIFileDecodeError(
                    malformedReason: "Encountered end of file early.",
                    try dataReader.nonAdvancingRead()
                )
                
                // first check for end of track
            
                if readBuffer.count == Self.chunkEnd.count,
                   readBuffer.elementsEqual(Self.chunkEnd)
                {
                    endOfChunk = true
                    break
                }
            
                // check for running status
            
                var runningStatusByte: UInt8?
            
                if !readBuffer.isEmpty {
                    let testForRunningStatusByte = readBuffer[readBuffer.startIndex]
                    if (0x00 ... 0x7F).contains(testForRunningStatusByte) {
                        if let bytes: Data = runningStatus?.midi1SMFRawBytes(),
                           !bytes.isEmpty
                        {
                            let getRunningStatusByte: UInt8 = bytes[bytes.startIndex]
                            runningStatusByte = getRunningStatusByte
                        }
                    }
                }
                
                // iterate through all known event initializers
            
                var foundEvent: (newEvent: MIDIFileEventPayload, bufferLength: Int)?
            
                autoreleasepool {
                    // if running status byte is present, inject it into the byte buffer
                    let prefix: [UInt8] = if let runningStatusByte {
                        [runningStatusByte]
                    } else { [] }
                    
                    for eventDef in MIDIFile.Chunk.Track.eventDecodeOrder.concreteTypes {
                        if let success = try? eventDef
                            .initFrom(midi1SMFRawBytesStream: prefix + readBuffer)
                        {
                            foundEvent = (newEvent: success.newEvent, bufferLength: success.bufferLength - prefix.count)
                            break // break for-loop lazily
                        }
                    }
                }
                
                if let foundEvent {
                    // inject delta time into event
                    let newEventDelta: MIDIFileEvent.DeltaTime = .ticks(UInt32(eventDeltaTime.value))
                
                    // add new event to new track
                    newEvents.append(foundEvent.newEvent.smfWrappedEvent(delta: newEventDelta))
                    let chunkBufferLength = foundEvent.bufferLength
                    dataReader.advanceBy(chunkBufferLength)
                
                    // store event in running status
                    let newEventBytes: Data = foundEvent.newEvent.midi1SMFRawBytes()
                    if !newEventBytes.isEmpty {
                        let testForRunningStatusByte: D
                            .Element = (foundEvent.newEvent.midi1SMFRawBytes() as Data).first!
                        
                        if (0x80 ... 0xEF).contains(testForRunningStatusByte) {
                            runningStatus = foundEvent.newEvent
                        } else if (0xF0 ... 0xF7).contains(testForRunningStatusByte) {
                            runningStatus = nil
                        }
                    }
                
                } else {
                    // throw an error since no events could be decoded and there are still bytes
                    // remaining in the chunk
                
                    let byteOffsetString = dataReader.readOffset
                        .hexString(padTo: 1, prefix: true)
                
                    let sampleBytes = (1 ... 8)
                        .reduce([UInt8]()) {
                            // read as many bytes as possible, up to range.count
                            if let getBytes = try? dataReader.nonAdvancingRead(bytes: $1) {
                                return Array(getBytes)
                            }
                            return $0
                        }
                        .hexString(padEachTo: 2, prefixes: true)
                
                    throw .malformed(
                        "Unexpected data encountered before end of track at track data byte offset \(byteOffsetString) (\(sampleBytes) ...)."
                    )
                }
            }
        
            events = newEvents
        }
    }
}

extension MIDIFile.Chunk.Track {
    func midi1SMFRawBytes<D: MutableDataProtocol>(
        using timeBase: MIDIFile.TimeBase
    ) throws(MIDIFile.EncodeError) -> D {
        // assemble chunk body without header or length
        
        var bodyData = D()
        
        for event in events {
            let unwrapped = event.smfUnwrappedEvent
            bodyData.append(deltaTime: unwrapped.delta.ticksValue(using: timeBase))
            bodyData.append(contentsOf: unwrapped.event.midi1SMFRawBytes() as D)
        }
        
        bodyData.append(deltaTime: 0)
        bodyData += Self.chunkEnd
        
        // assemble full chunk data with header and length
        
        var data = D()
        
        // 4-byte chunk identifier
        data += identifier.toASCIIData()
        
        // chunk data length (32-bit 4 byte big endian integer)
        if let trackLength = UInt32(exactly: bodyData.count) {
            data += trackLength.toData(.bigEndian)
        } else {
            // track length overflows max length integer size
            // maximum track data size is 4.294967296 GB (UInt32.max bytes)
            throw .internalInconsistency(
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
        .rpn, // must be before .cc
        .nrpn, // must be before .cc
        .cc,
        .pressure,
        .pitchBend,
        .notePressure,
        .programChange,
        .keySignature,
        .smpteOffset,
        .sysEx7,
        .universalSysEx7,
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
    
    /// Returns ``events`` mapped to their beat position in the sequence.
    /// This is computed so avoid frequent calls to this method.
    /// Ensure the `ppq` supplied is the same as used in the MIDI file.
    public func eventsAtBeatPositions(ppq: UInt16) -> [(beat: Double, event: MIDIFileEvent)] {
        var position = 0.0
        return events.map {
            let deltaTicks = $0.delta.ticksValue(using: .musical(ticksPerQuarterNote: ppq))
            if deltaTicks != 0 {
                position += Double(deltaTicks) / Double(ppq)
            }
            return (beat: position, event: $0)
        }
    }
}
