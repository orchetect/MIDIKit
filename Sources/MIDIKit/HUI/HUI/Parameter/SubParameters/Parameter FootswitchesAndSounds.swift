//
//  Parameter FootswitchesAndSounds.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Footswitches and Sounds - no LEDs or buttons associated
    public enum FootswitchesAndSounds: Equatable, Hashable {
        
        case footswitchRelay1
        case footswitchRelay2
        case click
        case beep
        
    }
    
}

extension MIDI.HUI.Parameter.FootswitchesAndSounds: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        case .footswitchRelay1:  return (0x1D, 0x0)
        case .footswitchRelay2:  return (0x1D, 0x1)
        case .click:             return (0x1D, 0x2)
        case .beep:              return (0x1D, 0x3)
            
        }
        
    }
    
}
