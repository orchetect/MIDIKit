//
//  Parameter TimeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Time Display LEDs
    public enum TimeDisplay: Equatable, Hashable {
        
        /// "TIME CODE"
        /// Time format LEDs that are to the left of the main time display above the control room section (no button, LED only)
        case timecode
        
        /// "FEET"
        /// Time format LEDs that are to the left of the main time display above the control room section (no button, LED only)
        case feet
        
        /// "BEATS"
        /// Time format LEDs that are to the left of the main time display above the control room section (no button, LED only)
        case beats
        
        /// "RUDE SOLO LIGHT"
        /// Above the control room section
        case rudeSolo
        
    }
    
}

extension MIDI.HUI.Parameter.TimeDisplay: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x16
        // Timecode LEDs (no buttons, LEDs only)
        case .timecode:  return (0x16, 0x0)
        case .feet:      return (0x16, 0x1)
        case .beats:     return (0x16, 0x2)
        case .rudeSolo:  return (0x16, 0x3)
            
        }
        
    }
    
}

extension MIDI.HUI.Parameter.TimeDisplay: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // Zone 0x16
        // Timecode LEDs (no buttons, LEDs only)
        case .timecode:  return ".timecode"
        case .feet:      return ".feet"
        case .beats:     return ".beats"
        case .rudeSolo:  return ".rudeSolo"
        
        }

    }

}
