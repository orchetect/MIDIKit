//
//  Parameter AutoMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Auto Mode (To the right of the channel strips)
    public enum AutoMode: Equatable, Hashable {
        
        case read
        case latch
        case trim
        case touch
        case write
        case off
        
    }
    
}

extension MIDI.HUI.Parameter.AutoMode: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        case .trim:   return (0x18, 0x0)
        case .latch:  return (0x18, 0x1)
        case .read:   return (0x18, 0x2)
        case .off:    return (0x18, 0x3)
        case .write:  return (0x18, 0x4)
        case .touch:  return (0x18, 0x5)
            
        }
        
    }
    
}
