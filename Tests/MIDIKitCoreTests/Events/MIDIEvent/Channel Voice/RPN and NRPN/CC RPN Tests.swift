//
//  CC RPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import MIDIKitCore
import XCTest

final class MIDIEvent_CC_RPN_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    // MARK: - MIDIEvent.midi1RPN() -> Raw MIDI 1.0 Bytes
    
    func testRPN_MIDI1_EventToBytes_NoDataEntry() {
        let rpn: [MIDIEvent] = MIDIEvent.midi1RPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: nil,
                dataEntryLSB: nil
            ),
            channel: 0x9
        )
    
        XCTAssertEqual(
            rpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x65, 66,
             0xB9, 0x64, 103]
        )
    }
    
    func testRPN_MIDI1_EventToBytes_DataEntryMSB() {
        let rpn: [MIDIEvent] = MIDIEvent.midi1RPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: 127,
                dataEntryLSB: nil
            ),
            channel: 0x9
        )
    
        XCTAssertEqual(
            rpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x65, 66,
             0xB9, 0x64, 103,
             0xB9, 0x06, 127]
        )
    }
    
    func testRPN_MIDI1_EventToBytes_DataEntryMSBandLSB() {
        let rpn: [MIDIEvent] = MIDIEvent.midi1RPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: 127,
                dataEntryLSB: 2
            ),
            channel: 0x9
        )
    
        XCTAssertEqual(
            rpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x65, 66,
             0xB9, 0x64, 103,
             0xB9, 0x06, 127,
             0xB9, 0x26, 2]
        )
    }
    
    func testRPN_MIDI1_EventToBytes_Null() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1RPN(
            .null,
            channel: 0x9
        )
    
        XCTAssertEqual(
            nrpn.flatMap { $0.midi1RawBytes() },
            [0xB9, 0x65, 0x7F,
             0xB9, 0x64, 0x7F]
        )
    }
    
    // MARK: - Raw MIDI 1.0 Bytes -> MIDIEvent.umpRawWords()
    // TODO: add unit tests if/when aggregate CC/DataEntry parsing gets added to `MIDI1Parser`
    
    // MARK: - MIDIEvent.rpn() -> Raw MIDI 2.0 RPN UMP Words
    
    func testRPN_MIDI2_EventToWords_Absolute() {
        let nrpn: MIDIEvent = .rpn(
            .raw(
                parameter: .init(msb: 0x40, lsb: 0x01),
                dataEntryMSB: 0x12,
                dataEntryLSB: nil
            ),
            change: .absolute,
            channel: 0x9
        )
        
        XCTAssertEqual(
            nrpn.umpRawWords(protocol: .midi2_0),
            [[UMPWord(0x40, 0x29, 0x40, 0x01),
              UMPWord(0x24, 0x00, 0x00, 0x00)]]
        )
    }
    
    func testRPN_MIDI2_EventToWords_Relative() {
        let nrpn: MIDIEvent = .rpn(
            .raw(
                parameter: .init(msb: 0x40, lsb: 0x01),
                dataEntryMSB: 0x12,
                dataEntryLSB: nil
            ),
            change: .relative,
            channel: 0x9
        )
        
        XCTAssertEqual(
            nrpn.umpRawWords(protocol: .midi2_0),
            [[UMPWord(0x40, 0x49, 0x40, 0x01),
              UMPWord(0x24, 0x00, 0x00, 0x00)]]
        )
    }
    
    func testRPN_MIDI2_EventToWords_Null() {
        let nrpn: MIDIEvent = .rpn(
            .null,
            change: .absolute,
            channel: 0x9
        )
        
        XCTAssertEqual(
            nrpn.umpRawWords(protocol: .midi2_0),
            [[UMPWord(0x40, 0x29, 0x7F, 0x7F),
              UMPWord(0x00, 0x00, 0x00, 0x00)]]
        )
    }
    
    // MARK: - Raw MIDI 2.0 RPN UMP Words -> MIDIEvent.rpn()
    // See MIDIKitIO - MIDI2Parser Tests.swift
}

#endif
