//
//  SysCommonType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Common MIDI Event types.
    public enum SysCommonType: Equatable, Hashable {
        /// System Common: Timecode Quarter-Frame
        /// (MIDI 1.0 / 2.0)
        case timecodeQuarterFrame
        
        /// System Common: Song Position Pointer
        /// (MIDI 1.0 / 2.0)
        case songPositionPointer
        
        /// System Common: Song Select
        /// (MIDI 1.0 / 2.0)
        case songSelect
        
        /// System Common: Tune Request
        /// (MIDI 1.0 / 2.0)
        case tuneRequest
    }
}

extension MIDIEvent.SysCommonType: Identifiable {
    public var id: Self { self }
}

extension MIDIEvent.SysCommonType: Sendable { }

extension MIDIEvent {
    /// Declarative System Common MIDI Event types used in event filters.
    public enum SysCommonTypes: Equatable, Hashable {
        /// Return only System Common events.
        case only
        /// Return only System Common events matching a certain event type.
        case onlyType(SysCommonType)
        /// Return only System Common events matching certain event type(s).
        case onlyTypes(Set<SysCommonType>)
        
        /// Retain System Common events only with a certain type,
        /// while retaining all non-System Common events.
        case keepType(SysCommonType)
        /// Retain System Common events only with certain type(s),
        /// while retaining all non-System Common events.
        case keepTypes(Set<SysCommonType>)
        
        /// Drop all System Common events,
        /// while retaining all non-System Common events.
        case drop
        /// Drop all System Common events,
        /// while retaining all non-System Common events matching a certain event type.
        case dropType(SysCommonType)
        /// while retaining all non-System Common events matching certain event type(s).
        case dropTypes(Set<SysCommonType>)
    }
}

extension MIDIEvent.SysCommonTypes: Sendable { }
