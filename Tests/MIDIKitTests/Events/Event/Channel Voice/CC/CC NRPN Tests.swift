//
//  CC NRPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEventCCNRPN_Tests: XCTestCase {
    
    typealias NRPN = MIDI.Event.CC.Controller.NRPN
    
    func testNRPN_MIDI1_NoDataEntry() {
        
        let nrpn: [MIDI.Event] = MIDI.Event.ccNRPN(.raw(parameter: .init(msb: 66, lsb: 103),
                                                        dataEntryMSB: nil,
                                                        dataEntryLSB: nil),
                                                   channel: 0x9)
        
        XCTAssertEqual(nrpn.flatMap { $0.midi1RawBytes() },
                       [0xB9, 0x63, 66,
                        0xB9, 0x62, 103])
        
    }
    
    func testNRPN_MIDI1_DataEntryMSB() {
        
        let nrpn: [MIDI.Event] = MIDI.Event.ccNRPN(.raw(parameter: .init(msb: 66, lsb: 103),
                                                        dataEntryMSB: 127,
                                                        dataEntryLSB: nil),
                                                   channel: 0x9)
        
        XCTAssertEqual(nrpn.flatMap { $0.midi1RawBytes() },
                       [0xB9, 0x63, 66,
                        0xB9, 0x62, 103,
                        0xB9, 0x06, 127])
        
    }
    
    func testNRPN_MIDI1_testRPN_MIDI1_DataEntryMSBandLSB() {
        
        let nrpn: [MIDI.Event] = MIDI.Event.ccNRPN(.raw(parameter: .init(msb: 66, lsb: 103),
                                                        dataEntryMSB: 127,
                                                        dataEntryLSB: 2),
                                                   channel: 0x9)
        
        XCTAssertEqual(nrpn.flatMap { $0.midi1RawBytes() },
                       [0xB9, 0x63, 66,
                        0xB9, 0x62, 103,
                        0xB9, 0x06, 127,
                        0xB9, 0x26, 2])
        
    }
    
    func testNRPN_MIDI1_Null() {
        
        let nrpn: [MIDI.Event] = MIDI.Event.ccNRPN(.null,
                                                   channel: 0x9)
        
        XCTAssertEqual(nrpn.flatMap { $0.midi1RawBytes() },
                       [0xB9, 0x63, 0x7F,
                        0xB9, 0x62, 0x7F])
        
    }
    
}

#endif
