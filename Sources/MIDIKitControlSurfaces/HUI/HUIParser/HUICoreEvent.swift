//
//  HUICoreEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// HUI Core Event.
/// Represents raw HUI messages with essential abstractions.
public enum HUICoreEvent: Hashable {
    case ping
    
    case levelMeters(
        channelStrip: UInt4,
        side: HUISurface.State.StereoLevelMeter.Side,
        level: Int
    )
    
    case faderLevel(
        channelStrip: UInt4,
        level: UInt14
    )
    
    case vPot(
        vPot: HUIVPot,
        delta: UInt7
    )
    
    case largeDisplay(slices: [[HUILargeDisplayCharacter]])
    
    case timeDisplay(text: HUITimeDisplayString)
    
    case selectAssignText(text: HUISmallDisplayString)
    
    case channelName(
        channelStrip: UInt4,
        text: HUISmallDisplayString
    )
    
    case `switch`(
        zone: HUIZone,
        port: HUIPort,
        state: Bool
    )
}

extension HUICoreEvent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ping:
            return "ping"
        
        case let .levelMeters(
            channelStrip: channelStrip,
            side: side,
            level: level
        ):
            return "levelMeters(channelStrip: \(channelStrip), side: \(side), level: \(level))"
            
        case let .faderLevel(
            channelStrip: channelStrip,
            level: level
        ):
            return "faderLevel(channelStrip: \(channelStrip), level: \(level))"
            
        case let .vPot(
            vPot: vPot,
            delta: delta
        ):
            return "vPot(\(vPot), delta: \(delta))"
            
        case let .largeDisplay(slices: slices):
            return "largeDisplay(slices: \(slices.map(\.stringValue)))"
            
        case let .timeDisplay(text: text):
            return "timeDisplay(text: \(text.stringValue))"
            
        case let .selectAssignText(text: text):
            return "selectAssignText(text: \(text.stringValue))"
            
        case let .channelName(
            channelStrip: channelStrip,
            text: text
        ):
            return "channelName(channelStrip: \(channelStrip), text: \(text.stringValue))"
            
        case let .switch(
            zone: zone,
            port: port,
            state: state
        ):
            return "switch(zone: \(zone), port: \(port), state: \(state ? "on" : "off"))"
        }
    }
}
