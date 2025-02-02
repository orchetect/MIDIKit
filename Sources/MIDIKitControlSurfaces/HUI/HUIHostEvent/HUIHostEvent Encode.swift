//
//  HUIHostEvent Encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIHostEvent {
    /// Encode the HUI event to raw HUI MIDI event(s).
    public func encode() -> [MIDIEvent] {
        switch self {
        case .ping:
            [encodeHUIPing(to: .surface)]

        case let .levelMeter(channelStrip, side, level):
            [encodeHUILevelMeter(
                channel: channelStrip,
                side: side,
                level: level
            )]
            
        case let .faderLevel(channelStrip, level):
            encodeHUIFader(level: level, channel: channelStrip)
            
        case let .vPot(vPot, display):
            [encodeHUIVPot(display: display, for: vPot)]
            
        case let .largeDisplay(slices):
            encodeHUILargeDisplay(slices: slices)

        case let .timeDisplay(charsRightToLeft):
            [encodeHUITimeDisplay(charsRightToLeft: charsRightToLeft)]
            
        case let .selectAssignDisplay(text):
            [encodeHUISmallDisplay(for: .selectAssign, text: text)]
            
        case let .channelDisplay(channelStrip, text):
            [encodeHUISmallDisplay(for: .channel(channelStrip), text: text)]
            
        case let .switch(huiSwitch, state):
            encodeHUISwitch(huiSwitch, state: state, to: .surface)
        }
    }
}

extension HUIHostEvent: _HUIEvent {
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
            case let .display(display):
                self = .vPot(vPot: vPot, display: display)
            case .delta:
                // TODO: should probably refactor so this case isn't possible
                assertionFailure(
                    "HUIHostEvent should never be initialized from a vPot delta change message. This should never happen."
                )
                // return neutral event as failsafe instead of crashing
                self = .ping
            }
            
        case let .largeDisplay(slices):
            self = .largeDisplay(slices: slices)
            
        case let .timeDisplay(charsRightToLeft):
            self = .timeDisplay(charsRightToLeft: charsRightToLeft)
            
        case let .selectAssignDisplay(text):
            self = .selectAssignDisplay(text: text)
            
        case let .channelDisplay(channelStrip, text):
            self = .channelDisplay(channelStrip: channelStrip, text: text)
            
        case let .switch(huiSwitch, state):
            self = .switch(huiSwitch: huiSwitch, state: state)
            
        case .jogWheel:
            // TODO: should probably refactor so this case isn't possible
            assertionFailure(
                "HUIHostEvent should never be initialized from a jog wheel message. This should never happen."
            )
            // return neutral event as failsafe instead of crashing
            self = .ping
            
        case .systemReset:
            Logger.debug(
                "HUIHostEvent was initialized from a system reset message, which is undefined for a HUI host to receive."
            )
            // return neutral event as failsafe instead of crashing
            self = .ping
        }
    }
}
