//
//  Note Attribute Pitch7_9.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Darwin

extension MIDI.Event.Note.Attribute {
    
    /// Pitch 7.9
    ///
    /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
    ///
    /// Range: 0+(0/512) ... 127+(511/512)
    public struct Pitch7_9: Equatable, Hashable {
        
        var coarse: MIDI.UInt7
        
        var fine: MIDI.UInt9
        
    }
    
}

// MARK: - Byte.Pair

extension MIDI.Event.Note.Attribute.Pitch7_9 {
    
    public init(_ bytePair: MIDI.Byte.Pair) {
        
        coarse = MIDI.UInt7((bytePair.msb & 0b1111_1110) >> 1)
        
        fine = MIDI.UInt9(
            MIDI.UInt9.Storage(bytePair.lsb)
                + (MIDI.UInt9.Storage(bytePair.msb & 0b1) << 8)
        )
        
    }
    
    /// UInt16 representation.
    public var bytePair: MIDI.Byte.Pair {
        
        let msb = MIDI.Byte(coarse.value << 1) + MIDI.Byte((fine.value & 0b1_0000_0000) >> 8)
        let lsb = MIDI.Byte(fine.value & 0b1111_1111)
        
        return .init(msb: msb, lsb: lsb)
        
    }
    
}

// MARK: - UInt16

extension MIDI.Event.Note.Attribute.Pitch7_9 {
    
    public init(_ uInt16Value: UInt16) {
        
        coarse = ((uInt16Value & 0b1111_1110_0000_0000) >> 9).toMIDIUInt7
        fine =    (uInt16Value & 0b0000_0001_1111_1111)      .toMIDIUInt9
        
    }
    
    /// UInt16 representation.
    public var uInt16Value: UInt16 {
        
        (UInt16(coarse.value) << 9) + fine.value
        
    }
    
}

// MARK: - Double

extension MIDI.Event.Note.Attribute.Pitch7_9 {
    
    /// Converted from a Double value (0.0...127.998046875)
    public init(_ double: Double) {
        
        let double = double.clamped(to: 0.0...127.998046875)
        
        let truncated = trunc(double)
        
        coarse = MIDI.UInt7(truncated)
        fine = MIDI.UInt9(round((double - truncated) * 0b10_0000_0000))
        
    }
    
    /// Converted to a Double value (0.0...127.998046875)
    public var doubleValue: Double {
        
        Double(coarse.value) + (Double(fine.value) / 0b10_0000_0000)
        
    }
    
}
