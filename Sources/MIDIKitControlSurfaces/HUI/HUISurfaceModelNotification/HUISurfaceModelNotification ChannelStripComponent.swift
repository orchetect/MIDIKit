//
//  HUISurfaceModelNotification ChannelStripComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurfaceModelNotification {
    /// A discrete component of a HUI channel strip and its state change.
    public enum ChannelStripComponent {
        /// Stereo Level Meter.
        case levelMeter(side: HUISurfaceModelState.StereoLevelMeter.Side, level: Int)
        
        /// Record Ready Button LED.
        case recordReady(state: Bool)
        
        /// Insert Button LED.
        case insert(state: Bool)
        
        /// V-Sel Button LED.
        case vPotSelect(state: Bool)
        
        /// V-Pot LED ring display.
        case vPot(display: HUIVPotDisplay)
        
        /// Auto(mation) Button LED.
        case auto(state: Bool)
        
        /// Solo Button LED.
        case solo(state: Bool)
        
        /// Mute Button LED.
        case mute(state: Bool)
        
        /// 4-character channel name text display.
        case nameDisplay(text: HUISmallDisplayString)
        
        /// Select Button LED.
        case select(state: Bool)
        
        /// Motorized Fader level.
        case faderLevel(level: UInt14)
    }
}

extension HUISurfaceModelNotification.ChannelStripComponent: Equatable { }

extension HUISurfaceModelNotification.ChannelStripComponent: Hashable { }

extension HUISurfaceModelNotification.ChannelStripComponent: Sendable { }

extension HUISurfaceModelNotification.ChannelStripComponent: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .levelMeter(side, level):
            return "levelMeter(side: \(side), level: \(level))"
        case let .recordReady(state):
            return "recordReady(state: \(state))"
        case let .insert(state):
            return "insert(state: \(state))"
        case let .vPotSelect(state):
            return "vPotSelect(state: \(state))"
        case let .vPot(display):
            return "vPot(\(display))"
        case let .auto(state):
            return "auto(state: \(state))"
        case let .solo(state):
            return "solo(state: \(state))"
        case let .mute(state):
            return "mute(state: \(state))"
        case let .nameDisplay(text):
            return "nameDisplay(text: \(text))"
        case let .select(state):
            return "select(state: \(state))"
        case let .faderLevel(level):
            return "faderLevel(\(level))"
        }
    }
}
