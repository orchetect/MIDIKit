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
        case vSel
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
        
        // note: zone (channel number) will be provided when accessed from `MIDI.HUI.Parameter.zoneAndPort`
        
        switch self {
        case .faderTouched:  return 0x0
        case .select:        return 0x1
        case .mute:          return 0x2
        case .solo:          return 0x3
        case .auto:          return 0x4
        case .vSel:          return 0x5
        case .insert:        return 0x6
        case .recordReady:   return 0x7
        }
        
    }
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        return (0x00, port)
        
    }
    
}
