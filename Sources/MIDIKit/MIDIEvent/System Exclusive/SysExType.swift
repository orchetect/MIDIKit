//
//  SysExType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Declarative System Exclusive MIDI Event types used in event filters.
    public enum SysExTypes {
        /// Return only System Exclusive events.
        case only
        /// Return only System Exclusive events matching a certain event type.
        case onlyType(SysExType)
        /// Return only System Exclusive events matching certain event type(s).
        case onlyTypes(Set<SysExType>)
        
        /// Retain System Exclusive events only with a certain type,
        /// while retaining all non-System Exclusive events.
        case keepType(SysExType)
        /// Retain System Exclusive events only with certain type(s),
        /// while retaining all non-System Exclusive events.
        case keepTypes(Set<SysExType>)
        
        /// Drop all System Exclusive events,
        /// while retaining all non-System Exclusive events.
        case drop
        /// Drop all System Exclusive events,
        /// while retaining all non-System Exclusive events matching a certain event type.
        case dropType(SysExType)
        /// while retaining all non-System Exclusive events matching certain event type(s).
        case dropTypes(Set<SysExType>)
    }
    
    /// System Exclusive MIDI Event types.
    public enum SysExType: Equatable, Hashable {
        case sysEx7
        case universalSysEx7
        case sysEx8
        case universalSysEx8
    }
}
