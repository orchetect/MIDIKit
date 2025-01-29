//
//  HUISurfaceModelState StereoLevelMeter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the state of a channel strip's stereo level meter on the meter
    /// bridge.
    ///
    /// As value increases, all LEDs up to and including that value will illuminate, representing an
    /// audio level meter with 12 LED segments. A value of `0x0` indicates no LEDs are illuminated.
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
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class StereoLevelMeter {
        /// Left Meter Channel.
        ///
        /// As value increases, all LEDs up to and including that value will illuminate,
        /// representing an audio level meter with 12 LED segments. A value of `0x0` indicates no
        /// LEDs are illuminated.
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
        public var left: Int = 0 {
            didSet {
                if !StereoLevelMeterSide.levelRange.contains(left) {
                    left = left.clamped(to: StereoLevelMeterSide.levelRange)
                }
            }
        }
        
        /// Right Meter Channel.
        ///
        /// As value increases, all LEDs up to and including that value will illuminate,
        /// representing an audio level meter with 12 LED segments. A value of `0x0` indicates no
        /// LEDs are illuminated.
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
        public var right: Int = 0 {
            didSet {
                if !StereoLevelMeterSide.levelRange.contains(right) {
                    right = right.clamped(to: StereoLevelMeterSide.levelRange)
                }
            }
        }
    }
}

// MARK: - Properties

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.StereoLevelMeter {
    @inlinable
    public func level(of side: HUISurfaceModelState.StereoLevelMeterSide) -> Int {
        switch side {
        case .left:  return left
        case .right: return right
        }
    }
}

// MARK: - StereoLevelMeter Side

extension HUISurfaceModelState {
    /// Enum describing the side of a stereo level meter
    public enum StereoLevelMeterSide {
        /// Left stereo channel.
        case left
        
        /// Right stereo channel.
        case right
    }
}

extension HUISurfaceModelState.StereoLevelMeterSide: Equatable { }

extension HUISurfaceModelState.StereoLevelMeterSide: Hashable { }

extension HUISurfaceModelState.StereoLevelMeterSide: Sendable { }

extension HUISurfaceModelState.StereoLevelMeterSide: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        }
    }
}

extension HUISurfaceModelState.StereoLevelMeterSide {
    /// Raw value for HUI message encoding.
    @inlinable
    var rawValue: UInt8 {
        switch self {
        case .left: return 0
        case .right: return 1
        }
    }
}

// MARK: - Constants

extension HUISurfaceModelState.StereoLevelMeterSide {
    /// Level value range minimum value.
    /// (`0` means that no LEDs on the meter are lit up.)
    public static let levelMin: Int = 0x0
    
    /// Level value range maximum value.
    public static let levelMax: Int = 0xC
    
    /// Range of possible level meter values.
    /// (`0` indicates that no LEDs on the meter are lit up.)
    public static let levelRange = levelMin ... levelMax
}
