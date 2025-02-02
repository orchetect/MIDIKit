//
//  HUISwitch AutoEnable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Auto Enable section (to the right of the channel strips).
    public enum AutoEnable {
        case fader
        case pan
        case plugin
        case mute
        case send
        case sendMute
    }
}

extension HUISwitch.AutoEnable: Equatable { }

extension HUISwitch.AutoEnable: Hashable { }

extension HUISwitch.AutoEnable: Sendable { }

extension HUISwitch.AutoEnable: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x17
        // Auto Enable (To the right of the channel strips)
        case .plugin:   (0x17, 0x0)
        case .pan:      (0x17, 0x1)
        case .fader:    (0x17, 0x2)
        case .sendMute: (0x17, 0x3)
        case .send:     (0x17, 0x4)
        case .mute:     (0x17, 0x5)
        }
    }
}

extension HUISwitch.AutoEnable: CustomStringConvertible {
    public var description: String {
        switch self {
        case .plugin:   "plugin"
        case .pan:      "pan"
        case .fader:    "fader"
        case .sendMute: "sendMute"
        case .send:     "send"
        case .mute:     "mute"
        }
    }
}
