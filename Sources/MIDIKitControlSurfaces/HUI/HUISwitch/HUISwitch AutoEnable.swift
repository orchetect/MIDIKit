//
//  HUISwitch AutoEnable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Auto Enable section (to the right of the channel strips).
    public enum AutoEnable: Equatable, Hashable {
        case fader
        case pan
        case plugin
        case mute
        case send
        case sendMute
    }
}

extension HUISwitch.AutoEnable: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x17
        // Auto Enable (To the right of the channel strips)
        case .plugin:    return (0x17, 0x0)
        case .pan:       return (0x17, 0x1)
        case .fader:     return (0x17, 0x2)
        case .sendMute:  return (0x17, 0x3)
        case .send:      return (0x17, 0x4)
        case .mute:      return (0x17, 0x5)
        }
    }
}

extension HUISwitch.AutoEnable: CustomStringConvertible {
    public var description: String {
        switch self {
        case .plugin:    return "plugin"
        case .pan:       return "pan"
        case .fader:     return "fader"
        case .sendMute:  return "sendMute"
        case .send:      return "send"
        case .mute:      return "mute"
        }
    }
}

extension HUISwitch.AutoEnable: Sendable { }
