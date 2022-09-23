//
//  HUIHostEvent Encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIHostEvent {
    /// Encode the HUI event to raw HUI MIDI event(s).
    public func encode() -> [MIDIEvent] {
        switch self {
        case .ping:
            return [encodeHUIPing(to: .surface)]

        case let .levelMeter(channelStrip, side, level):
            return [encodeHUILevelMeter(
                channel: channelStrip,
                side: side,
                level: level
            )]
            
        case let .faderLevel(channelStrip, level):
            return encodeHUIFader(level: level, channel: channelStrip)
            
        case let .vPot(vPot, value):
            return [encodeHUIVPotValue(for: vPot, rawValue: value.rawIndex)]
            
        case let .largeDisplay(slices):
            return encodeHUILargeDisplay(slices: slices)

        case let .timeDisplay(charsRightToLeft):
            return [encodeHUITimeDisplay(charsRightToLeft: charsRightToLeft)]
            
        case let .selectAssignDisplay(text):
            return [encodeHUISmallDisplay(for: .selectAssign, text: text)]
            
        case let .channelDisplay(channelStrip, text):
            return [encodeHUISmallDisplay(for: .channel(channelStrip), text: text)]
            
        case let .switch(huiSwitch, state):
            return encodeHUISwitch(huiSwitch, state: state, to: .surface)
        }
    }
}

extension HUIHostEvent: _HUIEventProtocol {
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
                // should never happen
                fatalError()
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
        }
    }
}
