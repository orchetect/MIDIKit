//
//  HUISwitch Transport.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Transport section.
    public enum Transport {
        case talkback      // activates onboard talkback mic
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
        case rtz           // |< RTZ
        case end           // END >|
        case online
        case loop
        case quickPunch
    }
}

extension HUISwitch.Transport: Equatable { }

extension HUISwitch.Transport: Hashable { }

extension HUISwitch.Transport: Sendable { }

extension HUISwitch.Transport: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x0E
        // Transport Main
        case .talkback:      (0x0E, 0x0)
        case .rewind:        (0x0E, 0x1)
        case .fastFwd:       (0x0E, 0x2)
        case .stop:          (0x0E, 0x3)
        case .play:          (0x0E, 0x4)
        case .record:        (0x0E, 0x5)
        // Zone 0x0F
        // Transport continued
        case .rtz:           (0x0F, 0x0)
        case .end:           (0x0F, 0x1)
        case .online:        (0x0F, 0x2)
        case .loop:          (0x0F, 0x3)
        case .quickPunch:    (0x0F, 0x4)
        // Zone 0x10
        // Transport Punch
        case .punchAudition: (0x10, 0x0)
        case .punchPre:      (0x10, 0x1)
        case .punchIn:       (0x10, 0x2)
        case .punchOut:      (0x10, 0x3)
        case .punchPost:     (0x10, 0x4)
        }
    }
}

extension HUISwitch.Transport: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x0E
        // Transport Main
        case .talkback:      "talkback"
        case .rewind:        "rewind"
        case .fastFwd:       "fastFwd"
        case .stop:          "stop"
        case .play:          "play"
        case .record:        "record"
        // Zone 0x0F
        // Transport continued
        case .rtz:           "rtz"
        case .end:           "end"
        case .online:        "online"
        case .loop:          "loop"
        case .quickPunch:    "quickPunch"
        // Zone 0x10
        // Transport Punch
        case .punchAudition: "punchAudition"
        case .punchPre:      "punchPre"
        case .punchIn:       "punchIn"
        case .punchOut:      "punchOut"
        case .punchPost:     "punchPost"
        }
    }
}
