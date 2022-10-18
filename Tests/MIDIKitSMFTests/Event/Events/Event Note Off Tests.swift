//
//  Event Note Off Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_NoteOff_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0x80, 0x01, 0x40]
        
        let event = try MIDIFileEvent.NoteOff(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 1)
        XCTAssertEqual(event.velocity, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.NoteOff(
            note: 1,
            velocity: .midi1(0x40),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0x80, 0x01, 0x40])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0x81, 0x3C, 0x7F]
        
        let event = try MIDIFileEvent.NoteOff(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 60)
        XCTAssertEqual(event.velocity, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.NoteOff(
            note: 60,
            velocity: .midi1(0x7F),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0x81, 0x3C, 0x7F])
    }
}

#endif
