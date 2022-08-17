//
//  State ChannelStrip Fader.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State.ChannelStrip {
    /// State storage representing the state/values of a channel strip fader
    public struct Fader: Equatable, Hashable {
        /// Raw level value
        public var level: UInt14 = 0
        
        /// Touch Status (true = fader is being touched by the user)
        public var touched: Bool = false
        
        // constants
        
        /// Constant: minimum `level` value
        public static let levelMin: Int = 0
        
        /// Constant: maximum `level` value
        public static let levelMax: Int = 0x3FFF // 16383
        
        /// Constant: Range of possible `level` values
        public static let levelRange: ClosedRange<Int> = 0 ... 0x3FFF
        
        // convenience
        
        /// Returns `.level` expressed as a unit interval between 0.0...1.0
        public var levelUnitInterval: Double {
            Double(level.value) / Double(Self.levelMax)
        }
    }
}

// HUISurfaceStateProtocol conformance is on HUISurface.State.ChannelStrip and it handles the `.touched` switch property there, so we don't need a setter/getter here
