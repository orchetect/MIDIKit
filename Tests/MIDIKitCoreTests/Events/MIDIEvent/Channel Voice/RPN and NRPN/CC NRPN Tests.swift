//
//  CC NRPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import MIDIKitCore
import XCTest

final class MIDIEvent_CC_NRPN_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    // MARK: - MIDIEvent.midi1NRPN() -> Raw MIDI 1.0 Bytes
    
    func testNRPN_MIDI1_EventToBytes_NoDataEntry() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: nil,
                dataEntryLSB: nil
            ),
            channel: 0x9
        )
    
        XCTAssertEqual(
            nrpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x63, 66,
             0xB9, 0x62, 103]
        )
    }
    
    func testNRPN_MIDI1_EventToBytes_DataEntryMSB() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: 127,
                dataEntryLSB: nil
            ),
            channel: 0x9
        )
    
        XCTAssertEqual(
            nrpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x63, 66,
             0xB9, 0x62, 103,
             0xB9, 0x06, 127]
        )
    }
    
    func testNRPN_MIDI1_EventToBytes_DataEntryMSBandLSB() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: 127,
                dataEntryLSB: 2
            ),
            channel: 0x9
        )
    
        XCTAssertEqual(
            nrpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x63, 66,
             0xB9, 0x62, 103,
             0xB9, 0x06, 127,
             0xB9, 0x26, 2]
        )
    }
    
    func testNRPN_MIDI1_EventToBytes_Null() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .null,
            channel: 0x9
        )
    
        XCTAssertEqual(
            nrpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x63, 0x7F,
             0xB9, 0x62, 0x7F]
        )
    }
    
    // MARK: - Raw MIDI 1.0 Bytes -> MIDIEvent.midi1NRPN()
    // TODO: add unit tests if/when aggregate CC/DataEntry parsing gets added to `MIDI1Parser`
    
    // MARK: - MIDIEvent.nrpn() -> Raw MIDI 2.0 RPN UMP Words
    
    func testNRPN_MIDI2_EventToWords_Absolute() {
        let nrpn: MIDIEvent = .nrpn(
            .raw(
                parameter: .init(msb: 0x40, lsb: 0x01),
                dataEntryMSB: 0x12,
                dataEntryLSB: nil
            ),
            change: .absolute,
            channel: 0x9
        )
        
        XCTAssertEqual(
            nrpn.umpRawWords(protocol: ._2_0),
            [[UMPWord(0x40, 0x39, 0x40, 0x01),
              UMPWord(0x24, 0x00, 0x00, 0x00)]]
        )
    }
    
    func testNRPN_MIDI2_EventToWords_Relative() {
        let nrpn: MIDIEvent = .nrpn(
            .raw(
                parameter: .init(msb: 0x40, lsb: 0x01),
                dataEntryMSB: 0x12,
                dataEntryLSB: nil
            ),
            change: .relative,
            channel: 0x9
        )
        
        XCTAssertEqual(
            nrpn.umpRawWords(protocol: ._2_0),
            [[UMPWord(0x40, 0x59, 0x40, 0x01),
              UMPWord(0x24, 0x00, 0x00, 0x00)]]
        )
    }
    
    func testNRPN_MIDI2_EventToWords_Null() {
        let nrpn: MIDIEvent = .nrpn(
            .null,
            change: .absolute,
            channel: 0x9
        )
        
        XCTAssertEqual(
            nrpn.umpRawWords(protocol: ._2_0),
            [[UMPWord(0x40, 0x39, 0x7F, 0x7F),
              UMPWord(0x00, 0x00, 0x00, 0x00)]]
        )
    }
    
    // MARK: - Raw MIDI 2.0 RPN UMP Words -> MIDIEvent.nrpn()
    // See MIDIKitIO - MIDI2Parser Tests.swift
}

#endif
