//
//  Event NRPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSMF
import XCTest

final class Event_NRPN_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    // MARK: - With Data LSB
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_FullyFormedMessages() throws {
        let bytes: [UInt8] = [
            0xB1, 0x63, 0x00, // cc 99, chan 1
            0xB1, 0x62, 0x01, // cc 98, chan 1
            0xB1, 0x06, 0x02, // cc 6, chan 1
            0xB1, 0x26, 0x03  // cc 38, chan 1
        ]
        
        let event = try MIDIFileEvent.NRPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(
            event.parameter,
            .raw(parameter: .init(msb: 0x00, lsb: 0x01), dataEntryMSB: 0x02, dataEntryLSB: 0x03)
        )
        XCTAssertEqual(event.channel, 1)
    }
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_RunningStatus() throws {
        let bytes: [UInt8] = [
            0xB1, 0x63, 0x00, // cc 99, chan 1
            0x62, 0x01, // cc 98, chan 1, running status 0xB1
            0x06, 0x02, // cc 6, chan 1, running status 0xB1
            0x26, 0x03  // cc 38, chan 1, running status 0xB1
        ]
        
        let event = try MIDIFileEvent.NRPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(
            event.parameter,
            .raw(parameter: .init(msb: 0x00, lsb: 0x01), dataEntryMSB: 0x02, dataEntryLSB: 0x03)
        )
        XCTAssertEqual(event.channel, 1)
    }
    
    func testEvent_MIDI1SMFRawBytes_SinglePacket_FullyFormedMessages() {
        let event = MIDIFileEvent.NRPN(
            .raw(parameter: .init(msb: 0x00, lsb: 0x01), dataEntryMSB: 0x02, dataEntryLSB: 0x03),
            change: .absolute,
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xB1, 0x63, 0x00, // cc 99, chan 1
            0xB1, 0x62, 0x01, // cc 98, chan 1
            0xB1, 0x06, 0x02, // cc 6, chan 1
            0xB1, 0x26, 0x03  // cc 38, chan 1
        ])
    }
    
    // MARK: - No Data LSB
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_FullyFormedMessages_NoDataLSB() throws {
        let bytes: [UInt8] = [
            0xB2, 0x63, 0x05, // cc 99, chan 2
            0xB2, 0x62, 0x10, // cc 98, chan 2
            0xB2, 0x06, 0x08 // cc 6, chan 2
        ]
        
        let event = try MIDIFileEvent.NRPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(
            event.parameter,
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: nil)
        )
        XCTAssertEqual(event.channel, 2)
    }
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_RunningStatus_NoDataLSB() throws {
        let bytes: [UInt8] = [
            0xB2, 0x63, 0x05, // cc 99, chan 2
            0x62, 0x10, // cc 98, chan 2, running status 0xB2
            0x06, 0x08 // cc 6, chan 2, running status 0xB2
        ]
        
        let event = try MIDIFileEvent.NRPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(
            event.parameter,
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: nil)
        )
        XCTAssertEqual(event.channel, 2)
    }
    
    func testEvent_MIDI1SMFRawBytes_SinglePacket_FullyFormedMessages_NoDataLSB() {
        let event = MIDIFileEvent.NRPN(
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: nil),
            change: .absolute,
            channel: 2
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xB2, 0x63, 0x05, // cc 99, chan 2
            0xB2, 0x62, 0x10, // cc 98, chan 2
            0xB2, 0x06, 0x08 // cc 6, chan 2
        ])
    }
}

#endif
