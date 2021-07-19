//
//  Parameter ControlRoom.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Control Room section
    public enum ControlRoom: Equatable, Hashable {
        
        case input1
        case input2
        case input3
        case discreteInput1to1
        case mute
        case dim
        case mono
        case output1
        case output2
        case output3
        
    }
    
}

extension MIDI.HUI.Parameter.ControlRoom: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x11
        // Control Room - Monitor Input
        case .input3:             return (0x11, 0x0)
        case .input2:             return (0x11, 0x1)
        case .input1:             return (0x11, 0x2)
        case .mute:               return (0x11, 0x3)
        case .discreteInput1to1:  return (0x11, 0x4)
            
        // Zone 0x12
        // Control Room - Monitor Output
        case .output3:            return (0x12, 0x0)
        case .output2:            return (0x12, 0x1)
        case .output1:            return (0x12, 0x2)
        case .dim:                return (0x12, 0x3)
        case .mono:               return (0x12, 0x4)
            
        }
        
    }
    
}
