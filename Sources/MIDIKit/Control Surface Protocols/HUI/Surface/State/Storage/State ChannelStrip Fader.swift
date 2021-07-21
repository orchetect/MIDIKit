//
//  State ChannelStrip Fader.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

extension MIDI.HUI.Surface.State.ChannelStrip {
    
    /// State storage representing the state/values of a channel strip fader
    public struct Fader: Equatable, Hashable {
        
        /// Raw level value
        public var level: MIDI.UInt14 = 0
        
        /// Touch Status (true = fader is being touched by the user)
        public var touched: Bool = false
        
        // constants
        
        /// Constant: minimum `level` value
        public static let levelMin: Int = 0
        
        /// Constant: maximum `level` value
        public static let levelMax: Int = 0x3FFF // 16383
        
        /// Constant: Range of possible `level` values
        public static let levelRange: ClosedRange<Int> = 0...0x3FFF
        
        // convenience
        
        /// Returns `.level` expressed as a unit interval between 0.0...1.0
        public var levelUnitInterval: Double {
            level.value.double / Self.levelMax.double
        }
        
    }
    
}

// MIDIHUIStateProtocol conformance is on MIDI.HUI.Surface.State.ChannelStrip and it handles the `.touched` switch property there, so we don't need a setter/getter here
