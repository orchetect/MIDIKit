//
//  Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.TrackChunk {
    /// Track event with a delta time offset.
    public struct Event {
        // MARK: - Typealiases
        
        /// Delta time advancement within a MIDI file track.
        public typealias DeltaTime = Timebase.DeltaTime
        
        // MARK: - Properties
        
        /// The delta time offset of the event.
        public var delta: DeltaTime
        
        /// The track event.
        public var event: MIDIFileTrackEvent
        
        public init(delta: DeltaTime, event: MIDIFileTrackEvent) {
            self.delta = delta
            self.event = event
        }
        
        @_disfavoredOverload
        public init(delta: DeltaTime, event: any MIDIFileTrackEventPayload) {
            self.delta = delta
            self.event = event.asMIDIFileTrackEvent()
        }
    }
}

extension MIDIFile.TrackChunk.Event: Equatable { }

extension MIDIFile.TrackChunk.Event: Hashable { }

extension MIDIFile.TrackChunk.Event: Sendable { }

extension MIDIFile.TrackChunk.Event: CustomStringConvertible {
    public var description: String {
        "\(delta) - \(event)"
    }
}

extension MIDIFile.TrackChunk.Event: CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }
}
