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
        XCTAssertEqual(note.stringValue, "C-2")
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
        XCTAssertEqual(getAllNotes[0].stringValue, "C-2")
        
        XCTAssertEqual(getAllNotes[58].stringValue, "A#2")
        XCTAssertEqual(getAllNotes[59].stringValue, "B2")
        XCTAssertEqual(getAllNotes[60].stringValue, "C3") // middle C
        XCTAssertEqual(getAllNotes[61].stringValue, "C#3")
        
        XCTAssertEqual(getAllNotes[127].number, 127)
        XCTAssertEqual(getAllNotes[127].tuning, 440.0)
        XCTAssertEqual(getAllNotes[127].frequencyValue, 12543.853951415975)
        XCTAssertEqual(getAllNotes[127].stringValue, "G8")
    }
    
    func testNoteNameString() {
        // spot check
        
        XCTAssertEqual(MIDI.Note(string: "C-2")?.number, 0)
        
        XCTAssertEqual(MIDI.Note(string: "A#2")?.number, 58)
        XCTAssertEqual(MIDI.Note(string: "B2")?.number, 59)
        XCTAssertEqual(MIDI.Note(string: "C3")?.number, 60)
        XCTAssertEqual(MIDI.Note(string: "C#3")?.number, 61)
        
        XCTAssertEqual(MIDI.Note(string: "G8")?.number, 127)
        
        // edge cases
        
        XCTAssertEqual(MIDI.Note(string: "B-3")?.number, nil)
        XCTAssertEqual(MIDI.Note(string: "G#8")?.number, nil)
    }
    
    func testNoteNameAndOctave() {
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
    
}

#endif
