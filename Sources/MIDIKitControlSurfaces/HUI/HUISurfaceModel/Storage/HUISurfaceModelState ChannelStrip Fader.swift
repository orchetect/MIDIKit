//
//  HUISurfaceModelState ChannelStrip Fader.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.ChannelStrip {
    /// State storage representing the state of a channel strip fader.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class Fader {
        /// Raw level value.
        public var level: UInt14 = 0
        
        /// Touch status (`true` indicates the fader is being touched by the user).
        public var touched: Bool = false
        
        // convenience
        
        /// Returns the ``level`` property expressed as a unit interval between `0.0 ... 1.0`.
        public var levelUnitInterval: Double {
            Double(level) / Double(Self.levelMax)
        }
    }
}

// MARK: - Constants

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.ChannelStrip.Fader {
    /// Constant: minimum ``level`` value.
    public static let levelMin: UInt14 = 0
    
    /// Constant: maximum ``level`` value.
    public static let levelMax: UInt14 = 0x3FFF // 16383
    
    /// Constant: Range of possible ``level`` values.
    public static let levelRange: ClosedRange<UInt14> = 0 ... 0x3FFF
}

// HUISurfaceModelStateProtocol conformance is on HUISurfaceModelState.ChannelStrip and it handles the
// `.touched` switch property there, so we don't need a setter/getter here
