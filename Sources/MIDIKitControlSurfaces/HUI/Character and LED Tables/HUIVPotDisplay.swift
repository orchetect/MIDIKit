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
    
    public init() {
        leds = .allOff
        lowerLED = false
    }
    
    public init(leds: LEDState, lowerLED: Bool) {
        self.leds = leds
        self.lowerLED = lowerLED
    }
    
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

extension HUIVPotDisplay {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:options --maxwidth none
    
    /// Preset HUI VPot LED states.
    public enum LEDState: CaseIterable, Equatable, Hashable {
        case allOff
        
        /// A single LED is illuminated.
        case single(LED)
        
        /// A range of LED(s) are illuminated starting from the center and extending to the given LED.
        case center(to: LED)
        
        /// A range of LED(s) are illuminated starting from the left and extending to the given LED.
        case left(to: LED)
        
        /// A range of LED(s) are illuminated starting from the center and extending symmetrically to both left and right by the given number of LEDs.
        case centerSymmetrical(width: Int)
        
        public static var allCases: [Self] = [.allOff]
            + LED.allCases.map { .single($0) }
            + LED.allCases.map { .center(to: $0) }
            + LED.allCases.map { .left(to: $0) }
            + (1 ... 5).map { .centerSymmetrical(width: $0) }
        
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
                case 0x1 ... 0x5:
                    self = .centerSymmetrical(width: Int(nibbles.low))
                case 0x6 ... 0xB:
                    self = .centerSymmetrical(width: 6)
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
            case let .centerSymmetrical(width):
                return 0x30 + UInt8(width.clamped(to: 0...5))
            }
        }
        
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
            return (0 ..< 11).map { (bits >> $0) & 0b1 == 0b1 }.reversed()
        }
        
        /// LED states as an 11-bit pattern. (Big-endian, occupying 11 least significant bits).
        public var bitPattern: UInt16 {
            Self.ledMatrix[Int(rawValue)]
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
        
        /// Returns contiguous bounds as LED indexes from `0x0 ... 0xA`.
        /// Returns `nil` if all LEDs are off.
        public var bounds: ClosedRange<LED>? {
            switch self {
            case .allOff:
                return nil
            
            case let .single(led):
                return led ... led
                
            case let .center(to: led):
                switch led {
                case .L5, .L4, .L3, .L2, .L1:
                    return led ... .C
                case .C:
                    return .C ... .C
                case .R1, .R2, .R3, .R4, .R5:
                    return .C ... led
                }
            
            case let .left(to: led):
                return .L5 ... led
            
            case let .centerSymmetrical(width: width):
                switch width {
                case ...0: return nil
                case 1:    return .C ... .C
                case 2:    return .L1 ... .R1
                case 3:    return .L2 ... .R2
                case 4:    return .L3 ... .R3
                case 5:    return .L4 ... .R4
                case 6...: return .L5 ... .R5
                default:   return nil
                }
            }
        }
        
        /// Returns contiguous bounds as unit intervals (`0.0 ... 1.0`).
        /// Returns `nil` if all LEDs are off.
        public var unitIntervalBounds: ClosedRange<Double>? {
            guard let bounds = bounds else { return nil }
            
            return bounds.lowerBound.unitIntervalLowerBound ... bounds.upperBound.unitIntervalUpperBound
        }
        
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

extension HUIVPotDisplay.LEDState {
    /// HUI V-Pot Display LED.
    /// Raw value is the offset from the leftmost LED.
    public enum LED: UInt8, CaseIterable, Equatable, Hashable {
        case L5 = 0x0
        case L4 = 0x1
        case L3 = 0x2
        case L2 = 0x3
        case L1 = 0x4
        case C  = 0x5
        case R1 = 0x6
        case R2 = 0x7
        case R3 = 0x8
        case R4 = 0x9
        case R5 = 0xA
        
        var unitIntervalLowerBound: Double {
            Double(rawValue) / 0xB
        }
        
        var unitIntervalUpperBound: Double {
            Double(rawValue + 1) / 0xB
        }
    }
}

extension HUIVPotDisplay.LEDState.LED: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension HUIVPotDisplay.LEDState.LED: CustomStringConvertible {
    public var description: String {
        switch self {
        case .L5: return "L5"
        case .L4: return "L4"
        case .L3: return "L3"
        case .L2: return "L2"
        case .L1: return "L1"
        case .C:  return "C"
        case .R1: return "R1"
        case .R2: return "R2"
        case .R3: return "R3"
        case .R4: return "R4"
        case .R5: return "R5"
        }
    }
}

// MARK: - CustomStringConvertible

extension HUIVPotDisplay.LEDState: CustomStringConvertible {
    public var description: String {
        "[" + stringValue() + "]"
    }
}

// MARK: - Static Constructors

extension HUIVPotDisplay {
    /// Initialize HUI V-Pot LED Ring Display state with all LEDs off.
    public static var allOff: HUIVPotDisplay = .init(leds: .allOff, lowerLED: false)
}
