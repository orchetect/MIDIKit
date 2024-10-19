//
//  Event PitchBend Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import XCTest

final class Event_PitchBend_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xE0, 0x00, 0x40]
        
        let event = try MIDIFileEvent.PitchBend(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.value, .midi1(.midpoint))
        XCTAssertEqual(event.channel, 0)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.PitchBend(
            value: .midi1(.midpoint),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xE0, 0x00, 0x40])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xE1, 0x7F, 0x7F]
        
        let event = try MIDIFileEvent.PitchBend(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.value, .midi1(.max))
        XCTAssertEqual(event.channel, 1)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.PitchBend(
            value: .midi1(.max),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xE1, 0x7F, 0x7F])
    }
}
