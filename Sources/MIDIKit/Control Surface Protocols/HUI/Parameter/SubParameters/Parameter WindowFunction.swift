//
//  Parameter WindowFunction.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Window Functions
    public enum WindowFunction: Equatable, Hashable {
        
        case mix
        case edit
        case transport
        case memLoc
        case status
        case alt
        
    }
    
}

extension MIDI.HUI.Parameter.WindowFunction: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x09
        // Window Functions
        case .mix:        return (0x09, 0x0)
        case .edit:       return (0x09, 0x1)
        case .transport:  return (0x09, 0x2)
        case .memLoc:     return (0x09, 0x3)
        case .status:     return (0x09, 0x4)
        case .alt:        return (0x09, 0x5)
            
        }
        
    }
    
}

extension MIDI.HUI.Parameter.WindowFunction: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // Zone 0x09
        // Window Functions
        case .mix:        return ".mix"
        case .edit:       return ".edit"
        case .transport:  return ".transport"
        case .memLoc:     return ".memLoc"
        case .status:     return ".status"
        case .alt:        return ".alt"
        
        }

    }

}
