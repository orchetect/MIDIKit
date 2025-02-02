//
//  CC NRPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct MIDIEvent_CC_NRPN_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    // MARK: - MIDIEvent.midi1NRPN() -> Raw MIDI 1.0 Bytes
    
    @Test
    func nrpn_MIDI1_EventToBytes_NoDataEntry() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: nil,
                dataEntryLSB: nil
            ),
            channel: 0x9
        )
        
        #expect(
            nrpn.flatMap { $0.midi1RawBytes() } ==
                [0xB9, 0x63, 66,
                 0xB9, 0x62, 103]
        )
    }
    
    @Test
    func nrpn_MIDI1_EventToBytes_DataEntryMSB() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: 127,
                dataEntryLSB: nil
            ),
            channel: 0x9
        )
        
        #expect(
            nrpn.flatMap { $0.midi1RawBytes() } ==
                [0xB9, 0x63, 66,
                 0xB9, 0x62, 103,
                 0xB9, 0x06, 127]
        )
    }
    
    @Test
    func nrpn_MIDI1_EventToBytes_DataEntryMSBandLSB() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .raw(
                parameter: .init(msb: 66, lsb: 103),
                dataEntryMSB: 127,
                dataEntryLSB: 2
            ),
            channel: 0x9
        )
        
        #expect(
            nrpn.flatMap { $0.midi1RawBytes() } ==
                [0xB9, 0x63, 66,
                 0xB9, 0x62, 103,
                 0xB9, 0x06, 127,
                 0xB9, 0x26, 2]
        )
    }
    
    @Test
    func nrpn_MIDI1_EventToBytes_Null() {
        let nrpn: [MIDIEvent] = MIDIEvent.midi1NRPN(
            .null,
            channel: 0x9
        )
        
        #expect(
            nrpn.flatMap { $0.midi1RawBytes() } ==
                [0xB9, 0x63, 0x7F,
                 0xB9, 0x62, 0x7F]
        )
    }
    
    // MARK: - Raw MIDI 1.0 Bytes -> MIDIEvent.nrpn()
    // See MIDIKitIO - MIDI1Parser Tests.swift
    
    // MARK: - MIDIEvent.nrpn() -> Raw MIDI 2.0 RPN UMP Words
    
    @Test
    func nrpn_MIDI2_EventToWords_Absolute() {
        let nrpn: MIDIEvent = .nrpn(
            .raw(
                parameter: .init(msb: 0x40, lsb: 0x01),
                dataEntryMSB: 0x12,
                dataEntryLSB: nil
            ),
            change: .absolute,
            channel: 0x9
        )
        
        #expect(
            nrpn.umpRawWords(protocol: .midi2_0) ==
                [[UMPWord(0x40, 0x39, 0x40, 0x01),
                  UMPWord(0x24, 0x00, 0x00, 0x00)]]
        )
    }
    
    @Test
    func nrpn_MIDI2_EventToWords_Relative() {
        let nrpn: MIDIEvent = .nrpn(
            .raw(
                parameter: .init(msb: 0x40, lsb: 0x01),
                dataEntryMSB: 0x12,
                dataEntryLSB: nil
            ),
            change: .relative,
            channel: 0x9
        )
        
        #expect(
            nrpn.umpRawWords(protocol: .midi2_0) ==
                [[UMPWord(0x40, 0x59, 0x40, 0x01),
                  UMPWord(0x24, 0x00, 0x00, 0x00)]]
        )
    }
    
    @Test
    func nrpn_MIDI2_EventToWords_Null() {
        let nrpn: MIDIEvent = .nrpn(
            .null,
            change: .absolute,
            channel: 0x9
        )
        
        #expect(
            nrpn.umpRawWords(protocol: .midi2_0) ==
                [[UMPWord(0x40, 0x39, 0x7F, 0x7F),
                  UMPWord(0x00, 0x00, 0x00, 0x00)]]
        )
    }
    
    // MARK: - Raw MIDI 2.0 RPN UMP Words -> MIDIEvent.nrpn()
    // See MIDIKitIO - MIDI2Parser Tests.swift
}
