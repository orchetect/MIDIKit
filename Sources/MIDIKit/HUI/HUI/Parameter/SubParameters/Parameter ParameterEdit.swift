//
//  Parameter ParameterEdit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Parameter Edit section
    public enum ParameterEdit: Equatable, Hashable {
        
        case assign
        case compare
        case bypass
        case select1
        case select2
        case select3
        case select4
        /// Toggle: Insert (off) / Param (on)
        case insertOrParam
        
    }
    
}

extension MIDI.HUI.Parameter.ParameterEdit: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        case .insertOrParam:  return (0x1C, 0x0)
        case .assign:         return (0x1C, 0x1)
        case .select1:        return (0x1C, 0x2)
        case .select2:        return (0x1C, 0x3)
        case .select3:        return (0x1C, 0x4)
        case .select4:        return (0x1C, 0x5)
        case .bypass:         return (0x1C, 0x6)
        case .compare:        return (0x1C, 0x7)
            
        }
        
    }
    
}
