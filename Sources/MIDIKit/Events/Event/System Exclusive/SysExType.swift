//
//  SysExType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    public enum SysExTypes {
        
        case only
        case onlyType(SysExType)
        case onlyTypes(Set<SysExType>)
        
        case keepType(SysExType)
        case keepTypes(Set<SysExType>)
        
        case drop
        case dropType(SysExType)
        case dropTypes(Set<SysExType>)
        
    }
    
    public enum SysExType {
        
        case sysEx
        case universalSysEx
        
    }
    
}
