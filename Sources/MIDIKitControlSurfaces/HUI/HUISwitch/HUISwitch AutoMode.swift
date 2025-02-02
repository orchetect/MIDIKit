//
//  HUISwitch AutoMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Auto Mode section (to the right of the channel strips).
    public enum AutoMode {
        case read
        case latch
        case trim
        case touch
        case write
        case off
    }
}

extension HUISwitch.AutoMode: Equatable { }

extension HUISwitch.AutoMode: Hashable { }

extension HUISwitch.AutoMode: Sendable { }

extension HUISwitch.AutoMode: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        case .trim:  (0x18, 0x0)
        case .latch: (0x18, 0x1)
        case .read:  (0x18, 0x2)
        case .off:   (0x18, 0x3)
        case .write: (0x18, 0x4)
        case .touch: (0x18, 0x5)
        }
    }
}

extension HUISwitch.AutoMode: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        case .trim:  "trim"
        case .latch: "latch"
        case .read:  "read"
        case .off:   "off"
        case .write: "write"
        case .touch: "touch"
        }
    }
}
