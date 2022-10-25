//
//  Event SequenceNumber Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_SequenceNumber_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xFF, 0x00, 0x02, 0x00, 0x00]
        
        let event = try MIDIFileEvent.SequenceNumber(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.sequence, 0x00)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.SequenceNumber(sequence: 0x00)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x00, 0x02, 0x00, 0x00])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xFF, 0x00, 0x02, 0x7F, 0xFF]
        
        let event = try MIDIFileEvent.SequenceNumber(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.sequence, 0x7FFF)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.SequenceNumber(sequence: 0x7FFF)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x00, 0x02, 0x7F, 0xFF])
    }
}

#endif
