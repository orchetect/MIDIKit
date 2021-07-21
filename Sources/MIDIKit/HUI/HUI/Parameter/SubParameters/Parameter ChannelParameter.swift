//
//  Parameter ChannelParameter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Channel Strips
    public enum ChannelParameter: Equatable, Hashable {
        
        case recordReady
        case insert
        case vPotSelect
        case auto
        case solo
        case mute
        case select
        case faderTouched
        
    }
    
}

extension MIDI.HUI.Parameter.ChannelParameter: MIDIHUIParameterProtocol {
    
    @inlinable
    public var port: MIDI.HUI.Port {
        
        switch self {
        
        // Zones 0x00 - 0x07
        // Channel Strips
        case .faderTouched:  return 0x0
        case .select:        return 0x1
        case .mute:          return 0x2
        case .solo:          return 0x3
        case .auto:          return 0x4
        case .vPotSelect:    return 0x5
        case .insert:        return 0x6
        case .recordReady:   return 0x7
            
        }
        
    }
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        // note: zone (channel number) will be provided when accessed from `MIDI.HUI.Parameter.zoneAndPort`
        
        // this method is only here to fulfil the MIDIHUIParameterProtocol protocol requirement, it's not actually used (and should not actually be used)
        // if it is ever used, the channel (0x00) provided here should be replaced with the channel strip number (0x00...0x07) after calling this method
        
        return (0x00, port)
        
    }
    
}
