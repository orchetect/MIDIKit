//
//  State ChannelStrip.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing a single HUI channel strip and its components
    public struct ChannelStrip: Equatable, Hashable {
        
        public var levelMeter = StereoLevelMeter()
        
        /// Record Ready Button LED
        public var recordReady = false
        
        /// Insert Button LED
        public var insert = false
        
        /// V-Sel Button LED
        public var vPotSelect = false
        public var vPotLevel: Int = 0
        
        /// Auto(mation) Button LED
        public var auto = false
        
        /// Solo Button LED
        public var solo = false
        
        /// Mute Button LED
        public var mute = false
        
        /// 4-character Channel Name LCD Display
        public var textDisplayString: String = "    "
        
        /// Select Button LED
        public var select = false
        
        /// Motorized Fader
        public var fader = Fader()
        
    }
    
}

extension MIDI.HUI.Surface.State.ChannelStrip: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.ChannelParameter

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .recordReady:  return recordReady
        case .insert:       return insert
        case .vSel:         return vPotSelect
        case .auto:         return auto
        case .solo:         return solo
        case .mute:         return mute
        case .select:       return select
        case .faderTouched: return fader.touched
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .recordReady:  recordReady = state
        case .insert:       insert = state
        case .vSel:         vPotSelect = state
        case .auto:         auto = state
        case .solo:         solo = state
        case .mute:         mute = state
        case .select:       select = state
        case .faderTouched: fader.touched = state
        }
        
    }
    
}
