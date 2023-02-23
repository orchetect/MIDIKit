//
//  MIDIPacket Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKitIO
@_implementationOnly import MIDIKitInternals
import CoreMIDI

final class MIDIPacket_Tests: XCTestCase {
    func testEmptyBytes256Length() throws {
        let testPacket = kMIDIPacket.emptyBytes256Length
        
        XCTAssertEqual(testPacket.rawBytes, [UInt8](repeating: 0x00, count: 256))
        XCTAssertEqual(testPacket.rawTimeStamp, 123_456_789)
    }
    
    func testNoteOn60Vel65Chan1() throws {
        let testPacket = kMIDIPacket.noteOn60Vel65Chan1
        
        XCTAssertEqual(testPacket.rawBytes, [0x90, 0x3C, 0x41])
        XCTAssertEqual(testPacket.rawTimeStamp, 123_456_789)
    }
    
    func testNoteOn60Vel65Chan1_CC12Val105Chan1() throws {
        let testPacket = kMIDIPacket.noteOn60Vel65Chan1_CC12Val105Chan1
        
        XCTAssertEqual(testPacket.rawBytes, [0x90, 0x3C, 0x41, 0xB0, 0x08, 0x69])
        XCTAssertEqual(testPacket.rawTimeStamp, 987_654_321)
    }
    
    func testFull256Bytes() throws {
        let testPacket = kMIDIPacket.full256Bytes
        
        XCTAssertEqual(testPacket.rawBytes, kMIDIPacket.full256Bytes_rawBytes)
        XCTAssertEqual(testPacket.rawTimeStamp, UInt64.max)
    }
}

#endif
