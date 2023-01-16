//
//  Event KeySignature Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_KeySignature_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xFF, 0x59, 0x02, 4, 0x00]
        
        let event = try MIDIFileEvent.KeySignature(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.flatsOrSharps, 4)
        XCTAssertEqual(event.majorKey, true)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.KeySignature(flatsOrSharps: 4, majorKey: true)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x59, 0x02, 4, 0x00])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xFF, 0x59, 0x02, 0xFD, 0x01]
        
        let event = try MIDIFileEvent.KeySignature(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.flatsOrSharps, -3)
        XCTAssertEqual(event.majorKey, false)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.KeySignature(flatsOrSharps: -3, majorKey: false)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x59, 0x02, 0xFD, 0x01])
    }
}

#endif
