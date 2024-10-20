//
//  LEDState.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIVPotDisplay {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:options --maxwidth none
    
    /// Preset HUI V-Pot LED states.
    ///
    /// For HUI V-Pot LED ring displays, it is not possible to toggle individual LEDs arbitrarily. Instead, the HUI protocol defines a set of LED state presets that are individually indexed. This index set is abstracted here as an enumeration of clearly defined preset configuration cases.
    public enum LEDState: Equatable, Hashable {
        case allOff
        
        /// A single LED is illuminated.
        case single(LED)
        
        /// A range of LED(s) are illuminated starting from the center and extending to the given LED.
        case center(to: LED)
        
        /// A range of LED(s) are illuminated starting from the left and extending to the given LED.
        case left(to: LED)
        
        /// A range of LED(s) are illuminated starting from the center and extending symmetrically to both left and right by the given radius (count) of LEDs.
        ///
        /// - Parameters:
        ///   - radius: The LED to use as a radius reference. It doesn't matter if this is a Left or Right LED, its distance from center defines the symmetrical radius from center.
        case centerRadius(radius: LED)
    }
}

// MARK: - CaseIterable

extension HUIVPotDisplay.LEDState: CaseIterable {
    public static let allCases: [Self] =
        [.allOff]
            + LED.allCases.map { .single($0) }
            + LED.allCases.map { .left(to: $0) }
            + LED.allCases.map { .center(to: $0) }
            + LED.allCases.map { .centerRadius(radius: $0) }
}

// MARK: - CustomStringConvertible

extension HUIVPotDisplay.LEDState: CustomStringConvertible {
    public var description: String {
        "[" + stringValue() + "]"
    }
}

// MARK: - Sendable

extension HUIVPotDisplay.LEDState: Sendable { }

// MARK: - RawValue

extension HUIVPotDisplay.LEDState {
    /// Initialize from raw encoded value
    public init?(rawValue: UInt8) {
        guard (0x00 ... 0x7F).contains(rawValue) else { return nil }
        
        let nibbles = (rawValue % 0x40).nibbles
        
        if nibbles.low == 0x0 {
            self = .allOff
            return
        }
        
        func formLED() -> LED? {
            guard nibbles.low > 0 else { return nil }
            return LED(rawValue: UInt8(nibbles.low - 1))
        }
        
        switch nibbles.high {
        case 0x0: // single
            if let led = formLED() {
                self = .single(led)
            } else { self = .allOff }
        case 0x1: // center to LED
            if let led = formLED() {
                self = .center(to: led)
            } else { self = .allOff }
        case 0x2: // left to LED
            if let led = formLED() {
                self = .left(to: led)
            } else { self = .allOff }
        case 0x3: // center width
            switch nibbles.low {
            case 0x0:
                self = .allOff
            case 0x1 ... 0x6:
                self = .centerRadius(radius: LED(radius: nibbles.low.intValue - 1)!)
            case 0x7 ... 0xB:
                self = .centerRadius(radius: .L5)
            default: // 0xC ... 0xF are unused
                self = .allOff
            }
        default:
            return nil
        }
    }
    
    /// Return the raw index value encoded in the HUI message.
    public var rawValue: UInt8 {
        switch self {
        case .allOff:
            return 0x00
        case let .single(led):
            return 0x01 + led.rawValue
        case let .center(led):
            return 0x11 + led.rawValue
        case let .left(led):
            return 0x21 + led.rawValue
        case let .centerRadius(radius):
            return 0x31 + UInt8(radius.radius)
        }
    }
}

// MARK: - LED Matrix Table

extension HUIVPotDisplay.LEDState {
    // swiftformat:disable numberFormatting
    
    /// Matrix of preset LED states.
    ///
    /// Array indexes are the literal index number that is encoded in the HUI MIDI message.
    /// The contents of the array are the literal bit-patterns representing the LEDs in the LED ring display.
    static let bitPatterns: [UInt16] = [
        // 0x00 ... 0x0B
        0b00000000000,
        0b10000000000,
        0b01000000000,
        0b00100000000,
        0b00010000000,
        0b00001000000,
        0b00000100000,
        0b00000010000,
        0b00000001000,
        0b00000000100,
        0b00000000010,
        0b00000000001,
        
        // 0x0C ... 0x0F (not used)
        0, 0, 0, 0,
        
        // 0x10 ... 0x1B
        0b00000000000,
        0b11111100000,
        0b01111100000,
        0b00111100000,
        0b00011100000,
        0b00001100000,
        0b00000100000,
        0b00000110000,
        0b00000111000,
        0b00000111100,
        0b00000111110,
        0b00000111111,
        
        // 0x1C ... 0x1F (not used)
        0, 0, 0, 0,
        
        // 0x20 ... 0x2B
        0b00000000000,
        0b10000000000,
        0b11000000000,
        0b11100000000,
        0b11110000000,
        0b11111000000,
        0b11111100000,
        0b11111110000,
        0b11111111000,
        0b11111111100,
        0b11111111110,
        0b11111111111,
        
        // 0x2C ... 0x2F (not used)
        0, 0, 0, 0,
        
        // 0x30 ... 0x3B
        0b00000000000,
        0b00000100000,
        0b00001110000,
        0b00011111000,
        0b00111111100,
        0b01111111110,
        0b11111111111,
        0b11111111111,
        0b11111111111,
        0b11111111111,
        0b11111111111,
        0b11111111111,
        
        // 0x3C ... 0x3F (not used)
        0, 0, 0, 0
    ]
    // swiftformat:enable numberFormatting
}

// MARK: - Bounds

extension HUIVPotDisplay.LEDState {
    /// Returns contiguous bounds as LED indexes from `0x0 ... 0xA`.
    /// Returns `nil` if all LEDs are off.
    public var bounds: ClosedRange<LED>? {
        switch self {
        case .allOff:
            return nil
            
        case let .single(led):
            return led ... led
            
        case let .left(to: led):
            return .L5 ... led
            
        case let .center(to: led):
            switch led {
            case .L5, .L4, .L3, .L2, .L1:
                return led ... .C
            case .C:
                return .C ... .C
            case .R1, .R2, .R3, .R4, .R5:
                return .C ... led
            }
            
        case let .centerRadius(radius: radius):
            switch radius {
            case .C:       return .C ... .C
            case .L1, .R1: return .L1 ... .R1
            case .L2, .R2: return .L2 ... .R2
            case .L3, .R3: return .L3 ... .R3
            case .L4, .R4: return .L4 ... .R4
            case .L5, .R5: return .L5 ... .R5
            }
        }
    }
    
    /// Returns contiguous bounds as unit intervals (`0.0 ... 1.0`).
    /// Returns `nil` if all LEDs are off.
    public var unitIntervalBounds: ClosedRange<Double>? {
        guard let bounds else { return nil }
        
        return bounds.lowerBound.unitIntervalLowerBound ...
            bounds.upperBound.unitIntervalUpperBound
    }
}

// MARK: - Data Representations

extension HUIVPotDisplay.LEDState {
    /// LED configuration represented as a string of 11 characters.
    /// Useful for debugging or simple UI display.
    public func stringValue(
        activeChar: Character = "*",
        inactiveChar: Character = " "
    ) -> String {
        let chars: [Character] = boolArray.map { $0 ? activeChar : inactiveChar }
        return String(chars)
    }
    
    /// LED configuration represented as a `Bool` array.
    public var boolArray: [Bool] {
        let bits = Self.bitPatterns[Int(rawValue)]
        return (0 ..< 11).map { (bits >> $0) & 0b1 == 0b1 }.reversed()
    }
    
    /// LED states as an 11-bit pattern. (Big-endian, occupying 11 least significant bits).
    public var bitPattern: UInt16 {
        Self.bitPatterns[Int(rawValue)]
    }
}

// MARK: - Static Constructors

extension HUIVPotDisplay.LEDState {
    /// Suitable default case for use as a default/neutral preset index.
    public static func `default`() -> Self {
        .allOff
    }
    
    /// Suitable default case for use as a substitute for an unknown preset index.
    public static func unknown() -> Self {
        .allOff
    }
    
    /// Initialize by returning a ``single(_:)`` case constructed from a unit interval corresponding to the LED position.
    public static func single(unitInterval: Double) -> Self {
        .single(LED(position: unitInterval))
    }
    
    /// Initialize by returning a ``left(to:)`` case constructed from a unit interval corresponding to the terminating LED position.
    public static func left(toUnitInterval unitInterval: Double) -> Self {
        .left(to: LED(position: unitInterval))
    }
    
    /// Initialize by returning a ``center(to:)`` case constructed from a unit interval corresponding to the terminating LED position.
    public static func center(toUnitInterval unitInterval: Double) -> Self {
        .center(to: LED(position: unitInterval))
    }
    
    /// Initialize by returning a ``centerRadius(radius:)`` case constructed from a unit interval corresponding to the radius from center.
    public static func centerRadius(unitInterval: Double) -> Self {
        if let led = LED(radiusUnitInterval: unitInterval) {
            return .centerRadius(radius: led)
        } else {
            return .allOff
        }
    }
}
