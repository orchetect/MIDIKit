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
    struct Note {
        
        // MARK: - Constants
        
        /// Constant: lowest possible note number
        public static let lowestNote: UInt8 = 0x00
        
        /// Constant: highest possible note number
        public static let highestNote: UInt8 = 0x7F
        
        /// MIDI note number.
        public var number: MIDI.UInt7 = 0
        
        /// Tuning in Hertz, for use with frequency conversion
        public var tuning: Double = 440.0
        
        public init() {}
        
        /// Construct from a MIDI note number.
        public init?(number: Int) {
            guard let uint7 = MIDI.UInt7(exactly: number) else { return nil }
            self.number = uint7
        }
        
        /// Construct from a MIDI note number.
        public init(number: MIDI.UInt7) {
            self.number = number
        }
        
        /// Construct from a MIDI note number.
        /// Invalid value returns nil.
        public init?(number: UInt8) {
            guard let uint7 = MIDI.UInt7(exactly: number) else { return nil }
            self.number = uint7
        }
        
        /// Construct from a note `Name` and octave.
        /// Invalid values returns nil.
        public init?(_ name: Name, octave: Int) {
            if !setNoteNumber(from: name, octave: octave) { return nil }
        }
        
        /// Construct from a MIDI note name string.
        /// If the string cannot be parsed, nil is returned.
        public init?(string: String) {
            if !setNoteNumber(from: string) { return nil }
        }
        
        /// Construct from a frequency in Hz and round to the nearest MIDI note.
        /// Sets the nearest note number to the frequency.
        /// If resulting note number is invalid, nil is returned.
        public init?(frequency: Double) {
            if !setNoteNumber(fromFrequency: frequency) { return nil }
        }
        
        @discardableResult
        public mutating func setNoteNumber(from source: Name,
                                           octave: Int) -> Bool
        {
            let rootValue = 0
            
            let noteNum = rootValue + ((octave + 2) * 12) + source.scaleOffset
            
            guard let uint7 = MIDI.UInt7(exactly: noteNum) else { return false }
            
            number = uint7
            
            return true
        }
        
        /// Set note number from a MIDI note name string.
        @discardableResult
        public mutating func setNoteNumber(from source: String) -> Bool {
            var noteString = ""
            var noteName: Name?
            
            let testCharSet = CharacterSet(charactersIn: "ABCDEFG")
            guard let rngNote = source.rangeOfCharacter(
                from: testCharSet,
                options: [],
                range: source.startIndex ..< source.index(after: source.startIndex)
            )
            else { return false }
            
            // test for # Sharp
            if let rngSharp = source.rangeOfCharacter(from: CharacterSet(charactersIn: "#")) {
                noteString = String(source[rngNote.lowerBound ... rngSharp.lowerBound])
            } else {
                noteString = String(source[rngNote])
            }
            
            Name.allCases.forEach {
                if $0.rawValue == noteString { noteName = $0 }
            }
            
            guard let noteName = noteName else { return false }
            
            let octaveString = String(source[source.index(source.startIndex, offsetBy: noteString.count)...])
            
            // must convert string to int
            guard let octave = Int(octaveString) else { return false }
            
            // must be within range
            guard -2 ... 8 ~= octave else { return false }
            
            return setNoteNumber(from: noteName, octave: octave)
        }
        
        /// Sets the nearest note number to the frequency
        @discardableResult
        public mutating func setNoteNumber(fromFrequency: Double,
                                           tuning: Double? = nil) -> Bool
        {
            let tuningHz = tuning ?? self.tuning
            
            let noteNum = Self.calculateMIDINoteNumber(
                ofFrequency: fromFrequency,
                tuning: tuningHz
            )
            
            guard let uint7 = MIDI.UInt7(exactly: noteNum) else { return false }
            
            number = uint7
            
            return true
        }
        
        /// Get or set MIDI note name string (ie: "A-2" "C#6").
        /// Case insensitive.
        public var stringValue: String {
            get {
                let divided = Int(number)
                    .quotientAndRemainder(dividingBy: 12)
                let octave = divided.quotient - 2
                let scaleOffset = divided.remainder
                
                let findNoteName = Name.allCases
                    .first(where: { $0.scaleOffset == scaleOffset })
                
                let noteName = findNoteName?.rawValue ?? ""
                
                return "\(noteName)\(octave)"
            }
            set {
                setNoteNumber(from: newValue)
            }
        }
        
        /// Get or set MIDI note frequency in Hz, based on `.tuning` property.
        public var frequencyValue: Double {
            get {
                Self.calculateFrequency(ofMIDINote: Int(number),
                                        tuning: tuning)
            }
            set {
                setNoteNumber(fromFrequency: newValue,
                              tuning: tuning)
            }
        }
        
        /// Get MIDI note frequency in Hz, based on an arbitrary tuning (ignoring `.tuning` property).
        /// Does not set `tuning` property.
        public func frequencyValue(tuning: Double) -> Double {
            Self.calculateFrequency(ofMIDINote: Int(number),
                                    tuning: tuning)
        }
    }
    
}

extension MIDI.Note: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        stringValue
    }
    
    public var debugDescription: String {
        "Note(\(stringValue) number:\(number))"
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
        Int(other.number - number)
    }
    
    public func advanced(by n: Int) -> Self {
        let val = (Int(number) + n)
            .clamped(to: Int(Self.lowestNote) ... Int(Self.highestNote))
        
        return Self(number: UInt8(val)) ?? .init()
    }
    
}

public extension MIDI.Note {
    
    /// Returns an array of all 128 MIDI notes
    static var allNotes: [Self] = {
        (lowestNote ... highestNote)
            .compactMap { Self(number: $0) }
    }()
    
}

extension MIDI.Note {
    
    /// Internal: Returns frequency in Hz calculated from a MIDI note number.
    /// - parameter ofMIDINote: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    public static func calculateFrequency(ofMIDINote: Int,
                                          tuning: Double = 440.0) -> Double
    {
        pow(2.0, (Double(ofMIDINote) - 69.0) / 12.0) * tuning
    }
    
    /// Internal: Returns a MIDI note number calculated from frequency in Hz.
    /// Note: Results may be out-of-bounds (outside of 0...127)
    /// - parameter ofMIDINote: MIDI note number
    /// - parameter tuning: Tuning in Hertz
    private static func calculateMIDINoteNumber(ofFrequency: Double,
                                                tuning: Double = 440.0) -> Int
    {
        Int(round(12.0 * log2(ofFrequency / tuning) + 69.0))
    }
    
}
