//
//  HUIEvent ChannelStripComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIEvent {
    /// A discrete component of a HUI channel strip and its state change.
    public enum ChannelStripComponent: Equatable, Hashable {
        /// Stereo Level Meter.
        case levelMeter(side: HUISurfaceModel.StereoLevelMeter.Side, level: Int)
        
        /// Record Ready Button LED.
        case recordReady(state: Bool)
        
        /// Insert Button LED.
        case insert(state: Bool)
        
        /// V-Sel Button LED.
        case vPotSelect(state: Bool)
        
        /// V-Pot encoding.
        case vPot(value: HUIVPotValue)
        
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
        
        /// Motorized Fader touched state.
        case faderTouched(state: Bool)
        
        /// Motorized Fader level.
        case faderLevel(level: UInt14)
    }
}
