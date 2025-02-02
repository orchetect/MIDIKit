//
//  HUISurfaceEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// HUI Surface Event: basic HUI surface message definition.
/// These events are sent from the client surface to the host as a result of user interaction with
/// the surface: when the user moves a fader, turns a V-Pot knob, presses a button, or otherwise
/// interacts with any aspect of the surface.
public enum HUISurfaceEvent {
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
        side: HUISurfaceModelState.StereoLevelMeterSide,
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

extension HUISurfaceEvent: Equatable { }

extension HUISurfaceEvent: Hashable { }

extension HUISurfaceEvent: Sendable { }

extension HUISurfaceEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ping:
            "ping"
            
        case let .switch(
            huiSwitch: huiSwitch,
            state: state
        ):
            "switch(\(huiSwitch), state: \(state ? "on" : "off"))"
            
        case let .faderLevel(
            channelStrip: channelStrip,
            level: level
        ):
            "faderLevel(channelStrip: \(channelStrip), level: \(level))"
            
        case let .levelMeter(
            channelStrip: channelStrip,
            side: side,
            level: level
        ):
            "levelMeter(channelStrip: \(channelStrip), side: \(side), level: \(level))"
            
        case let .vPot(
            vPot: vPot,
            delta: delta
        ):
            "vPot(\(vPot), delta: \(delta))"
            
        case let .jogWheel(delta):
            "jogWheel(delta: \(delta))"
            
        case .systemReset:
            "systemReset"
        }
    }
}
