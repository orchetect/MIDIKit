//
//  Parameter FunctionKey.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Function Keys (To the right of the channel strips)
    public enum FunctionKey: Equatable, Hashable {
        
        case f1
        case f2
        case f3
        case f4
        case f5
        case f6
        case f7
        case f8OrEsc
        
    }
    
}

extension MIDI.HUI.Parameter.FunctionKey: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x1B
        // Function Keys
        case .f1:         return (0x1B, 0x0)
        case .f2:         return (0x1B, 0x1)
        case .f3:         return (0x1B, 0x2)
        case .f4:         return (0x1B, 0x3)
        case .f5:         return (0x1B, 0x4)
        case .f6:         return (0x1B, 0x5)
        case .f7:         return (0x1B, 0x6)
        case .f8OrEsc:    return (0x1B, 0x7)
            
        }
        
    }
    
}
