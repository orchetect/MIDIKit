//
//  MIDIEventFilterGroup.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

/// An object that stores zero or more MIDI event filters in series, with a method to filter MIDI events through the stored filters.
open class MIDIEventFilterGroup {
    /// Filters to use, processed in series.
    public var filters: [MIDIEventFilter]
        
    /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events through the filters.
    public init(filter: MIDIEventFilter) {
        filters = [filter]
    }
        
    /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events through the filters.
    public init(filters: [MIDIEventFilter]) {
        self.filters = filters
    }
        
    /// Filter events based on the stored `filters`.
    public func filter(events: [MIDIEvent]) -> [MIDIEvent] {
        var events = events
            
        for filter in filters {
            events = filter.apply(to: events)
        }
            
        return events
    }
}
