//
//  StereoLevelMeter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the state/values of a channel strip's stereo level meter on the meter bridge
    public struct StereoLevelMeter: Equatable, Hashable {
        
        /// Left Meter Channel
        public var left: Int = 0
        
        /// Right Meter Channel
        public var right: Int = 0
        
        // constants
        
        /// Level value range minimum.
        /// (0 means that no LEDs on the meter are lit up.)
        public static let levelMin: Int = 0
        
        /// Level value range maximum
        public static let levelMax: Int = 12
        
        /// Range of possible level meter values.
        /// (0 means that no LEDs on the meter are lit up.)
        public static let levelRange = levelMin...levelMax
        
    }
    
}

extension MIDI.HUI.Surface.State.StereoLevelMeter {
    
    /// Enum describing the side of a stereo level meter
    public enum Side: Equatable, Hashable {
        
        case left
        case right
        
    }
    
    public func level(of side: Side) -> Int {
        switch side {
        case .left: return left
        case .right: return right
        }
    }
    
}
