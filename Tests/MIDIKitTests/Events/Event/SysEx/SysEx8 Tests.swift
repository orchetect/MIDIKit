//
//  SysEx8 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class SysEx8Tests: XCTestCase {
	
	func testSysEx8_SingleUMP() throws {
		
        let sourceRawBytes: [MIDI.Byte] = [0x00, // stream ID
                                           0x00, 0x7D, // sysEx ID
                                           0x01, 0x34, 0xE6] // data bytes
		
		let event = try MIDI.Event(sysEx8RawBytes: sourceRawBytes)
        guard case .sysEx8(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.manufacturer, .oneByte(0x7D))
        XCTAssertEqual(innerEvent.data, [0x01, 0x34, 0xE6])
        XCTAssertEqual(innerEvent.group, 0)
		
        XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                       [
                        [0x50060000,
                         0x7D0134E6,
                         0x00000000,
                         0x00000000]
                       ])
        
	}
    
    func testSysEx8_2Part_UMP() throws {
        
        let event = MIDI.Event.sysEx8(manufacturer: .threeByte(byte2: 0x00, byte3: 0x66),
                                      data: [0x01, 0x02, 0x03, 0x01,
                                             0x02, 0x03, 0x04, 0x05,
                                             0x06, 0x07, 0x08, 0x09,
                                             0x0A, 0x0B, 0x0C, 0xE6],
                                      group: 0)
        
        guard case .sysEx8(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.manufacturer, .threeByte(byte2: 0x00, byte3: 0x66))
        XCTAssertEqual(innerEvent.data, [0x01, 0x02, 0x03, 0x01,
                                         0x02, 0x03, 0x04, 0x05,
                                         0x06, 0x07, 0x08, 0x09,
                                         0x0A, 0x0B, 0x0C, 0xE6])
        XCTAssertEqual(innerEvent.group, 0)
        
        XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                       [
                        [0x501E0080,
                         0x66010203,
                         0x01020304,
                         0x05060708],
                        [0x50360009,
                         0x0A0B0CE6,
                         0x00000000,
                         0x00000000]
                       ])
        
    }
    
    func testSysEx8_3Part_UMP() throws {
        
        let event = MIDI.Event.sysEx8(manufacturer: .threeByte(byte2: 0x21, byte3: 0x09),
                                      data: [0x01, 0x02, 0x03, 0x01,
                                             0x02, 0x03, 0x04, 0x05,
                                             0x06, 0x07, 0x08, 0x09,
                                             0x0A, 0x0B, 0x0C, 0x0D,
                                             0x0E, 0x0F, 0x10, 0x11,
                                             0x12, 0x13, 0x14, 0x15,
                                             0x16, 0x17, 0x18, 0x19,
                                             0xE6],
                                      group: 0)
        
        guard case .sysEx8(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.manufacturer, .threeByte(byte2: 0x21, byte3: 0x09))
        XCTAssertEqual(innerEvent.data, [0x01, 0x02, 0x03, 0x01,
                                         0x02, 0x03, 0x04, 0x05,
                                         0x06, 0x07, 0x08, 0x09,
                                         0x0A, 0x0B, 0x0C, 0x0D,
                                         0x0E, 0x0F, 0x10, 0x11,
                                         0x12, 0x13, 0x14, 0x15,
                                         0x16, 0x17, 0x18, 0x19,
                                         0xE6])
        XCTAssertEqual(innerEvent.group, 0)
        
        XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                       [
                        [0x501E00A1,
                         0x09010203,
                         0x01020304,
                         0x05060708],
                        [0x502E0009,
                         0x0A0B0C0D,
                         0x0E0F1011,
                         0x12131415],
                        [0x50360016,
                         0x171819E6,
                         0x00000000,
                         0x00000000]
                       ])
        
    }
    
    func testUniversalSysEx8_SingleUMP() throws {
        
        let event = MIDI.Event.universalSysEx8(universalType: .realTime,
                                               deviceID: 0x01,
                                               subID1: 0x02,
                                               subID2: 0x03,
                                               data: [0x01, 0x02, 0x03, 0x04,
                                                      0x05, 0x06, 0x07, 0xE6])
        
        guard case .universalSysEx8(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.universalType, .realTime)
        XCTAssertEqual(innerEvent.deviceID, 0x01)
        XCTAssertEqual(innerEvent.subID1, 0x02)
        XCTAssertEqual(innerEvent.subID2, 0x03)
        XCTAssertEqual(innerEvent.data, [0x01, 0x02, 0x03, 0x04,
                                         0x05, 0x06, 0x07, 0xE6])
        XCTAssertEqual(innerEvent.group, 0)
        
        XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                       [
                        [0x500E0000,
                         0x7F010203,
                         0x01020304,
                         0x050607E6]
                       ])
        
    }
    
    func testUniversalSysEx8_2Part_UMP() throws {
        
        let event = MIDI.Event.universalSysEx8(universalType: .realTime,
                                               deviceID: 0x01,
                                               subID1: 0x02,
                                               subID2: 0x03,
                                               data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                                      0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                                                      0xE6])
        
        guard case .universalSysEx8(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.universalType, .realTime)
        XCTAssertEqual(innerEvent.deviceID, 0x01)
        XCTAssertEqual(innerEvent.subID1, 0x02)
        XCTAssertEqual(innerEvent.subID2, 0x03)
        XCTAssertEqual(innerEvent.data, [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                         0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                                         0xE6])
        XCTAssertEqual(innerEvent.group, 0)
        
        XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                       [
                        [0x501E0000,
                         0x7F010203,
                         0x01020304,
                         0x05060708],
                        [0x50360009,
                         0x0A0B0CE6,
                         0x00000000,
                         0x00000000]
                       ])
        
    }
    
    func testUniversalSysEx8_3Part_UMP() throws {
        
        let event = MIDI.Event.universalSysEx8(universalType: .nonRealTime,
                                               deviceID: 0x01,
                                               subID1: 0x02,
                                               subID2: 0x03,
                                               data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                                      0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                                                      0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12,
                                                      0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
                                                      0x19, 0xE6])
        
        guard case .universalSysEx8(let innerEvent) = event
        else { XCTFail() ; return }
        
        XCTAssertEqual(innerEvent.universalType, .nonRealTime)
        XCTAssertEqual(innerEvent.deviceID, 0x01)
        XCTAssertEqual(innerEvent.subID1, 0x02)
        XCTAssertEqual(innerEvent.subID2, 0x03)
        XCTAssertEqual(innerEvent.data, [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                         0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                                         0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12,
                                         0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
                                         0x19, 0xE6])
        XCTAssertEqual(innerEvent.group, 0)
        
        XCTAssertEqual(event.umpRawWords(protocol: ._2_0),
                       [
                        [0x501E0000,
                         0x7E010203,
                         0x01020304,
                         0x05060708],
                        [0x502E0009,
                         0x0A0B0C0D,
                         0x0E0F1011,
                         0x12131415],
                        [0x50360016,
                         0x171819E6,
                         0x00000000,
                         0x00000000]
                       ])
        
    }
	
	func testSysEx8RawBytes_Malformed() {
		
		// empty raw bytes - invalid
		XCTAssertThrowsError(
			try MIDI.Event(sysEx8RawBytes: [])
		)
		
		// start byte only - invalid when in a complete SysEx8 UMP message
        XCTAssertThrowsError(
            try MIDI.Event(sysEx8RawBytes: [0x00])
		)
		
        // invalid sysEx ID
        XCTAssertThrowsError(
            try MIDI.Event(sysEx8RawBytes: [0x00, // stream ID
                                            0x00, 0x80, // sysEx ID -- invalid
                                            0x01, 0x34, 0xE6]) // data bytes
		)
		
	}
	
	func testEquatable() throws {
		
		// ensure instances equate correctly
		
        let event1A = try MIDI.Event(sysEx8RawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        let event1B = try MIDI.Event(sysEx8RawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        
        let event2 = try MIDI.Event(sysEx8RawBytes: [0x00, // stream ID
                                                     0x00, 0x42, // sysEx ID
                                                     0x01, 0x34, 0xE5]) // data bytes)
        
        XCTAssert(event1A == event1B)
		
		XCTAssert(event1A != event2)
		
	}
	
	func testHashable() throws {
		
		// ensure instances hash correctly
        
        let event1A = try MIDI.Event(sysEx8RawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        let event1B = try MIDI.Event(sysEx8RawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        
        let event2 = try MIDI.Event(sysEx8RawBytes: [0x00, // stream ID
                                                     0x00, 0x42, // sysEx ID
                                                     0x01, 0x34, 0xE5]) // data bytes)
		
		let set1: Set<MIDI.Event> = [event1A, event1B]
		
		let set2: Set<MIDI.Event> = [event1A, event2]
		
		XCTAssertEqual(set1.count, 1)
		
		XCTAssertEqual(set2.count, 2)
		
	}
	
}

#endif
