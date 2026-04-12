//
//  Track.swift
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
    public struct Track {
        // MARK: - Typealiases
        
        /// Delta time advancement within a MIDI file track.
        public typealias DeltaTime = Timebase.DeltaTime
        
        // MARK: - Identifiable
        
        public let id: UUID
        
        // MARK: - Properties
        
        /// Storage for events in the track.
        public var events: [Event]
        
        /// The delta time after the final event, just before the end-of-track.
        /// Typically this is `0`. A non-zero value is tantamount to empty track length prior to the end-of-track.
        public var deltaTimeBeforeEndOfTrack: DeltaTime
        
        /// Instance a new empty MIDI file track.
        public init() {
            self.init(events: [])
        }
        
        /// Instance a new MIDI file track with events.
        public init(events: [Event]) {
            id = UUID()
            self.events = events
            deltaTimeBeforeEndOfTrack = .none
        }
        
        /// Instance a new MIDI file track with events.
        @_disfavoredOverload
        public init(events: some Sequence<Event>) {
            self.init(events: Array(events))
        }
    }
}

extension MIDI1File.Track: Equatable { }

extension MIDI1File.Track: Hashable { }

extension MIDI1File.Track: Identifiable {
    // `id` is a stored instance property
}

extension MIDI1File.Track: Sendable { }

extension MIDI1File.Track: CustomStringConvertible {
    public var description: String {
        description(maxEventCount: 10) // by default, limit number of events
    }
    
    /// Generate a description of the track, optionally limiting the number of events in the output.
    public func description(maxEventCount: Int?) -> String {
        descriptionBuilder(
            maxEventCount: maxEventCount,
            deltaPadLength: 15,
            deltaDesc: { $0.description },
            eventDesc: { $0.midiFileDescription }
        )
    }
}

extension MIDI1File.Track: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescription(maxEventCount: 10) // by default, limit number of events
    }
    
    /// Generate a debug description of the track, optionally limiting the number of events in the output.
    public func debugDescription(maxEventCount: Int?) -> String {
        descriptionBuilder(
            maxEventCount: maxEventCount,
            deltaPadLength: 15 + 11,
            deltaDesc: { $0.debugDescription },
            eventDesc: { $0.midiFileDebugDescription }
        )
    }
}

extension MIDI1File.Track {
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

extension MIDI1File.Track {
    /// The 3-byte sequence that must appear at the end of every track.
    public static var trackEndByes: [UInt8] { [0xFF, 0x2F, 0x00] }
}

// MARK: - Common Methods Across all Timebases

extension MIDI1File.Track {
    /// Returns all ``events`` that have a delta time of zero from the start of the track.
    public var eventsAtStart: LazyMapSequence<LazyPrefixWhileSequence<LazySequence<[Event]>.Elements>.Elements, MIDIFileEvent> {
        events
            .lazy
            .prefix(while: { $0.delta == .none })
            .map(\.event)
    }
    
    /// Returns the first **Track Or Sequence Name** text event found at time zero, trimming whitespace.
    /// If no such event exists, `nil` is returned.
    public var initialTrackOrSequenceName: String? {
        eventsAtStart
            .lazy
            .compactMap { event -> MIDIFileEvent.Text? in
                guard case let .text(text) = event else { return nil }
                return text
            }
            .first(where: { $0.textType == .trackOrSequenceName })?
            .text
            .trimmingCharacters(in: .whitespaces)
    }
    
    /// Returns the timecode represented by the SMPTE offset event found at time zero.
    /// If no such event exists, `nil` is returned.
    public var initialSMPTEOffset: Timecode? {
        eventsAtStart
            .lazy
            .compactMap { event -> MIDIFileEvent.SMPTEOffset? in
                guard case let .smpteOffset(offset) = event else { return nil }
                return offset
            }
            .first?
            .timecode
    }
}
