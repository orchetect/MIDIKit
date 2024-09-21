//
//  HUISwitch FootswitchesAndSounds.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Footswitches and Sounds - no LEDs or buttons associated.
    public enum FootswitchesAndSounds: Equatable, Hashable {
        case footswitchRelay1
        case footswitchRelay2
        case click
        case beep
    }
}

extension HUISwitch.FootswitchesAndSounds: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        case .footswitchRelay1:  return (0x1D, 0x0)
        case .footswitchRelay2:  return (0x1D, 0x1)
        case .click:             return (0x1D, 0x2)
        case .beep:              return (0x1D, 0x3)
        }
    }
}

extension HUISwitch.FootswitchesAndSounds: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        case .footswitchRelay1:  return "footswitchRelay1"
        case .footswitchRelay2:  return "footswitchRelay2"
        case .click:             return "click"
        case .beep:              return "beep"
        }
    }
}

extension HUISwitch.FootswitchesAndSounds: Sendable { }
