//
//  HUISwitch ChannelStrip.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Channel Strip switches.
    public enum ChannelStrip {
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

extension HUISwitch.ChannelStrip: Equatable { }

extension HUISwitch.ChannelStrip: Hashable { }

extension HUISwitch.ChannelStrip: Sendable { }

extension HUISwitch.ChannelStrip: HUISwitchProtocol {
    /// HUI port constants.
    public var port: HUIPort {
        switch self {
        // Zones 0x00 - 0x07
        // Channel Strips
        case .faderTouched: 0x0
        case .select:       0x1
        case .mute:         0x2
        case .solo:         0x3
        case .auto:         0x4
        case .vPotSelect:   0x5
        case .insert:       0x6
        case .recordReady:  0x7
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
        case .faderTouched: "faderTouched"
        case .select:       "select"
        case .mute:         "mute"
        case .solo:         "solo"
        case .auto:         "auto"
        case .vPotSelect:   "vPotSelect"
        case .insert:       "insert"
        case .recordReady:  "recordReady"
        }
    }
}
