//
//  TrackChunk+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

extension MIDIFile.TrackChunk {
    /// Init from MIDI file data stream.
    /// If the initializer returns `nil`, discard the track without throwing an error.
    public init?<D: DataProtocol>(
        midi1SMFRawBytesStream stream: D,
        timebase: Timebase,
        options: MIDIFileTrackDecodeOptions
    ) throws(MIDIFileDecodeError) {
        guard stream.count >= 8 else {
            throw .malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        let track: Self? = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
            let identifierString = try parser.toMIDIFileDecodeError(
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
            
            guard identifierString == Self.identifier.string else {
                throw .malformed(
                    "Chunk header does not contain track header identifier. Found \(identifierString.quoted) instead."
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
        timebase: Timebase,
        options: MIDIFileTrackDecodeOptions
    ) throws(MIDIFileDecodeError) {
        // sanitize inputs
        let maxEventCount = options.maxEventCount?.clamped(to: 0...)
        
        // chunk data
        
        let track: Self? = try rawData.withDataParser { parser throws(MIDIFileDecodeError) in
            // events
            
            var endOfChunk = false
            var newEvents: [Event] = []
            var deltaTimeBeforeEndOfTrack: DeltaTime = .none
            
            // running status
            
            var parsedEventCount = 0
            var runningStatusByte: UInt8?
            
            do throws(MIDIFileDecodeError) {
                while !endOfChunk {
                    // check for early return if event count is being limited
                    if let maxEventCount, parsedEventCount >= maxEventCount { break }
                    
                    // delta time
                    
                    let eventDeltaTimeRead = try parser.toMIDIFileDecodeError(
                        malformedReason: "Encountered end of file early.",
                        try parser.read(bytes: 4, advance: false)
                    )
                    
                    guard let eventDeltaTime = eventDeltaTimeRead.decodeVariableLengthValue()
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
                        deltaTimeBeforeEndOfTrack = .ticks(UInt32(eventDeltaTime.value))
                        break
                    }
                    
                    // status
                    
                    let isStatusBytePresent = readBuffer[0] >= 0x80
                    
                    // parse out next event
                    
                    var foundEvent: (newEvent: any MIDIFileTrackEventPayload, bufferLength: Int, statusByte: UInt8)?
                    
                    let effectiveRunningStatus: UInt8? = isStatusBytePresent ? nil : runningStatusByte
                    if let eventType = MIDIFileTrackEventType(
                        atStartOf: readBuffer,
                        runningStatus: effectiveRunningStatus,
                        detectParameterNumberSequence: false // parse out discrete events; RPN/NRPN events are bundled later
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
                    let newEventDelta: DeltaTime = .ticks(UInt32(eventDeltaTime.value))
                    
                    // add new event to new track
                    newEvents.append(Event(delta: newEventDelta, event: foundEvent.newEvent.wrapped))
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
                var eventsIndex = newEvents.startIndex
                while eventsIndex < newEvents.endIndex {
                    Self.bundleRPNAndNRPN(index: eventsIndex, in: &newEvents, timebase: timebase)
                    eventsIndex += 1
                }
            }
            
            var track = MIDIFile.TrackChunk(events: newEvents)
            track.deltaTimeBeforeEndOfTrack = deltaTimeBeforeEndOfTrack
            return track
        }
        
        if let track { self = track } else { return nil }
    }
    
    static func bundleRPNAndNRPN(
        index eventsIndex: [Event].Index,
        in newEvents: inout [Event],
        timebase: Timebase
    ) {
        guard newEvents[eventsIndex].event.eventType == .cc
        else { return }
        
        guard case let .cc(msbEvent) = newEvents[eventsIndex].event
        else { return }
        
        guard msbEvent.controller == .rpnMSB || msbEvent.controller == .nrpnMSB
        else { return }
        
        // minimum 3 events required, also prevents crash
        guard newEvents.indices.contains(eventsIndex.advanced(by: 2))
        else { return }
        
        // all CC events
        guard newEvents[eventsIndex ... eventsIndex.advanced(by: 2)]
            .allSatisfy({ $0.event.eventType == .cc })
        else { return }
        
        // same channel
        guard newEvents[eventsIndex ... eventsIndex.advanced(by: 2)]
            .map({ $0.event.midiEvent()?.channel })
            .allSatisfy({ $0 == msbEvent.channel })
        else { return }
        
        let dataEntryLSBIndex = eventsIndex.advanced(by: 3)
        let dataEntryLSB: (
            delta: DeltaTime, value: UInt7
        )? = if newEvents.indices.contains(dataEntryLSBIndex),
                case let .cc(dataEntryLSBCCEvent) = newEvents[dataEntryLSBIndex].event,
                dataEntryLSBCCEvent.controller == .lsb(for: .dataEntry),
                dataEntryLSBCCEvent.channel == msbEvent.channel // must match channel
        { (newEvents[dataEntryLSBIndex].delta, dataEntryLSBCCEvent.value.midi1Value) } else { nil }
        
        let eventsSlice = newEvents[eventsIndex ... eventsIndex.advanced(by: 2)]
        let extractedEvents: [(delta: DeltaTime, event: MIDIEvent.CC)] = eventsSlice.compactMap {
            guard case let .cc(e) = $0.event else { return nil }
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
        let totalDelta: UInt32 = extractedEvents.map(\.delta).reduce(into: 0) {
            $0 += $1.ticks(using: timebase)
        } + (dataEntryLSB?.delta.ticks(using: timebase) ?? 0)
        
        var replacementEvent: Event?
        
        if extractedEvents[0].event.controller == .rpnMSB,
           extractedEvents[1].event.controller == .rpnLSB,
           extractedEvents[2].event.controller == .dataEntry
        {
            let rc = MIDIEvent.RegisteredController(
                parameter: param,
                data: (msb: dataEntryMSB, lsb: dataEntryLSB?.value)
            )
            let midiEvent: MIDIEvent.RPN = .init(rc, channel: channel)
            let midiTrackEvent: MIDIFileTrackEvent = .rpn(midiEvent)
            replacementEvent = Event(delta: .ticks(totalDelta), event: midiTrackEvent)
        } else if extractedEvents[0].event.controller == .nrpnMSB,
                  extractedEvents[1].event.controller == .nrpnLSB,
                  extractedEvents[2].event.controller == .dataEntry
        {
            let rc = MIDIEvent.AssignableController(
                parameter: param,
                data: (msb: dataEntryMSB, lsb: dataEntryLSB?.value)
            )
            let midiEvent: MIDIEvent.NRPN = .init(rc, channel: channel)
            let midiTrackEvent: MIDIFileTrackEvent = .nrpn(midiEvent)
            replacementEvent = Event(delta: .ticks(totalDelta), event: midiTrackEvent)
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
