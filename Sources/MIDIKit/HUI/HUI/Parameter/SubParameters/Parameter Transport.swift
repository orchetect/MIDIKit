//
//  Parameter Transport.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Parameter {
    
    /// Transport Section
    public enum Transport: Equatable, Hashable {
        
        case talkback     // activates onboard talkback mic
        case rewind
        case fastFwd
        case stop
        case play
        case record
        case punchAudition
        case punchPre
        case punchIn
        case punchOut
        case punchPost
        case rtz          // |< RTZ
        case end          // END >|
        case online
        case loop
        case quickPunch
        
    }
    
}

extension MIDI.HUI.Parameter.Transport: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        
        // Zone 0x0E
        // Transport Main
        case .talkback:        return (0x0E, 0x0)
        case .rewind:          return (0x0E, 0x1)
        case .fastFwd:         return (0x0E, 0x2)
        case .stop:            return (0x0E, 0x3)
        case .play:            return (0x0E, 0x4)
        case .record:          return (0x0E, 0x5)
            
        // Zone 0x0F
        // Transport continued
        case .rtz:             return (0x0F, 0x0)
        case .end:             return (0x0F, 0x1)
        case .online:          return (0x0F, 0x2)
        case .loop:            return (0x0F, 0x3)
        case .quickPunch:      return (0x0F, 0x4)
            
        // Zone 0x10
        // Transport Punch
        case .punchAudition:   return (0x10, 0x0)
        case .punchPre:        return (0x10, 0x1)
        case .punchIn:         return (0x10, 0x2)
        case .punchOut:        return (0x10, 0x3)
        case .punchPost:       return (0x10, 0x4)
            
        }
        
    }
    
}
