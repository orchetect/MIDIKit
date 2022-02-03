//
//  MIDI Note Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

final class NoteTests: XCTestCase {
    
    func testInitDefaults() {
        // ensure nominal defaults
        
        let note = MIDI.Note()
        
        XCTAssertEqual(note.number, 0)
        XCTAssertEqual(note.tuning, 440.0)
        XCTAssertEqual(note.frequencyValue, 8.175798915643707)
        XCTAssertEqual(note.stringValue(), "C-2")
    }
    
    func testInitNumber() {
        
        // test all common BinaryInteger inits, except MIDI.UInt7
        
        XCTAssertEqual(MIDI.Note(number: Int(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: UInt(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: Int8(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: UInt8(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: Int16(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: UInt16(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: Int32(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: UInt32(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: Int64(0x60))?.number, 0x60)
        XCTAssertEqual(MIDI.Note(number: UInt64(0x60))?.number, 0x60)
    }
    
    func testFrequency() {
        // test conversion:
        // note number -> frequency -> note number
        
        (0...127).forEach {
            guard let freq = MIDI.Note(number: $0)?.frequencyValue
            else {
                XCTFail("Failed to get note frequency for note number \($0)")
                return
            }
            
            // check rounding
            if let num = MIDI.Note(frequency: freq)?.number.intValue,
               num != $0
            {
                XCTFail("Note number conversion failed for frequency \($0)Hz")
            }
        }
    }
    
    func testAllNotes() {
        let getAllNotes = MIDI.Note.allNotes
        
        XCTAssertEqual(getAllNotes.count, 128)
        
        // spot check
        
        XCTAssertEqual(getAllNotes[0].number, 0)
        XCTAssertEqual(getAllNotes[0].tuning, 440.0)
        XCTAssertEqual(getAllNotes[0].frequencyValue, 8.175798915643707)
        XCTAssertEqual(getAllNotes[0].stringValue(), "C-2")
        
        XCTAssertEqual(getAllNotes[58].stringValue(), "A#2")
        XCTAssertEqual(getAllNotes[59].stringValue(), "B2")
        XCTAssertEqual(getAllNotes[60].stringValue(), "C3") // middle C
        XCTAssertEqual(getAllNotes[61].stringValue(), "C#3")
        
        XCTAssertEqual(getAllNotes[127].number, 127)
        XCTAssertEqual(getAllNotes[127].tuning, 440.0)
        XCTAssertEqual(getAllNotes[127].frequencyValue, 12543.853951415975)
        XCTAssertEqual(getAllNotes[127].stringValue(), "G8")
    }
    
    func testStringValue() {
        
        // don't respell A♮
        XCTAssertEqual(MIDI.Note(57).stringValue(), "A2")
        XCTAssertEqual(MIDI.Note(57).stringValue(respellSharpAsFlat: true), "A2")
        XCTAssertEqual(MIDI.Note(57).stringValue(unicodeAccidental: true), "A2")
        XCTAssertEqual(MIDI.Note(57).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "A2")
        
        // respelling and unicode accidental
        XCTAssertEqual(MIDI.Note(58).stringValue(), "A#2")
        XCTAssertEqual(MIDI.Note(58).stringValue(respellSharpAsFlat: true), "Bb2")
        XCTAssertEqual(MIDI.Note(58).stringValue(unicodeAccidental: true), "A♯2")
        XCTAssertEqual(MIDI.Note(58).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "B♭2")
        
        // don't respell B♮
        XCTAssertEqual(MIDI.Note(59).stringValue(), "B2")
        XCTAssertEqual(MIDI.Note(59).stringValue(respellSharpAsFlat: true), "B2")
        XCTAssertEqual(MIDI.Note(59).stringValue(unicodeAccidental: true), "B2")
        XCTAssertEqual(MIDI.Note(59).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "B2")
        
        // don't respell C♮
        XCTAssertEqual(MIDI.Note(60).stringValue(), "C3")
        XCTAssertEqual(MIDI.Note(60).stringValue(respellSharpAsFlat: true), "C3")
        XCTAssertEqual(MIDI.Note(60).stringValue(unicodeAccidental: true), "C3")
        XCTAssertEqual(MIDI.Note(60).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "C3")
        
        // respelling and unicode accidental
        XCTAssertEqual(MIDI.Note(61).stringValue(), "C#3")
        XCTAssertEqual(MIDI.Note(61).stringValue(respellSharpAsFlat: true), "Db3")
        XCTAssertEqual(MIDI.Note(61).stringValue(unicodeAccidental: true), "C♯3")
        XCTAssertEqual(MIDI.Note(61).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "D♭3")
        
        // don't respell D♮
        XCTAssertEqual(MIDI.Note(62).stringValue(), "D3")
        XCTAssertEqual(MIDI.Note(62).stringValue(respellSharpAsFlat: true), "D3")
        XCTAssertEqual(MIDI.Note(62).stringValue(unicodeAccidental: true), "D3")
        XCTAssertEqual(MIDI.Note(62).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "D3")
        
        // respelling and unicode accidental
        XCTAssertEqual(MIDI.Note(63).stringValue(), "D#3")
        XCTAssertEqual(MIDI.Note(63).stringValue(respellSharpAsFlat: true), "Eb3")
        XCTAssertEqual(MIDI.Note(63).stringValue(unicodeAccidental: true), "D♯3")
        XCTAssertEqual(MIDI.Note(63).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "E♭3")
        
        // don't respell E♮
        XCTAssertEqual(MIDI.Note(64).stringValue(), "E3")
        XCTAssertEqual(MIDI.Note(64).stringValue(respellSharpAsFlat: true), "E3")
        XCTAssertEqual(MIDI.Note(64).stringValue(unicodeAccidental: true), "E3")
        XCTAssertEqual(MIDI.Note(64).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "E3")
        
        // don't respell F♮
        XCTAssertEqual(MIDI.Note(65).stringValue(), "F3")
        XCTAssertEqual(MIDI.Note(65).stringValue(respellSharpAsFlat: true), "F3")
        XCTAssertEqual(MIDI.Note(65).stringValue(unicodeAccidental: true), "F3")
        XCTAssertEqual(MIDI.Note(65).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "F3")
        
        // respelling and unicode accidental
        XCTAssertEqual(MIDI.Note(66).stringValue(), "F#3")
        XCTAssertEqual(MIDI.Note(66).stringValue(respellSharpAsFlat: true), "Gb3")
        XCTAssertEqual(MIDI.Note(66).stringValue(unicodeAccidental: true), "F♯3")
        XCTAssertEqual(MIDI.Note(66).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "G♭3")
        
        // don't respell G♮
        XCTAssertEqual(MIDI.Note(67).stringValue(), "G3")
        XCTAssertEqual(MIDI.Note(67).stringValue(respellSharpAsFlat: true), "G3")
        XCTAssertEqual(MIDI.Note(67).stringValue(unicodeAccidental: true), "G3")
        XCTAssertEqual(MIDI.Note(67).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "G3")
        
        // respelling and unicode accidental
        XCTAssertEqual(MIDI.Note(68).stringValue(), "G#3")
        XCTAssertEqual(MIDI.Note(68).stringValue(respellSharpAsFlat: true), "Ab3")
        XCTAssertEqual(MIDI.Note(68).stringValue(unicodeAccidental: true), "G♯3")
        XCTAssertEqual(MIDI.Note(68).stringValue(respellSharpAsFlat: true,
                                                 unicodeAccidental: true), "A♭3")
        
    }
    
    func testNoteInit_String() {
        // spot check
        
        XCTAssertEqual(MIDI.Note(string: "B-3")?.number, nil) // out of bounds
        XCTAssertEqual(MIDI.Note(string: "C-2")?.number, 0)
        
        XCTAssertEqual(MIDI.Note(string: "A#2")?.number, 58)
        XCTAssertEqual(MIDI.Note(string: "Bb2")?.number, 58)
        XCTAssertEqual(MIDI.Note(string: "B2")?.number, 59)
        XCTAssertEqual(MIDI.Note(string: "C3")?.number, 60)
        XCTAssertEqual(MIDI.Note(string: "C#3")?.number, 61)
        
        XCTAssertEqual(MIDI.Note(string: "G8")?.number, 127)
        XCTAssertEqual(MIDI.Note(string: "G#8")?.number, nil) // out of bounds
        
        // alternate accidental symbols
        
        XCTAssertEqual(MIDI.Note(string: "Ab2")?.number, 56)
        XCTAssertEqual(MIDI.Note(string: "A♭2")?.number, 56)
        
        XCTAssertEqual(MIDI.Note(string: "A♯2")?.number, 58)
        XCTAssertEqual(MIDI.Note(string: "B♭2")?.number, 58)
        
        XCTAssertEqual(MIDI.Note(string: "B♯2"), nil) // don't allow C across different octave
        XCTAssertEqual(MIDI.Note(string: "C♭3"), nil) // don't allow B across different octave
        
        XCTAssertEqual(MIDI.Note(string: "C♯3")?.number, 61)
        XCTAssertEqual(MIDI.Note(string: "D♭3")?.number, 61)
        
        XCTAssertEqual(MIDI.Note(string: "D♯3")?.number, 63)
        XCTAssertEqual(MIDI.Note(string: "E♭3")?.number, 63)
        
        XCTAssertEqual(MIDI.Note(string: "E♯3")?.number, 65) // F♮
        XCTAssertEqual(MIDI.Note(string: "F♭3")?.number, 64) // E♮
        
        XCTAssertEqual(MIDI.Note(string: "F♯3")?.number, 66)
        XCTAssertEqual(MIDI.Note(string: "G♭3")?.number, 66)
        
        XCTAssertEqual(MIDI.Note(string: "G♯3")?.number, 68)
        XCTAssertEqual(MIDI.Note(string: "A♭3")?.number, 68)
        
    }
    
    func testNoteInit_NameAndOctave() {
        // spot check
        
        XCTAssertEqual(MIDI.Note(.C, octave: -2)?.number, 0)
        
        XCTAssertEqual(MIDI.Note(.A_sharp, octave: 2)?.number, 58)
        XCTAssertEqual(MIDI.Note(.B, octave: 2)?.number, 59)
        XCTAssertEqual(MIDI.Note(.C, octave: 3)?.number, 60)
        XCTAssertEqual(MIDI.Note(.C_sharp, octave: 3)?.number, 61)
        
        XCTAssertEqual(MIDI.Note(.G, octave: 8)?.number, 127)
        
        // edge cases
        
        XCTAssertEqual(MIDI.Note(.B, octave: -3)?.number, nil)
        XCTAssertEqual(MIDI.Note(.G_sharp, octave: 8)?.number, nil)
    }
    
    func testNoteName() {
        XCTAssertEqual(MIDI.Note(0).name, .C)
        XCTAssertEqual(MIDI.Note(0).octave, -2)
        
        XCTAssertEqual(MIDI.Note(59).name, .B)
        XCTAssertEqual(MIDI.Note(59).octave, 2)
        
        XCTAssertEqual(MIDI.Note(60).name, .C)
        XCTAssertEqual(MIDI.Note(60).octave, 3)
        
        XCTAssertEqual(MIDI.Note(127).name, .G)
        XCTAssertEqual(MIDI.Note(127).octave, 8)
    }
    
    func testPianoKeyType_WhiteKeys() {
        
        // generate white keys
        
        let whiteKeyNames = ["C", "D", "E", "F", "G", "A", "B"]
        let whiteKeyNamesTopOctave = ["C", "D", "E", "F", "G"]
        
        let whiteKeyNoteNames = ((-2)...7)
            .flatMap { octave in
                whiteKeyNames.map { "\($0)\(octave)" }
            }
        + whiteKeyNamesTopOctave.map { "\($0)8" }
        
        let whiteKeyNotes: [MIDI.Note] = whiteKeyNoteNames
            .map { MIDI.Note(string: $0)! }
        
        // test white keys
        
        XCTAssertEqual(whiteKeyNotes.count, 75)
        XCTAssert(whiteKeyNotes.allSatisfy { !$0.isSharp })
        
    }
    
    func testPianoKeyType_BlackKeys() {
        
        // generate black keys
        
        let blackKeyNames = ["C#", "D#", "F#", "G#", "A#"]
        let blackKeyNamesTopOctave = ["C#", "D#", "F#"]
        
        let blackKeyNoteNames = ((-2)...7)
            .flatMap { octave in
                blackKeyNames.map { "\($0)\(octave)" }
            }
        + blackKeyNamesTopOctave.map { "\($0)8" }
        
        let blackKeyNotes: [MIDI.Note] = blackKeyNoteNames
            .map { MIDI.Note(string: $0)! }
        
        // test black keys
        
        XCTAssertEqual(blackKeyNotes.count, 53)
        XCTAssert(blackKeyNotes.allSatisfy { $0.isSharp })
        
    }
    
}

#endif
