//
//  Event Note On Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import XCTest

final class Event_NoteOn_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0x90, 0x01, 0x40]
        
        let event = try MIDIFileEvent.NoteOn(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 1)
        XCTAssertEqual(event.velocity, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.NoteOn(
            note: 1,
            velocity: .midi1(0x40),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0x90, 0x01, 0x40])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0x91, 0x3C, 0x7F]
        
        let event = try MIDIFileEvent.NoteOn(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 60)
        XCTAssertEqual(event.velocity, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.NoteOn(
            note: 60,
            velocity: .midi1(0x7F),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0x91, 0x3C, 0x7F])
    }
    
    // MARK: - Edge Cases
    
    func testInit_midi1SMFRawBytes_Velocity0() throws {
        let bytes: [UInt8] = [0x90, 0x3C, 0x00]
        
        let event = try MIDIFileEvent.NoteOn(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 60)
        XCTAssertEqual(event.velocity, .midi1(0x00))
        XCTAssertEqual(event.channel, 0)
    }
    
    func testMIDI1SMFRawBytes_Velocity0_NoTranslation() {
        let event = MIDIFileEvent.NoteOn(
            note: 60,
            velocity: .midi1(0x00),
            channel: 0,
            midi1ZeroVelocityAsNoteOff: false
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0x90, 0x3C, 0x00])
    }
    
    func testMIDI1SMFRawBytes_Velocity0_TranslateOff() {
        let event = MIDIFileEvent.NoteOn(
            note: 60,
            velocity: .midi1(0x00),
            channel: 0,
            midi1ZeroVelocityAsNoteOff: true
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0x80, 0x3C, 0x00]) // interpreted as Note Off
    }
    
    func testMIDI1SMFRawBytes_Velocity1_TranslateOff() {
        let event = MIDIFileEvent.NoteOn(
            note: 60,
            velocity: .midi1(0x01),
            channel: 0,
            midi1ZeroVelocityAsNoteOff: true
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0x90, 0x3C, 0x01])
    }
}
