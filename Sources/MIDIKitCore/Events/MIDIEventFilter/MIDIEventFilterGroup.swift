//
//  MIDIEventFilterGroup.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// A group of filters containing zero or more MIDI event filters in series, with a method to filter
/// MIDI events through the stored filters.
public struct MIDIEventFilterGroup {
    /// Filters to use, processed in series.
    public var filters: [MIDIEventFilter]
    
    /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events
    /// through the filters.
    public init() {
        filters = []
    }
    
    /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events
    /// through the filters.
    public init(filter: MIDIEventFilter) {
        filters = [filter]
    }
    
    /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events
    /// through the filters.
    public init(filters: [MIDIEventFilter]) {
        self.filters = filters
    }
    
    /// Filter events based on the stored ``filters`` in series.
    public func filter(events: [MIDIEvent]) -> [MIDIEvent] {
        var events = events
    
        for filter in filters {
            events = filter.apply(to: events)
        }
    
        return events
    }
}

// MARK: - Equatable

extension MIDIEventFilterGroup: Equatable {
    public static func == (lhs: MIDIEventFilterGroup, rhs: MIDIEventFilterGroup) -> Bool {
        lhs.filters == rhs.filters
    }
}

// MARK: - Hashable

extension MIDIEventFilterGroup: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(filters)
    }
}

// MARK: - Sendable

extension MIDIEventFilterGroup: Sendable { }
