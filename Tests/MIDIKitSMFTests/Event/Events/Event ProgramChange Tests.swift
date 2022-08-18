//
//  Event ProgramChange Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_ProgramChange_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [Byte] = [0xC0, 0x40]
        
        let event = try MIDIFileEvent.ProgramChange(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.program, 0x40)
        XCTAssertEqual(event.channel, 0)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.ProgramChange(
            program: 0x40,
            bank: .noBankSelect,
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xC0, 0x40])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [Byte] = [0xC1, 0x7F]
        
        let event = try MIDIFileEvent.ProgramChange(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.program, 0x7F)
        XCTAssertEqual(event.channel, 1)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.ProgramChange(
            program: 0x7F,
            bank: .noBankSelect,
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xC1, 0x7F])
    }
}

#endif
