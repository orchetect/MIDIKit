//
//  UtilityType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    /// Declarative Utility MIDI Event types used in event filters.
    public enum UtilityTypes {
        
        /// Return only Utility events.
        case only
        /// Return only Utility events matching a certain event type.
        case onlyType(UtilityType)
        /// Return only Utility events matching certain event type(s).
        case onlyTypes(Set<UtilityType>)
        
        /// Retain Utility events only with a certain type,
        /// while retaining all non-Utility events.
        case keepType(UtilityType)
        /// Retain Utility events only with certain type(s),
        /// while retaining all non-Utility events.
        case keepTypes(Set<UtilityType>)
        
        /// Drop all Utility events,
        /// while retaining all non-Utility events.
        case drop
        /// Drop all Utility events,
        /// while retaining all non-Utility events matching a certain event type.
        case dropType(UtilityType)
        /// while retaining all non-Utility events matching certain event type(s).
        case dropTypes(Set<UtilityType>)
        
    }
    
    /// Utility MIDI Event types.
    public enum UtilityType: Equatable, Hashable {
        
        case noOp
        case jrClock
        case jrTimestamp
        
    }
    
}
