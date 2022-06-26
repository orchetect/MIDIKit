//
//  Note On Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class MIDIEventNoteOn_Tests: XCTestCase {
    
    typealias NoteOn = MIDI.Event.Note.On
    
    // MARK: - Standard Note tests
    
    func testUMP_MIDI1_0() {
        
        for noteNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .noteOn(noteNum,
                                         velocity: .midi1(64),
                                         attribute: .none,
                                         channel: 0x1,
                                         group: 0x9,
                                         midi1ZeroVelocityAsNoteOff: false)
            
            XCTAssertEqual(cc.umpRawWords(protocol: ._1_0),
                           [[
                            MIDI.UMPWord(0x29,
                                         0x91,
                                         noteNum.uInt8Value,
                                         64)
                           ]])
            
        }
        
    }
    
    func testUMP_MIDI2_0() {
        
        for noteNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .noteOn(noteNum,
                                         velocity: .midi1(64),
                                         attribute: .none,
                                         channel: 0x1,
                                         group: 0x9,
                                         midi1ZeroVelocityAsNoteOff: false)
            
            XCTAssertEqual(cc.umpRawWords(protocol: ._2_0),
                           [[
                            MIDI.UMPWord(0x49,
                                         0x91,
                                         noteNum.uInt8Value,
                                         0x00),
                            MIDI.UMPWord(0x80, 0x00,
                                         0x00, 0x00)
                           ]])
            
        }
        
    }
    
    func testUMP_MIDI2_0_WithAttribute() {
        
        for noteNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .noteOn(noteNum,
                                         velocity: .midi1(127),
                                         attribute: .pitch7_9(coarse: 0b110_1100,
                                                              fine: 0b1_1001_1110),
                                         channel: 0x1,
                                         group: 0x9,
                                         midi1ZeroVelocityAsNoteOff: false)
            
            XCTAssertEqual(cc.umpRawWords(protocol: ._2_0),
                           [[
                            MIDI.UMPWord(0x49,
                                         0x91,
                                         noteNum.uInt8Value,
                                         0x03),
                            MIDI.UMPWord(0xFF, 0xFF,
                                         0b110_1100_1, 0b1001_1110)
                           ]])
            
        }
        
    }
    
    // MARK: - Note On specific tests
    
    func testZeroVelocityAsNoteOff_midi1RawBytes() {
        
        // MIDI 1 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .midi1RawBytes(),
            [0x80, 0x3C, 0x00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .midi1RawBytes(),
            [0x90, 0x3C, 0x00] // note on
        )
        
        // MIDI 2 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .midi1RawBytes(),
            [0x90, 0x3C, 0x01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .midi1RawBytes(),
            [0x90, 0x3C, 0x01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        // Unit Interval Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .midi1RawBytes(),
            [0x80, 0x3C, 0x00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   attribute: .none,
                   channel: 0,
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
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .umpRawWords(protocol: ._1_0),
            [0x20_80_3C_00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .umpRawWords(protocol: ._1_0),
            [0x20_90_3C_00] // note on
        )
        
        // MIDI 2 Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .umpRawWords(protocol: ._1_0),
            [0x20_90_3C_01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: false)
                .umpRawWords(protocol: ._1_0),
            [0x20_90_3C_01] // note on, velocity 1 (as per MIDI 2.0 spec)
        )
        
        // Unit Interval Velocity Value
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true)
                .umpRawWords(protocol: ._1_0),
            [0x20_80_3C_00] // note off
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   attribute: .none,
                   channel: 0,
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
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi1(0),
                   attribute: .none,
                   channel: 0,
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
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .midi2(0),
                   attribute: .none,
                   channel: 0,
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
                   attribute: .none,
                   channel: 0,
                   group: 0,
                   midi1ZeroVelocityAsNoteOff: true) // no effect for MIDI 2.0 note on
                .umpRawWords(protocol: ._2_0),
            [0x40_90_3C_00, // note on
             0x0000_0000]
        )
        
        XCTAssertEqual(
            NoteOn(note: 60,
                   velocity: .unitInterval(0.0),
                   attribute: .none,
                   channel: 0,
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
