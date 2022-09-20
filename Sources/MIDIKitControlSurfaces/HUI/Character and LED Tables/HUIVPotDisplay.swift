//
//  HUIVPotDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI V-Pot LED Ring Display.
///
/// Around each V-Pot are 11 LEDs in a ring (semi-circle), as well as a single LED centered underneath.
public struct HUIVPotDisplay: Equatable, Hashable {
    /// LED ring: 11 LEDs in a semi-circle, each with on or off state. The center LED is index 5.
    public var leds: LEDState
    
    /// Lower LED state.
    public var lowerLED: Bool
    
    public init(leds: LEDState, lowerLED: Bool) {
        self.leds = leds
        self.lowerLED = lowerLED
    }
    
    /// Init from raw encoded preset index.
    init(rawIndex: UInt8) {
        switch rawIndex {
        case 0x00 ... 0x3B:
            leds = LEDState(rawValue: rawIndex) ?? .unknown()
            lowerLED = false
        case 0x40 ... 0x7B:
            leds = LEDState(rawValue: rawIndex) ?? .unknown()
            lowerLED = true
        default:
            leds = .allOff
            lowerLED = false
        }
    }
}

extension HUIVPotDisplay {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:options --maxwidth none
    
    /// Preset HUI VPot LED states.
    public enum LEDState: UInt8, CaseIterable {
        case allOff          = 0x00
        
        case singleL5        = 0x01
        case singleL4        = 0x02
        case singleL3        = 0x03
        case singleL2        = 0x04
        case singleL1        = 0x05
        case singleC         = 0x06
        case singleR1        = 0x07
        case singleR2        = 0x08
        case singleR3        = 0x09
        case singleR4        = 0x0A
        case singleR5        = 0x0B
        
        case fromCenterToL5  = 0x11
        case fromCenterToL4  = 0x12
        case fromCenterToL3  = 0x13
        case fromCenterToL2  = 0x14
        case fromCenterToL1  = 0x15
        case fromCenterToC   = 0x16
        case fromCenterToR1  = 0x17
        case fromCenterToR2  = 0x18
        case fromCenterToR3  = 0x19
        case fromCenterToR4  = 0x1A
        case fromCenterToR5  = 0x1B
        
        case fromLeftToL5    = 0x21
        case fromLeftToL4    = 0x22
        case fromLeftToL3    = 0x23
        case fromLeftToL2    = 0x24
        case fromLeftToL1    = 0x25
        case fromLeftToC     = 0x26
        case fromLeftToR1    = 0x27
        case fromLeftToR2    = 0x28
        case fromLeftToR3    = 0x29
        case fromLeftToR4    = 0x2A
        case fromLeftToR5    = 0x2B
        
        case centerWidth0    = 0x31
        case centerWidth1    = 0x32
        case centerWidth3    = 0x33
        case centerWidth5    = 0x34
        case centerWidth7    = 0x35
        case centerWidth9    = 0x36
        case centerWidth11   = 0x37
        /// Same state as ``fromCenterWidth11``.
        case centerWidth11altA = 0x38
        /// Same state as ``fromCenterWidth11``.
        case centerWidth11altB = 0x39
        /// Same state as ``fromCenterWidth11``.
        case centerWidth11altC = 0x3A
        /// Same state as ``fromCenterWidth11``.
        case centerWidth11altD = 0x3B
        
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
            let bits = Self.ledMatrix[Int(rawValue)]
            return (0 ..< 11).map { (bits >> $0) & 0b1 == 0b1 }
        }
        
        // swiftformat:disable numberFormatting
        
        /// Matrix of preset LED states.
        static let ledMatrix: [UInt16] = [
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
        
        /// Suitable default case for use as a default/neutral preset index.
        public static func `default`() -> Self {
            .allOff
        }
        
        /// Suitable default case for use as a substitute for an unknown preset index.
        public static func unknown() -> Self {
            .allOff
        }
    }
}

// MARK: - CustomStringConvertible

extension HUIVPotDisplay.LEDState: CustomStringConvertible {
    public var description: String {
        "[" + stringValue() + "]"
    }
}
