//
//  MIDINote Yamaha Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDINote_Yamaha_Tests {
    private let style: MIDINote.Style = .yamaha
    
    @Test
    func initDefaults() {
        // ensure nominal defaults
        
        let note = MIDINote(0, style: style)
        
        #expect(note.number == 0)
        #expect(note.style == .yamaha)
        #expect(note.frequencyValue() == 8.175798915643707)
        #expect(note.stringValue() == "C-2")
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
        #expect(getAllNotes[0].stringValue() == "C-2")
        
        #expect(getAllNotes[58].stringValue() == "A#2")
        #expect(getAllNotes[59].stringValue() == "B2")
        #expect(getAllNotes[60].stringValue() == "C3") // middle C
        #expect(getAllNotes[61].stringValue() == "C#3")
        
        #expect(getAllNotes[127].number == 127)
        #expect(getAllNotes[127].frequencyValue() == 12543.853951415975)
        #expect(getAllNotes[127].stringValue() == "G8")
    }
    
    @Test
    func stringValue() {
        // don't respell A♮
        #expect(MIDINote(57, style: style).stringValue() == "A2")
        #expect(MIDINote(57, style: style).stringValue(respellSharpAsFlat: true) == "A2")
        #expect(MIDINote(57, style: style).stringValue(unicodeAccidental: true) == "A2")
        #expect(MIDINote(57, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "A2")
        
        // respelling and unicode accidental
        #expect(MIDINote(58, style: style).stringValue() == "A#2")
        #expect(MIDINote(58, style: style).stringValue(respellSharpAsFlat: true) == "Bb2")
        #expect(MIDINote(58, style: style).stringValue(unicodeAccidental: true) == "A♯2")
        #expect(MIDINote(58, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "B♭2")
        
        // don't respell B♮
        #expect(MIDINote(59, style: style).stringValue() == "B2")
        #expect(MIDINote(59, style: style).stringValue(respellSharpAsFlat: true) == "B2")
        #expect(MIDINote(59, style: style).stringValue(unicodeAccidental: true) == "B2")
        #expect(MIDINote(59, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "B2")
        
        // don't respell C♮
        #expect(MIDINote(60, style: style).stringValue() == "C3")
        #expect(MIDINote(60, style: style).stringValue(respellSharpAsFlat: true) == "C3")
        #expect(MIDINote(60, style: style).stringValue(unicodeAccidental: true) == "C3")
        #expect(MIDINote(60, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "C3")
        
        // respelling and unicode accidental
        #expect(MIDINote(61, style: style).stringValue() == "C#3")
        #expect(MIDINote(61, style: style).stringValue(respellSharpAsFlat: true) == "Db3")
        #expect(MIDINote(61, style: style).stringValue(unicodeAccidental: true) == "C♯3")
        #expect(MIDINote(61, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "D♭3")
        
        // don't respell D♮
        #expect(MIDINote(62, style: style).stringValue() == "D3")
        #expect(MIDINote(62, style: style).stringValue(respellSharpAsFlat: true) == "D3")
        #expect(MIDINote(62, style: style).stringValue(unicodeAccidental: true) == "D3")
        #expect(MIDINote(62, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "D3")
        
        // respelling and unicode accidental
        #expect(MIDINote(63, style: style).stringValue() == "D#3")
        #expect(MIDINote(63, style: style).stringValue(respellSharpAsFlat: true) == "Eb3")
        #expect(MIDINote(63, style: style).stringValue(unicodeAccidental: true) == "D♯3")
        #expect(MIDINote(63, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "E♭3")
        
        // don't respell E♮
        #expect(MIDINote(64, style: style).stringValue() == "E3")
        #expect(MIDINote(64, style: style).stringValue(respellSharpAsFlat: true) == "E3")
        #expect(MIDINote(64, style: style).stringValue(unicodeAccidental: true) == "E3")
        #expect(MIDINote(64, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "E3")
        
        // don't respell F♮
        #expect(MIDINote(65, style: style).stringValue() == "F3")
        #expect(MIDINote(65, style: style).stringValue(respellSharpAsFlat: true) == "F3")
        #expect(MIDINote(65, style: style).stringValue(unicodeAccidental: true) == "F3")
        #expect(MIDINote(65, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "F3")
        
        // respelling and unicode accidental
        #expect(MIDINote(66, style: style).stringValue() == "F#3")
        #expect(MIDINote(66, style: style).stringValue(respellSharpAsFlat: true) == "Gb3")
        #expect(MIDINote(66, style: style).stringValue(unicodeAccidental: true) == "F♯3")
        #expect(MIDINote(66, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "G♭3")
        
        // don't respell G♮
        #expect(MIDINote(67, style: style).stringValue() == "G3")
        #expect(MIDINote(67, style: style).stringValue(respellSharpAsFlat: true) == "G3")
        #expect(MIDINote(67, style: style).stringValue(unicodeAccidental: true) == "G3")
        #expect(MIDINote(67, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "G3")
        
        // respelling and unicode accidental
        #expect(MIDINote(68, style: style).stringValue() == "G#3")
        #expect(MIDINote(68, style: style).stringValue(respellSharpAsFlat: true) == "Ab3")
        #expect(MIDINote(68, style: style).stringValue(unicodeAccidental: true) == "G♯3")
        #expect(MIDINote(68, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ) == "A♭3")
    }
    
    @Test
    func noteInit_String() throws {
        // spot check
        
        #expect(throws: (any Error).self) { try MIDINote("B-3", style: style).number } // out of bounds
        #expect(try MIDINote("C-2", style: style).number == 0)
        
        #expect(try MIDINote("A#2", style: style).number == 58)
        #expect(try MIDINote("Bb2", style: style).number == 58)
        #expect(try MIDINote("B2", style: style).number == 59)
        #expect(try MIDINote("C3", style: style).number == 60)
        #expect(try MIDINote("C#3", style: style).number == 61)
        
        #expect(try MIDINote("G8", style: style).number == 127)
        #expect(throws: (any Error).self) { try MIDINote("G#8", style: style).number } // out of bounds
        
        // alternate accidental symbols
        
        #expect(try MIDINote("Ab2", style: style).number == 56)
        #expect(try MIDINote("A♭2", style: style).number == 56)
        
        #expect(try MIDINote("A♯2", style: style).number == 58)
        #expect(try MIDINote("B♭2", style: style).number == 58)
        
        #expect(throws: (any Error).self) {
            try MIDINote("B♯2", style: style) // don't allow C across different octave
        }
        #expect(throws: (any Error).self) {
            try MIDINote("C♭3", style: style) // don't allow B across different octave
        }
        
        #expect(try MIDINote("C♯3", style: style).number == 61)
        #expect(try MIDINote("D♭3", style: style).number == 61)
        
        #expect(try MIDINote("D♯3", style: style).number == 63)
        #expect(try MIDINote("E♭3", style: style).number == 63)
        
        #expect(try MIDINote("E♯3", style: style).number == 65) // F♮
        #expect(try MIDINote("F♭3", style: style).number == 64) // E♮
        
        #expect(try MIDINote("F♯3", style: style).number == 66)
        #expect(try MIDINote("G♭3", style: style).number == 66)
        
        #expect(try MIDINote("G♯3", style: style).number == 68)
        #expect(try MIDINote("A♭3", style: style).number == 68)
    }
    
    @Test
    func noteInit_NameAndOctave() throws {
        // spot check
        
        #expect(try MIDINote(.C, octave: -2, style: style).number == 0)
        
        #expect(try MIDINote(.A_sharp, octave: 2, style: style).number == 58)
        #expect(try MIDINote(.B, octave: 2, style: style).number == 59)
        #expect(try MIDINote(.C, octave: 3, style: style).number == 60)
        #expect(try MIDINote(.C_sharp, octave: 3, style: style).number == 61)
        
        #expect(try MIDINote(.G, octave: 8, style: style).number == 127)
        
        // edge cases
        
        #expect(throws: (any Error).self) { try MIDINote(.B, octave: -3, style: style).number }
        #expect(throws: (any Error).self) { try MIDINote(.G_sharp, octave: 8, style: style).number }
    }
    
    @Test
    func noteName() {
        #expect(MIDINote(0, style: style).name == .C)
        #expect(MIDINote(0, style: style).octave == -2)
        
        #expect(MIDINote(59, style: style).name == .B)
        #expect(MIDINote(59, style: style).octave == 2)
        
        #expect(MIDINote(60, style: style).name == .C)
        #expect(MIDINote(60, style: style).octave == 3)
        
        #expect(MIDINote(127, style: style).name == .G)
        #expect(MIDINote(127, style: style).octave == 8)
    }
    
    @Test
    func pianoKeyType_WhiteKeys() throws {
        // generate white keys
        
        let whiteKeyNames = ["C", "D", "E", "F", "G", "A", "B"]
        let whiteKeyNamesTopOctave = ["C", "D", "E", "F", "G"]
        
        let whiteKeyNoteNames = ((-2) ... 7)
            .flatMap { octave in
                whiteKeyNames.map { "\($0)\(octave)" }
            }
            + whiteKeyNamesTopOctave.map { "\($0)8" }
        
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
        
        let blackKeyNoteNames = ((-2) ... 7)
            .flatMap { octave in
                blackKeyNames.map { "\($0)\(octave)" }
            }
            + blackKeyNamesTopOctave.map { "\($0)8" }
        
        let blackKeyNotes: [MIDINote] = try blackKeyNoteNames
            .map { try MIDINote($0, style: style) }
        
        // test black keys
        
        #expect(blackKeyNotes.count == 53)
        #expect(blackKeyNotes.allSatisfy { $0.isSharp })
    }
}
