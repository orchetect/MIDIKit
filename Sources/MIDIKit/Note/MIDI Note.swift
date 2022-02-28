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
        
        /// Tuning in Hertz, for use with frequency conversion
        public var tuning: Double = 440.0
        
        public init() { }
        
        /// Construct from a MIDI note number.
        /// Returns `nil` if note number is invalid.
        public init?<T: BinaryInteger>(_ number: T) {
            
            guard let uint7 = MIDI.UInt7(exactly: number) else { return nil }
            self.number = uint7
            
        }
        
        /// Construct from a MIDI note number.
        public init(_ number: MIDI.UInt7) {
            
            self.number = number
            
        }
        
        /// Construct from a note `Name` and octave.
        /// Returns `nil` if note and octave pair is invalid.
        public init?(_ name: Name, octave: Int) {
            
            if !setNoteNumber(name, octave: octave) { return nil }
            
        }
        
        /// Construct from a MIDI note name string.
        /// Returns `nil` if the string cannot be parsed.
        public init?(_ string: String) {
            
            if !setNoteNumber(from: string) { return nil }
            
        }
        
        /// Construct from a frequency in Hz and round to the nearest MIDI note.
        /// Sets the nearest note number to the frequency.
        /// Returns `nil` if resulting note number is invalid.
        public init?(frequency: Double) {
            
            if !setNoteNumber(frequency: frequency) { return nil }
            
        }
        
        /// Set note number from note name and octave.
        /// Returns `false` if note and octave pair is invalid.
        @discardableResult
        public mutating func setNoteNumber(_ source: Name,
                                           octave: Int) -> Bool {
            
            let noteNum = ((octave + 2) * 12) + source.scaleOffset
            
            guard let uint7 = MIDI.UInt7(exactly: noteNum) else { return false }
            
            number = uint7
            
            return true
            
        }
        
        /// Set note number from a MIDI note name string.
        /// Returns `false` if the string cannot be parsed.
        @discardableResult
        public mutating func setNoteNumber(from source: String) -> Bool {
            
            var noteString = ""
            
            let testCharSet = CharacterSet(charactersIn: "ABCDEFG")
            guard let rngNote = source.rangeOfCharacter(
                from: testCharSet,
                options: [],
                range: source.startIndex ..< source.index(after: source.startIndex)
            )
            else { return false }
            
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
            
            guard let noteName = Name(noteString) else { return false }
            
            let octaveString = String(
                source[
                    source.index(source.startIndex,
                                 offsetBy: noteString.count)...
                ]
            )
            
            // must convert string to int
            guard let octave = Int(octaveString) else { return false }
            
            // must be within range
            guard -2 ... 8 ~= octave else { return false }
            
            return setNoteNumber(noteName, octave: octave)
            
        }
        
        
        /// Sets the nearest note number to the frequency in Hz.
        /// Returns `nil` if resulting note number is invalid.
        @discardableResult
        public mutating func setNoteNumber(frequency: Double,
                                           tuning: Double? = nil) -> Bool {
            
            let tuningHz = tuning ?? self.tuning
            
            let noteNum = Self.calculateMIDINoteNumber(
                ofFrequency: frequency,
                tuning: tuningHz
            )
            
            guard let uint7 = MIDI.UInt7(exactly: noteNum) else { return false }
            
            number = uint7
            
            return true
            
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
        
        /// Get or set MIDI note frequency in Hz, based on `.tuning` property.
        public var frequencyValue: Double {
            
            get {
                Self.calculateFrequency(ofMIDINote: number.intValue,
                                        tuning: tuning)
            }
            set {
                setNoteNumber(frequency: newValue,
                              tuning: tuning)
            }
            
        }
        
        /// Get MIDI note frequency in Hz, based on an arbitrary tuning (ignoring `.tuning` property).
        /// Does not set `tuning` property.
        public func frequencyValue(tuning: Double) -> Double {
            
            Self.calculateFrequency(ofMIDINote: number.intValue,
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
        
        let val = (number.intValue + n)
            .clamped(to:
                         MIDI.NoteNumberRange.all.lowerBound.intValue
                     ... MIDI.NoteNumberRange.all.upperBound.intValue
            )
        
        return Self(val) ?? .init()
        
    }
    
}

public extension MIDI.Note {
    
    /// Returns an array of all 128 MIDI notes.
    static let allNotes: [Self] = MIDI.NoteRange.all.map { $0 }
    
}

extension MIDI.Note {
    
    /// Internal: Returns frequency in Hz calculated from a MIDI note number.
    /// - parameter ofMIDINote: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    public static func calculateFrequency(ofMIDINote: Int,
                                          tuning: Double = 440.0) -> Double {
        
        pow(2.0, (Double(ofMIDINote) - 69.0) / 12.0) * tuning
        
    }
    
    /// Internal: Returns a MIDI note number calculated from frequency in Hz.
    /// Note: Results may be out-of-bounds (outside of 0...127)
    /// - parameter ofMIDINote: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    private static func calculateMIDINoteNumber(ofFrequency: Double,
                                                tuning: Double = 440.0) -> Int {
        
        Int(round(12.0 * log2(ofFrequency / tuning) + 69.0))
        
    }
    
}
