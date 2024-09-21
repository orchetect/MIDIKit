//
//  MIDINote.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Value type describing a MIDI note number.
///
/// Constructors and properties allow getting and setting by raw value, note name & octave, or
/// string representation.
public struct MIDINote: Equatable, Hashable {
    // MARK: - Constants
    
    /// MIDI note number.
    public var number: UInt7 = 0
    
    /// MIDI note naming style (octave offset).
    public var style: Style = .yamaha
    
    // MARK: - Init
    
    /// Construct from a MIDI note number.
    @_disfavoredOverload
    public init(
        _ number: some BinaryInteger,
        style: Style = .yamaha
    ) throws {
        self.style = style
    
        guard let uint7 = UInt7(exactly: number) else {
            throw NoteError.outOfBounds
        }
        self.number = uint7
    }
    
    /// Construct from a MIDI note number.
    public init(
        _ number: UInt7,
        style: Style = .yamaha
    ) {
        self.style = style
        self.number = number
    }
    
    /// Construct from a note `Name` and octave.
    public init(
        _ name: Name,
        octave: Int,
        style: Style = .yamaha
    ) throws {
        self.style = style
        try setNoteNumber(
            name,
            octave: octave
        )
    }
    
    /// Construct from a MIDI note name string.
    public init(
        _ string: String,
        style: Style = .yamaha
    ) throws {
        self.style = style
        try setNoteNumber(from: string)
    }
    
    /// Construct from a frequency in Hz and round to the nearest MIDI note.
    /// Sets the nearest note number to the frequency.
    public init(
        frequency: Double,
        style: Style = .yamaha
    ) throws {
        self.style = style
        try setNoteNumber(frequency: frequency)
    }
    
    /// Get the MIDI note name enum case.
    public var name: Name {
        Name.convert(
            noteNumber: number,
            style: style
        )
        .name
    }
    
    /// Get the MIDI note name enum case.
    ///
    /// This octave number reflects the naming style that was set at time of initialization.
    public var octave: Int {
        Name.convert(
            noteNumber: number,
            style: style
        )
        .octave
    }
    
    /// Get the MIDI note name string (ie: "A-2" "C#6").
    ///
    /// This string reflects the naming style that was set at time of initialization.
    ///
    /// - Parameters:
    ///   - namingStandard: Note naming standard (octave offset).
    ///   - respellSharpAsFlat: If note is sharp, respell enharmonically as a flat (ie: G♯ becomes
    /// A♭). Otherwise, sharp is always used, which is typical convention for MIDI note names.
    ///   - unicodeAccidental: Use stylized unicode character for sharp (♯) and flat (♭).
    ///
    /// - Returns: MIDI note name string.
    public func stringValue(
        respellSharpAsFlat: Bool = false,
        unicodeAccidental: Bool = false
    ) -> String {
        let divided = number.intValue
            .quotientAndRemainder(dividingBy: 12)
        let octave = divided.quotient + style.firstOctaveOffset
        let scaleOffset = divided.remainder
    
        let findNoteName = Name.allCases
            .first(where: { $0.scaleOffset == scaleOffset })
    
        let noteName = findNoteName?.stringValue(
            respellSharpAsFlat: respellSharpAsFlat,
            unicodeAccidental: unicodeAccidental
        )
            ?? "?"
    
        return "\(noteName)\(octave)"
    }
    
    /// Get MIDI note frequency in Hz, based on tuning.
    public func frequencyValue(tuning: Double = 440.0) -> Double {
        Self.calculateFrequency(
            midiNote: number.intValue,
            tuning: tuning
        )
    }
}

// MARK: - Internal Setters

extension MIDINote {
    /// Set note number from note name and octave.
    mutating func setNoteNumber(
        _ source: Name,
        octave: Int
    ) throws {
        let noteNum = ((octave - style.firstOctaveOffset) * 12) + source.scaleOffset
    
        guard let uInt7 = UInt7(exactly: noteNum) else {
            throw NoteError.outOfBounds
        }
    
        number = uInt7
    }
    
    /// Set note number from a MIDI note name string.
    mutating func setNoteNumber(from source: String) throws {
        var noteString = ""
    
        let testCharSet = CharacterSet(charactersIn: "ABCDEFG")
        guard let rngNote = source.rangeOfCharacter(
            from: testCharSet,
            options: [],
            range: source.startIndex ..< source.index(after: source.startIndex)
        ) else {
            throw NoteError.malformedNoteName
        }
    
        // test for # Sharp
    
        let cs = [
            MIDINote.Name.sharpAccidental,
            MIDINote.Name.sharpAccidentalUnicode,
            MIDINote.Name.flatAccidental,
            MIDINote.Name.flatAccidentalUnicode
        ]
            .map { "\($0)" }
            .joined()
    
        let accidentalCharSet = CharacterSet(charactersIn: cs)
    
        if let rngAccidental = source.rangeOfCharacter(from: accidentalCharSet) {
            noteString = String(source[rngNote.lowerBound ... rngAccidental.lowerBound])
        } else {
            noteString = String(source[rngNote])
        }
    
        guard let noteName = Name(noteString) else {
            throw NoteError.malformedNoteName
        }
    
        let octaveString = String(
            source[
                source.index(
                    source.startIndex,
                    offsetBy: noteString.count
                )...
            ]
        )
    
        // must convert string to int
        guard let octave = Int(octaveString) else {
            throw NoteError.outOfBounds
        }
    
        // must be within range
        guard (style.firstOctaveOffset ... 10 + style.firstOctaveOffset) ~= octave else {
            throw NoteError.outOfBounds
        }
    
        try setNoteNumber(
            noteName,
            octave: octave
        )
    }
    
    /// Sets the nearest note number to the frequency in Hz.
    mutating func setNoteNumber(
        frequency: Double,
        tuning: Double = 440.0
    ) throws {
        let noteNum = Self.calculateMIDINoteNumber(
            frequency: frequency,
            tuning: tuning
        )
    
        guard let uInt7 = UInt7(exactly: noteNum) else {
            throw NoteError.outOfBounds
        }
    
        number = uInt7
    }
}

extension MIDINote: CustomStringConvertible {
    public var description: String {
        stringValue(unicodeAccidental: true)
    }
}

extension MIDINote: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Note(\(stringValue(unicodeAccidental: true)) number:\(number))"
    }
}

extension MIDINote: Comparable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.number == rhs.number
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.number < rhs.number
    }
}

extension MIDINote: Strideable {
    public typealias Stride = Int
    
    public func distance(to other: Self) -> Int {
        other.number.intValue - number.intValue
    }
    
    public func advanced(by n: Int) -> Self {
        let clamped = UInt7(clamping: number.intValue + n)
    
        return Self(clamped, style: style)
    }
}

extension MIDINote: Sendable { }

extension MIDINote {
    /// Returns an array of all 128 MIDI notes.
    public static func allNotes(style: Style = .yamaha) -> [Self] {
        Array(MIDINoteRange.all(style: style))
    }
}

extension MIDINote {
    /// Utility method that returns frequency in Hz calculated from a MIDI note number.
    /// - Parameter midiNote: MIDI note number
    /// - Parameter tuning: Tuning in Hertz
    public static func calculateFrequency(
        midiNote: Int,
        tuning: Double = 440.0
    ) -> Double {
        pow(2.0, (Double(midiNote) - 69.0) / 12.0) * tuning
    }
    
    /// Utility method that returns a MIDI note number calculated from frequency in Hz.
    /// Note: Results may be out-of-bounds (outside of `0 ... 127`)
    /// - Parameter frequency: MIDI note number
    /// - Parameter tuning: Tuning in Hertz
    public static func calculateMIDINoteNumber(
        frequency: Double,
        tuning: Double = 440.0
    ) -> Int {
        Int(round(12.0 * log2(frequency / tuning) + 69.0))
    }
}
