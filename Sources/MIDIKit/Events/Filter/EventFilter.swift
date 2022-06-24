//
//  EventFilter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events through the filters.
    open class EventFilter {
        
        /// Filters to use.
        public var filters: [MIDI.Event.Filter]
        
        /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events through the filters.
        public init(filter: MIDI.Event.Filter) {
            self.filters = [filter]
        }
        
        /// An object that stores zero or more MIDI event filters, with a method to filter MIDI events through the filters.
        public init(filters: [MIDI.Event.Filter]) {
            self.filters = filters
        }
        
        /// Filter events based on the stored `filters`.
        public func filter(events: [MIDI.Event]) -> [MIDI.Event] {
            // iterate through filters array and return the result
            
            var events = events
            
            for filter in filters {
                events = filter.apply(to: events)
            }
            
            return events
            
        }
        
    }
    
}
