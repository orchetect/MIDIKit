//
//  Channel Voice Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitCore
import XCTest

final class MIDIEvent_ChannelVoiceTests_Tests: XCTestCase {
    // MARK: - Channel Voice Event encoding
    
    func testProgramChange_RawBytes_MIDI1_0() {
        XCTAssertEqual(
            MIDIEvent.programChange(program: 0x64, bank: .noBankSelect, channel: 10, group: 0).midi1RawBytes(),
            [0xCA, 0x64]
        )
        
        XCTAssertEqual(
            MIDIEvent.programChange(program: 0x64, bank: .bankSelect(msb: 0x10, lsb: 0x00), channel: 10, group: 0).midi1RawBytes(),
            [
                0xBA, 0x00, 0x10, // Bank Select MSB
                0xBA, 0x20, 0x00, // Bank Select LSB
                0xCA, 0x64 // Program Change
            ]
        )
        
        XCTAssertEqual(
            MIDIEvent.programChange(program: 0x64, bank: .bankSelect(msb: 0x10, lsb: 0x01), channel: 10, group: 0).midi1RawBytes(),
            [
                0xBA, 0x00, 0x10, // Bank Select MSB
                0xBA, 0x20, 0x01, // Bank Select LSB
                0xCA, 0x64 // Program Change
            ]
        )
    }
    
    // TODO: Add unit tests for other Channel Voice events
}
