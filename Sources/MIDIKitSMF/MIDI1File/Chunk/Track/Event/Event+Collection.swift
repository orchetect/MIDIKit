//
//  Event+Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension RangeReplaceableCollection {
    /// Append a new MIDI track event with delta time offset.
    @_disfavoredOverload
    public mutating func append<Timebase: MIDIFileTimebase>(
        delta: MIDI1File<Timebase>.Track.DeltaTime = .none,
        _ newEvent: MIDIFileEvent
    ) where Element == MIDI1File<Timebase>.Track.Event {
        let timedEvent = Element(delta: delta, event: newEvent)
        append(timedEvent)
    }
    
    /// Inserts a new MIDI track event with delta time offset into the collection at the specified position.
    @_disfavoredOverload
    public mutating func insert<Timebase: MIDIFileTimebase>(
        delta: MIDI1File<Timebase>.Track.DeltaTime = .none,
        newEvent: MIDIFileEvent,
        at i: Index
    ) where Element == MIDI1File<Timebase>.Track.Event {
        let timedEvent = Element(delta: delta, event: newEvent)
        insert(timedEvent, at: i)
    }
}

extension Collection {
    /// Returns `true` if the content of the MIDI file track event collection is equal to another collection.
    /// (Omits ``id`` properties from the comparison.)
    public func isEqual<Timebase: MIDIFileTimebase>(to other: some Collection<Element>) -> Bool
    where Element == MIDI1File<Timebase>.Track.Event {
        guard count == other.count else { return false }
        
        for (lhs, rhs) in zip(self, other) {
            guard lhs.isEqual(to: rhs) else { return false }
        }
        return true
    }
}
