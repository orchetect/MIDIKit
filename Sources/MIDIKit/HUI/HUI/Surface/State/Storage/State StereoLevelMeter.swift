//
//  State StereoLevelMeter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the state/values of a channel strip's stereo level meter on the meter bridge.
    ///
    /// As value increases, all LEDs up to and including that value will illuminate, representing an audio level meter with 12 LED segments. A value of 0 indicates no LEDs are illuminated.
    ///
    ///     Value  Level       LED Segment
    ///     -----  ----------  -----------------
    ///     0xC    >=   0dBFS  🟥 red (clip)
    ///     0xB    >=  -2dBFS  🟨 yellow
    ///     0xA    >=  -4dBFS  🟨 yellow
    ///     0x9    >=  -6dBFS  🟨 yellow
    ///     0x8    >=  -8dBFS  🟩 green
    ///     0x7    >= -10dBFS  🟩 green
    ///     0x6    >= -14dBFS  🟩 green
    ///     0x5    >= -20dBFS  🟩 green
    ///     0x4    >= -30dBFS  🟩 green
    ///     0x3    >= -40dBFS  🟩 green
    ///     0x2    >= -50dBFS  🟩 green
    ///     0x1    >= -60dBFS  🟩 green
    ///     0x0    <  -60dBFS  (no LEDs on)
    ///
    public struct StereoLevelMeter: Equatable, Hashable {
        
        /// Left Meter Channel
        public var left: Int = 0
        {
            didSet {
                if !left.isContained(in: Self.levelRange) {
                    left = left.clamped(to: Self.levelRange)
                }
            }
        }
        
        /// Right Meter Channel
        public var right: Int = 0
        {
            didSet {
                if !right.isContained(in: Self.levelRange) {
                    right = right.clamped(to: Self.levelRange)
                }
            }
        }
        
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
        case .left:  return left
        case .right: return right
        }
    }
    
}
