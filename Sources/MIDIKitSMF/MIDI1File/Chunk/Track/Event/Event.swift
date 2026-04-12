//
//  Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDI1File.Track {
    /// Track event with a delta time offset.
    public struct Event {
        // MARK: - Typealiases
        
        /// Delta time advancement within a MIDI file track.
        public typealias DeltaTime = Timebase.DeltaTime
        
        // MARK: - Identifiable
        
        public let id = UUID()
        
        // MARK: - Properties
        
        /// The delta time offset of the event.
        public var delta: DeltaTime
        
        /// The track event.
        public var event: MIDIFileEvent
        
        public init(delta: DeltaTime, event: MIDIFileEvent) {
            self.delta = delta
            self.event = event
        }
        
        @_disfavoredOverload
        public init(delta: DeltaTime, event: any MIDIFileEventPayload) {
            self.delta = delta
            self.event = event.asMIDIFileEvent()
        }
    }
}

extension MIDI1File.Track.Event: Equatable {
    /// Returns `true` if the content of the event is equal to another event.
    /// (Omits ``id`` from the comparison.)
    public func isEqual(to other: Self) -> Bool {
        delta == other.delta
            && event == other.event
    }
}

extension MIDI1File.Track.Event: Hashable { }

extension MIDI1File.Track.Event: Identifiable {
    // `id` is a stored instance property
}

extension MIDI1File.Track.Event: Sendable { }

extension MIDI1File.Track.Event: CustomStringConvertible {
    public var description: String {
        "\(delta) - \(event)"
    }
}

extension MIDI1File.Track.Event: CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }
}
