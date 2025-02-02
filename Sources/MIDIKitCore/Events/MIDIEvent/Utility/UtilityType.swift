//
//  UtilityType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIEvent {
    /// Utility MIDI Event types.
    public enum UtilityType {
        case noOp
        case jrClock
        case jrTimestamp
    }
}

extension MIDIEvent.UtilityType: Equatable { }

extension MIDIEvent.UtilityType: Hashable { }

extension MIDIEvent.UtilityType: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.UtilityType: Sendable { }

extension MIDIEvent {
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
}

extension MIDIEvent.UtilityTypes: Equatable { }

extension MIDIEvent.UtilityTypes: Hashable { }

extension MIDIEvent.UtilityTypes: Sendable { }
