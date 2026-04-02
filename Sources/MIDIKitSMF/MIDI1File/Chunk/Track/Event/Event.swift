//
//  Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File.TrackChunk {
    /// Track event with a delta time offset.
    public struct Event {
        // MARK: - Typealiases
        
        /// Delta time advancement within a MIDI file track.
        public typealias DeltaTime = Timebase.DeltaTime
        
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

extension MIDI1File.TrackChunk.Event: Equatable { }

extension MIDI1File.TrackChunk.Event: Hashable { }

extension MIDI1File.TrackChunk.Event: Sendable { }

extension MIDI1File.TrackChunk.Event: CustomStringConvertible {
    public var description: String {
        "\(delta) - \(event)"
    }
}

extension MIDI1File.TrackChunk.Event: CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }
}
