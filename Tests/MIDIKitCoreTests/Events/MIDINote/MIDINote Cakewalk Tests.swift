//
//  MIDINote Cakewalk Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDINote_Cakewalk_Tests {
    private let style: MIDINote.Style = .cakewalk
    
    @Test
    func initDefaults() {
        // ensure nominal defaults
        
        let note = MIDINote(0, style: style)
        
        #expect(note.number == 0)
        #expect(note.style == .cakewalk)
        #expect(note.frequencyValue() == 8.175798915643707)
        #expect(note.stringValue() == "C0")
    }
    
    @Test
    func initNumber() throws {
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
    func frequency() throws {
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
    func allNotes() {
        let getAllNotes = MIDINote.allNotes(style: style)
        
        #expect(getAllNotes.count == 128)
        
        // spot check
        
        #expect(getAllNotes[0].number == 0)
        #expect(getAllNotes[0].frequencyValue() == 8.175798915643707)
        #expect(getAllNotes[0].stringValue() == "C0")
        
        #expect(getAllNotes[58].stringValue() == "A#4")
        #expect(getAllNotes[59].stringValue() == "B4")
        #expect(getAllNotes[60].stringValue() == "C5") // middle C
        #expect(getAllNotes[61].stringValue() == "C#5")
        
        #expect(getAllNotes[127].number == 127)
        #expect(getAllNotes[127].frequencyValue() == 12543.853951415975)
        #expect(getAllNotes[127].stringValue() == "G10")
    }
    
    @Test
    func stringValue() {
        // don't respell A♮
        #expect(MIDINote(57, style: style).stringValue() == "A4")
        #expect(MIDINote(57, style: style).stringValue(respellSharpAsFlat: true) == "A4")
        #expect(MIDINote(57, style: style).stringValue(unicodeAccidental: true) == "A4")
        #expect(MIDINote(57, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "A4")
        
        // respelling and unicode accidental
        #expect(MIDINote(58, style: style).stringValue() == "A#4")
        #expect(MIDINote(58, style: style).stringValue(respellSharpAsFlat: true) == "Bb4")
        #expect(MIDINote(58, style: style).stringValue(unicodeAccidental: true) == "A♯4")
        #expect(MIDINote(58, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "B♭4")
        
        // don't respell B♮
        #expect(MIDINote(59, style: style).stringValue() == "B4")
        #expect(MIDINote(59, style: style).stringValue(respellSharpAsFlat: true) == "B4")
        #expect(MIDINote(59, style: style).stringValue(unicodeAccidental: true) == "B4")
        #expect(MIDINote(59, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "B4")
        
        // don't respell C♮
        #expect(MIDINote(60, style: style).stringValue() == "C5")
        #expect(MIDINote(60, style: style).stringValue(respellSharpAsFlat: true) == "C5")
        #expect(MIDINote(60, style: style).stringValue(unicodeAccidental: true) == "C5")
        #expect(MIDINote(60, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "C5")
        
        // respelling and unicode accidental
        #expect(MIDINote(61, style: style).stringValue() == "C#5")
        #expect(MIDINote(61, style: style).stringValue(respellSharpAsFlat: true) == "Db5")
        #expect(MIDINote(61, style: style).stringValue(unicodeAccidental: true) == "C♯5")
        #expect(MIDINote(61, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "D♭5")
        
        // don't respell D♮
        #expect(MIDINote(62, style: style).stringValue() == "D5")
        #expect(MIDINote(62, style: style).stringValue(respellSharpAsFlat: true) == "D5")
        #expect(MIDINote(62, style: style).stringValue(unicodeAccidental: true) == "D5")
        #expect(MIDINote(62, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "D5")
        
        // respelling and unicode accidental
        #expect(MIDINote(63, style: style).stringValue() == "D#5")
        #expect(MIDINote(63, style: style).stringValue(respellSharpAsFlat: true) == "Eb5")
        #expect(MIDINote(63, style: style).stringValue(unicodeAccidental: true) == "D♯5")
        #expect(MIDINote(63, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "E♭5")
        
        // don't respell E♮
        #expect(MIDINote(64, style: style).stringValue() == "E5")
        #expect(MIDINote(64, style: style).stringValue(respellSharpAsFlat: true) == "E5")
        #expect(MIDINote(64, style: style).stringValue(unicodeAccidental: true) == "E5")
        #expect(MIDINote(64, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "E5")
        
        // don't respell F♮
        #expect(MIDINote(65, style: style).stringValue() == "F5")
        #expect(MIDINote(65, style: style).stringValue(respellSharpAsFlat: true) == "F5")
        #expect(MIDINote(65, style: style).stringValue(unicodeAccidental: true) == "F5")
        #expect(MIDINote(65, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "F5")
        
        // respelling and unicode accidental
        #expect(MIDINote(66, style: style).stringValue() == "F#5")
        #expect(MIDINote(66, style: style).stringValue(respellSharpAsFlat: true) == "Gb5")
        #expect(MIDINote(66, style: style).stringValue(unicodeAccidental: true) == "F♯5")
        #expect(MIDINote(66, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "G♭5")
        
        // don't respell G♮
        #expect(MIDINote(67, style: style).stringValue() == "G5")
        #expect(MIDINote(67, style: style).stringValue(respellSharpAsFlat: true) == "G5")
        #expect(MIDINote(67, style: style).stringValue(unicodeAccidental: true) == "G5")
        #expect(MIDINote(67, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "G5")
        
        // respelling and unicode accidental
        #expect(MIDINote(68, style: style).stringValue() == "G#5")
        #expect(MIDINote(68, style: style).stringValue(respellSharpAsFlat: true) == "Ab5")
        #expect(MIDINote(68, style: style).stringValue(unicodeAccidental: true) == "G♯5")
        #expect(MIDINote(68, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "A♭5")
    }
    
    @Test
    func noteInit_String() throws {
        // spot check
        
        #expect(throws: (any Error).self) { try MIDINote("B-1", style: style).number } // out of bounds
        #expect(try MIDINote("C0", style: style).number == 0)
        
        #expect(try MIDINote("A#4", style: style).number == 58)
        #expect(try MIDINote("Bb4", style: style).number == 58)
        #expect(try MIDINote("B4", style: style).number == 59)
        #expect(try MIDINote("C5", style: style).number == 60)
        #expect(try MIDINote("C#5", style: style).number == 61)
        
        #expect(try MIDINote("G10", style: style).number == 127)
        #expect(throws: (any Error).self) { try MIDINote("G#10", style: style).number } // out of bounds
        
        // alternate accidental symbols
        
        #expect(try MIDINote("Ab4", style: style).number == 56)
        #expect(try MIDINote("A♭4", style: style).number == 56)
        
        #expect(try MIDINote("A♯4", style: style).number == 58)
        #expect(try MIDINote("B♭4", style: style).number == 58)
        
        #expect(throws: (any Error).self) {
            try MIDINote("B♯4", style: style) // don't allow C across different octave
        }
        #expect(throws: (any Error).self) {
            try MIDINote("C♭4", style: style) // don't allow B across different octave
        }
        
        #expect(try MIDINote("C♯5", style: style).number == 61)
        #expect(try MIDINote("D♭5", style: style).number == 61)
        
        #expect(try MIDINote("D♯5", style: style).number == 63)
        #expect(try MIDINote("E♭5", style: style).number == 63)
        
        #expect(try MIDINote("E♯5", style: style).number == 65) // F♮
        #expect(try MIDINote("F♭5", style: style).number == 64) // E♮
        
        #expect(try MIDINote("F♯5", style: style).number == 66)
        #expect(try MIDINote("G♭5", style: style).number == 66)
        
        #expect(try MIDINote("G♯5", style: style).number == 68)
        #expect(try MIDINote("A♭5", style: style).number == 68)
    }
    
    @Test
    func noteInit_NameAndOctave() throws {
        // spot check
        
        #expect(try MIDINote(.C, octave: 0, style: style).number == 0)
        
        #expect(try MIDINote(.A_sharp, octave: 4, style: style).number == 58)
        #expect(try MIDINote(.B, octave: 4, style: style).number == 59)
        #expect(try MIDINote(.C, octave: 5, style: style).number == 60)
        #expect(try MIDINote(.C_sharp, octave: 5, style: style).number == 61)
        
        #expect(try MIDINote(.G, octave: 10, style: style).number == 127)
        
        // edge cases
        
        #expect(throws: (any Error).self) { try MIDINote(.B, octave: -1, style: style).number }
        #expect(throws: (any Error).self) { try MIDINote(.G_sharp, octave: 10, style: style).number }
    }
    
    @Test
    func noteName() {
        #expect(MIDINote(0, style: style).name == .C)
        #expect(MIDINote(0, style: style).octave == 0)
        
        #expect(MIDINote(59, style: style).name == .B)
        #expect(MIDINote(59, style: style).octave == 4)
        
        #expect(MIDINote(60, style: style).name == .C)
        #expect(MIDINote(60, style: style).octave == 5)
        
        #expect(MIDINote(127, style: style).name == .G)
        #expect(MIDINote(127, style: style).octave == 10)
    }
    
    @Test
    func pianoKeyType_WhiteKeys() throws {
        // generate white keys
        
        let whiteKeyNames = ["C", "D", "E", "F", "G", "A", "B"]
        let whiteKeyNamesTopOctave = ["C", "D", "E", "F", "G"]
        
        let whiteKeyNoteNames = (0 ... 9)
            .flatMap { octave in
                whiteKeyNames.map { "\($0)\(octave)" }
            }
            + whiteKeyNamesTopOctave.map { "\($0)10" }
        
        let whiteKeyNotes: [MIDINote] = try whiteKeyNoteNames
            .map { try MIDINote($0, style: style) }
        
        // test white keys
        
        #expect(whiteKeyNotes.count == 75)
        #expect(whiteKeyNotes.allSatisfy { !$0.isSharp })
    }
    
    @Test
    func pianoKeyType_BlackKeys() throws {
        // generate black keys
        
        let blackKeyNames = ["C#", "D#", "F#", "G#", "A#"]
        let blackKeyNamesTopOctave = ["C#", "D#", "F#"]
        
        let blackKeyNoteNames = (0 ... 9)
            .flatMap { octave in
                blackKeyNames.map { "\($0)\(octave)" }
            }
            + blackKeyNamesTopOctave.map { "\($0)10" }
        
        let blackKeyNotes: [MIDINote] = try blackKeyNoteNames
            .map { try MIDINote($0, style: style) }
        
        // test black keys
        
        #expect(blackKeyNotes.count == 53)
        #expect(blackKeyNotes.allSatisfy { $0.isSharp })
    }
}
