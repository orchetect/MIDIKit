//
//  HUISurfaceEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// HUI Surface Event: basic HUI surface message definition.
/// These events are sent from the client surface to the host as a result of user interaction with
/// the surface: when the user moves a fader, turns a V-Pot knob, presses a button, or otherwise
/// interacts with any aspect of the surface.
public enum HUISurfaceEvent: Equatable, Hashable {
    /// HUI ping message.
    case ping
    
    /// HUI switch type with state.
    case `switch`(
        huiSwitch: HUISwitch,
        state: Bool
    )
    
    /// Motorized fader level.
    case faderLevel(
        channelStrip: UInt4,
        level: UInt14
    )
    
    /// Stereo LED level meters.
    case levelMeter(
        channelStrip: UInt4,
        side: HUISurfaceModel.StereoLevelMeter.Side,
        level: Int
    )
    
    /// V-Pot rotary knob -/+ delta change.
    case vPot(
        vPot: HUIVPot,
        delta: Int7
    )
    
    /// Jog Wheel -/+ delta change.
    case jogWheel(delta: Int7)
    
    /// System reset message:
    /// Whenever a HUI surface is turned on or off it should transmit this message to the host.
    case systemReset
}

extension HUISurfaceEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ping:
            return "ping"
            
        case let .switch(
            huiSwitch: huiSwitch,
            state: state
        ):
            return "switch(\(huiSwitch), state: \(state ? "on" : "off"))"
            
        case let .faderLevel(
            channelStrip: channelStrip,
            level: level
        ):
            return "faderLevel(channelStrip: \(channelStrip), level: \(level))"
            
        case let .levelMeter(
            channelStrip: channelStrip,
            side: side,
            level: level
        ):
            return "levelMeter(channelStrip: \(channelStrip), side: \(side), level: \(level))"
            
        case let .vPot(
            vPot: vPot,
            delta: delta
        ):
            return "vPot(\(vPot), delta: \(delta))"
            
        case let .jogWheel(delta):
            return "jogWheel(delta: \(delta))"
            
        case .systemReset:
            return "systemReset"
        }
    }
}

extension HUISurfaceEvent: Sendable { }
