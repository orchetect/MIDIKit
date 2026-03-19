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

// MARK: - Methods

extension MIDIFile.Chunk.Track {
    /// Returns ``events`` mapped to their quarter-note beat position from the start of the track.
    /// This is computed, so avoid repeated calls to this method.
    /// Ensure the `ppq` (ticks per quarter note) supplied is the same as used in the MIDI file.
    public func eventsAtQuarterNotePositions(atPPQ ppq: UInt16) -> [(beat: Double, event: MIDIFileEvent)] {
        var position = 0.0
        return events.map {
            position += $0.delta.quarterNoteBeats(atPPQ: ppq)
            return (beat: position, event: $0)
        }
    }
}
