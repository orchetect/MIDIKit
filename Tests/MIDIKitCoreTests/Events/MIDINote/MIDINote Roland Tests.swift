//
//  MIDINote Roland Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class MIDINote_Roland_Tests: XCTestCase {
    fileprivate let style: MIDINote.Style = .roland
    
    func testInitDefaults() {
        // ensure nominal defaults
    
        let note = MIDINote(style: style)
    
        XCTAssertEqual(note.number, 0)
        XCTAssertEqual(note.style, .roland)
        XCTAssertEqual(note.frequencyValue(), 8.175798915643707)
        XCTAssertEqual(note.stringValue(), "C-1")
    }
    
    func testInitNumber() throws {
        // test all common BinaryInteger inits, except UInt7
    
        XCTAssertEqual(try MIDINote(Int(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(UInt(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(Int8(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(UInt8(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(Int16(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(UInt16(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(Int32(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(UInt32(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(Int64(0x60), style: style).number, 0x60)
        XCTAssertEqual(try MIDINote(UInt64(0x60), style: style).number, 0x60)
    }
    
    func testFrequency() throws {
        // test conversion:
        // note number -> frequency -> note number
    
        try (0 ... 127).forEach {
            let freq = try MIDINote($0, style: style).frequencyValue()
    
            // check rounding
            let num = try MIDINote(frequency: freq, style: style).number.intValue
    
            XCTAssertEqual(num, $0, "Note number conversion failed for frequency \($0)Hz")
        }
    }
    
    func testAllNotes() {
        let getAllNotes = MIDINote.allNotes(style: style)
    
        XCTAssertEqual(getAllNotes.count, 128)
    
        // spot check
    
        XCTAssertEqual(getAllNotes[0].number, 0)
        XCTAssertEqual(getAllNotes[0].frequencyValue(), 8.175798915643707)
        XCTAssertEqual(getAllNotes[0].stringValue(), "C-1")
    
        XCTAssertEqual(getAllNotes[58].stringValue(), "A#3")
        XCTAssertEqual(getAllNotes[59].stringValue(), "B3")
        XCTAssertEqual(getAllNotes[60].stringValue(), "C4") // middle C
        XCTAssertEqual(getAllNotes[61].stringValue(), "C#4")
    
        XCTAssertEqual(getAllNotes[127].number, 127)
        XCTAssertEqual(getAllNotes[127].frequencyValue(), 12543.853951415975)
        XCTAssertEqual(getAllNotes[127].stringValue(), "G9")
    }
    
    func testStringValue() {
        // don't respell A♮
        XCTAssertEqual(MIDINote(57, style: style).stringValue(), "A3")
        XCTAssertEqual(MIDINote(57, style: style).stringValue(respellSharpAsFlat: true), "A3")
        XCTAssertEqual(MIDINote(57, style: style).stringValue(unicodeAccidental: true), "A3")
        XCTAssertEqual(MIDINote(57, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "A3")
    
        // respelling and unicode accidental
        XCTAssertEqual(MIDINote(58, style: style).stringValue(), "A#3")
        XCTAssertEqual(MIDINote(58, style: style).stringValue(respellSharpAsFlat: true), "Bb3")
        XCTAssertEqual(MIDINote(58, style: style).stringValue(unicodeAccidental: true), "A♯3")
        XCTAssertEqual(MIDINote(58, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "B♭3")
    
        // don't respell B♮
        XCTAssertEqual(MIDINote(59, style: style).stringValue(), "B3")
        XCTAssertEqual(MIDINote(59, style: style).stringValue(respellSharpAsFlat: true), "B3")
        XCTAssertEqual(MIDINote(59, style: style).stringValue(unicodeAccidental: true), "B3")
        XCTAssertEqual(MIDINote(59, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "B3")
    
        // don't respell C♮
        XCTAssertEqual(MIDINote(60, style: style).stringValue(), "C4")
        XCTAssertEqual(MIDINote(60, style: style).stringValue(respellSharpAsFlat: true), "C4")
        XCTAssertEqual(MIDINote(60, style: style).stringValue(unicodeAccidental: true), "C4")
        XCTAssertEqual(MIDINote(60, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "C4")
    
        // respelling and unicode accidental
        XCTAssertEqual(MIDINote(61, style: style).stringValue(), "C#4")
        XCTAssertEqual(MIDINote(61, style: style).stringValue(respellSharpAsFlat: true), "Db4")
        XCTAssertEqual(MIDINote(61, style: style).stringValue(unicodeAccidental: true), "C♯4")
        XCTAssertEqual(MIDINote(61, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "D♭4")
    
        // don't respell D♮
        XCTAssertEqual(MIDINote(62, style: style).stringValue(), "D4")
        XCTAssertEqual(MIDINote(62, style: style).stringValue(respellSharpAsFlat: true), "D4")
        XCTAssertEqual(MIDINote(62, style: style).stringValue(unicodeAccidental: true), "D4")
        XCTAssertEqual(MIDINote(62, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "D4")
    
        // respelling and unicode accidental
        XCTAssertEqual(MIDINote(63, style: style).stringValue(), "D#4")
        XCTAssertEqual(MIDINote(63, style: style).stringValue(respellSharpAsFlat: true), "Eb4")
        XCTAssertEqual(MIDINote(63, style: style).stringValue(unicodeAccidental: true), "D♯4")
        XCTAssertEqual(MIDINote(63, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "E♭4")
    
        // don't respell E♮
        XCTAssertEqual(MIDINote(64, style: style).stringValue(), "E4")
        XCTAssertEqual(MIDINote(64, style: style).stringValue(respellSharpAsFlat: true), "E4")
        XCTAssertEqual(MIDINote(64, style: style).stringValue(unicodeAccidental: true), "E4")
        XCTAssertEqual(MIDINote(64, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "E4")
    
        // don't respell F♮
        XCTAssertEqual(MIDINote(65, style: style).stringValue(), "F4")
        XCTAssertEqual(MIDINote(65, style: style).stringValue(respellSharpAsFlat: true), "F4")
        XCTAssertEqual(MIDINote(65, style: style).stringValue(unicodeAccidental: true), "F4")
        XCTAssertEqual(MIDINote(65, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "F4")
    
        // respelling and unicode accidental
        XCTAssertEqual(MIDINote(66, style: style).stringValue(), "F#4")
        XCTAssertEqual(MIDINote(66, style: style).stringValue(respellSharpAsFlat: true), "Gb4")
        XCTAssertEqual(MIDINote(66, style: style).stringValue(unicodeAccidental: true), "F♯4")
        XCTAssertEqual(MIDINote(66, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "G♭4")
    
        // don't respell G♮
        XCTAssertEqual(MIDINote(67, style: style).stringValue(), "G4")
        XCTAssertEqual(MIDINote(67, style: style).stringValue(respellSharpAsFlat: true), "G4")
        XCTAssertEqual(MIDINote(67, style: style).stringValue(unicodeAccidental: true), "G4")
        XCTAssertEqual(MIDINote(67, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "G4")
    
        // respelling and unicode accidental
        XCTAssertEqual(MIDINote(68, style: style).stringValue(), "G#4")
        XCTAssertEqual(MIDINote(68, style: style).stringValue(respellSharpAsFlat: true), "Ab4")
        XCTAssertEqual(MIDINote(68, style: style).stringValue(unicodeAccidental: true), "G♯4")
        XCTAssertEqual(MIDINote(68, style: style).stringValue(
            respellSharpAsFlat: true,
            unicodeAccidental: true
        ), "A♭4")
    }
    
    func testNoteInit_String() throws {
        // spot check
    
        XCTAssertThrowsError(try MIDINote("B-2", style: style).number) // out of bounds
        XCTAssertEqual(try MIDINote("C-1", style: style).number, 0)
    
        XCTAssertEqual(try MIDINote("A#3", style: style).number, 58)
        XCTAssertEqual(try MIDINote("Bb3", style: style).number, 58)
        XCTAssertEqual(try MIDINote("B3", style: style).number, 59)
        XCTAssertEqual(try MIDINote("C4", style: style).number, 60)
        XCTAssertEqual(try MIDINote("C#4", style: style).number, 61)
    
        XCTAssertEqual(try MIDINote("G9", style: style).number, 127)
        XCTAssertThrowsError(try MIDINote("G#9", style: style).number) // out of bounds
    
        // alternate accidental symbols
    
        XCTAssertEqual(try MIDINote("Ab3", style: style).number, 56)
        XCTAssertEqual(try MIDINote("A♭3", style: style).number, 56)
    
        XCTAssertEqual(try MIDINote("A♯3", style: style).number, 58)
        XCTAssertEqual(try MIDINote("B♭3", style: style).number, 58)
    
        XCTAssertThrowsError(
            try MIDINote("B♯3", style: style)
        ) // don't allow C across different octave
        XCTAssertThrowsError(
            try MIDINote("C♭4", style: style)
        ) // don't allow B across different octave
    
        XCTAssertEqual(try MIDINote("C♯4", style: style).number, 61)
        XCTAssertEqual(try MIDINote("D♭4", style: style).number, 61)
    
        XCTAssertEqual(try MIDINote("D♯4", style: style).number, 63)
        XCTAssertEqual(try MIDINote("E♭4", style: style).number, 63)
    
        XCTAssertEqual(try MIDINote("E♯4", style: style).number, 65) // F♮
        XCTAssertEqual(try MIDINote("F♭4", style: style).number, 64) // E♮
    
        XCTAssertEqual(try MIDINote("F♯4", style: style).number, 66)
        XCTAssertEqual(try MIDINote("G♭4", style: style).number, 66)
    
        XCTAssertEqual(try MIDINote("G♯4", style: style).number, 68)
        XCTAssertEqual(try MIDINote("A♭4", style: style).number, 68)
    }
    
    func testNoteInit_NameAndOctave() throws {
        // spot check
    
        XCTAssertEqual(try MIDINote(.C, octave: -1, style: style).number, 0)
    
        XCTAssertEqual(try MIDINote(.A_sharp, octave: 3, style: style).number, 58)
        XCTAssertEqual(try MIDINote(.B, octave: 3, style: style).number, 59)
        XCTAssertEqual(try MIDINote(.C, octave: 4, style: style).number, 60)
        XCTAssertEqual(try MIDINote(.C_sharp, octave: 4, style: style).number, 61)
    
        XCTAssertEqual(try MIDINote(.G, octave: 9, style: style).number, 127)
    
        // edge cases
    
        XCTAssertThrowsError(try MIDINote(.B, octave: -2, style: style).number)
        XCTAssertThrowsError(try MIDINote(.G_sharp, octave: 9, style: style).number)
    }
    
    func testNoteName() {
        XCTAssertEqual(MIDINote(0, style: style).name, .C)
        XCTAssertEqual(MIDINote(0, style: style).octave, -1)
    
        XCTAssertEqual(MIDINote(59, style: style).name, .B)
        XCTAssertEqual(MIDINote(59, style: style).octave, 3)
    
        XCTAssertEqual(MIDINote(60, style: style).name, .C)
        XCTAssertEqual(MIDINote(60, style: style).octave, 4)
    
        XCTAssertEqual(MIDINote(127, style: style).name, .G)
        XCTAssertEqual(MIDINote(127, style: style).octave, 9)
    }
    
    func testPianoKeyType_WhiteKeys() throws {
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
    
        XCTAssertEqual(whiteKeyNotes.count, 75)
        XCTAssert(whiteKeyNotes.allSatisfy { !$0.isSharp })
    }
    
    func testPianoKeyType_BlackKeys() throws {
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
    
        XCTAssertEqual(blackKeyNotes.count, 53)
        XCTAssert(blackKeyNotes.allSatisfy { $0.isSharp })
    }
}

#endif
