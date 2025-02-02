//
//  HUISurfaceModelState ChannelStrip.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUISurfaceModelState {
    /// State storage representing an individual channel strip and its components.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class ChannelStrip {
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.ChannelStrip: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.ChannelStrip
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .recordReady:  recordReady
        case .insert:       insert
        case .vPotSelect:   vPotSelect
        case .auto:         auto
        case .solo:         solo
        case .mute:         mute
        case .select:       select
        case .faderTouched: fader.touched
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
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
