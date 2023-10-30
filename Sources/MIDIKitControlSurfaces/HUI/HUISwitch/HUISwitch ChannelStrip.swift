//
//  HUISwitch ChannelStrip.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Channel Strip switches.
    public enum ChannelStrip: Equatable, Hashable {
        case recordReady
        case insert
        case vPotSelect
        case auto
        case solo
        case mute
        case select
        case faderTouched
    }
}

extension HUISwitch.ChannelStrip: HUISwitchProtocol {
    /// HUI port constants.
    public var port: HUIPort {
        switch self {
        // Zones 0x00 - 0x07
        // Channel Strips
        case .faderTouched:  return 0x0
        case .select:        return 0x1
        case .mute:          return 0x2
        case .solo:          return 0x3
        case .auto:          return 0x4
        case .vPotSelect:    return 0x5
        case .insert:        return 0x6
        case .recordReady:   return 0x7
        }
    }
    
    public var zoneAndPort: HUIZoneAndPort {
        // note: zone (channel number) will be provided when accessed from `HUISwitch.zoneAndPort`
        
        // this method is only here to fulfill the HUISwitchProtocol protocol requirement, it's not
        // actually used (and should not actually be used)
        // if it is ever used, the channel (0x00) provided here should be replaced with the channel
        // strip number (0x00 ... 0x07) after calling this method
        
        (0x00, port)
    }
}

extension HUISwitch.ChannelStrip: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zones 0x00 - 0x07
        // Channel Strips
        case .faderTouched:  return "faderTouched"
        case .select:        return "select"
        case .mute:          return "mute"
        case .solo:          return "solo"
        case .auto:          return "auto"
        case .vPotSelect:    return "vPotSelect"
        case .insert:        return "insert"
        case .recordReady:   return "recordReady"
        }
    }
}

extension HUISwitch.ChannelStrip: Sendable { }
