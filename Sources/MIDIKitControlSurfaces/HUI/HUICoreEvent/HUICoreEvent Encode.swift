//
//  HUICoreEvent Encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUICoreEvent {
    /// Encode the HUI core event to raw HUI MIDI event(s).
    public func encode(to role: HUIRole) -> [MIDIEvent] {
        switch self {
        case .ping:
            return [encodeHUIPing(to: role)]

        case let .levelMeter(channelStrip, side, level):
            return [encodeHUILevelMeter(
                channel: channelStrip,
                side: side,
                level: level
            )]
            
        case let .faderLevel(channelStrip, level):
            return encodeHUIFader(level: level, channel: channelStrip)
            
        case let .vPot(vPot, delta):
            return [encodeHUIVPotValue(for: vPot, delta: delta)]
            
        case let .largeDisplay(slices):
            return encodeHUILargeDisplay(slices: slices)

        case let .timeDisplay(charsRightToLeft):
            return [encodeHUITimeDisplay(charsRightToLeft: charsRightToLeft)]
            
        case let .selectAssignDisplay(text):
            return [encodeHUISmallText(for: .selectAssign, text: text)]
            
        case let .channelDisplay(channelStrip, text):
            return [encodeHUISmallText(for: .channel(channelStrip), text: text)]
            
        case let .switch(huiSwitch, state):
            return encodeHUISwitch(huiSwitch, state: state, to: role)
        }
    }
}
