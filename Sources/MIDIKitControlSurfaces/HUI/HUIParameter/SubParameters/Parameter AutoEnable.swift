//
//  Parameter AutoEnable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIParameter {
    /// Auto Enable (To the right of the channel strips).
    public enum AutoEnable: Equatable, Hashable {
        case fader
        case pan
        case plugin
        case mute
        case send
        case sendMute
    }
}

extension HUIParameter.AutoEnable: HUIParameterProtocol {
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

extension HUIParameter.AutoEnable: CustomStringConvertible {
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
