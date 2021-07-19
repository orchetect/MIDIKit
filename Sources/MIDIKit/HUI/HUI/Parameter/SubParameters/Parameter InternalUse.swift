//
//  Parameter InternalUse.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Internal Functions - no LEDs or buttons associated
    public enum InternalUse: Equatable, Hashable {
        
        case footswitchRelay1
        case footswitchRelay2
        case click
        case beep
        
    }
    
}

extension MIDI.HUI.Parameter.InternalUse: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        case .footswitchRelay1:  return (0x1D, 0x0)
        case .footswitchRelay2:  return (0x1D, 0x1)
        case .click:             return (0x1D, 0x2)
        case .beep:              return (0x1D, 0x3)
            
        }
        
    }
    
}
