//
//  Event Text Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import XCTest

final class Event_Text_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_EmptyString() throws {
        let bytes: [UInt8] = [
            0xFF, 0x01, // header
            0x00        // length: 0 bytes
        ]
        
        let event = try MIDIFileEvent.Text(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.textType, .text)
        XCTAssertEqual(event.text, "")
    }
    
    func testMIDI1SMFRawBytes_EmptyString() {
        let event = MIDIFileEvent.Text(type: .text, string: "")
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x01, // header
            0x00        // length: 0 bytes
        ])
    }
    
    func testInit_midi1SMFRawBytes_WithString() throws {
        let bytes: [UInt8] = [
            0xFF, 0x01, // header
            0x04,       // length: 4 bytes
            0x61, 0x62, 0x63, 0x64 // string characters
        ]
        
        let event = try MIDIFileEvent.Text(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.textType, .text)
        XCTAssertEqual(event.text, "abcd")
    }
    
    func testMIDI1SMFRawBytes_WithString() {
        let event = MIDIFileEvent.Text(type: .text, string: "abcd")
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x01, // header
            0x04,       // length: 4 bytes
            0x61, 0x62, 0x63, 0x64 // string characters
        ])
    }
    
    // MARK: Text Types
    
    func testTextHeaders() {
        // ensure all text event header IDs exist
        
        MIDIFileEvent.Text.EventType.allCases.forEach {
            XCTAssertNotNil(MIDIFile.kTextEventHeaders[$0])
        }
    }
    
    func testTextTypes() throws {
        func textTypeTest(
            eventType: MIDIFileEvent.Text.EventType,
            eventID: UInt8
        ) throws {
            let bytes: [UInt8] = [
                0xFF, eventID, // header
                0x01,          // length: 1 bytes
                0x61           // string characters
            ]
            
            let event1 = MIDIFileEvent.Text(type: eventType, string: "a")
            XCTAssertEqual(event1.midi1SMFRawBytes(), bytes)
            
            let event2 = try MIDIFileEvent.Text(midi1SMFRawBytes: bytes)
            XCTAssertEqual(event1, event2)
        }
        
        let textTypes: [MIDIFileEvent.Text.EventType: UInt8] = [
            .text                : 0x01,
            .copyright           : 0x02,
            .trackOrSequenceName : 0x03,
            .instrumentName      : 0x04,
            .lyric               : 0x05,
            .marker              : 0x06,
            .cuePoint            : 0x07,
            .programName         : 0x08,
            .deviceName          : 0x09
        ]
        
        try textTypes.forEach {
            try textTypeTest(eventType: $0.key, eventID: $0.value)
        }
    }
    
    // swiftformat:options --wrapcollections preserve
    // swiftformat:options --maxwidth none
    
    func testExtendedCharacters() throws {
        let rawData: [UInt8] = [
            0xFF, 0x02, 0x22, 0x43, 0x6F, 0x70, 0x79, 0x72,
            0x69, 0x67, 0x68, 0x74, 0x20, 0xA9, 0x20, 0x32,
            0x30, 0x30, 0x30, 0x20, 0x62, 0x79, 0x20, 0x53,
            0x6F, 0x6D, 0x65, 0x20, 0x47, 0x75, 0x79, 0x20,
            0x48, 0x65, 0x6C, 0x6C, 0x6F
        ]
        
        let text = try MIDIFileEvent.Text(midi1SMFRawBytes: rawData)
        
        // check string integrity
        let str = "Copyright © 2000 by Some Guy Hello"
        XCTAssertEqual(text.text, str)
        
        // check instance equality
        XCTAssertEqual(text, MIDIFileEvent.Text(copyright: str))
    }
    
    func testNewlineCharacter() throws {
        let rawData: [UInt8] = [
            0xFF, 0x01, 0x1C, 0x53, 0x65, 0x71, 0x75, 0x65,
            0x6E, 0x63, 0x65, 0x64, 0x20, 0x62, 0x79, 0x20,
            0x4D, 0x72, 0x2E, 0x20, 0x4A, 0x6F, 0x68, 0x6E,
            0x6E, 0x79, 0x20, 0x44, 0x6F, 0x65, 0x0A
        ]
        
        let text = try MIDIFileEvent.Text(midi1SMFRawBytes: rawData)
        
        // check string integrity
        let str = "Sequenced by Mr. Johnny Doe\n"
        XCTAssertEqual(text.text, str)
        
        // check instance equality
        XCTAssertEqual(text, MIDIFileEvent.Text(text: str))
    }
    
    // TODO: add tests - edge cases etc.
}
