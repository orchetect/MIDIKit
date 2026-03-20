//
//  Track+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

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
                    
                    if readBuffer.count == Self.trackEndByes.count,
                       readBuffer.elementsEqual(Self.trackEndByes)
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
                            $0 += $1.ticks
                        } + (dataEntryLSB?.delta.ticks ?? 0)
                        
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
