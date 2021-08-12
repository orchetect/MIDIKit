//
//  SysCommonType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    public enum SysCommonTypes {
        
        case only
        case onlyType(SysCommonType)
        case onlyTypes(Set<SysCommonType>)
        
        case keepType(SysCommonType)
        case keepTypes(Set<SysCommonType>)
        
        case drop
        case dropType(SysCommonType)
        case dropTypes(Set<SysCommonType>)
        
    }
    
    public enum SysCommonType {
        
        case timecodeQuarterFrame
        case songPositionPointer
        case songSelect
        case unofficialBusSelect
        case tuneRequest
        
    }
    
}
