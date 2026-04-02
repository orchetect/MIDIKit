//
//  TrackChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import SwiftTimecodeCore
internal import SwiftDataParsing

// MARK: - Track

extension MIDI1File {
    /// Track: `MTrk` chunk type.
    public struct TrackChunk {
        // MARK: - Typealiases
        
        /// Delta time advancement within a MIDI file track.
        public typealias DeltaTime = Timebase.DeltaTime
        
        // MARK: - Properties
        
        /// Storage for events in the track.
        public var events: [Event] = []
        
        /// The delta time after the final event, just before the end-of-track.
        /// Typically this is `0`. A non-zero value is tantamount to empty track length prior to the end-of-track.
        public var deltaTimeBeforeEndOfTrack: DeltaTime = .none
        
        /// Instance a new empty MIDI file track.
        public init() { }
        
        /// Instance a new MIDI file track with events.
        public init(events: [Event]) {
            self.events = events
        }
        
        /// Instance a new MIDI file track with events.
        @_disfavoredOverload
        public init(events: some Sequence<Event>) {
            self.events = Array(events)
        }
    }
}

extension MIDI1File.TrackChunk: Equatable { }

extension MIDI1File.TrackChunk: Hashable { }

extension MIDI1File.TrackChunk: Sendable { }

extension MIDI1File.TrackChunk: CustomStringConvertible {
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

extension MIDI1File.TrackChunk: CustomDebugStringConvertible {
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

extension MIDI1File.TrackChunk {
    func descriptionBuilder(
        maxEventCount: Int?,
        deltaPadLength: Int,
        deltaDesc: (DeltaTime) -> String,
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
                let deltaString = deltaDesc(event.delta)
                    .padding(toLength: deltaPadLength, withPad: " ", startingAt: 0)
                
                outputString += "    \(deltaString) \(eventDesc(event.event.wrapped))"
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

// MARK: - Static

extension MIDI1File.TrackChunk {
    /// The 3-byte sequence that must appear at the end of every track.
    public static var trackEndByes: [UInt8] { [0xFF, 0x2F, 0x00] }
}

// MARK: - Properties

extension MIDI1File.TrackChunk {
    /// Returns all ``events`` that have a delta time of zero from the start of the track.
    public var eventsAtStart: [MIDIFileEvent] {
        events
            .prefix(while: { $0.delta == .none })
            .map(\.event)
    }
    
    /// Returns the timecode represented by the SMPTE offset event that appears at delta time 0 (start of track),
    /// if such an event exists.
    public var origin: Timecode? {
        guard let event = eventsAtStart.filter({ $0.eventType == .smpteOffset }).first,
              case let .smpteOffset(payload) = event
        else {
            return nil
        }
        return payload.timecode
    }
}
