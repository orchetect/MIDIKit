//
//  CC NRPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class MIDIEvent_CC_NRPN_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    typealias NRPN = MIDIEvent.CC.Controller.NRPN
    
    func testNRPN_MIDI1_NoDataEntry() {
        let nrpn: [MIDIEvent] = MIDIEvent.ccNRPN(
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
    
    func testNRPN_MIDI1_DataEntryMSB() {
        let nrpn: [MIDIEvent] = MIDIEvent.ccNRPN(
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
    
    func testNRPN_MIDI1_testRPN_MIDI1_DataEntryMSBandLSB() {
        let nrpn: [MIDIEvent] = MIDIEvent.ccNRPN(
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
    
    func testNRPN_MIDI1_Null() {
        let nrpn: [MIDIEvent] = MIDIEvent.ccNRPN(
            .null,
            channel: 0x9
        )
    
        XCTAssertEqual(
            nrpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x63, 0x7F,
             0xB9, 0x62, 0x7F]
        )
    }
}

#endif
