//
//  HUIHostEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// HUI Host Event: basic HUI host message definition.
/// These events are sent from the host to the client surface to update state of the surface: fader
/// levels, text displays, LEDs, and even triggering beep sounds.
public enum HUIHostEvent: Equatable, Hashable {
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
        side: HUISurfaceModelState.StereoLevelMeter.Side,
        level: Int
    )
    
    /// V-Pot LED display.
    case vPot(
        vPot: HUIVPot,
        display: HUIVPotDisplay
    )
    
    /// Large Display text slices.
    ///
    /// Slices are indexed `0 ... 7` and are 10 characters each.
    case largeDisplay(slices: HUILargeDisplaySlices)
    
    /// Time Display digits.
    ///
    /// Between one and 8 digits, indexed in the array from right-to-left of the actual display.
    /// (Index 0 is the rightmost character).
    ///
    /// This is because HUI encodes time display digits in reverse order since the digits on the
    /// righthand side of a time display will update most frequently, which allows conservation of
    /// data bandwidth when transmitting frequent time display changes.
    case timeDisplay(charsRightToLeft: [HUITimeDisplayCharacter])
    
    /// Select Assign 4-character text display.
    case selectAssignDisplay(text: HUISmallDisplayString)
    
    /// Channel strip 4-character name text display.
    case channelDisplay(
        channelStrip: UInt4,
        text: HUISmallDisplayString
    )
}

extension HUIHostEvent: CustomStringConvertible {
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
            display: display
        ):
            return "vPot(\(vPot), display: \(display))"
            
        case let .largeDisplay(slices: slices):
            let flatSlices = slices.map { "\($0.key): \($0.value.stringValue)" }
            return "largeDisplay(slices: \(flatSlices))"
            
        case let .timeDisplay(charsRightToLeft: charsRightToLeft):
            return "timeDisplay(chars: \(charsRightToLeft.reversed().stringValue))"
            
        case let .selectAssignDisplay(text: text):
            return "selectAssignDisplay(text: \(text.stringValue))"
            
        case let .channelDisplay(
            channelStrip: channelStrip,
            text: text
        ):
            return "channelDisplay(channelStrip: \(channelStrip), text: \(text.stringValue))"
        }
    }
}

extension HUIHostEvent: Sendable { }
