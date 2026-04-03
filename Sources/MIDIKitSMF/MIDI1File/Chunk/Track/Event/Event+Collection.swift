//
//  Event+Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension RangeReplaceableCollection {
    /// Append a new MIDI track event with delta time offset.
    @_disfavoredOverload
    public mutating func append<Timebase: MIDIFileTimebase>(
        delta: MIDI1File<Timebase>.TrackChunk.DeltaTime = .none,
        _ newEvent: MIDIFileEvent
    ) where Element == MIDI1File<Timebase>.TrackChunk.Event {
        let timedEvent = Element(delta: delta, event: newEvent)
        append(timedEvent)
    }
}
