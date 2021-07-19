//
//  Parameter AutoEnable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Auto Enable (To the right of the channel strips)
    public enum AutoEnable: Equatable, Hashable {
        
        case fader
        case pan
        case plugin
        case mute
        case send
        case sendMute
        
    }
    
}

extension MIDI.HUI.Parameter.AutoEnable: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        case.plugin:    return (0x17, 0x0)
        case.pan:       return (0x17, 0x1)
        case.fader:     return (0x17, 0x2)
        case.sendMute:  return (0x17, 0x3)
        case.send:      return (0x17, 0x4)
        case.mute:      return (0x17, 0x5)
            
        }
        
    }
    
}
