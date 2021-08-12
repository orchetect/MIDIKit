//
//  SysRealTimeType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    public enum SysRealTimeTypes {
        
        case only
        case onlyType(SysRealTimeType)
        case onlyTypes(Set<SysRealTimeType>)
        
        case keepType(SysRealTimeType)
        case keepTypes(Set<SysRealTimeType>)
        
        case drop
        case dropType(SysRealTimeType)
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
