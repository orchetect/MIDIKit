//
//  HUISurfaceModelState ChannelStrip Fader.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUISurfaceModelState.ChannelStrip {
    /// State storage representing the state of a channel strip fader.
    public struct Fader {
        /// Raw level value.
        public var level: UInt14 = 0
        
        /// Touch status (`true` indicates the fader is being touched by the user).
        public var touched: Bool = false
        
        // constants
        
        /// Constant: minimum ``level`` value.
        public static let levelMin: UInt14 = 0
        
        /// Constant: maximum ``level`` value.
        public static let levelMax: UInt14 = 0x3FFF // 16383
        
        /// Constant: Range of possible ``level`` values.
        public static let levelRange: ClosedRange<UInt14> = 0 ... 0x3FFF
        
        // convenience
        
        /// Returns the ``level`` property expressed as a unit interval between `0.0 ... 1.0`.
        public var levelUnitInterval: Double {
            Double(level) / Double(Self.levelMax)
        }
    }
}

extension HUISurfaceModelState.ChannelStrip.Fader: Equatable { }

extension HUISurfaceModelState.ChannelStrip.Fader: Hashable { }

extension HUISurfaceModelState.ChannelStrip.Fader: Sendable { }

// HUISurfaceModelStateProtocol conformance is on HUISurfaceModelState.ChannelStrip and it handles the
// `.touched` switch property there, so we don't need a setter/getter here
