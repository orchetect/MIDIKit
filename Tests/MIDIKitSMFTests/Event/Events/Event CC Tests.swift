//
//  Event CC Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_CC_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xB0, 0x01, 0x40]
        
        let event = try MIDIFileEvent.CC(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.controller, .modWheel) // CC 1
        XCTAssertEqual(event.value, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.CC(
            controller: .modWheel,
            value: .midi1(0x40),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xB0, 0x01, 0x40])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xB1, 0x0B, 0x7F]
        
        let event = try MIDIFileEvent.CC(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.controller, .expression) // CC 11
        XCTAssertEqual(event.value, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.CC(
            controller: .expression,
            value: .midi1(0x7F),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xB1, 0x0B, 0x7F])
    }
}

#endif
