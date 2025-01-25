//
//  MIDINote Roland Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDINote_Roland_Tests {
    private let style: MIDINote.Style = .roland
    
    @Test
    func InitDefaults() {
        // ensure nominal defaults
        
        let note = MIDINote(0, style: style)
        
        #expect(note.number == 0)
        #expect(note.style == .roland)
        #expect(note.frequencyValue() == 8.175798915643707)
        #expect(note.stringValue() == "C-1")
    }
    
    @Test
    func InitNumber() throws {
        // test all common BinaryInteger inits, except UInt7
        
        #expect(try MIDINote(Int(0x60), style: style).number == 0x60)
        #expect(try MIDINote(UInt(0x60), style: style).number == 0x60)
        #expect(try MIDINote(Int8(0x60), style: style).number == 0x60)
        #expect(try MIDINote(UInt8(0x60), style: style).number == 0x60)
        #expect(try MIDINote(Int16(0x60), style: style).number == 0x60)
        #expect(try MIDINote(UInt16(0x60), style: style).number == 0x60)
        #expect(try MIDINote(Int32(0x60), style: style).number == 0x60)
        #expect(try MIDINote(UInt32(0x60), style: style).number == 0x60)
        #expect(try MIDINote(Int64(0x60), style: style).number == 0x60)
        #expect(try MIDINote(UInt64(0x60), style: style).number == 0x60)
    }
    
    @Test
    func Frequency() throws {
        // test conversion:
        // note number -> frequency -> note number
        
        for noteNum in 0 ... 127 {
            let freq = try MIDINote(noteNum, style: style).frequencyValue()
            
            // check rounding
            let num = try MIDINote(frequency: freq, style: style).number.intValue
            
            #expect(num == noteNum, "Note number conversion failed for frequency \(noteNum)Hz")
        }
    }
    
    @Test
    func AllNotes() {
        let getAllNotes = MIDINote.allNotes(style: style)
        
        #expect(getAllNotes.count == 128)
        
        // spot check
        
        #expect(getAllNotes[0].number == 0)
        #expect(getAllNotes[0].frequencyValue() == 8.175798915643707)
        #expect(getAllNotes[0].stringValue() == "C-1")
        
        #expect(getAllNotes[58].stringValue() == "A#3")
        #expect(getAllNotes[59].stringValue() == "B3")
        #expect(getAllNotes[60].stringValue() == "C4") // middle C
        #expect(getAllNotes[61].stringValue() == "C#4")
        
        #expect(getAllNotes[127].number == 127)
        #expect(getAllNotes[127].frequencyValue() == 12543.853951415975)
        #expect(getAllNotes[127].stringValue() == "G9")
    }
    
    @Test
    func StringValue() {
        // don't respell A♮
        #expect(MIDINote(57, style: style).stringValue() == "A3")
        #expect(MIDINote(57, style: style).stringValue(respellSharpAsFlat: true) == "A3")
        #expect(MIDINote(57, style: style).stringValue(unicodeAccidental: true) == "A3")
        #expect(MIDINote(57, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "A3")
        
        // respelling and unicode accidental
        #expect(MIDINote(58, style: style).stringValue() == "A#3")
        #expect(MIDINote(58, style: style).stringValue(respellSharpAsFlat: true) == "Bb3")
        #expect(MIDINote(58, style: style).stringValue(unicodeAccidental: true) == "A♯3")
        #expect(MIDINote(58, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "B♭3")
        
        // don't respell B♮
        #expect(MIDINote(59, style: style).stringValue() == "B3")
        #expect(MIDINote(59, style: style).stringValue(respellSharpAsFlat: true) == "B3")
        #expect(MIDINote(59, style: style).stringValue(unicodeAccidental: true) == "B3")
        #expect(MIDINote(59, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "B3")
        
        // don't respell C♮
        #expect(MIDINote(60, style: style).stringValue() == "C4")
        #expect(MIDINote(60, style: style).stringValue(respellSharpAsFlat: true) == "C4")
        #expect(MIDINote(60, style: style).stringValue(unicodeAccidental: true) == "C4")
        #expect(MIDINote(60, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "C4")
        
        // respelling and unicode accidental
        #expect(MIDINote(61, style: style).stringValue() == "C#4")
        #expect(MIDINote(61, style: style).stringValue(respellSharpAsFlat: true) == "Db4")
        #expect(MIDINote(61, style: style).stringValue(unicodeAccidental: true) == "C♯4")
        #expect(MIDINote(61, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "D♭4")
        
        // don't respell D♮
        #expect(MIDINote(62, style: style).stringValue() == "D4")
        #expect(MIDINote(62, style: style).stringValue(respellSharpAsFlat: true) == "D4")
        #expect(MIDINote(62, style: style).stringValue(unicodeAccidental: true) == "D4")
        #expect(MIDINote(62, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "D4")
        
        // respelling and unicode accidental
        #expect(MIDINote(63, style: style).stringValue() == "D#4")
        #expect(MIDINote(63, style: style).stringValue(respellSharpAsFlat: true) == "Eb4")
        #expect(MIDINote(63, style: style).stringValue(unicodeAccidental: true) == "D♯4")
        #expect(MIDINote(63, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "E♭4")
        
        // don't respell E♮
        #expect(MIDINote(64, style: style).stringValue() == "E4")
        #expect(MIDINote(64, style: style).stringValue(respellSharpAsFlat: true) == "E4")
        #expect(MIDINote(64, style: style).stringValue(unicodeAccidental: true) == "E4")
        #expect(MIDINote(64, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "E4")
        
        // don't respell F♮
        #expect(MIDINote(65, style: style).stringValue() == "F4")
        #expect(MIDINote(65, style: style).stringValue(respellSharpAsFlat: true) == "F4")
        #expect(MIDINote(65, style: style).stringValue(unicodeAccidental: true) == "F4")
        #expect(MIDINote(65, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "F4")
        
        // respelling and unicode accidental
        #expect(MIDINote(66, style: style).stringValue() == "F#4")
        #expect(MIDINote(66, style: style).stringValue(respellSharpAsFlat: true) == "Gb4")
        #expect(MIDINote(66, style: style).stringValue(unicodeAccidental: true) == "F♯4")
        #expect(MIDINote(66, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "G♭4")
        
        // don't respell G♮
        #expect(MIDINote(67, style: style).stringValue() == "G4")
        #expect(MIDINote(67, style: style).stringValue(respellSharpAsFlat: true) == "G4")
        #expect(MIDINote(67, style: style).stringValue(unicodeAccidental: true) == "G4")
        #expect(MIDINote(67, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "G4")
        
        // respelling and unicode accidental
        #expect(MIDINote(68, style: style).stringValue() == "G#4")
        #expect(MIDINote(68, style: style).stringValue(respellSharpAsFlat: true) == "Ab4")
        #expect(MIDINote(68, style: style).stringValue(unicodeAccidental: true) == "G♯4")
        #expect(MIDINote(68, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "A♭4")
    }
    
    @Test
    func NoteInit_String() throws {
        // spot check
        
        #expect(throws: (any Error).self) { try MIDINote("B-2", style: style).number } // out of bounds
        #expect(try MIDINote("C-1", style: style).number == 0)
        
        #expect(try MIDINote("A#3", style: style).number == 58)
        #expect(try MIDINote("Bb3", style: style).number == 58)
        #expect(try MIDINote("B3", style: style).number == 59)
        #expect(try MIDINote("C4", style: style).number == 60)
        #expect(try MIDINote("C#4", style: style).number == 61)
        
        #expect(try MIDINote("G9", style: style).number == 127)
        #expect(throws: (any Error).self) { try MIDINote("G#9", style: style).number } // out of bounds
        
        // alternate accidental symbols
        
        #expect(try MIDINote("Ab3", style: style).number == 56)
        #expect(try MIDINote("A♭3", style: style).number == 56)
        
        #expect(try MIDINote("A♯3", style: style).number == 58)
        #expect(try MIDINote("B♭3", style: style).number == 58)
        
        #expect(throws: (any Error).self) {
            try MIDINote("B♯3", style: style) // don't allow C across different octave
        }
        #expect(throws: (any Error).self) {
            try MIDINote("C♭4", style: style) // don't allow B across different octave
        }
        
        #expect(try MIDINote("C♯4", style: style).number == 61)
        #expect(try MIDINote("D♭4", style: style).number == 61)
        
        #expect(try MIDINote("D♯4", style: style).number == 63)
        #expect(try MIDINote("E♭4", style: style).number == 63)
        
        #expect(try MIDINote("E♯4", style: style).number == 65) // F♮
        #expect(try MIDINote("F♭4", style: style).number == 64) // E♮
        
        #expect(try MIDINote("F♯4", style: style).number == 66)
        #expect(try MIDINote("G♭4", style: style).number == 66)
        
        #expect(try MIDINote("G♯4", style: style).number == 68)
        #expect(try MIDINote("A♭4", style: style).number == 68)
    }
    
    @Test
    func NoteInit_NameAndOctave() throws {
        // spot check
        
        #expect(try MIDINote(.C, octave: -1, style: style).number == 0)
        
        #expect(try MIDINote(.A_sharp, octave: 3, style: style).number == 58)
        #expect(try MIDINote(.B, octave: 3, style: style).number == 59)
        #expect(try MIDINote(.C, octave: 4, style: style).number == 60)
        #expect(try MIDINote(.C_sharp, octave: 4, style: style).number == 61)
        
        #expect(try MIDINote(.G, octave: 9, style: style).number == 127)
        
        // edge cases
        
        #expect(throws: (any Error).self) { try MIDINote(.B, octave: -2, style: style).number }
        #expect(throws: (any Error).self) { try MIDINote(.G_sharp, octave: 9, style: style).number }
    }
    
    @Test
    func NoteName() {
        #expect(MIDINote(0, style: style).name == .C)
        #expect(MIDINote(0, style: style).octave == -1)
        
        #expect(MIDINote(59, style: style).name == .B)
        #expect(MIDINote(59, style: style).octave == 3)
        
        #expect(MIDINote(60, style: style).name == .C)
        #expect(MIDINote(60, style: style).octave == 4)
        
        #expect(MIDINote(127, style: style).name == .G)
        #expect(MIDINote(127, style: style).octave == 9)
    }
    
    @Test
    func PianoKeyType_WhiteKeys() throws {
        // generate white keys
        
        let whiteKeyNames = ["C", "D", "E", "F", "G", "A", "B"]
        let whiteKeyNamesTopOctave = ["C", "D", "E", "F", "G"]
        
        let whiteKeyNoteNames = ((-1) ... 8)
            .flatMap { octave in
                whiteKeyNames.map { "\($0)\(octave)" }
            }
            + whiteKeyNamesTopOctave.map { "\($0)9" }
        
        let whiteKeyNotes: [MIDINote] = try whiteKeyNoteNames
            .map { try MIDINote($0, style: style) }
        
        // test white keys
        
        #expect(whiteKeyNotes.count == 75)
        #expect(whiteKeyNotes.allSatisfy { !$0.isSharp })
    }
    
    @Test
    func PianoKeyType_BlackKeys() throws {
        // generate black keys
        
        let blackKeyNames = ["C#", "D#", "F#", "G#", "A#"]
        let blackKeyNamesTopOctave = ["C#", "D#", "F#"]
        
        let blackKeyNoteNames = ((-1) ... 8)
            .flatMap { octave in
                blackKeyNames.map { "\($0)\(octave)" }
            }
            + blackKeyNamesTopOctave.map { "\($0)9" }
        
        let blackKeyNotes: [MIDINote] = try blackKeyNoteNames
            .map { try MIDINote($0, style: style) }
        
        // test black keys
        
        #expect(blackKeyNotes.count == 53)
        #expect(blackKeyNotes.allSatisfy { $0.isSharp })
    }
}
