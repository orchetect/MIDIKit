//
//  HUISurfaceModel ChannelStrip.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUISurfaceModel {
    /// State storage representing an individual channel strip and its components.
    public struct ChannelStrip: Equatable, Hashable {
        /// Stereo Level Meter.
        public var levelMeter = StereoLevelMeter()
        
        /// Record Ready Button LED.
        public var recordReady = false
        
        /// Insert Button LED.
        public var insert = false
        
        /// V-Sel Button LED.
        public var vPotSelect = false
        
        /// V-Pot Display LEDs.
        public var vPotDisplay: HUIVPotDisplay = .init()
        
        /// Auto(mation) Button LED.
        public var auto = false
        
        /// Solo Button LED.
        public var solo = false
        
        /// Mute Button LED.
        public var mute = false
        
        /// 4-character channel name text display.
        public var nameDisplay: HUISmallDisplayString = .init()
        
        /// Select Button LED.
        public var select = false
        
        /// Motorized Fader.
        public var fader = Fader()
    }
}

extension HUISurfaceModel.ChannelStrip: HUISurfaceModelState {
    public typealias Switch = HUISwitch.ChannelStrip

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .recordReady:  return recordReady
        case .insert:       return insert
        case .vPotSelect:   return vPotSelect
        case .auto:         return auto
        case .solo:         return solo
        case .mute:         return mute
        case .select:       return select
        case .faderTouched: return fader.touched
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .recordReady:  recordReady = state
        case .insert:       insert = state
        case .vPotSelect:   vPotSelect = state
        case .auto:         auto = state
        case .solo:         solo = state
        case .mute:         mute = state
        case .select:       select = state
        case .faderTouched: fader.touched = state
        }
    }
}
