//
//  Event Tempo Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_Tempo_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [
            0xFF, 0x51, 0x03, // header
            0x07, 0xA1, 0x20  // 24-bit tempo encoding
        ]
        
        let event = try MIDIFileEvent.Tempo(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.bpm, 120.0)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.Tempo(bpm: 120.0)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x51, 0x03, // header
            0x07, 0xA1, 0x20  // 24-bit tempo encoding
        ])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [
            0xFF, 0x51, 0x03, // header
            0x0F, 0x42, 0x40  // 24-bit tempo encoding
        ]
        
        let event = try MIDIFileEvent.Tempo(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.bpm, 60.0)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.Tempo(bpm: 60.0)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x51, 0x03, // header
            0x0F, 0x42, 0x40  // 24-bit tempo encoding
        ])
    }
}

#endif
