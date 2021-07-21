//
//  Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class MIDIEventParserTests: XCTestCase {
    
    func testMIDIPacketData_parseEvents_Empty() {
        
        XCTAssertEqual(
            MIDI.PacketData(data: [], timeStamp: 0)
                .parsedMIDI1Events().events,
            []
        )
        
    }
    
    func testMIDIPacketData_parseEvents_SingleEvents() {
        
        // - channel voice
        
        // note off
        XCTAssertEqual(
            MIDI.PacketData(data: [0x80, 0x3C, 0x40], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.noteOff(note: 60, velocity: 64, channel: 0)]
        )
        
        // note on
        XCTAssertEqual(
            MIDI.PacketData(data: [0x91, 0x3C, 0x40], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.noteOn(note: 60, velocity: 64, channel: 1)]
        )
        
        // poly aftertouch
        XCTAssertEqual(
            MIDI.PacketData(data: [0xA4, 0x3C, 0x40], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.polyAftertouch(note: 60, pressure: 64, channel: 4)]
        )
        
        // cc
        XCTAssertEqual(
            MIDI.PacketData(data: [0xB1, 0x01, 0x7F], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.cc(controller: 1, value: 127, channel: 1)]
        )
        
        // program change
        XCTAssertEqual(
            MIDI.PacketData(data: [0xCA, 0x20], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.programChange(program: 32, channel: 10)]
        )
        
        // channel aftertouch
        XCTAssertEqual(
            MIDI.PacketData(data: [0xD8, 0x40], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.chanAftertouch(pressure: 64, channel: 8)]
        )
        
        // pitch bend
        XCTAssertEqual(
            MIDI.PacketData(data: [0xE3, 0x00, 0x40], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.pitchBend(value: 8192, channel: 3)]
        )
        
        // - system messages
        
        // SysEx
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF0, 0x20, 0xF7], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.sysEx(manufacturer: MIDI.Event.SysEx.Manufacturer(oneByte: 0x20)!, data: [])]
        )
        
        // System Common - timecode quarter-frame
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF1, 0x00], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.timecodeQuarterFrame(byte: 0x00)]
        )
        
        // System Common - Song Position Pointer
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF2, 0x08, 0x00], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.songPositionPointer(midiBeat: 8)]
        )
        
        // System Common - Song Select
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF3, 0x08], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.songSelect(number: 8)]
        )
        
        // System Common - (0xF4 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF4], timeStamp: 0)
                .parsedMIDI1Events().events,
            []
        )
        
        // System Common - (0xF5 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF5], timeStamp: 0)
                .parsedMIDI1Events().events,
            []
        )
        
        // System Common - Tune Request
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF6], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.tuneRequest]
        )
        
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // on its own, 0xF7 is ignored
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF7], timeStamp: 0)
                .parsedMIDI1Events().events,
            []
        )
        
        // real time: timing clock
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF8], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.timingClock]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            MIDI.PacketData(data: [0xF9], timeStamp: 0)
                .parsedMIDI1Events().events,
            []
        )
        
        // real time: start
        XCTAssertEqual(
            MIDI.PacketData(data: [0xFA], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.start]
        )
        
        // real time: continue
        XCTAssertEqual(
            MIDI.PacketData(data: [0xFB], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.continue]
        )
        
        // real time: stop
        XCTAssertEqual(
            MIDI.PacketData(data: [0xFC], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.stop]
        )
        
        // real time: (undefined)
        XCTAssertEqual(
            MIDI.PacketData(data: [0xFD], timeStamp: 0)
                .parsedMIDI1Events().events,
            []
        )
        
        // real time: active sensing
        XCTAssertEqual(
            MIDI.PacketData(data: [0xFE], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.activeSensing]
        )
        
        // real time: system reset
        XCTAssertEqual(
            MIDI.PacketData(data: [0xFF], timeStamp: 0)
                .parsedMIDI1Events().events,
            [.systemReset]
        )
        
    }
    
    func testMIDIPacketData_parseEvents_MultipleEvents() {
        
        // channel voice
        
        XCTAssertEqual(
            MIDI.PacketData(
                data: [
                    0x80, 0x3C, 0x40,
                    0x90, 0x3C, 0x40
                ],
                timeStamp: 0
            )
            .parsedMIDI1Events().events,
            
            [.noteOff(note: 60, velocity: 64, channel: 0),
             .noteOn(note: 60, velocity: 64, channel: 0)]
        )
        
        XCTAssertEqual(
            MIDI.PacketData(
                data: [
                    0xB1, 0x01, 0x7F,
                    0x96, 0x3C, 0x40,
                    0xB2, 0x02, 0x08
                ],
                timeStamp: 0
            )
            .parsedMIDI1Events().events,
            
            [.cc(controller: 1, value: 127, channel: 1),
             .noteOn(note: 60, velocity: 64, channel: 6),
             .cc(controller: 2, value: 8, channel: 2)]
        )
        
    }
    
    func testMIDIPacketData_parseEvents_RunningStatus_SinglePacket() {
        
        XCTAssertEqual(
            MIDI.PacketData(
                data: [
                    0x90,
                    0x3C, 0x40,
                    0x3D, 0x41
                ],
                timeStamp: 0
            )
            .parsedMIDI1Events().events,
            
            [.noteOn(note: 60, velocity: 64, channel: 0),
             .noteOn(note: 61, velocity: 65, channel: 0)]
        )
        
        XCTAssertEqual(
            MIDI.PacketData(
                data: [
                    0x9F,
                    0x3C, 0x40,
                    0x3D, 0x41,
                    0x3E, 0x42
                ],
                timeStamp: 0
            )
            .parsedMIDI1Events().events,
            
            [.noteOn(note: 60, velocity: 64, channel: 15),
             .noteOn(note: 61, velocity: 65, channel: 15),
             .noteOn(note: 62, velocity: 66, channel: 15)]
        )
        
    }
    
    func testMIDIPacketData_parseEvents_RunningStatus_SeparatePackets_Simple() {
        
        var parsed = MIDI.PacketData(
            data: [
                0x92,
                0x3C, 0x40
            ],
            timeStamp: 0
        )
        .parsedMIDI1Events(runningStatus: nil)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOn(note: 60, velocity: 64, channel: 2)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x92
        )
        
        parsed = MIDI.PacketData(
            data: [
                0x3E, 0x42
            ],
            timeStamp: 0
        )
        .parsedMIDI1Events(runningStatus: parsed.runningStatus)
        
        XCTAssertEqual(
            parsed.events,
            [.noteOn(note: 62, velocity: 66, channel: 2)]
        )
        
        XCTAssertEqual(
            parsed.runningStatus,
            0x92
        )
        
        parsed = MIDI.PacketData(
            data: [
                0x84,
                0x01, 0x02
            ],
            timeStamp: 0
        )
        .parsedMIDI1Events(runningStatus: parsed.runningStatus)
        
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
