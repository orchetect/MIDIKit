//
//  Parameter StatusAndGroup.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Status/Group (To the right of the channel strips)
    public enum StatusAndGroup: Equatable, Hashable {
        
        case auto
        case monitor
        case phase
        case group
        case create
        case suspend
        
    }
    
}

extension MIDI.HUI.Parameter.StatusAndGroup: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        case .phase:    return (0x19, 0x0)
        case .monitor:  return (0x19, 0x1)
        case .auto:     return (0x19, 0x2)
        case .suspend:  return (0x19, 0x3)
        case .create:   return (0x19, 0x4)
        case .group:    return (0x19, 0x5)
        }
        
    }
    
}
