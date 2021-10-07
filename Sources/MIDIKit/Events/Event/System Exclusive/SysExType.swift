//
//  SysExType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
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
    
    public enum SysExType {
        
        case sysEx
        case universalSysEx
        
    }
    
}
