//
//  MIDI1Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventMIDI1ParserTests: XCTestCase {
    
    func testMIDIPacketData_parseEvents_Empty() {
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
    }
    
    func testMIDIPacketData_parseEvents_SingleEvents() {
        
        // - channel voice
        
        // note off
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0x80, 0x3C, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.noteOff(note: 60, velocity: 64, channel: 0)]
        )
        
        // note on
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0x91, 0x3C, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.noteOn(note: 60, velocity: 64, channel: 1)]
        )
        
        // poly aftertouch
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xA4, 0x3C, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.polyAftertouch(note: 60, pressure: 64, channel: 4)]
        )
        
        // cc
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xB1, 0x01, 0x7F], timeStamp: 0)
                .parsedEvents().events,
            [.cc(controller: 1, value: 127, channel: 1)]
        )
        
        // program change
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xCA, 0x20], timeStamp: 0)
                .parsedEvents().events,
            [.programChange(program: 32, channel: 10)]
        )
        
        // channel aftertouch
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xD8, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.chanAftertouch(pressure: 64, channel: 8)]
        )
        
        // pitch bend
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xE3, 0x00, 0x40], timeStamp: 0)
                .parsedEvents().events,
            [.pitchBend(value: 8192, channel: 3)]
        )
        
        // - system messages
        
        // SysEx
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF0, 0x20, 0xF7], timeStamp: 0)
                .parsedEvents().events,
            [.sysEx(manufacturer: MIDI.Event.SysEx.Manufacturer(oneByte: 0x20)!, data: [])]
        )
        
        // System Common - timecode quarter-frame
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF1, 0x00], timeStamp: 0)
                .parsedEvents().events,
            [.timecodeQuarterFrame(byte: 0x00)]
        )
        
        // System Common - Song Position Pointer
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF2, 0x08, 0x00], timeStamp: 0)
                .parsedEvents().events,
            [.songPositionPointer(midiBeat: 8)]
        )
        
        // System Common - Song Select
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF3, 0x08], timeStamp: 0)
                .parsedEvents().events,
            [.songSelect(number: 8)]
        )
        
        // System Common - (0xF4 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF4], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // System Common - (0xF5 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF5], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // System Common - Tune Request
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF6], timeStamp: 0)
                .parsedEvents().events,
            [.tuneRequest]
        )
        
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // on its own, 0xF7 is ignored
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF7], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // real time: timing clock
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF8], timeStamp: 0)
                .parsedEvents().events,
            [.timingClock]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xF9], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // real time: start
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFA], timeStamp: 0)
                .parsedEvents().events,
            [.start]
        )
        
        // real time: continue
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFB], timeStamp: 0)
                .parsedEvents().events,
            [.continue]
        )
        
        // real time: stop
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFC], timeStamp: 0)
                .parsedEvents().events,
            [.stop]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFD], timeStamp: 0)
                .parsedEvents().events,
            []
        )
        
        // real time: active sensing
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFE], timeStamp: 0)
                .parsedEvents().events,
            [.activeSensing]
        )
        
        // real time: system reset
        XCTAssertEqual(
            MIDI.Packet.PacketData(bytes: [0xFF], timeStamp: 0)
                .parsedEvents().events,
            [.systemReset]
        )
        
    }
    
    func testMIDIPacketData_parseEvents_MultipleEvents() {
        
        // channel voice
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0x80, 0x3C, 0x40,
                    0x90, 0x3C, 0x40
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.noteOff(note: 60, velocity: 64, channel: 0),
             .noteOn(note: 60, velocity: 64, channel: 0)]
        )
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0xB1, 0x01, 0x7F,
                    0x96, 0x3C, 0x40,
                    0xB2, 0x02, 0x08
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.cc(controller: 1, value: 127, channel: 1),
             .noteOn(note: 60, velocity: 64, channel: 6),
             .cc(controller: 2, value: 8, channel: 2)]
        )
        
    }
    
    func testMIDIPacketData_parseEvents_RunningStatus_SinglePacket() {
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0x90,
                    0x3C, 0x40,
                    0x3D, 0x41
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.noteOn(note: 60, velocity: 64, channel: 0),
             .noteOn(note: 61, velocity: 65, channel: 0)]
        )
        
        XCTAssertEqual(
            MIDI.Packet.PacketData(
                bytes: [
                    0x9F,
                    0x3C, 0x40,
                    0x3D, 0x41,
                    0x3E, 0x42
                ],
                timeStamp: 0
            )
            .parsedEvents().events,
            
            [.noteOn(note: 60, velocity: 64, channel: 15),
             .noteOn(note: 61, velocity: 65, channel: 15),
             .noteOn(note: 62, velocity: 66, channel: 15)]
        )
        
    }
    
    func testMIDIPacketData_parseEvents_RunningStatus_SeparatePackets_Simple() {
        
        var parsed = MIDI.Packet.PacketData(
            bytes: [
                0x92,
                0x3C, 0x40
            ],
            timeStamp: 0
        )
        .parsedEvents(runningStatus: nil)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOn(note: 60, velocity: 64, channel: 2)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x92
        )
        
        parsed = MIDI.Packet.PacketData(
            bytes: [
                0x3E, 0x42
            ],
            timeStamp: 0
        )
        .parsedEvents(runningStatus: parsed.runningStatus)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOn(note: 62, velocity: 66, channel: 2)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x92
        )
        
        parsed = MIDI.Packet.PacketData(
            bytes: [
                0x84,
                0x01, 0x02
            ],
            timeStamp: 0
        )
        .parsedEvents(runningStatus: parsed.runningStatus)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOff(note: 1, velocity: 2, channel: 4)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x84
        )
        
    }
    
    func testMIDIPacketData_parseEvents_InsertedRealTimeMessages() {
        #warning("> test this")
    }
    
    #warning("> test all MIDI messages from parser!")
    
}
#endif
