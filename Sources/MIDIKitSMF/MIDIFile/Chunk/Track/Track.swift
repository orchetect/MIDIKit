//
//  Track.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - Track

extension MIDIFile.Chunk {
    /// Track: `MTrk` chunk type.
    public struct Track {
        /// Storage for events in the track.
        public var events: [MIDIFileEvent] = []
        
        /// Instance a new empty MIDI file track.
        public init() { }
        
        /// Instance a new MIDI file track with events.
        public init(events: [MIDIFileEvent]) {
            self.events = events
        }
        
        /// Instance a new MIDI file track with events.
        @_disfavoredOverload
        public init(events: some Sequence<MIDIFileEvent>) {
            self.events = Array(events)
        }
    }
}

extension MIDIFile.Chunk.Track: Equatable { }

extension MIDIFile.Chunk.Track: Hashable { }

extension MIDIFile.Chunk.Track: Sendable { }

extension MIDIFile.Chunk.Track: CustomStringConvertible {
    public var description: String {
        description(maxEventCount: 10) // by default, limit number of events
    }
    
    /// Generate a description of the track, optionally limiting the number of events in the output.
    public func description(maxEventCount: Int?) -> String {
        descriptionBuilder(
            maxEventCount: maxEventCount,
            deltaPadLength: 15,
            deltaDesc: { $0.description },
            eventDesc: { $0.smfDescription }
        )
    }
}

extension MIDIFile.Chunk.Track: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescription(maxEventCount: 10) // by default, limit number of events
    }
    
    /// Generate a debug description of the track, optionally limiting the number of events in the output.
    public func debugDescription(maxEventCount: Int?) -> String {
        descriptionBuilder(
            maxEventCount: maxEventCount,
            deltaPadLength: 15 + 11,
            deltaDesc: { $0.debugDescription },
            eventDesc: { $0.smfDebugDescription }
        )
    }
}

extension MIDIFile.Chunk.Track {
    func descriptionBuilder(
        maxEventCount: Int?,
        deltaPadLength: Int,
        deltaDesc: (MIDIFileEvent.DeltaTime) -> String,
        eventDesc: (any MIDIFileEventPayload) -> String
    ) -> String {
        // sanitize inputs
        let maxEventCount = maxEventCount?.clamped(to: 0...)
        
        var outputString = ""
        outputString += "Track(".newLined
        outputString += "  events (\(events.count)): ".newLined
        
        if events.isEmpty {
            outputString += "    No events.".newLined
        } else {
            let outputEvents = if let maxEventCount, maxEventCount < events.count {
                events.prefix(maxEventCount)
            } else {
                events[...]
            }
            
            for event in outputEvents {
                let deltaString = deltaDesc(event.smfUnwrappedEvent.delta)
                    .padding(toLength: deltaPadLength, withPad: " ", startingAt: 0)
                
                outputString += "    \(deltaString) \(eventDesc(event.smfUnwrappedEvent.event))"
                    .newLined
            }
            
            let excludedEventCount = events.count - outputEvents.count
            if excludedEventCount > 0 {
                let eventsLimitedString = if maxEventCount == 0 {
                    "..."
                } else {
                    "+ \(excludedEventCount) more events" // + " (\(events.count) total events)"
                }
                outputString += "    \(eventsLimitedString.newLined)"
            }
        }
        
        outputString += ")"
        
        return outputString
    }
}

extension MIDIFile.Chunk.Track: MIDIFileChunk {
    public var identifier: String { Self.staticIdentifier }
    
    public var chunkType: MIDIFile.ChunkType { Self.staticChunkType }
}

// MARK: - Static

extension MIDIFile.Chunk.Track {
    public static let staticIdentifier: String = "MTrk"
    public static let staticChunkType: MIDIFile.ChunkType = .track
    
    static let chunkEnd: [UInt8] = [0xFF, 0x2F, 0x00]
}

// MARK: - Static Constructors

extension MIDIFile.Chunk {
    /// Track: `MTrk` chunk type.
    public static func track(_ events: [MIDIFileEvent]) -> Self {
        .track(.init(events: events))
    }
    
    /// Track: `MTrk` chunk type.
    @_disfavoredOverload
    public static func track(_ events: some Sequence<MIDIFileEvent>) -> Self {
        .track(.init(events: events))
    }
}

// MARK: - Encoding

extension MIDIFile.Chunk.Track {
    /// Init from MIDI file data stream.
    /// If the initializer returns `nil`, discard the track without throwing an error.
    public init?<D: DataProtocol>(
        midi1SMFRawBytesStream stream: D,
        timebase: MIDIFile.Timebase,
        options: DecodeOptions
    ) throws(MIDIFile.DecodeError) {
        guard stream.count >= 8 else {
            throw .malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        let track: Self? = try stream.withDataParser { parser throws(MIDIFile.DecodeError) in
            let chunkTypeString = try parser.toMIDIFileDecodeError(
                malformedReason: "Missing chunk type bytes.",
                try parser.read(bytes: 4).asciiDataToString() ?? "????"
            )
        
            guard let chunkLengthInt32 = (try? parser.read(bytes: 4))?
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
        
            guard parser.remainingByteCount >= chunkLength else {
                throw .malformed(
                    "There was a problem reading track data blob. Encountered end of data early."
                )
            }
            
            guard let readChunk = try? parser.read(bytes: chunkLength) else {
                throw .malformed(
                    "There was a problem reading track data blob. Encountered end of data early."
                )
            }
            
            // we can't pass pointer ranges outside of the data reader closure,
            // so we must use them within the closure
            return try Self(
                midi1SMFRawBytes: readChunk,
                timebase: timebase,
                options: options
            )
        }
        
        if let track { self = track } else { return nil }
    }
    
    /// Init from raw data stream, excluding the header identifier and length.
    /// If the initializer returns `nil`, discard the track without throwing an error.
    init?<D: DataProtocol>(
        midi1SMFRawBytes rawData: D,
        timebase: MIDIFile.Timebase,
        options: DecodeOptions
    ) throws(MIDIFile.DecodeError) {
        // sanitize inputs
        let maxEventCount = options.maxEventCount?.clamped(to: 0...)
        
        // chunk data
        
        let track: Self? = try rawData.withDataParser { parser throws(MIDIFile.DecodeError) in
            // events
            
            var endOfChunk = false
            var newEvents: [MIDIFileEvent] = []
            
            // running status
            
            var parsedEventCount = 0
            var runningStatusByte: UInt8?
            
            do throws(MIDIFile.DecodeError) {
                while !endOfChunk {
                    // check for early return if event count is being limited
                    if let maxEventCount, parsedEventCount >= maxEventCount { break }
                    
                    // delta time
                    
                    let eventDeltaTimeRead = try parser.toMIDIFileDecodeError(
                        malformedReason: "Encountered end of file early.",
                        try parser.read(bytes: 4, advance: false)
                    )
                    
                    guard let eventDeltaTime = MIDIFile
                        .decodeVariableLengthValue(from: eventDeltaTimeRead)
                    else {
                        throw .malformed(
                            "Delta time variable length value could not be read and may be malformed."
                        )
                    }
                    
                    try parser.toMIDIFileDecodeError(try parser.seek(by: eventDeltaTime.byteLength))
                    
                    // event
                    
                    let readBuffer = try parser.toMIDIFileDecodeError(
                        malformedReason: "Encountered end of file early.",
                        try parser.read(advance: false)
                    )
                    
                    guard !readBuffer.isEmpty else {
                        throw .malformed("Encountered end of file early.")
                    }
                    
                    // first check for end of track
                    
                    if readBuffer.count == Self.chunkEnd.count,
                       readBuffer.elementsEqual(Self.chunkEnd)
                    {
                        endOfChunk = true
                        break
                    }
                    
                    // status
                    
                    let isStatusBytePresent = readBuffer[0] >= 0x80
                    
                    // parse out next event
                    
                    var foundEvent: (newEvent: MIDIFileEventPayload, bufferLength: Int, statusByte: UInt8)?
                    
                    let effectiveRunningStatus: UInt8? = isStatusBytePresent ? nil : runningStatusByte
                    if let eventType = MIDIFileEventType.eventType(
                        atStartOf: readBuffer,
                        runningStatus: effectiveRunningStatus,
                        detectParameterNumberSequence: false
                    ) {
                        let result = try eventType.concreteType.initFrom(
                            midi1SMFRawBytesStream: readBuffer,
                            runningStatus: effectiveRunningStatus
                        )
                        let statusByte = effectiveRunningStatus ?? readBuffer[0]
                        foundEvent = (newEvent: result.newEvent, bufferLength: result.bufferLength, statusByte: statusByte)
                    }
                    
                    guard let foundEvent else {
                        // throw an error since no events could be decoded and there are still bytes
                        // remaining in the chunk
                        
                        let byteOffsetString = parser.readOffset
                            .hexString(padTo: 1, prefix: true)
                        
                        let sampleBytes = (1 ... 8)
                            .reduce([UInt8]()) {
                                // read as many bytes as possible, up to range.count
                                if let getBytes = try? parser.read(bytes: $1, advance: false) {
                                    return Array(getBytes)
                                }
                                return $0
                            }
                            .hexString(padEachTo: 2, prefixes: true)
                        
                        throw .malformed(
                            "Unexpected data encountered before end of track at track data byte offset \(byteOffsetString) (\(sampleBytes) ...)."
                        )
                    }
                    
                    // inject delta time into event
                    let newEventDelta: MIDIFileEvent.DeltaTime = .ticks(UInt32(eventDeltaTime.value))
                    
                    // add new event to new track
                    newEvents.append(foundEvent.newEvent.smfWrappedEvent(delta: newEventDelta))
                    try parser.toMIDIFileDecodeError(try parser.seek(by: foundEvent.bufferLength))
                    
                    // store event in running status
                    if (0x80 ... 0xEF).contains(foundEvent.statusByte) {
                        runningStatusByte = foundEvent.statusByte
                    } else if (0xF0 ... 0xF7).contains(foundEvent.statusByte) {
                        runningStatusByte = nil
                    }
                    
                    // increment event counter
                    parsedEventCount += 1
                }
            } catch {
                switch options.errorStrategy {
                case .throwOnError:
                    throw error
                case .discardTracksWithErrors:
                    return nil
                case .decodePartialTracksWithErrors:
                    // cease decoding the track, but continue to allow any events that have been decoded so far to be returned without throwing an error
                    break
                }
            }
            
            // bundle RPN and NRPN events
            
            if options.bundleRPNAndNRPNEvents {
                func bundleRPNAndNRPN(index: [MIDIFileEvent].Index) {
                    if newEvents[eventsIndex].eventType == .cc,
                       case let .cc(_, msbEvent) = newEvents[eventsIndex],
                       msbEvent.controller == .rpnMSB || msbEvent.controller == .nrpnMSB,
                       newEvents.indices.contains(eventsIndex.advanced(by: 2)), // minimum 3 events required, also prevents crash
                       newEvents[eventsIndex ... eventsIndex.advanced(by: 2)].allSatisfy({ $0.eventType == .cc }), // all CC events
                       newEvents[eventsIndex ... eventsIndex.advanced(by: 2)].map({ $0.event()?.channel }).allSatisfy({ $0 == msbEvent.channel }) // same channel
                    {
                        let dataEntryLSBIndex = eventsIndex.advanced(by: 3)
                        let dataEntryLSB: (
                            delta: MIDIFileEvent.DeltaTime, value: UInt7
                        )? = if newEvents.indices.contains(dataEntryLSBIndex),
                                                      case let .cc(dataEntryLSBDelta, dataEntryLSBCCEvent) = newEvents[dataEntryLSBIndex],
                                                      dataEntryLSBCCEvent.controller == .lsb(for: .dataEntry),
                                                      dataEntryLSBCCEvent.channel == msbEvent.channel // must match channel
                        { (dataEntryLSBDelta, dataEntryLSBCCEvent.value.midi1Value) } else { nil }
                        
                        let eventsSlice = newEvents[eventsIndex ... eventsIndex.advanced(by: 2)]
                        let extractedEvents: [(delta: MIDIFileEvent.DeltaTime, event: MIDIEvent.CC)] = eventsSlice.compactMap {
                            guard case let .cc(_, e) = $0 else { return nil }
                            return (delta: $0.delta, event: e)
                        }
                        guard extractedEvents.count == eventsSlice.count else {
                            assertionFailure("Error unwrapping CC events while bundling RPN/NRPN messages. This should never happen.")
                            return
                        }
                        
                        let channel = extractedEvents[0].event.channel
                        
                        let param = UInt7Pair(
                            msb: extractedEvents[0].event.value.midi1Value,
                            lsb: extractedEvents[1].event.value.midi1Value
                        )
                        let dataEntryMSB = extractedEvents[2].event.value.midi1Value
                        let totalDelta = extractedEvents.map(\.delta).reduce(into: 0) {
                            $0 += $1.ticksValue(using: timebase)
                        } + (dataEntryLSB?.delta.ticksValue(using: timebase) ?? 0)
                        
                        var replacementEvent: MIDIFileEvent?
                        
                        if extractedEvents[0].event.controller == .rpnMSB,
                           extractedEvents[1].event.controller == .rpnLSB,
                           extractedEvents[2].event.controller == .dataEntry
                        {
                            let rc = MIDIEvent.RegisteredController(
                                parameter: param,
                                data: (msb: dataEntryMSB, lsb: dataEntryLSB?.value)
                            )
                            let event: MIDIEvent.RPN = .init(rc, channel: channel)
                            
                            let rpn: MIDIFileEvent = .rpn(delta: .ticks(totalDelta), event: event)
                            replacementEvent = rpn
                        } else if extractedEvents[0].event.controller == .nrpnMSB,
                                  extractedEvents[1].event.controller == .nrpnLSB,
                                  extractedEvents[2].event.controller == .dataEntry
                        {
                            let rc = MIDIEvent.AssignableController(
                                parameter: param,
                                data: (msb: dataEntryMSB, lsb: dataEntryLSB?.value)
                            )
                            let event: MIDIEvent.NRPN = .init(rc, channel: channel)
                            
                            let nrpn: MIDIFileEvent = .nrpn(delta: .ticks(totalDelta), event: event)
                            replacementEvent = nrpn
                        }
                        
                        if let replacementEvent {
                            let oldEventCount = dataEntryLSB != nil ? 4 : 3
                            newEvents.replaceSubrange(
                                eventsIndex ..< eventsIndex.advanced(by: oldEventCount),
                                with: [replacementEvent]
                            )
                        }
                    }
                }
                
                var eventsIndex = newEvents.startIndex
                while eventsIndex < newEvents.endIndex {
                    bundleRPNAndNRPN(index: eventsIndex)
                    eventsIndex += 1
                }
            }
            
            return MIDIFile.Chunk.Track(events: newEvents)
        }
        
        if let track { self = track } else { return nil }
    }
}

extension MIDIFile.Chunk.Track {
    public func midi1SMFRawBytes(
        using timebase: MIDIFile.Timebase
    ) throws(MIDIFile.EncodeError) -> Data {
        try midi1SMFRawBytes(as: Data.self, using: timebase)
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(
        as dataType: D.Type,
        using timebase: MIDIFile.Timebase
    ) throws(MIDIFile.EncodeError) -> D {
        // assemble chunk body without header or length
        
        var bodyData = D()
        
        for event in events {
            let unwrapped = event.smfUnwrappedEvent
            bodyData.append(deltaTime: unwrapped.delta.ticksValue(using: timebase))
            bodyData.append(contentsOf: unwrapped.event.midi1SMFRawBytes(as: D.self))
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
