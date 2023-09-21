//
//  Event Note Pressure Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSMF
import XCTest

final class Event_NotePressure_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xA0, 0x01, 0x40]
        
        let event = try MIDIFileEvent.NotePressure(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 1)
        XCTAssertEqual(event.amount, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.NotePressure(
            note: 1,
            amount: .midi1(0x40),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xA0, 0x01, 0x40])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xA1, 0x3C, 0x7F]
        
        let event = try MIDIFileEvent.NotePressure(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 60)
        XCTAssertEqual(event.amount, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.NotePressure(
            note: 60,
            amount: .midi1(0x7F),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xA1, 0x3C, 0x7F])
    }
}

#endif
