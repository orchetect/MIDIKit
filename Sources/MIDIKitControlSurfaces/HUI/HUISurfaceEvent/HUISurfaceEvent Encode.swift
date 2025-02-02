//
//  HUISurfaceEvent Encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurfaceEvent {
    /// Encode the HUI surface event to raw HUI MIDI event(s).
    public func encode() -> [MIDIEvent] {
        switch self {
        case .ping:
            [encodeHUIPing(to: .host)]
        
        case let .levelMeter(channelStrip, side, level):
            [encodeHUILevelMeter(
                channel: channelStrip,
                side: side,
                level: level
            )]
        
        case let .faderLevel(channelStrip, level):
            encodeHUIFader(level: level, channel: channelStrip)
        
        case let .vPot(vPot, delta):
            [encodeHUIVPot(delta: delta, for: vPot)]
        
        case let .jogWheel(delta):
            [encodeJogWheel(delta: delta)]
            
        case let .switch(huiSwitch, state):
            encodeHUISwitch(huiSwitch, state: state, to: .host)
        
        case .systemReset:
            [encodeHUISystemReset()]
        }
    }
}

extension HUISurfaceEvent: _HUIEvent {
    init(from coreEvent: HUICoreEvent) {
        switch coreEvent {
        case .ping:
            self = .ping
            
        case let .levelMeter(channelStrip, side, level):
            self = .levelMeter(channelStrip: channelStrip, side: side, level: level)
            
        case let .faderLevel(channelStrip, level):
            self = .faderLevel(channelStrip: channelStrip, level: level)
            
        case let .vPot(vPot, value):
            switch value {
            case .display:
                // TODO: should probably refactor so this case isn't possible
                assertionFailure(
                    "HUISurfaceEvent should never be initialized from a vPot LED ring display encoding message. This should never happen."
                )
                // return neutral event as failsafe instead of crashing
                self = .ping
            case let .delta(delta):
                self = .vPot(vPot: vPot, delta: delta)
            }
            
        case let .switch(huiSwitch, state):
            self = .switch(huiSwitch: huiSwitch, state: state)
            
        case .systemReset:
            self = .systemReset
            
        case let .jogWheel(delta):
            self = .jogWheel(delta: delta)
            
        default:
            Logger.debug(
                "HUISurfaceEvent was initialized from a non-relevant HUICoreEvent: \(coreEvent). This should never happen."
            )
            // return neutral event as failsafe instead of crashing
            self = .ping
        }
    }
}
