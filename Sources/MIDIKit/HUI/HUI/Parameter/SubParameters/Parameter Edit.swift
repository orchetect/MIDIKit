//
//  Parameter Edit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Edit (To the right of the channel strips)
    public enum Edit: Equatable, Hashable {
        
        case capture
        case cut
        case paste
        case separate
        case copy
        case delete
        
    }
    
}

extension MIDI.HUI.Parameter.Edit: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        case .paste:     return (0x1A, 0x0)
        case .cut:       return (0x1A, 0x1)
        case .capture:   return (0x1A, 0x2)
        case .delete:    return (0x1A, 0x3)
        case .copy:      return (0x1A, 0x4)
        case .separate:  return (0x1A, 0x5)
            
        }
        
    }
    
}
