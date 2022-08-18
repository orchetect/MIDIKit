//
//  Event SequencerSpecific Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_SequencerSpecific_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_Empty() throws {
        let bytes: [Byte] = [0xFF, 0x7F, 0x00]
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, [])
    }
    
    func testMIDI1SMFRawBytes_Empty() {
        let event = MIDIFileEvent.SequencerSpecific(data: [])
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x7F, 0x00])
    }
    
    func testInit_midi1SMFRawBytes_OneByte() throws {
        let bytes: [Byte] = [0xFF, 0x7F, 0x01, 0x34]
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, [0x34])
    }
    
    func testMIDI1SMFRawBytes_OneByte() {
        let event = MIDIFileEvent.SequencerSpecific(data: [0x34])
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x7F, 0x01, 0x34])
    }
    
    func testInit_midi1SMFRawBytes_127Bytes() throws {
        let data: [Byte] = .init(repeating: 0x12, count: 127)
        
        let bytes: [Byte] =
            [0xFF, 0x7F, // header
             0x7F]       // length: 127 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, data)
    }
    
    func testMIDI1SMFRawBytes_127Bytes() {
        let data: [Byte] = .init(repeating: 0x12, count: 127)
        
        let event = MIDIFileEvent.SequencerSpecific(data: data)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x7F, // header
             0x7F]       // length: 127 bytes to follow
                + data   // data
        )
    }
    
    func testInit_midi1SMFRawBytes_128Bytes() throws {
        let data: [Byte] = .init(repeating: 0x12, count: 128)
        
        let bytes: [Byte] =
            [0xFF, 0x7F, // header
             0x81, 0x00] // length: 128 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, data)
    }
    
    func testMIDI1SMFRawBytes_128Bytes() {
        let data: [Byte] = .init(repeating: 0x12, count: 128)
        
        let event = MIDIFileEvent.SequencerSpecific(data: data)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x7F, // header
             0x81, 0x00] // length: 128 bytes to follow
                + data   // data
        )
    }
}

#endif
