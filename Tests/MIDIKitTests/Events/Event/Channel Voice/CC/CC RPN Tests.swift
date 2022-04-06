//
//  CC RPN Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEventCCRPN_Tests: XCTestCase {
    
    typealias RPN = MIDI.Event.CC.Controller.RPN
    
    func testRPN_MIDI1_NoDataEntry() {
        
        let rpn: [MIDI.Event] = MIDI.Event.ccRPN(.raw(parameter: .init(msb: 66, lsb: 103),
                                                      dataEntryMSB: nil,
                                                      dataEntryLSB: nil),
                                                 channel: 0x9)
        
        XCTAssertEqual(rpn.flatMap(\.midi1RawBytes),
                       [0xB9, 0x65, 66,
                        0xB9, 0x64, 103])
        
    }
    
    func testRPN_MIDI1_DataEntryMSB() {
        
        let rpn: [MIDI.Event] = MIDI.Event.ccRPN(.raw(parameter: .init(msb: 66, lsb: 103),
                                                      dataEntryMSB: 127,
                                                      dataEntryLSB: nil),
                                                 channel: 0x9)
        
        XCTAssertEqual(rpn.flatMap(\.midi1RawBytes),
                       [0xB9, 0x65, 66,
                        0xB9, 0x64, 103,
                        0xB9, 0x06, 127])
        
    }
    
    func testRPN_MIDI1_testRPN_MIDI1_DataEntryMSBandLSB() {
        
        let rpn: [MIDI.Event] = MIDI.Event.ccRPN(.raw(parameter: .init(msb: 66, lsb: 103),
                                                      dataEntryMSB: 127,
                                                      dataEntryLSB: 2),
                                                 channel: 0x9)
        
        XCTAssertEqual(rpn.flatMap(\.midi1RawBytes),
                       [0xB9, 0x65, 66,
                        0xB9, 0x64, 103,
                        0xB9, 0x06, 127,
                        0xB9, 0x26, 2])
        
    }
    
}

#endif
