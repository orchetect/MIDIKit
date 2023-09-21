//
//  Event UnrecognizedMeta Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSMF
import XCTest

final class Event_UnrecognizedMeta_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_EmptyData() throws {
        let bytes: [UInt8] = [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x00        // length: 0 bytes to follow
        ]
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, [])
    }
    
    func testMIDI1SMFRawBytes_EmptyData() {
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: []
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x00        // length: 0 bytes to follow
        ])
    }
    
    func testInit_midi1SMFRawBytes_WithData() throws {
        let bytes: [UInt8] = [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x01,       // length: 1 bytes to follow
            0x12        // data byte
        ]
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, [0x12])
    }
    
    func testMIDI1SMFRawBytes_WithData() {
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: [0x12]
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x30, // unknown/undefined meta type 0x30
            0x01,       // length: 1 bytes to follow
            0x12        // data byte
        ])
    }
    
    func testInit_midi1SMFRawBytes_127Bytes() throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let bytes: [UInt8] =
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x7F]       // length: 127 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, data)
    }
    
    func testMIDI1SMFRawBytes_127Bytes() {
        let data: [UInt8] = .init(repeating: 0x12, count: 127)
        
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: data
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x7F]       // length: 127 bytes to follow
                + data   // data
        )
    }
    
    func testInit_midi1SMFRawBytes_128Bytes() throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let bytes: [UInt8] =
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x81, 0x00] // length: 128 bytes to follow
            + data       // data
        
        let event = try MIDIFileEvent.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, data)
    }
    
    func testMIDI1SMFRawBytes_128Bytes() {
        let data: [UInt8] = .init(repeating: 0x12, count: 128)
        
        let event = MIDIFileEvent.UnrecognizedMeta(
            metaType: 0x30,
            data: data
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x81, 0x00] // length: 128 bytes to follow
                + data   // data
        )
    }
}

#endif
