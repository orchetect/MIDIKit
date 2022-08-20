//
//  SysEx7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class SysEx7_Tests: XCTestCase {
    func testSysEx7RawBytes_Typical() throws {
        let sourceRawBytes: [UInt8] = [0xF0, 0x41, 0x01, 0x34, 0xF7]
		
        let event = try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        guard case let .sysEx7(innerEvent) = event
        else { XCTFail(); return }
    
        XCTAssertEqual(innerEvent.manufacturer, .oneByte(0x41))
        XCTAssertEqual(innerEvent.data, [0x01, 0x34])
        XCTAssertEqual(innerEvent.group, 0)
		
        XCTAssertEqual(event.midi1RawBytes(), sourceRawBytes)
        XCTAssertEqual(
            event.umpRawWords(protocol: ._2_0),
            [[0x3003_4101, 0x3400_0000]]
        )
    }
	
    func testSysEx7RawBytes_EmptyMessageBytes_WithMfr_WithEndByte() throws {
        let sourceRawBytes: [UInt8] = [0xF0, 0x41, 0xF7]
		
        let event = try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        guard case let .sysEx7(innerEvent) = event
        else { XCTFail(); return }
		
        XCTAssertEqual(innerEvent.manufacturer, .oneByte(0x41))
        XCTAssertEqual(innerEvent.data, [])
        XCTAssertEqual(innerEvent.group, 0)
    
        XCTAssertEqual(event.midi1RawBytes(), sourceRawBytes)
        XCTAssertEqual(
            event.umpRawWords(protocol: ._2_0),
            [[0x3001_4100, 0x0000_0000]]
        )
    }
    
    func testSysEx7RawBytes_EmptyMessageBytes_WithMfr() throws {
        let sourceRawBytes: [UInt8] = [0xF0, 0x41]
    
        let event = try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        guard case let .sysEx7(innerEvent) = event
        else { XCTFail(); return }
    
        XCTAssertEqual(innerEvent.manufacturer, .oneByte(0x41))
        XCTAssertEqual(innerEvent.data, [])
        XCTAssertEqual(innerEvent.group, 0)
    
        XCTAssertEqual(event.midi1RawBytes(), [0xF0, 0x41, 0xF7])
        XCTAssertEqual(
            event.umpRawWords(protocol: ._2_0),
            [[0x3001_4100, 0x0000_0000]]
        )
    }
    
    func testSysEx7RawBytes_EmptyMessageBytes_WithEndByte() {
        let sourceRawBytes: [UInt8] = [0xF0, 0xF7]
    
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        )
    }
	
    func testSysEx7RawBytes_MaxSize() {
        // valid - maximum byte length (256 bytes)
        XCTAssertNoThrow(
            try MIDIEvent.sysEx7(
                rawBytes: [0xF0, 0x41]
                    + [UInt8](repeating: 0x20, count: 256 - 3)
                    + [0xF7]
            )
        )
    
        // valid - length is larger than default 256 bytes (257 bytes)
        XCTAssertNoThrow(
            try MIDIEvent.sysEx7(
                rawBytes: [0xF0, 0x41]
                    + [UInt8](repeating: 0x20, count: 256 - 2)
                    + [0xF7]
            )
        )
    }
	
    func testSysEx7RawBytes_Malformed() {
        // empty raw bytes - invalid
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawBytes: [])
        )
		
        // start byte only - invalid
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawBytes: [0xF0])
        )
		
        // end byte only - invalid
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawBytes: [0xF7])
        )
		
        // start and end bytes only - invalid
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawBytes: [0xF0, 0xF7])
        )
		
        // correct start byte, valid length, but incorrect end byte
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF6])
        )
    }
	
    func testSysEx7RawHexString_Typical() throws {
        // space delimiter
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 34 F7"),
            .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
    
        // compact
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0410134F7"),
            .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
    
        // variable spacing
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 0134 F7"),
            .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
    
        // space delimiter - no trailing F7
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 34"),
            .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
    
        // compact - no trailing F7
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0410134"),
            .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
    
        // lowercase - no trailing F7
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "f0410134"),
            .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
    }
    
    func testSysEx7RawHexString_Malformed() throws {
        // wrong leading and trailing bytes
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "F7 41 01 34 F0")
        )
    
        // missing leading byte
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "41 01 34 F0")
        )
    
        // invalid hex characters
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 ZZ F7")
        )
    
        // uneven number of hex characters (should be in pairs)
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 34 F")
        )
    }
    
    func testSysEx7_midi1RawHexString() throws {
        let sysEx = MIDIEvent.SysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
    
        XCTAssertEqual(
            sysEx.midi1RawHexString(),
            "F0 41 01 34 F7"
        )
    
        XCTAssertEqual(
            sysEx.midi1RawHexString(leadingF0: false, trailingF7: false),
            "41 01 34"
        )
    
        XCTAssertEqual(
            sysEx.midi1RawHexString(separator: nil),
            "F0410134F7"
        )
    
        XCTAssertEqual(
            sysEx.midi1RawHexString(separator: ", "),
            "F0, 41, 01, 34, F7"
        )
    }
    
    func testUniversalSysEx7RawHexString_Typical() throws {
        // space delimiter
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 01 34 56 10 11 F7"),
            .universalSysEx7(
                universalType: .realTime,
                deviceID: 0x01,
                subID1: 0x34,
                subID2: 0x56,
                data: [0x10, 0x11]
            )
        )
    
        // compact
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F07F0134561011F7"),
            .universalSysEx7(
                universalType: .realTime,
                deviceID: 0x01,
                subID1: 0x34,
                subID2: 0x56,
                data: [0x10, 0x11]
            )
        )
    
        // variable spacing
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 013456 1011 F7"),
            .universalSysEx7(
                universalType: .realTime,
                deviceID: 0x01,
                subID1: 0x34,
                subID2: 0x56,
                data: [0x10, 0x11]
            )
        )
    
        // space delimiter - no trailing F7
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 0134 56 10 11"),
            .universalSysEx7(
                universalType: .realTime,
                deviceID: 0x01,
                subID1: 0x34,
                subID2: 0x56,
                data: [0x10, 0x11]
            )
        )
    
        // compact - no trailing F7
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "F07F0134561011"),
            .universalSysEx7(
                universalType: .realTime,
                deviceID: 0x01,
                subID1: 0x34,
                subID2: 0x56,
                data: [0x10, 0x11]
            )
        )
    
        // lowercase
        XCTAssertEqual(
            try MIDIEvent.sysEx7(rawHexString: "f0 7f 01 34 56 10 11 f7"),
            .universalSysEx7(
                universalType: .realTime,
                deviceID: 0x01,
                subID1: 0x34,
                subID2: 0x56,
                data: [0x10, 0x11]
            )
        )
    }
    
    func testUniversalSysEx7RawHexString_Malformed() throws {
        // wrong leading and trailing bytes
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "F7 7F 01 34 56 10 11 F0")
        )
    
        // missing leading byte
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "7F 01 34 56 10 11")
        )
    
        // invalid hex characters
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 01 34 56 ZZ 11 F7")
        )
    
        // uneven number of hex characters (should be in pairs)
        XCTAssertThrowsError(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 01 34 56 10 11 F")
        )
    }
    
    func testEquatable() throws {
        // ensure instances equate correctly
		
        let event1A = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
        let event1B = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		
        let event2 = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x64, 0xF7])
		
        XCTAssert(event1A == event1B)
		
        XCTAssert(event1A != event2)
    }
	
    func testHashable() throws {
        // ensure instances hash correctly
		
        let event1A = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
        let event1B = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
		
        let event2 = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x64, 0xF7])
		
        let set1: Set<MIDIEvent> = [event1A, event1B]
		
        let set2: Set<MIDIEvent> = [event1A, event2]
		
        XCTAssertEqual(set1.count, 1)
		
        XCTAssertEqual(set2.count, 2)
    }
}

#endif
