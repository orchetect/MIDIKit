//
//  HUISwitch FootswitchesAndSounds.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Footswitches and Sounds - no LEDs or buttons associated.
    public enum FootswitchesAndSounds {
        case footswitchRelay1
        case footswitchRelay2
        case click
        case beep
    }
}

extension HUISwitch.FootswitchesAndSounds: Equatable { }

extension HUISwitch.FootswitchesAndSounds: Hashable { }

extension HUISwitch.FootswitchesAndSounds: Sendable { }

extension HUISwitch.FootswitchesAndSounds: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        case .footswitchRelay1: (0x1D, 0x0)
        case .footswitchRelay2: (0x1D, 0x1)
        case .click:            (0x1D, 0x2)
        case .beep:             (0x1D, 0x3)
        }
    }
}

extension HUISwitch.FootswitchesAndSounds: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        case .footswitchRelay1: "footswitchRelay1"
        case .footswitchRelay2: "footswitchRelay2"
        case .click:            "click"
        case .beep:             "beep"
        }
    }
}
