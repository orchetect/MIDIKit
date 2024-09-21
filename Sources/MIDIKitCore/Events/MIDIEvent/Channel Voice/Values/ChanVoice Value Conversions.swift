//
//  ChanVoice Value Conversions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - 7-Bit <--> 16-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 7-bit value to a 16-bit value.
    /// Adheres to scaling algorithm defined in MIDI 2.0 Spec.
    static func scaled16Bit(from7Bit source: UInt7) -> UInt16 {
        let bitShiftedValue = UInt16(source) << 9
        if source <= 64 {
            return bitShiftedValue
        }
        // use bit repeat bits from extended 7-bit value
        let repeatValue6 = UInt16(source) & 0b111111
        return bitShiftedValue
            | (repeatValue6 << 3)
            | (repeatValue6 >> 3)
    }
    
    /// Internal:
    /// Scales a 16-bit value to a 7-bit value.
    static func scaled7Bit(from16Bit source: UInt16) -> UInt7 {
        UInt7(source >> 9) // (16 - 7)
    }
}

// MARK: - 7-Bit <--> 32-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 7-bit value to a 32-bit value.
    /// Adheres to scaling algorithm defined in MIDI 2.0 Spec.
    static func scaled32Bit(from7Bit source: UInt7) -> UInt32 {
        var bitShiftedValue = UInt32(source) << 25 // (32 - 7)
        if source <= 0x40 {
            return bitShiftedValue
        }
        // use bit repeat bits from extended 7-bit value
        var repeatValue = UInt32(source) & 0b111111
        repeatValue <<= 19 // ((32 - 7) - 6)
        while (repeatValue != 0) {
            bitShiftedValue |= repeatValue
            repeatValue >>= 6 // repeat bits
        }
        return bitShiftedValue
    }
    
    /// Internal:
    /// Scales a 32-bit value to a 7-bit value.
    static func scaled7Bit(from32Bit source: UInt32) -> UInt7 {
        UInt7(source >> 25) // (32 - 7)
    }
}

// MARK: - 14-Bit <--> 32-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 14-bit value to a 32-bit value.
    /// Adheres to scaling algorithm defined in MIDI 2.0 Spec.
    static func scaled32Bit(from14Bit source: UInt14) -> UInt32 {
        var bitShiftedValue = UInt32(source) << 18 // (32 - 14)
        if source <= 0x2000 {
            return bitShiftedValue
        }
        // use bit repeat bits from extended 14-bit value
        var repeatValue = UInt32(source) & 0b11111_11111111
        repeatValue <<= 5 // ((32 - 14) - 13)
        while (repeatValue != 0) {
            bitShiftedValue |= repeatValue
            repeatValue >>= 13 // repeat bits
        }
        return bitShiftedValue
    }
    
    /// Internal:
    /// Scales a 32-bit value to a 14-bit value.
    static func scaled14Bit(from32Bit source: UInt32) -> UInt14 {
        UInt14(source >> 18) // (32 - 14)
    }
}

// MARK: - Unit Interval <--> 7-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 7-bit value to a unit interval value.
    static func scaledUnitInterval(from7Bit source: UInt7) -> Double {
        if source <= 0x40 {
            return Double(source.uInt8Value) / 0x80
        } else if source == 0x7F {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source.uInt8Value - 0x40) / 0x7E)
        }
    }
    
    /// Internal:
    /// Scales a unit interval value to a 7-bit value.
    static func scaled7Bit(fromUnitInterval source: Double) -> UInt7 {
        let source = source.clamped(to: 0.0 ... 1.0)
    
        if source <= 0.5 {
            return UInt7(source * 0x80)
        } else {
            return 0x40 + UInt7((source - 0.5) * 0x7E)
        }
    }
}

// MARK: - Unit Interval <--> 14-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 14-bit value to a unit interval value.
    static func scaledUnitInterval(from14Bit source: UInt14) -> Double {
        if source <= 0x2000 {
            return Double(source.uInt16Value) / 0x4000
        } else if source == 0x3FFF {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source.uInt16Value - 0x2000) / 0x3FFE)
        }
    }
    
    /// Internal:
    /// Scales a unit interval value to a 14-bit value.
    static func scaled14Bit(fromUnitInterval source: Double) -> UInt14 {
        let source = source.clamped(to: 0.0 ... 1.0)
    
        if source <= 0.5 {
            return UInt14(source * 0x4000)
        } else {
            return 0x2000 + UInt14((source - 0.5) * 0x3FFE)
        }
    }
}

// MARK: - Unit Interval <--> 16-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 16-bit value to a unit interval value.
    static func scaledUnitInterval(from16Bit source: UInt16) -> Double {
        if source <= 0x8000 {
            return Double(source) / 0x10000
        } else if source == 0xFFFF {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source - 0x8000) / 0xFFFE)
        }
    }
    
    /// Internal:
    /// Scales a unit interval value to a 16-bit value.
    static func scaled16Bit(fromUnitInterval source: Double) -> UInt16 {
        let source = source.clamped(to: 0.0 ... 1.0)
    
        if source <= 0.5 {
            return UInt16(source * 0x10000)
        } else {
            return 0x8000 + UInt16((source - 0.5) * 0xFFFE)
        }
    }
}

// MARK: - Unit Interval <--> 32-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 32-bit value to a unit interval value.
    static func scaledUnitInterval(from32Bit source: UInt32) -> Double {
        if source <= 0x8000_0000 {
            return Double(source) / 0x1_0000_0000
        } else if source == 0xFFFF_FFFF {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source - 0x8000_0000) / 0xFFFF_FFFE)
        }
    }
    
    /// Internal:
    /// Scales a unit interval value to a 32-bit value.
    static func scaled32Bit(fromUnitInterval source: Double) -> UInt32 {
        let source = source.clamped(to: 0.0 ... 1.0)
    
        if source <= 0.5 {
            return UInt32(source * 0x1_0000_0000)
        } else {
            return 0x8000_0000 + UInt32((source - 0.5) * 0xFFFF_FFFE)
        }
    }
}

// MARK: - Bipolar Unit Interval <--> Unit Interval

extension MIDIEvent {
    /// Internal:
    /// Scales a unit interval value to a bipolar unit interval value.
    static func scaledBipolarUnitInterval(fromUnitInterval source: Double) -> Double {
        source.bipolarUnitIntervalValue
    }
    
    /// Internal:
    /// Scales a bipolar unit interval value to a unit interval value.
    static func scaledUnitInterval(fromBipolarUnitInterval source: Double) -> Double {
        Double(bipolarUnitInterval: source)
    }
}

// MARK: - Bipolar Unit Interval <--> 14-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 14-bit value to a bipolar unit interval value.
    static func scaledBipolarUnitInterval(from14Bit source: UInt14) -> Double {
        source.bipolarUnitIntervalValue
    }
    
    /// Internal:
    /// Scales a bipolar unit interval value to a 14-bit value.
    static func scaled14Bit(fromBipolarUnitInterval source: Double) -> UInt14 {
        UInt14(bipolarUnitInterval: source)
    }
}

// MARK: - Bipolar Unit Interval <--> 32-Bit

extension MIDIEvent {
    /// Internal:
    /// Scales a 32-bit value to a bipolar unit interval value.
    static func scaledBipolarUnitInterval(from32Bit source: UInt32) -> Double {
        source.bipolarUnitIntervalValue
    }
    
    /// Internal:
    /// Scales a bipolar unit interval value to a 32-bit value.
    static func scaled32Bit(fromBipolarUnitInterval source: Double) -> UInt32 {
        UInt32(bipolarUnitInterval: source)
    }
}
