//
//  Track.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Track

extension MIDIFile.Chunk {
    /// Track: `MTrk` chunk type.
    public struct Track: Equatable, Hashable {
        public static let staticIdentifier: String = "MTrk"
        
        internal static let chunkEnd: [UInt8] = [0xFF, 0x2F, 0x00]
        
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
    public var identifier: String { Self.staticIdentifier }
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
    public init<D: MutableDataProtocol>(midi1SMFRawBytesStream stream: D) throws
        where D.SubSequence: MutableDataProtocol
    {
        guard stream.count >= 8 else {
            throw MIDIFile.DecodeError.malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        let remainingData: D.SubSequence = try stream.withDataReader { dataReader in
            let chunkTypeString = try dataReader.read(bytes: 4)
                .asciiDataToString() ?? "????"
        
            guard let chunkLengthInt32 = (try? dataReader.read(bytes: 4))?
                .data.toUInt32(from: .bigEndian)
            else {
                throw MIDIFile.DecodeError.malformed(
                    "There was a problem reading chunk length."
                )
            }
            let chunkLength = Int(chunkLengthInt32)
            
            guard chunkTypeString == Self.staticIdentifier else {
                throw MIDIFile.DecodeError.malformed(
                    "Chunk header does not contain track header identifier. Found \(chunkTypeString.quoted) instead."
                )
            }
        
            guard dataReader.remainingByteCount >= chunkLength else {
                throw MIDIFile.DecodeError.malformed(
                    "There was a problem reading track data blob. Encountered end of data early."
                )
            }
            
            guard let readChunk = try? dataReader.read(bytes: chunkLength) else {
                throw MIDIFile.DecodeError.malformed(
                    "There was a problem reading track data blob. Encountered end of data early."
                )
            }
            return readChunk
        }
        
        try self.init(midi1SMFRawBytes: remainingData)
    }
    
    /// Init from raw data stream, excluding the header identifier and length.
    internal init<D: MutableDataProtocol>(midi1SMFRawBytes rawData: D) throws {
        // chunk data
        
        try rawData.withDataReader { dataReader in
            // events
        
            var eventsCounted = 0
            var endOfChunk = false
            var newEvents: [MIDIFileEvent] = []
        
            // running status
        
            var runningStatus: MIDIFileEventPayload?
        
            while !endOfChunk {
                eventsCounted += 1
            
                // delta time
            
                guard let eventDeltaTimeRead = try? dataReader.nonAdvancingRead(bytes: 4)
                else {
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
            
                dataReader.advanceBy(eventDeltaTime.byteLength)
                
                // event
                
                // TODO: an effort to improve performance when reading large MIDI files, but parser needs to be rewritten to vastly improve efficiency
                let readAheadCount = dataReader.remainingByteCount.clamped(to: 1...512)
                guard var readBuffer = try? dataReader.nonAdvancingRead(bytes: readAheadCount)
                else {
                    throw MIDIFile.DecodeError.malformed(
                        "Encountered end of file early."
                    )
                }
            
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
                        if let bytes: D = runningStatus?.midi1SMFRawBytes(),
                           !bytes.isEmpty
                        {
                            let getRunningStatusByte: D.Element = bytes[bytes.startIndex]
                            runningStatusByte = getRunningStatusByte
                        }
                    }
                }
            
                // if running status byte is present, inject it into the byte buffer
                if let runningStatusByte = runningStatusByte {
                    readBuffer.insert(runningStatusByte, at: readBuffer.startIndex)
                }
            
                // iterate through all known event initializers
            
                var foundEvent: (newEvent: MIDIFileEventPayload, bufferLength: Int)?
            
                autoreleasepool {
                    for eventDef in MIDIFile.Chunk.Track.eventDecodeOrder.concreteTypes {
                        if let success = try? eventDef.initFrom(midi1SMFRawBytesStream: readBuffer) {
                            foundEvent = success
                            break // break for-loop lazily
                        }
                    }
                }
                
                if let foundEvent = foundEvent {
                    // inject delta time into event
                    let newEventDelta: MIDIFileEvent
                        .DeltaTime = .ticks(UInt32(eventDeltaTime.value))
                
                    // offset buffer length if runningStatusByte is present
                    let chunkBufferLength = runningStatusByte != nil
                        ? foundEvent.bufferLength - 1
                        : foundEvent.bufferLength
                
                    // add new event to new track
                    newEvents.append(foundEvent.newEvent.smfWrappedEvent(delta: newEventDelta))
                    dataReader.advanceBy(chunkBufferLength)
                
                    // store event in running status
                    let newEventBytes: D = foundEvent.newEvent.midi1SMFRawBytes()
                    if !newEventBytes.isEmpty {
                        let testForRunningStatusByte: D
                            .Element = (foundEvent.newEvent.midi1SMFRawBytes() as D).first!
                        
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
                
                    throw MIDIFile.DecodeError.malformed(
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
    ) throws -> D {
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
        var position: Double = 0.0
        return events.map {
            let deltaTicks = $0.delta.ticksValue(using: .musical(ticksPerQuarterNote: ppq))
            if deltaTicks != 0 {
                position += Double(deltaTicks) / Double(ppq)
            }
            return (beat: position, event: $0)
        }
    }
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
