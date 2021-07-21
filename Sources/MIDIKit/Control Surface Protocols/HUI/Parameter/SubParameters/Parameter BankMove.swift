//
//  Parameter BankMove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Bank and channel navigation
    public enum BankMove: Equatable, Hashable {
        
        case channelLeft
        case channelRight
        
        case bankLeft
        case bankRight
        
    }
    
}

extension MIDI.HUI.Parameter.BankMove: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        case .channelLeft:   return (0x0A, 0x0)
        case .bankLeft:      return (0x0A, 0x1)
        case .channelRight:  return (0x0A, 0x2)
        case .bankRight:     return (0x0A, 0x3)
            
        }
        
    }
    
}

extension MIDI.HUI.Parameter.BankMove: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        case .channelLeft:   return ".channelLeft"
        case .bankLeft:      return ".bankLeft"
        case .channelRight:  return ".channelRight"
        case .bankRight:     return ".bankRight"
        
        }

    }

}
