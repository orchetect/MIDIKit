//
//  MIDIKit-0.5.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Symbols that were renamed or removed.

extension MIDINote {
    /// Utility method that returns frequency in Hz calculated from a MIDI note number.
    ///
    /// - Parameter ofMIDINote: MIDI note number
    /// - Parameter tuning: Tuning in Hertz
    @available(*, unavailable, renamed: "calculateFrequency(midiNote:tuning:)")
    public static func calculateFrequency(
        ofMIDINote: Int,
        tuning: Double = 440.0
    ) -> Double {
        Self.calculateFrequency(
            midiNote: ofMIDINote,
            tuning: tuning
        )
    }
    
    /// Utility method that returns a MIDI note number calculated from frequency in Hz.
    ///
    /// > Note: Results may be out-of-bounds (outside of `0 ... 127`)
    ///
    /// - Parameter ofFrequency: MIDI note number
    /// - Parameter tuning: Tuning in Hertz
    @available(*, unavailable, renamed: "calculateMIDINoteNumber(frequency:tuning:)")
    public static func calculateMIDINoteNumber(
        ofFrequency: Double,
        tuning: Double = 440.0
    ) -> Int {
        Self.calculateMIDINoteNumber(
            frequency: ofFrequency,
            tuning: tuning
        )
    }
}
