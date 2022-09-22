//
//  HUIModel ChannelStrip.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUIModel {
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
        public var vPotLevel: UInt7 = 0
        
        /// Auto(mation) Button LED.
        public var auto = false
        
        /// Solo Button LED.
        public var solo = false
        
        /// Mute Button LED.
        public var mute = false
        
        /// 4-character Channel Name LCD Text Display.
        public var nameTextDisplay: HUISmallDisplayString = .init()
        
        /// Select Button LED.
        public var select = false
        
        /// Motorized Fader.
        public var fader = Fader()
    }
}

extension HUIModel.ChannelStrip: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.ChannelParameter

    public func state(of param: Param) -> Bool {
        switch param {
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
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
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
