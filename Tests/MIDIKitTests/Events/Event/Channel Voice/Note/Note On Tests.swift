//
//  Note On Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventNoteOn_Tests: XCTestCase {
    
    typealias NoteOn = MIDI.Event.Note.On
    
    func testZeroVelocityAsNoteOff_midi1RawBytes() {
        
        // MIDI 1 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .midi1RawBytes(),
            [0x80, 0x3C, 0x00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .midi1RawBytes(),
            [0x90, 0x3C, 0x00] // note on
        )
        
        // MIDI 2 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .midi1RawBytes(),
            [0x90, 0x3C, 0x01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .midi1RawBytes(),
            [0x90, 0x3C, 0x01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        // Unit Interval Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .midi1RawBytes(),
            [0x80, 0x3C, 0x00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .midi1RawBytes(),
            [0x90, 0x3C, 0x00] // note on
        )
        
    }
    
    func testZeroVelocityAsNoteOff_umpRawWords_MIDI1_0() {
        
        // MIDI 1 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .umpRawWords(protocol: ._1_0),
            [0x20_80_3C_00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .umpRawWords(protocol: ._1_0),
            [0x20_90_3C_00] // note on
        )
        
        // MIDI 2 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .umpRawWords(protocol: ._1_0),
            [0x20_90_3C_01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .umpRawWords(protocol: ._1_0),
            [0x20_90_3C_01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        // Unit Interval Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .umpRawWords(protocol: ._1_0),
            [0x20_80_3C_00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .umpRawWords(protocol: ._1_0),
            [0x20_90_3C_00] // note on
        )
        
    }
    
    func testZeroVelocityAsNoteOff_umpRawWords_MIDI2_0() {
        
        // MIDI 1 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        // MIDI 2 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        // Unit Interval Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   channel: 0,
                   attribute: .none,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
    }
    
    func testEquatable() {
        
        // ensure midi1ZeroVelocityAsNoteOff is not factored into Equatable
        
        XCTAssertEqual(
            MIDI.Event.noteOn(60,
                              velocity: .midi1(0),
                              channel: 0,
                              midi1ZeroVelocityAsNoteOff: false),
            MIDI.Event.noteOn(60,
                              velocity: .midi1(0),
                              channel: 0,
                              midi1ZeroVelocityAsNoteOff: true)
        )
        
        XCTAssertEqual(
            MIDI.Event.noteOn(60,
                              velocity: .midi1(1),
                              channel: 0,
                              midi1ZeroVelocityAsNoteOff: false),
            MIDI.Event.noteOn(60,
                              velocity: .midi1(1),
                              channel: 0,
                              midi1ZeroVelocityAsNoteOff: true)
        )
        
    }
    
}

#endif
