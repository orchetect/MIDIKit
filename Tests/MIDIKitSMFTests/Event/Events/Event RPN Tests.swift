//
//  Event RPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSMF
import XCTest

final class Event_RPN_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    // MARK: - With Data LSB
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_FullyFormedMessages() throws {
        let bytes: [UInt8] = [
            0xB1, 0x65, 0x00, // cc 101, chan 1
            0xB1, 0x64, 0x01, // cc 100, chan 1
            0xB1, 0x06, 0x00, // cc 6, chan 1
            0xB1, 0x26, 0x01  // cc 38, chan 1
        ]
        
        let event = try MIDIFileEvent.RPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.parameter, .channelFineTuning(1))
        XCTAssertEqual(event.channel, 1)
    }
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_RunningStatus() throws {
        let bytes: [UInt8] = [
            0xB1, 0x65, 0x00, // cc 101, chan 1
            0x64, 0x01, // cc 100, chan 1, running status 0xB1
            0x06, 0x00, // cc 6, chan 1, running status 0xB1
            0x26, 0x01  // cc 38, chan 1, running status 0xB1
        ]
        
        let event = try MIDIFileEvent.RPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.parameter, .channelFineTuning(1))
        XCTAssertEqual(event.channel, 1)
    }
    
    func testEvent_MIDI1SMFRawBytes_SinglePacket_FullyFormedMessages() {
        let event = MIDIFileEvent.RPN(
            .channelFineTuning(1),
            change: .absolute,
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xB1, 0x65, 0x00, // cc 101, chan 1
            0xB1, 0x64, 0x01, // cc 100, chan 1
            0xB1, 0x06, 0x00, // cc 6, chan 1
            0xB1, 0x26, 0x01  // cc 38, chan 1
        ])
    }
    
    // MARK: - No Data LSB
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_FullyFormedMessages_NoDataLSB() throws {
        let bytes: [UInt8] = [
            0xB2, 0x65, 0x05, // cc 101, chan 2
            0xB2, 0x64, 0x10, // cc 100, chan 2
            0xB2, 0x06, 0x08 // cc 6, chan 2
        ]
        
        let event = try MIDIFileEvent.RPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(
            event.parameter,
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: nil)
        )
        XCTAssertEqual(event.channel, 2)
    }
    
    func testInit_Event_init_midi1SMFRawBytes_SinglePacket_RunningStatus_NoDataLSB() throws {
        let bytes: [UInt8] = [
            0xB2, 0x65, 0x05, // cc 101, chan 2
            0x64, 0x10, // cc 100, chan 2, running status 0xB2
            0x06, 0x08 // cc 6, chan 2, running status 0xB2
        ]
        
        let event = try MIDIFileEvent.RPN(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(
            event.parameter,
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: nil)
        )
        XCTAssertEqual(event.channel, 2)
    }
    
    func testEvent_MIDI1SMFRawBytes_SinglePacket_FullyFormedMessages_NoDataLSB() {
        let event = MIDIFileEvent.RPN(
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: nil),
            change: .absolute,
            channel: 2
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xB2, 0x65, 0x05, // cc 101, chan 2
            0xB2, 0x64, 0x10, // cc 100, chan 2
            0xB2, 0x06, 0x08 // cc 6, chan 2
        ])
    }
}

#endif
