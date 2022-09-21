//
//  Parameter Transport.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIParameter {
    /// Transport section.
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

extension HUIParameter.Transport: HUIParameterProtocol {
    public var zoneAndPort: HUIZoneAndPort {
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

extension HUIParameter.Transport: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x0E
        // Transport Main
        case .talkback:        return "talkback"
        case .rewind:          return "rewind"
        case .fastFwd:         return "fastFwd"
        case .stop:            return "stop"
        case .play:            return "play"
        case .record:          return "record"
            
        // Zone 0x0F
        // Transport continued
        case .rtz:             return "rtz"
        case .end:             return "end"
        case .online:          return "online"
        case .loop:            return "loop"
        case .quickPunch:      return "quickPunch"
            
        // Zone 0x10
        // Transport Punch
        case .punchAudition:   return "punchAudition"
        case .punchPre:        return "punchPre"
        case .punchIn:         return "punchIn"
        case .punchOut:        return "punchOut"
        case .punchPost:       return "punchPost"
        }
    }
}
