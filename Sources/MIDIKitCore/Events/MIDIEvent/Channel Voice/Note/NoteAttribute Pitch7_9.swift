//
//  NoteAttribute Pitch7_9.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Darwin

extension MIDIEvent.NoteAttribute {
    /// Pitch 7.9 Note Attribute
    /// (MIDI 2.0)
    ///
    /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
    ///
    /// Range: 0+(0/512) ... 127+(511/512)
    public struct Pitch7_9: Equatable, Hashable {
        /// 7-Bit coarse pitch in semitones, based on default Note Number equal temperament scale.
        public var coarse: UInt7
    
        /// 9-Bit fractional pitch above Note Number (i.e., fraction of one semitone).
        public var fine: UInt9
    
        /// Pitch 7.9 Note Attribute
        /// (MIDI 2.0)
        ///
        /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
        ///
        /// Range: 0+(0/512) ... 127+(511/512)
        ///
        /// - Parameters:
        ///   - coarse: 7-Bit coarse pitch in semitones, based on default Note Number equal temperament scale.
        ///   - fine: 9-Bit fractional pitch above Note Number (i.e., fraction of one semitone).
        public init(
            coarse: UInt7,
            fine: UInt9
        ) {
            self.coarse = coarse
            self.fine = fine
        }
    }
}

extension MIDIEvent.NoteAttribute.Pitch7_9: CustomStringConvertible {
    public var description: String {
        "pitch7.9(\(coarse), fine:\(fine))"
    }
}

// MARK: - BytePair

extension MIDIEvent.NoteAttribute.Pitch7_9 {
    /// Pitch 7.9 (MIDI 2.0): Initialize from UInt16 representation as a byte pair.
    ///
    /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
    ///
    /// Range: 0+(0/512) ... 127+(511/512)
    public init(_ bytePair: BytePair) {
        coarse = UInt7((bytePair.msb & 0b11111110) >> 1)
    
        fine = UInt9(
            UInt9.Storage(bytePair.lsb)
                + (UInt9.Storage(bytePair.msb & 0b1) << 8)
        )
    }
    
    /// UInt16 representation as a byte pair.
    public var bytePair: BytePair {
        let msb = Byte(coarse.value << 1) + Byte((fine.value & 0b1_00000000) >> 8)
        let lsb = Byte(fine.value & 0b11111111)
    
        return .init(msb: msb, lsb: lsb)
    }
}

// MARK: - UInt16

extension MIDIEvent.NoteAttribute.Pitch7_9 {
    /// Pitch 7.9 (MIDI 2.0): Initialize from UInt16 representation.
    ///
    /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
    ///
    /// Range: 0+(0/512) ... 127+(511/512)
    public init(_ uInt16Value: UInt16) {
        coarse = ((uInt16Value & 0b11111110_00000000) >> 9).toUInt7
        fine =    (uInt16Value & 0b00000001_11111111).toUInt9
    }
    
    /// UInt16 representation.
    public var uInt16Value: UInt16 {
        (UInt16(coarse.value) << 9) + fine.value
    }
}

// MARK: - Double

extension MIDIEvent.NoteAttribute.Pitch7_9 {
    /// Pitch 7.9 (MIDI 2.0): Initialize by converting from a Double value (0.0...127.998046875)
    ///
    /// A Q7.9 fixed-point unsigned integer that specifies a pitch in semitones.
    ///
    /// Range: 0+(0/512) ... 127+(511/512)
    public init(_ double: Double) {
        let double = double.clamped(to: 0.0 ... 127.998046875)
    
        let truncated = trunc(double)
    
        coarse = UInt7(truncated)
        fine = UInt9(round((double - truncated) * 0b10_00000000))
    }
    
    /// Converted to a Double value (0.0...127.998046875)
    public var doubleValue: Double {
        Double(coarse.value) + (Double(fine.value) / 0b10_00000000)
    }
}
