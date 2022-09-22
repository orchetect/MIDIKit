//
//  HUICoreEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// HUI Core Event.
/// Abstracts raw HUI messages into basic common-currency HUI message types carrying raw data as encoded.
public enum HUICoreEvent: Hashable {
    /// HUI ping message.
    case ping
    
    /// Stereo LED level meters.
    case levelMeters(
        channelStrip: UInt4,
        side: HUIModel.StereoLevelMeter.Side,
        level: Int
    )
    
    /// Motorized fader level.
    case faderLevel(
        channelStrip: UInt4,
        level: UInt14
    )
    
    /// V-Pot delta change.
    case vPot(
        vPot: HUIVPot,
        delta: UInt7
    )
    
    /// Large Display text slices.
    ///
    /// Slices are indexed `0 ... 7` and are 10 characters each.
    case largeDisplay(slices: [UInt4: [HUILargeDisplayCharacter]])
    
    /// Time Display digits.
    ///
    /// Between one and 8 digits, indexed in the array from right-to-left of the actual display. (Index 0 is the rightmost character).
    ///
    /// This is because HUI encodes time display digits in reverse order since the digits on the righthand side of a time display will update most frequently, which allows conservation of data bandwidth when transmitting frequent time display changes.
    case timeDisplay(charsRightToLeft: [HUITimeDisplayCharacter])
    
    /// Select Assign 4-character text display.
    case selectAssignText(text: HUISmallDisplayString)
    
    /// Channel strip 4-character name text display.
    case channelName(
        channelStrip: UInt4,
        text: HUISmallDisplayString
    )
    
    /// HUI switch type with state.
    case `switch`(
        huiSwitch: HUISwitch,
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
            let flatSlices = slices.map { "\($0.key): \($0.value.stringValue)" }
            return "largeDisplay(slices: \(flatSlices))"
            
        case let .timeDisplay(charsRightToLeft: charsRightToLeft):
            return "timeDisplay(chars: \(charsRightToLeft.reversed().stringValue))"
            
        case let .selectAssignText(text: text):
            return "selectAssignText(text: \(text.stringValue))"
            
        case let .channelName(
            channelStrip: channelStrip,
            text: text
        ):
            return "channelName(channelStrip: \(channelStrip), text: \(text.stringValue))"
            
        case let .switch(
            huiSwitch: huiSwitch,
            state: state
        ):
            return "switch(\(huiSwitch), state: \(state ? "on" : "off"))"
        }
    }
}
