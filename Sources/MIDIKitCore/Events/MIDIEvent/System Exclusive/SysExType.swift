//
//  SysExType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Exclusive MIDI Event types.
    public enum SysExType {
        /// System Exclusive: Manufacturer-specific (7-bit)
        /// (MIDI 1.0 / 2.0)
        case sysEx7
        
        /// Universal System Exclusive (7-bit)
        /// (MIDI 1.0 / 2.0)
        case universalSysEx7
        
        /// System Exclusive: Manufacturer-specific (8-bit)
        /// (MIDI 2.0 only)
        case sysEx8
        
        /// Universal System Exclusive (8-bit)
        /// (MIDI 2.0 only)
        case universalSysEx8
    }
}

extension MIDIEvent.SysExType: Equatable { }

extension MIDIEvent.SysExType: Hashable { }

extension MIDIEvent.SysExType: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.SysExType: Sendable { }

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
}

extension MIDIEvent.SysExTypes: Equatable { }

extension MIDIEvent.SysExTypes: Hashable { }

extension MIDIEvent.SysExTypes: Sendable { }
