//
//  SysRealTimeType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    public enum SysRealTimeTypes {
        
        /// Return only System Real Time events.
        case only
        /// Return only System Real Time events matching a certain event type.
        case onlyType(SysRealTimeType)
        /// Return only System Real Time events matching certain event type(s).
        case onlyTypes(Set<SysRealTimeType>)
        
        /// Retain System Real Time events only with a certain type,
        /// while retaining all non-System Real Time events.
        case keepType(SysRealTimeType)
        /// Retain System Real Time events only with certain type(s),
        /// while retaining all non-System Real Time events.
        case keepTypes(Set<SysRealTimeType>)
        
        /// Drop all System Real Time events,
        /// while retaining all non-System Real Time events.
        case drop
        /// Drop all System Real Time events,
        /// while retaining all non-System Real Time events matching a certain event type.
        case dropType(SysRealTimeType)
        /// while retaining all non-System Real Time events matching certain event type(s).
        case dropTypes(Set<SysRealTimeType>)
        
    }
    
    public enum SysRealTimeType {
        
        case timingClock
        case start
        case `continue`
        case stop
        case activeSensing
        case systemReset
        
    }
    
}
