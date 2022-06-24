//
//  MIDI Note.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

public extension MIDI {
    
    /// Object describing a MIDI note number.
    ///
    /// Constructors and properties allow getting and setting by raw value, note name & octave, or string representation.
    ///
    /// (Valid note range: C-2 to G8, or 0...127)
    ///
    /// Middle C is represented as C3 (note #60)
    struct Note: Equatable, Hashable {
        
        // MARK: - Constants
        
        /// MIDI note number.
        public var number: MIDI.UInt7 = 0
        
        public init() { }
        
        /// Construct from a MIDI note number.
        @_disfavoredOverload
        public init<T: BinaryInteger>(_ number: T) throws {
            
            guard let uint7 = MIDI.UInt7(exactly: number) else {
                throw NoteError.outOfBounds
            }
            self.number = uint7
            
        }
        
        /// Construct from a MIDI note number.
        public init(_ number: MIDI.UInt7) {
            
            self.number = number
            
        }
        
        /// Construct from a note `Name` and octave.
        public init(_ name: Name, octave: Int) throws {
            
            try setNoteNumber(name, octave: octave)
            
        }
        
        /// Construct from a MIDI note name string.
        public init(_ string: String) throws {
            
            try setNoteNumber(from: string)
            
        }
        
        /// Construct from a frequency in Hz and round to the nearest MIDI note.
        /// Sets the nearest note number to the frequency.
        public init(frequency: Double) throws {
            
            try setNoteNumber(frequency: frequency)
            
        }
        
        /// Set note number from note name and octave.
        public mutating func setNoteNumber(_ source: Name,
                                           octave: Int) throws {
            
            let noteNum = ((octave + 2) * 12) + source.scaleOffset
            
            guard let uInt7 = MIDI.UInt7(exactly: noteNum) else {
                throw NoteError.outOfBounds
            }
            
            number = uInt7
            
        }
        
        /// Set note number from a MIDI note name string.
        public mutating func setNoteNumber(from source: String) throws {
            
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
            
            let cs = [MIDI.Note.Name.sharpAccidental,
                      MIDI.Note.Name.sharpAccidentalUnicode,
                      MIDI.Note.Name.flatAccidental,
                      MIDI.Note.Name.flatAccidentalUnicode]
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
                    source.index(source.startIndex,
                                 offsetBy: noteString.count)...
                ]
            )
            
            // must convert string to int
            guard let octave = Int(octaveString) else {
                throw NoteError.outOfBounds
            }
            
            // must be within range
            guard -2 ... 8 ~= octave else {
                throw NoteError.outOfBounds
            }
            
            try setNoteNumber(noteName, octave: octave)
            
        }
        
        /// Sets the nearest note number to the frequency in Hz.
        public mutating func setNoteNumber(frequency: Double,
                                           tuning: Double = 440.0) throws {
            
            let noteNum = Self.calculateMIDINoteNumber(
                frequency: frequency,
                tuning: tuning
            )
            
            guard let uInt7 = MIDI.UInt7(exactly: noteNum) else {
                throw NoteError.outOfBounds
            }
            
            number = uInt7
            
        }
        
        /// Get the MIDI note name enum case.
        public var name: Name {
            
            Name.convert(noteNumber: number).name
            
        }
        
        /// Get the MIDI note name enum case.
        public var octave: Int {
            
            Name.convert(noteNumber: number).octave
            
        }
        
        /// Get the MIDI note name string (ie: "A-2" "C#6")
        ///
        /// - Parameters:
        ///   - respellSharpAsFlat: If note is sharp, respell enharmonically as a flat (ie: G♯ becomes A♭). Otherwise, sharp is always used, which is typical convention for MIDI note names.
        ///   - unicodeAccidental: Use stylized unicode character for sharp (♯) and flat (♭).
        ///
        /// - Returns: MIDI note name string.
        public func stringValue(
            respellSharpAsFlat: Bool = false,
            unicodeAccidental: Bool = false
        ) -> String {
            
            let divided = number.intValue
                .quotientAndRemainder(dividingBy: 12)
            let octave = divided.quotient - 2
            let scaleOffset = divided.remainder
            
            let findNoteName = Name.allCases
                .first(where: { $0.scaleOffset == scaleOffset })
            
            let noteName = findNoteName?.stringValue(respellSharpAsFlat: respellSharpAsFlat,
                                                     unicodeAccidental: unicodeAccidental)
            ?? "?"
            
            return "\(noteName)\(octave)"
            
        }
        
        /// Get MIDI note frequency in Hz, based on tuning.
        public func frequencyValue(tuning: Double = 440.0) -> Double {
            
            Self.calculateFrequency(midiNote: number.intValue,
                                    tuning: tuning)
            
        }
    }
    
}

extension MIDI.Note: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        
        stringValue(unicodeAccidental: true)
        
    }
    
    public var debugDescription: String {
        
        "Note(\(stringValue(unicodeAccidental: true)) number:\(number))"
        
    }
    
}

extension MIDI.Note: Comparable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.number == rhs.number
        
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        
        lhs.number < rhs.number
        
    }
    
}

extension MIDI.Note: Strideable {
    
    public typealias Stride = Int
    
    public func distance(to other: Self) -> Int {
        
        other.number.intValue - number.intValue
        
    }
    
    public func advanced(by n: Int) -> Self {
        
        let clamped = MIDI.UInt7(clamping: number.intValue + n)
        
        return Self(clamped)
        
    }
    
}

public extension MIDI.Note {
    
    /// Returns an array of all 128 MIDI notes.
    static let allNotes: [Self] = MIDI.NoteRange.all.map { $0 }
    
}

extension MIDI.Note {
    
    /// Utility method that returns frequency in Hz calculated from a MIDI note number.
    /// - parameter midiNote: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    public static func calculateFrequency(midiNote: Int,
                                          tuning: Double = 440.0) -> Double {
        
        pow(2.0, (Double(midiNote) - 69.0) / 12.0) * tuning
        
    }
    
    /// Utility method that returns a MIDI note number calculated from frequency in Hz.
    /// Note: Results may be out-of-bounds (outside of 0...127)
    /// - parameter frequency: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    public static func calculateMIDINoteNumber(frequency: Double,
                                               tuning: Double = 440.0) -> Int {
        
        Int(round(12.0 * log2(frequency / tuning) + 69.0))
        
    }
    
}

// MARK: - API Transition (release 0.5.0)

extension MIDI.Note {
    
    /// Utility method that returns frequency in Hz calculated from a MIDI note number.
    /// - parameter ofMIDINote: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    @available(*, unavailable, renamed: "calculateFrequency(midiNote:tuning:)")
    public static func calculateFrequency(ofMIDINote: Int,
                                          tuning: Double = 440.0) -> Double {
        
        Self.calculateFrequency(midiNote: ofMIDINote,
                                tuning: tuning)
        
    }
    
    /// Utility method that returns a MIDI note number calculated from frequency in Hz.
    /// Note: Results may be out-of-bounds (outside of 0...127)
    /// - parameter ofFrequency: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    @available(*, unavailable, renamed: "calculateMIDINoteNumber(frequency:tuning:)")
    public static func calculateMIDINoteNumber(ofFrequency: Double,
                                               tuning: Double = 440.0) -> Int {
        
        Self.calculateMIDINoteNumber(frequency: ofFrequency,
                                     tuning: tuning)
        
    }
    
}
