//
//  Parameter NumPad.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Number entry pad
    public enum NumPad: Equatable, Hashable {
        
        case num0
        case num1
        case num2
        case num3
        case num4
        case num5
        case num6
        case num7
        case num8
        case num9
        
        case period       // .
        case plus         // +
        case minus        // -
        case enter
        case clr          // clr
        case equals       // =
        case forwardSlash // /
        case asterisk     // *
        
    }
    
}

extension MIDI.HUI.Parameter.NumPad: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x13
        // Num Pad
        case .num0:          return (0x13, 0x0)
        case .num1:          return (0x13, 0x1)
        case .num4:          return (0x13, 0x2)
        case .num2:          return (0x13, 0x3)
        case .num5:          return (0x13, 0x4)
        case .period:        return (0x13, 0x5)
        case .num3:          return (0x13, 0x6)
        case .num6:          return (0x13, 0x7)
        
        // Zone 0x14
        // Num Pad
        case .enter:         return (0x14, 0x0)
        case .plus:          return (0x14, 0x1)
        
        // Zone 0x15
        // Num Pad
        case .num7:          return (0x15, 0x0)
        case .num8:          return (0x15, 0x1)
        case .num9:          return (0x15, 0x2)
        case .minus:         return (0x15, 0x3)
        case .clr:           return (0x15, 0x4)
        case .equals:        return (0x15, 0x5)
        case .forwardSlash:  return (0x15, 0x6)
        case .asterisk:      return (0x15, 0x7)
        
        }
        
    }
    
}
