//
//  Parameter Assign.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Assign (buttons to top left of channel strips)
    public enum Assign: Equatable, Hashable {
        case sendA
        case sendB
        case sendC
        case sendD
        case sendE
        case pan
        
        case recordReadyAll
        case bypass
        case mute
        case shift
        case suspend
        case `default`
        case assign
        case input
        case output
    }
    
}

extension MIDI.HUI.Parameter.Assign: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x0B
        // Assign 1 (buttons to top left of channel strips)
        case .output:          return (0x0B, 0x0)
        case .input:           return (0x0B, 0x1)
        case .pan:             return (0x0B, 0x2)
        case .sendE:           return (0x0B, 0x3)
        case .sendD:           return (0x0B, 0x4)
        case .sendC:           return (0x0B, 0x5)
        case .sendB:           return (0x0B, 0x6)
        case .sendA:           return (0x0B, 0x7)
            
        // Zone 0x0C
        // Assign 2 (buttons to top left of channel strips)
        case .assign:          return (0x0C, 0x0)
        case .default:         return (0x0C, 0x1)
        case .suspend:         return (0x0C, 0x2)
        case .shift:           return (0x0C, 0x3)
        case .mute:            return (0x0C, 0x4)
        case .bypass:          return (0x0C, 0x5)
        case .recordReadyAll:  return (0x0C, 0x6)
            
        }
        
    }
    
}
