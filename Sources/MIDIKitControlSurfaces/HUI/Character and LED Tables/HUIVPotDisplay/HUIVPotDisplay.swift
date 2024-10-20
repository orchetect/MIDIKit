//
//  HUIVPotDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI V-Pot LED Ring Display.
///
/// Around each V-Pot are 11 LEDs in a ring (semi-circle),
/// as well as a single LED centered underneath.
public struct HUIVPotDisplay: Equatable, Hashable {
    // MARK: State
    
    /// LED ring: 11 LEDs in a semi-circle, each with on or off state. The center LED is index 5.
    public var leds: LEDState
    
    /// Lower LED state.
    public var lowerLED: Bool
    
    // MARK: Init
    
    public init() {
        leds = .allOff
        lowerLED = false
    }
    
    public init(leds: LEDState, lowerLED: Bool) {
        self.leds = leds
        self.lowerLED = lowerLED
    }
}

extension HUIVPotDisplay: Sendable { }

// MARK: - Static Constructors

extension HUIVPotDisplay {
    /// Initialize HUI V-Pot LED Ring Display state with all LEDs off.
    public static let allOff: HUIVPotDisplay = .init(
        leds: .allOff,
        lowerLED: false
    )
}

// MARK: - Internal Helpers

extension HUIVPotDisplay {
    /// Internal:
    /// Init from raw encoded preset index.
    init(rawIndex: UInt8) {
        switch rawIndex {
        case 0x00 ... 0x3B:
            leds = LEDState(rawValue: rawIndex) ?? .unknown()
            lowerLED = false
        case 0x40 ... 0x7B:
            leds = LEDState(rawValue: rawIndex % 0x40) ?? .unknown()
            lowerLED = true
        default:
            leds = .allOff
            lowerLED = false
        }
    }
    
    /// Internal:
    /// Returns raw encoded preset index.
    var rawIndex: UInt7 {
        leds.rawValue.toUInt7 + (lowerLED ? 0x40 : 0x00)
    }
}
