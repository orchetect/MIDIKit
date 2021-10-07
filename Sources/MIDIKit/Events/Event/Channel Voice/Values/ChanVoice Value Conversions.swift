//
//  ChanVoice Value Conversions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - 7-Bit <--> 16-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaled16Bit(from7Bit source: MIDI.UInt7) -> UInt16 {
        
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
    
    @inline(__always)
    internal static func scaled7Bit(from16Bit source: UInt16) -> MIDI.UInt7 {
        
        MIDI.UInt7(source >> 9) // (16 - 7)
        
    }
    
}

// MARK: - 7-Bit <--> 32-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaled32Bit(from7Bit source: MIDI.UInt7) -> UInt32 {
        
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
    
    @inline(__always)
    internal static func scaled7Bit(from32Bit source: UInt32) -> MIDI.UInt7 {
        
        MIDI.UInt7(source >> 25) // (32 - 7)
        
    }
    
}

// MARK: - 14-Bit <--> 32-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaled32Bit(from14Bit source: MIDI.UInt14) -> UInt32 {
        
        var bitShiftedValue = UInt32(source) << 18 // (32 - 14)
        if source <= 0x2000 {
            return bitShiftedValue
        }
        // use bit repeat bits from extended 14-bit value
        var repeatValue = UInt32(source) & 0b1_1111_1111_1111
        repeatValue <<= 5 // ((32 - 14) - 13)
        while (repeatValue != 0) {
            bitShiftedValue |= repeatValue
            repeatValue >>= 13 // repeat bits
        }
        return bitShiftedValue
        
    }
    
    @inline(__always)
    internal static func scaled14Bit(from32Bit source: UInt32) -> MIDI.UInt14 {
        
        MIDI.UInt14(source >> 18) // (32 - 14)
        
    }
    
}

// MARK: - Unit Interval <--> 7-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from7Bit source: MIDI.UInt7) -> Double {
        
        if source <= 0x40 {
            return Double(source.uInt8Value) / 0x80
        } else if source == 0x7F {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source.uInt8Value - 0x40) / 0x7E)
        }
        
    }
    
    @inline(__always)
    internal static func scaled7Bit(fromUnitInterval source: Double) -> MIDI.UInt7 {
        
        let source = source.clamped(to: 0.0...1.0)
        
        if source <= 0.5 {
            return MIDI.UInt7(source * 0x80)
        } else {
            return 0x40 + MIDI.UInt7((source - 0.5) * 0x7E)
        }
        
    }
    
}

// MARK: - Unit Interval <--> 14-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from14Bit source: MIDI.UInt14) -> Double {
        
        if source <= 0x2000 {
            return Double(source.uInt16Value) / 0x4000
        } else if source == 0x3FFF {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source.uInt16Value - 0x2000) / 0x3FFE)
        }
        
    }
    
    @inline(__always)
    internal static func scaled14Bit(fromUnitInterval source: Double) -> MIDI.UInt14 {
        
        let source = source.clamped(to: 0.0...1.0)
        
        if source <= 0.5 {
            return MIDI.UInt14(source * 0x4000)
        } else {
            return 0x2000 + MIDI.UInt14((source - 0.5) * 0x3FFE)
        }
        
    }
    
}

// MARK: - Unit Interval <--> 16-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from16Bit source: UInt16) -> Double {
        
        if source <= 0x8000 {
            return Double(source) / 0x10000
        } else if source == 0xFFFF {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source - 0x8000) / 0xFFFE)
        }
        
    }
    
    @inline(__always)
    internal static func scaled16Bit(fromUnitInterval source: Double) -> UInt16 {
        
        let source = source.clamped(to: 0.0...1.0)
        
        if source <= 0.5 {
            return UInt16(source * 0x10000)
        } else {
            return 0x8000 + UInt16((source - 0.5) * 0xFFFE)
        }
        
    }
    
}

// MARK: - Unit Interval <--> 32-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from32Bit source: UInt32) -> Double {
        
        if source <= 0x80000000 {
            return Double(source) / 0x100000000
        } else if source == 0xFFFFFFFF {
            return 1.0
        } else {
            return 0.5000000000023283 + (Double(source - 0x80000000) / 0xFFFFFFFE)
        }
        
    }
    
    @inline(__always)
    internal static func scaled32Bit(fromUnitInterval source: Double) -> UInt32 {
        
        let source = source.clamped(to: 0.0...1.0)
        
        if source <= 0.5 {
            return UInt32(source * 0x100000000)
        } else {
            return 0x80000000 + UInt32((source - 0.5) * 0xFFFFFFFE)
        }
        
    }
    
}

// MARK: - Bipolar Unit Interval <--> Unit Interval

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledBipolarUnitInterval(fromUnitInterval source: Double) -> Double {
        
        source.bipolarUnitIntervalValue
        
    }
    
    @inline(__always)
    internal static func scaledUnitInterval(fromBipolarUnitInterval source: Double) -> Double {
        
        Double(bipolarUnitInterval: source)
        
    }
    
}

// MARK: - Bipolar Unit Interval <--> 14-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledBipolarUnitInterval(from14Bit source: MIDI.UInt14) -> Double {
        
        source.bipolarUnitIntervalValue
        
    }
    
    @inline(__always)
    internal static func scaled14Bit(fromBipolarUnitInterval source: Double) -> MIDI.UInt14 {
        
        MIDI.UInt14(bipolarUnitInterval: source)
        
    }
    
}

// MARK: - Bipolar Unit Interval <--> 32-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledBipolarUnitInterval(from32Bit source: UInt32) -> Double {
        
        source.bipolarUnitIntervalValue
        
    }
    
    @inline(__always)
    internal static func scaled32Bit(fromBipolarUnitInterval source: Double) -> UInt32 {
        
        UInt32(bipolarUnitInterval: source)
        
    }
    
}
