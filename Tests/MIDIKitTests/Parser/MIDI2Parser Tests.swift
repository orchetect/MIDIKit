//
//  MIDI2Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventMIDI2ParserTests: XCTestCase {
    
    func testUniversalPacketData_parsedEvents_Empty() {
        
        XCTAssertEqual(
            MIDI.Packet.UniversalPacketData(bytes: [], timeStamp: .zero)
                .parsedEvents(),
            []
        )
        
    }
    
    func testUniversalPacketData_parsedEvents_SingleEvents_MIDI1_0() {
        
        // template method
        
        func parsedEvents(bytes: [MIDI.Byte]) -> [MIDI.Event] {
            MIDI.Packet.UniversalPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
        
        // - UMP MIDI 1.0 channel voice
        
        // note off
        XCTAssertEqual(
            parsedEvents(bytes: [0x20, 0x80, 0x3C, 0x40]),
            [.noteOff(60, velocity: .midi1(64), channel: 0, group: 0x0)]
        )
        
        // note on
        XCTAssertEqual(
            parsedEvents(bytes: [0x21, 0x91, 0x3C, 0x40]),
            [.noteOn(60, velocity: .midi1(64), channel: 1, group: 0x1)]
        )
        
        // poly aftertouch
        XCTAssertEqual(
            parsedEvents(bytes: [0x22, 0xA4, 0x3C, 0x40]),
            [.notePressure(note: 60, amount: .midi1(64), channel: 4, group: 0x2)]
        )
        
        // cc
        XCTAssertEqual(
            parsedEvents(bytes: [0x23, 0xB1, 0x01, 0x7F]),
            [.cc(1, value: .midi1(127), channel: 1, group: 0x3)]
        )
        
        // program change
        XCTAssertEqual(
            parsedEvents(bytes: [0x24, 0xCA, 0x20, 0x00]),
            [.programChange(program: 32, channel: 10, group: 0x4)]
        )
        
        // channel aftertouch
        XCTAssertEqual(
            parsedEvents(bytes: [0x25, 0xD8, 0x40, 0x00]),
            [.pressure(amount: .midi1(64), channel: 8, group: 0x5)]
        )
        
        // pitch bend
        XCTAssertEqual(
            parsedEvents(bytes: [0x26, 0xE3, 0x00, 0x40]),
            [.pitchBend(value: .midi1(8192), channel: 3, group: 0x6)]
        )
        
        // - UMP MIDI 1.0 system messages
        
        // SysEx
        XCTAssertEqual(
            parsedEvents(bytes:
                            [0x30, // UMP message type (0x3?), group 0 (0x?0)
                             0x02, // complete (0x0?) + 2 bytes (0x?2)
                             0x7D, 0x01, // SysEx7 data bytes
                             0x00, 0x00, 0x00, 0x00] // pad remaining bytes
                        ),
            [.sysEx(manufacturer: .oneByte(0x7D),
                    data: [0x01],
                    group: 0)
            ]
        )
        
        // System Common - timecode quarter-frame
        XCTAssertEqual(
            parsedEvents(bytes: [0x17, 0xF1, 0x00, 0x00]),
            [.timecodeQuarterFrame(dataByte: 0x00, group: 0x7)]
        )
        
        // System Common - Song Position Pointer
        XCTAssertEqual(
            parsedEvents(bytes: [0x18, 0xF2, 0x08, 0x00]),
            [.songPositionPointer(midiBeat: 8, group: 0x8)]
        )
        
        // System Common - Song Select
        XCTAssertEqual(
            parsedEvents(bytes: [0x19, 0xF3, 0x08, 0x00]),
            [.songSelect(number: 8, group: 0x9)]
        )
        
        // System Common - (0xF4 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            parsedEvents(bytes: [0x10, 0xF4, 0x00, 0x00]),
            []
        )
        
        // System Common - (0xF5 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            parsedEvents(bytes: [0x10, 0xF5, 0x00, 0x00]),
            []
        )
        
        // System Common - Tune Request
        XCTAssertEqual(
            parsedEvents(bytes: [0x1A, 0xF6, 0x00, 0x00]),
            [.tuneRequest(group: 0xA)]
        )
        
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // on its own, 0xF7 is ignored
        XCTAssertEqual(
            parsedEvents(bytes: [0x10, 0xF7, 0x00, 0x00]),
            []
        )
        
        // real time: timing clock
        XCTAssertEqual(
            parsedEvents(bytes: [0x1B, 0xF8, 0x00, 0x00]),
            [.timingClock(group: 0xB)]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            parsedEvents(bytes: [0x10, 0xF9, 0x00, 0x00]),
            []
        )
        
        // real time: start
        XCTAssertEqual(
            parsedEvents(bytes: [0x1C, 0xFA, 0x00, 0x00]),
            [.start(group: 0xC)]
        )
        
        // real time: continue
        XCTAssertEqual(
            parsedEvents(bytes: [0x1D, 0xFB, 0x00, 0x00]),
            [.continue(group: 0xD)]
        )
        
        // real time: stop
        XCTAssertEqual(
            parsedEvents(bytes: [0x1E, 0xFC, 0x00, 0x00]),
            [.stop(group: 0xE)]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            parsedEvents(bytes: [0x10, 0xFD, 0x00, 0x00]),
            []
        )
        
        // real time: active sensing
        XCTAssertEqual(
            parsedEvents(bytes: [0x1F, 0xFE, 0x00, 0x00]),
            [.activeSensing(group: 0xF)]
        )
        
        // real time: system reset
        XCTAssertEqual(
            parsedEvents(bytes: [0x10, 0xFF, 0x00, 0x00]),
            [.systemReset(group: 0x0)]
        )
        
    }
    
    func testUniversalPacketData_parsedEvents_MultipleEvents() {
        
        // UMP packets do not allow for multiple events in a single packet
        // UMP packets only ever contain a single discrete MIDI event
        // nothing to test
        
    }
    
    func testUniversalPacketData_parsedEvents_RunningStatus() {
        
        // MIDI 2.0 does not support/allow Running Status
        // UMP packets containing MIDI 1.0 events must always be the entire, complete message including status byte
        // UMP packets only ever contain a single discrete MIDI event, so Running Status within a single packet is not supported either
        // nothing to test
        
    }
    
    func testUniversalPacketData_parsedEvents_Malformed() {
        
        // template method
        
        func parsedEvents(bytes: [MIDI.Byte]) -> [MIDI.Event] {
            MIDI.Packet.UniversalPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
        
        // tests
        
        // UMP MIDI 1.0 events
        
        // data bytes (< 0x80) in the place of a MIDI 1.0 status byte are meaningless/malformed
        for byte: MIDI.Byte in 0x00...0x7F {
            XCTAssertEqual(parsedEvents(bytes: [0x20, byte, 0x00, 0x00]), []) // nulls
            XCTAssertEqual(parsedEvents(bytes: [0x20, byte, 0x40, 0x40]), []) // arbitrary data
        }
        
        // non-UInt32 aligned data layout (multiples of 4 bytes)
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80, 0x01]), [])
        // valid 4-byte UInt32 word followed by non-uniform 1...3 bytes:
        //   - technically a malformed packet
        //   - this would almost never happen since UMP packets are always 4-byte aligned;
        //   - the only way we would encounter non-4 byte alignment is if we feed raw bytes
        //     into the parser such as this
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80, 0x01, 0x02,
                                            0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80, 0x01, 0x02,
                                            0x00, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80, 0x01, 0x02,
                                            0x00, 0x00, 0x00]), [])
        
        // note off
        // - requires two data bytes to follow, which fills out the entire word without needing null byte padding
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x80, 0x80, 0x80]), [])
        
        // note on
        // - requires two data bytes to follow, which fills out the entire word without needing null byte padding
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x90, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x90, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0x90, 0x80, 0x80]), [])
        
        // poly aftertouch
        // - requires two data bytes to follow, which fills out the entire word without needing null byte padding
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xA0, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xA0, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xA0, 0x80, 0x80]), [])
        
        // cc
        // - requires two data bytes to follow, which fills out the entire word without needing null byte padding
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xB0, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xB0, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xB0, 0x80, 0x80]), [])
        
        // program change
        // - requires one data byte to follow, with one null byte trailing padding
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xC0, 0x00, 0x80]),
                       [.programChange(program: 0, channel: 0, group: 0)])
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xC0, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xC0, 0x80, 0x80]), [])
        
        // channel aftertouch
        // - requires one data byte to follow, with one null byte trailing padding
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xD0, 0x00, 0x80]),
                       [.pressure(amount: .midi1(0), channel: 0, group: 0)])
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xD0, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xD0, 0x80, 0x80]), [])
        
        // pitch bend
        // - requires two data bytes to follow, which fills out the entire word without needing null byte padding
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xE0, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xE0, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xE0, 0x80, 0x80]), [])
        
        // System Common - System Exclusive start
        // - not allowed in UMP packets - test for rejection
        // - UMP message type 0x2 (MIDI 1 channel voice) can only be used for MIDI 1 channel voice messages and not MIDI 1 sysex/common/realtime so this must be rejected
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xF0, 0x00, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xF0, 0x01, 0x02]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xF0, 0x01, 0xF7]), [])
        // - UMP message type 0x2 (MIDI 1 channel voice) must always be a single 4-byte UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xF0, 0x00, 0x00,
                                            0x00, 0x00, 0x00, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xF0, 0x01, 0x02,
                                            0x03, 0x04, 0x05, 0x06]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xF0, 0x01, 0x02,
                                            0x03, 0x04, 0x05, 0xF7]), [])
        // - SysEx7 must be 64-bit (8 byte / 2 UInt32 word) packet, so a 4 byte packet will be rejected.
        // - also, 0xF0 and 0xF7 bytes must be omitted in UMP SysEx packets
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF0, 0x00, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF0, 0x01, 0x02]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF0, 0x01, 0xF7]), [])
        
        // System Common - Timecode quarter-frame
        // [msgtype+group, 0xF1, data byte, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF1, 0x01, 0x00]),
                       [.timecodeQuarterFrame(dataByte: 0x01, group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF1, 0x01, 0x01]),
                       [.timecodeQuarterFrame(dataByte: 0x01, group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF1, 0x01, 0x80]),
                       [.timecodeQuarterFrame(dataByte: 0x01, group: 0x0)])
        // test data byte > 127
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF1, 0x80, 0x00]), [])
        
        // System Common - Song Position Pointer
        // [msgtype+group, 0xF2, lsb byte, msb byte]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF2, 0x08, 0x00]),
                       [.songPositionPointer(midiBeat: 8)])
        // test data byte(s) > 127
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF2, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF2, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF2, 0x80, 0x80]), [])
        
        // System Common - Song Select
        // [msgtype+group, 0xF3, data byte, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF3, 0x3C, 0x00]),
                       [.songSelect(number: 0x3C)])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF3, 0x3C, 0x80]),
                       [.songSelect(number: 0x3C)])
        // test data byte > 127
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF3, 0x80, 0x00]), [])
        
        // System Common - Undefined
        // [msgtype+group, 0xF4, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF4, 0x00, 0x00]), [])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF4, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF4, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF4, 0x80, 0x80]), [])
        
        // System Common - Undefined
        // [msgtype+group, 0xF5, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF5, 0x00, 0x00]), [])
        // -trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF5, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF5, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF5, 0x80, 0x80]), [])
        
        // System Common - Tune Request
        // [msgtype+group, 0xF6, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF6, 0x00, 0x00]),
                       [.tuneRequest(group: 0x0)])
        // -trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF6, 0x80, 0x00]),
                       [.tuneRequest(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF6, 0x00, 0x80]),
                       [.tuneRequest(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF6, 0x80, 0x80]),
                       [.tuneRequest(group: 0x0)])
        
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // - not allowed in UMP packets - test for rejection
        // - UMP message type 0x2 (MIDI 1 channel voice) can only be used for MIDI 1 channel voice messages and not MIDI 1 sysex/common/realtime so this must be rejected
        XCTAssertEqual(parsedEvents(bytes: [0x20, 0xF7, 0x01, 0x00]), [])
        // - SysEx7 must be 64-bit (8 byte / 2 UInt32 word) packet, so a 4 byte packet will be rejected.
        // - also, 0xF0 and 0xF7 bytes must be omitted in UMP SysEx packets
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF7, 0x01, 0x00]), [])
        
        // System Real Time - Timing Clock
        // [msgtype+group, 0xF8, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF8, 0x00, 0x00]),
                       [.timingClock(group: 0x0)])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF8, 0x80, 0x00]),
                       [.timingClock(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF8, 0x00, 0x80]),
                       [.timingClock(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF8, 0x80, 0x80]),
                       [.timingClock(group: 0x0)])
        
        // Real Time - Undefined
        // [msgtype+group, 0xF9, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF9, 0x00, 0x00]), [])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF9, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF9, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xF9, 0x80, 0x80]), [])
        
        // System Real Time - Start
        // [msgtype+group, 0xFA, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFA, 0x00, 0x00]),
                       [.start(group: 0x0)])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFA, 0x80, 0x00]),
                       [.start(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFA, 0x00, 0x80]),
                       [.start(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFA, 0x80, 0x80]),
                       [.start(group: 0x0)])
        
        // System Real Time - Continue
        // [msgtype+group, 0xFB, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFB, 0x00, 0x00]),
                       [.continue(group: 0x0)])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFB, 0x80, 0x00]),
                       [.continue(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFB, 0x00, 0x80]),
                       [.continue(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFB, 0x80, 0x80]),
                       [.continue(group: 0x0)])
        
        // System Real Time - Stop
        // [msgtype+group, 0xFC, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFC, 0x00, 0x00]),
                       [.stop(group: 0x0)])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFC, 0x80, 0x00]),
                       [.stop(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFC, 0x00, 0x80]),
                       [.stop(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFC, 0x80, 0x80]),
                       [.stop(group: 0x0)])
        
        // System Real Time - Undefined
        // [msgtype+group, 0xFD, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFD, 0x00, 0x00]), [])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFD, 0x80, 0x00]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFD, 0x00, 0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFD, 0x80, 0x80]), [])
        
        // System Real Time - Active Sensing
        // [msgtype+group, 0xFE, 0x00, 0x00]
        // - in MIDI2.0/UMP spec are not used and discouraged, but are allowed
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFE, 0x00, 0x00]),
                       [.activeSensing(group: 0x0)])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFE, 0x80, 0x00]),
                       [.activeSensing(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFE, 0x00, 0x80]),
                       [.activeSensing(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFE, 0x80, 0x80]),
                       [.activeSensing(group: 0x0)])
        
        // System Real Time - System Reset
        // [msgtype+group, 0xFF, 0x00, 0x00]
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFF, 0x00, 0x00]),
                       [.systemReset(group: 0x0)])
        // - trailing bytes should be null (0x00) but it doesn't really matter what they are since they are discarded and merely there to fill out all four bytes of the UInt32 word
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFF, 0x80, 0x00]),
                       [.systemReset(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFF, 0x00, 0x80]),
                       [.systemReset(group: 0x0)])
        XCTAssertEqual(parsedEvents(bytes: [0x10, 0xFF, 0x80, 0x80]),
                       [.systemReset(group: 0x0)])
        
    }
    
    #warning("> write MIDI2 multi-packet SysEx7 / SysEx8 test")
    
    #warning("> write remaining MIDI2/UMP tests")
    
}

#endif
