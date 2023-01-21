//
//  Temporary Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitIO

final class Temporary_Tests: XCTestCase {
    private let midi1Parser = MIDI1Parser()
    private let midi2Parser = MIDI2Parser()
    
    private func parse(umpBytes: [UInt8]) -> [MIDIEvent] {
        let p = UniversalMIDIPacketData(bytes: umpBytes, timeStamp: 0)
        return midi2Parser.parsedEvents(in: p)
    }
    
    func testPackets1() {
        // 0x40, 0xB9, 0x63, 0x00, 0x80, 0x00, 0x00, 0x00
        // cc#99 val:midi2(2147483648) chan:0x9
        
        print(parse(umpBytes: [0x40, 0xB9, 0x63, 0x00, 0x80, 0x00, 0x00, 0x00]))
        // -> [cc(99, val: midi1(64)/midi2(2147483648), chan: 0x9, group: 0x0)]
    }
    
    func testPackets2() {
        // 0x40, 0xB9, 0x62, 0x00, 0x02, 0x00, 0x00, 0x00
        // cc#98 val:midi2(33554432) chan:0x9
        
        print(parse(umpBytes: [0x40, 0xB9, 0x62, 0x00, 0x02, 0x00, 0x00, 0x00]))
        // -> [cc(98, val: midi1(1)/midi2(33554432), chan: 0x9, group: 0x0)]
    }
    
    #warning("> finish this")
    func testPackets3() {
        // 0x40, 0x39, 0x40, 0x01, 0x12, 0x00, 0x00, 0x00
        // 0x40, 0xB9, 0x63, 0x00, 0x85, 0x0A, 0x14, 0x28
        // cc#99 val:midi2(2232030248) chan:0x9

        print(parse(umpBytes: [0x40, 0x39, 0x40, 0x01, 0x12, 0x00, 0x00, 0x00]))
        // [nrpn(raw(param: [msb: 0x40, lsb: 0x01], dataMSB: 9, dataLSB: 0), change: absolute, chan: 0x9, group: 0x0)]

        print(parse(umpBytes: [0x40, 0xB9, 0x63, 0x00, 0x85, 0x0A, 0x14, 0x28]))
        // -> [cc(99, val: midi1(66)/midi2(2232030248), chan: 0x9, group: 0x0)]
    }
    
//    func testDummy() {
//        _ = MIDIEvent.midi1NRPN(
//            .raw(parameter: .init(msb: 1, lsb: 2), dataEntryMSB: 0, dataEntryLSB: 0),
//            channel: 0
//        )
//    }
    
    func testPackets4() {
        // 0x40, 0x39, 0x40, 0x68, 0xFE, 0x03, 0xF8, 0x0F
        // not parsing
        
        // valid - data is scaled to 32 bit
        print(parse(umpBytes: [0x40, 0x39, 0x40, 0x68, 0xFE, 0x03, 0xF8, 0x0F]))
        
        print(parse(umpBytes: [0x40, 0xC9, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00]))
    }
    
    // test doesn't really prove anything - can delete
    func testRPNValueScaling() {
        // template method
        
        let parser = MIDI2Parser()
        
        for val in UInt14.min ... UInt14.max {
            let valPair = val.midiUInt7Pair
            let rpn: MIDIEvent = MIDIEvent.rpn(
                parameter: .init(msb: 00, lsb: 01),
                data: (msb: valPair.msb, lsb: valPair.lsb),
                channel: 0
            )
            let words = rpn.umpRawWords(protocol: ._2_0).first!
            
            let packet = UniversalMIDIPacketData(words: words, timeStamp: .zero)
            
            let events = parser.parsedEvents(in: packet)
            
            XCTAssertEqual([rpn], events)
        }
        
    }
}

#endif
