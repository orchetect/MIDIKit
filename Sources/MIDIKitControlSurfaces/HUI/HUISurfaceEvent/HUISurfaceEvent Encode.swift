//
//  HUISurfaceEvent Encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurfaceEvent {
    /// Encode the HUI surface event to raw HUI MIDI event(s).
    public func encode() -> [MIDIEvent] {
        switch self {
        case .ping:
            return [encodeHUIPing(to: .host)]
        
        case let .levelMeter(channelStrip, side, level):
            return [encodeHUILevelMeter(
                channel: channelStrip,
                side: side,
                level: level
            )]
        
        case let .faderLevel(channelStrip, level):
            return encodeHUIFader(level: level, channel: channelStrip)
        
        case let .vPot(vPot, value):
            return [encodeHUIVPotValue(for: vPot, rawValue: value.rawUInt7Byte)]
        
        case let .jogWheel(delta):
            return [encodeJogWheel(rawDelta: delta.rawUInt7Byte)]
            
        case let .switch(huiSwitch, state):
            return encodeHUISwitch(huiSwitch, state: state, to: .host)
        
        case .systemReset:
            return [encodeHUISystemReset()]
        }
    }
}

extension HUISurfaceEvent: _HUIEventProtocol {
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
                // TODO: should never happen, but not great solution
                fatalError()
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
            // TODO: should never happen, but not great solution
            fatalError()
        }
    }
}
