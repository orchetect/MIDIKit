//
//  HUICoreEvent.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// HUI Core Event.
/// Represents raw HUI messages with essential abstractions.
public enum HUICoreEvent: Hashable {
    case ping
        
    case levelMeters(
        channelStrip: Int,
        side: HUISurface.State.StereoLevelMeter.Side,
        level: Int
    )
        
    case faderLevel(
        channelStrip: Int,
        level: UInt14
    )
        
    case vPot(
        number: Int,
        value: UInt7
    )
        
    case largeDisplayText(components: [String])
        
    case timeDisplayText(components: [String])
        
    case selectAssignText(text: String)
        
    case channelName(
        channelStrip: Int,
        text: String
    )
        
    case `switch`(
        zone: Byte,
        port: UInt4,
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
            number: channelStrip,
            value: value
        ):
            return "vPot(number: \(channelStrip), value: \(value))"
            
        case let .largeDisplayText(components: components):
            return "largeDisplayText(components: \(components))"
            
        case let .timeDisplayText(components: components):
            return "timeDisplayText(components: \(components))"
            
        case let .selectAssignText(text: text):
            return "selectAssignText(text: \(text))"
            
        case let .channelName(
            channelStrip: channelStrip,
            text: text
        ):
            return "channelName(channelStrip: \(channelStrip), text: \(text))"
            
        case let .switch(
            zone: zone,
            port: port,
            state: state
        ):
            return "switch(zone: \(zone), port: \(port), state: \(state ? "on" : "off"))"
        }
    }
}
