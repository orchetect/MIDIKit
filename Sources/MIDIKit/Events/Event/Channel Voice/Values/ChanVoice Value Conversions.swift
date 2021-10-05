//
//  ChanVoice Value Conversions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - 7-Bit <--> 16-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaled16Bit(from7Bit source: MIDI.UInt7) -> UInt16 {
        
        #warning("> code this")
        let scaled = (Double(source.uInt8Value) / 0x7F) * 0xFFFF
        return UInt16(scaled.rounded())
        
    }
    
    @inline(__always)
    internal static func scaled7Bit(from16Bit source: UInt16) -> MIDI.UInt7 {
        
        #warning("> code this")
        let scaled = (Double(source) / 0xFFFF) * 0x7F
        return MIDI.UInt7(scaled.rounded())
        
    }
    
}

// MARK: - 7-Bit <--> 32-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaled32Bit(from7Bit source: MIDI.UInt7) -> UInt32 {
        
        #warning("> code this")
        let scaled = (Double(source.uInt8Value) / 0x7F) * 0xFFFFFFFF
        return UInt32(scaled.rounded())
        
    }
    
    @inline(__always)
    internal static func scaled7Bit(from32Bit source: UInt32) -> MIDI.UInt7 {
        
        #warning("> code this")
        let scaled = (Double(source) / 0xFFFFFFFF) * 0x7F
        return MIDI.UInt7(scaled.rounded())
        
    }
    
}

// MARK: - 14-Bit <--> 32-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaled32Bit(from14Bit source: MIDI.UInt14) -> UInt32 {
        
        #warning("> code this")
        let scaled = (Double(source.uInt16Value) / 0x3FFF) * 0xFFFFFFFF
        return UInt32(scaled.rounded())
        
    }
    
    @inline(__always)
    internal static func scaled14Bit(from32Bit source: UInt32) -> MIDI.UInt14 {
        
        #warning("> code this")
        let scaled = (Double(source) / 0xFFFFFFFF) * 0x3FFF
        return MIDI.UInt14(scaled.rounded())
        
    }
    
}

// MARK: - Unit Interval <--> 7-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from7Bit source: MIDI.UInt7) -> Double {
        
        #warning("> code this")
        return Double(source.uInt8Value) / 0x7F
        
    }
    
    @inline(__always)
    internal static func scaled7Bit(fromUnitInterval source: Double) -> MIDI.UInt7 {
        
        #warning("> code this")
        let scaled = source.clamped(to: 0.0...1.0) * 0x7F
        return MIDI.UInt7(scaled.rounded())
        
    }
    
}

// MARK: - Unit Interval <--> 14-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from14Bit source: MIDI.UInt14) -> Double {
        
        #warning("> code this")
        return Double(source.uInt16Value) / 0x3FFF
        
    }
    
    @inline(__always)
    internal static func scaled14Bit(fromUnitInterval source: Double) -> MIDI.UInt14 {
        
        #warning("> code this")
        let scaled = source.clamped(to: 0.0...1.0) * 0x3FFF
        return MIDI.UInt14(scaled.rounded())
        
    }
    
}

// MARK: - Unit Interval <--> 16-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from16Bit source: UInt16) -> Double {
        
        #warning("> code this")
        return Double(source) / 0xFFFF
        
    }
    
    @inline(__always)
    internal static func scaled16Bit(fromUnitInterval source: Double) -> UInt16 {
        
        #warning("> code this")
        let scaled = source.clamped(to: 0.0...1.0) * 0xFFFF
        return UInt16(scaled.rounded())
        
    }
    
}

// MARK: - Unit Interval <--> 32-Bit

extension MIDI.Event {
    
    @inline(__always)
    internal static func scaledUnitInterval(from32Bit source: UInt32) -> Double {
        
        #warning("> code this")
        return Double(source) / 0xFFFFFFFF
        
    }
    
    @inline(__always)
    internal static func scaled32Bit(fromUnitInterval source: Double) -> UInt32 {
        
        #warning("> code this")
        let scaled = source.clamped(to: 0.0...1.0) * 0xFFFFFFFF
        return UInt32(scaled.rounded())
        
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
