//
//  MIDI1Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import XCTest

final class MIDI1Parser_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testPacketData_parsedEvents_Empty() {
        XCTAssertEqual(
            MIDIPacketData(bytes: [], timeStamp: .zero)
                .parsedEvents(),
            []
        )
    }
    
    func testPacketData_parsedEvents_SingleEvents() {
        // template method
    
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            MIDIPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
    
        // - channel voice
    
        // note off
        XCTAssertEqual(
            parsedEvents(bytes: [0x80, 0x3C, 0x40]),
            [.noteOff(60, velocity: .midi1(64), channel: 0, group: 0)]
        )
    
        // note on
        XCTAssertEqual(
            parsedEvents(bytes: [0x91, 0x3C, 0x40]),
            [.noteOn(60, velocity: .midi1(64), channel: 1, group: 0)]
        )
    
        // poly aftertouch
        XCTAssertEqual(
            parsedEvents(bytes: [0xA4, 0x3C, 0x40]),
            [.notePressure(note: 60, amount: .midi1(64), channel: 4, group: 0)]
        )
    
        // cc
        XCTAssertEqual(
            parsedEvents(bytes: [0xB1, 0x01, 0x7F]),
            [.cc(1, value: .midi1(127), channel: 1, group: 0)]
        )
    
        // program change
        XCTAssertEqual(
            parsedEvents(bytes: [0xCA, 0x40]),
            [.programChange(program: 64, channel: 10, group: 0)]
        )
        // MIDI1Parser does not wait for trailing program change event in order to bundle them in a `.programChange` event.
        // It is more idiomatic to MIDI 2.0 than MIDI 1.0.
        // TODO: It could be implemented as an optional parser feature in future, similar to MIDI2Parser's RPN/NRPN bundling ability.
        XCTAssertEqual(
            parsedEvents(bytes: [0xBA, 0x00, 0x10,
                                 0xBA, 0x20, 0x01,
                                 0xCA, 0x40]),
            [
                .cc(0, value: .midi1(0x10), channel: 10, group: 0x0),
                .cc(32, value: .midi1(0x01), channel: 10, group: 0x0),
                .programChange(program: 64, /* bank: .bankSelect(msb: 0x10, lsb: 0x01), */ channel: 10, group: 0)
            ]
        )
    
        // channel aftertouch
        XCTAssertEqual(
            parsedEvents(bytes: [0xD8, 0x40]),
            [.pressure(amount: .midi1(64), channel: 8, group: 0)]
        )
    
        // pitch bend
        XCTAssertEqual(
            parsedEvents(bytes: [0xE3, 0x00, 0x40]),
            [.pitchBend(value: .midi1(8192), channel: 3, group: 0)]
        )
    
        // - system messages
    
        // SysEx
        XCTAssertEqual(
            parsedEvents(bytes: [0xF0, 0x7D, 0x01, 0xF7]),
            try [.sysEx7(
                manufacturer: .oneByte(0x7D),
                data: [0x01],
                group: 0
            )]
        )
    
        // System Common - timecode quarter-frame
        XCTAssertEqual(
            parsedEvents(bytes: [0xF1, 0x00]),
            [.timecodeQuarterFrame(dataByte: 0x00, group: 0)]
        )
    
        // System Common - Song Position Pointer
        XCTAssertEqual(
            parsedEvents(bytes: [0xF2, 0x08, 0x00]),
            [.songPositionPointer(midiBeat: 8, group: 0)]
        )
    
        // System Common - Song Select
        XCTAssertEqual(
            parsedEvents(bytes: [0xF3, 0x08]),
            [.songSelect(number: 8, group: 0)]
        )
    
        // System Common - (0xF4 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            parsedEvents(bytes: [0xF4]),
            []
        )
    
        // System Common - (0xF5 is undefined in MIDI 1.0 Spec)
        XCTAssertEqual(
            parsedEvents(bytes: [0xF5]),
            []
        )
    
        // System Common - Tune Request
        XCTAssertEqual(
            parsedEvents(bytes: [0xF6]),
            [.tuneRequest(group: 0)]
        )
    
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // on its own, 0xF7 is ignored
        XCTAssertEqual(
            parsedEvents(bytes: [0xF7]),
            []
        )
    
        // System Real-Time - timing clock
        XCTAssertEqual(
            parsedEvents(bytes: [0xF8]),
            [.timingClock(group: 0)]
        )
    
        // System Real-Time - (undefined)
        XCTAssertEqual(
            parsedEvents(bytes: [0xF9]),
            []
        )
    
        // System Real-Time - start
        XCTAssertEqual(
            parsedEvents(bytes: [0xFA]),
            [.start(group: 0)]
        )
    
        // System Real-Time - continue
        XCTAssertEqual(
            parsedEvents(bytes: [0xFB]),
            [.continue(group: 0)]
        )
    
        // System Real-Time - stop
        XCTAssertEqual(
            parsedEvents(bytes: [0xFC]),
            [.stop(group: 0)]
        )
    
        // System Real-Time - (undefined)
        XCTAssertEqual(
            parsedEvents(bytes: [0xFD]),
            []
        )
    
        // System Real-Time - active sensing
        XCTAssertEqual(
            parsedEvents(bytes: [0xFE]),
            [.activeSensing(group: 0)]
        )
    
        // System Real-Time - system reset
        XCTAssertEqual(
            parsedEvents(bytes: [0xFF]),
            [.systemReset(group: 0)]
        )
    }
    
    func testPacketData_parsedEvents_MultipleEvents() {
        // channel voice
    
        XCTAssertEqual(
            MIDIPacketData(
                bytes: [
                    0x80, 0x3C, 0x40,
                    0x90, 0x3C, 0x40
                ],
                timeStamp: .zero
            )
            .parsedEvents(),
            
            [.noteOff(60, velocity: .midi1(64), channel: 0),
             .noteOn(60, velocity: .midi1(64), channel: 0)]
        )
    
        XCTAssertEqual(
            MIDIPacketData(
                bytes: [
                    0xB1, 0x01, 0x7F,
                    0x96, 0x3C, 0x40,
                    0xB2, 0x02, 0x08
                ],
                timeStamp: .zero
            )
            .parsedEvents(),
            
            [.cc(1, value: .midi1(127), channel: 1),
             .noteOn(60, velocity: .midi1(64), channel: 6),
             .cc(2, value: .midi1(8), channel: 2)]
        )
    }
    
    func testPacketData_parsedEvents_RunningStatus_SinglePacket() {
        XCTAssertEqual(
            MIDIPacketData(
                bytes: [
                    0x90,
                    0x3C, 0x40,
                    0x3D, 0x41
                ],
                timeStamp: .zero
            )
            .parsedEvents(),
            
            [.noteOn(60, velocity: .midi1(64), channel: 0),
             .noteOn(61, velocity: .midi1(65), channel: 0)]
        )
    
        XCTAssertEqual(
            MIDIPacketData(
                bytes: [
                    0x9F,
                    0x3C, 0x40,
                    0x3D, 0x41,
                    0x3E, 0x42
                ],
                timeStamp: .zero
            )
            .parsedEvents(),
            
            [.noteOn(60, velocity: .midi1(64), channel: 15),
             .noteOn(61, velocity: .midi1(65), channel: 15),
             .noteOn(62, velocity: .midi1(66), channel: 15)]
        )
    }
    
    func testPacketData_parsedEvents_RunningStatus_SeparatePackets_Simple() {
        MIDI1Parser.default.runningStatus = nil
        
        var parsed = MIDIPacketData(
            bytes: [
                0x92,
                0x3C, 0x40
            ],
            timeStamp: .zero
        )
        .parsedEvents()
    
        XCTAssertEqual(
            parsed,
            [.noteOn(60, velocity: .midi1(64), channel: 2)]
        )
        
        XCTAssertEqual(
            MIDI1Parser.default.runningStatus,
            0x92
        )
        
        parsed = MIDIPacketData(
            bytes: [
                0x3E, 0x42
            ],
            timeStamp: .zero
        )
        .parsedEvents()
        
        XCTAssertEqual(
            parsed,
            [.noteOn(62, velocity: .midi1(66), channel: 2)]
        )
        
        XCTAssertEqual(
            MIDI1Parser.default.runningStatus,
            0x92
        )
        
        parsed = MIDIPacketData(
            bytes: [
                0x84,
                0x01, 0x02
            ],
            timeStamp: .zero
        )
        .parsedEvents()
    
        XCTAssertEqual(
            parsed,
            [.noteOff(1, velocity: .midi1(2), channel: 4)]
        )
    
        XCTAssertEqual(
            MIDI1Parser.default.runningStatus,
            0x84
        )
    }
    
    func testPacketData_parsedEvents_MidstreamRealTimeMessages_SinglePacket() {
        // template method
    
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            MIDIPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
    
        let systemRealTimeMessages: [UInt8 : [MIDIEvent]] = [
            0xF8: [.timingClock(group: 0)],
            0xF9: [], // undefined
            0xFA: [.start(group: 0)],
            0xFB: [.continue(group: 0)],
            0xFC: [.stop(group: 0)],
            0xFD: [], // undefined
            0xFE: [.activeSensing(group: 0)],
            0xFF: [.systemReset(group: 0)]
        ]
        
        // tests
        
        // preface:
        // MIDI 1.0 Spec: "Real-Time messages can be sent at any time and may be inserted anywhere
        // in a MIDI data stream, including between Status and Data bytes of any other MIDI
        // messages."
        
        // ------------------------------------------------
        
        // test: real-time message byte in between status and data byte(s) of a CV message
        // result: should produce the CV message and the real-time message
        
        systemRealTimeMessages.forEach { realTimeMessage in
            let realTimeByte = realTimeMessage.key
            let realTimeEvent = realTimeMessage.value
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90,
                            realTimeByte, // inserted between status and databyte1
                            0x3C, 0x40]
                ),
                
                realTimeEvent + [.noteOn(60, velocity: .midi1(64), channel: 0)]
            )
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C,
                            realTimeByte, // inserted between databyte1 and databyte2
                            0x40]
                ),
                
                realTimeEvent + [.noteOn(60, velocity: .midi1(64), channel: 0)]
            )
        }
    }
    
    func testPacketData_parsedEvents_RunningStatus_SystemRealTime() throws {
        // template method
    
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            MIDIPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
        
        let systemRealTimeMessages: [UInt8 : [MIDIEvent]] = [
            0xF8: [.timingClock(group: 0)],
            0xF9: [], // undefined
            0xFA: [.start(group: 0)],
            0xFB: [.continue(group: 0)],
            0xFC: [.stop(group: 0)],
            0xFD: [], // undefined
            0xFE: [.activeSensing(group: 0)],
            0xFF: [.systemReset(group: 0)]
        ]
        
        // tests
        
        // premise: test that real-time system messages reset Running Status
        
        // test: full CV message, real-time system message, CV running status data bytes only
        // result: should produce two CV messages and a real-time message
        
        try systemRealTimeMessages.forEach { realTimeMessage in
            let realTimeByte = realTimeMessage.key
            let realTimeEvent = realTimeMessage.value
            
            // channel voice Running Status
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C, 0x40, // full CV note on message
                            realTimeByte, // real-time message
                            0x3D, 0x41 // CV running status data bytes
                    ]
                ),
                
                [.noteOn(60, velocity: .midi1(64), channel: 0)]
                    + realTimeEvent
                    + [.noteOn(61, velocity: .midi1(65), channel: 0)]
            )
            
            // system real-time events are not a SysEx terminator
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0xF0, 0x41, 0x01, 0x34,
                            realTimeByte, // real-time message
                            0x27, 0x52, 0xF7 // SysEx message continues
                    ]
                ),
                
                try realTimeEvent + [
                    .sysEx7(
                        manufacturer: .oneByte(0x41),
                        data: [0x01, 0x34, 0x27, 0x52]
                    )
                ]
            )
        }
    }
    
    func testPacketData_parsedEvents_RunningStatus_SystemCommon() {
        // template method
    
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            MIDIPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
    
        let systemCommonMessages: [[UInt8] : [MIDIEvent]] = [
            // 0xF0 - SysEx Start, not applicable to check in this test
            [0xF1, 0x00]       : [.timecodeQuarterFrame(dataByte: 0x00, group: 0)],
            [0xF2, 0x08, 0x00] : [.songPositionPointer(midiBeat: 8, group: 0)],
            [0xF3, 0x05]       : [.songSelect(number: 5, group: 0)],
            [0xF4]             : [], // undefined
            [0xF5]             : [], // undefined
            [0xF6]             : [.tuneRequest(group: 0)],
            [0xF7]             : [] // SysEx end
        ]
        
        // tests
        
        // premise: test that system common messages reset Running Status
        
        // test: full CV message, system common message, CV running status data bytes only
        // result: should produce the first CV messages and the system common message but not the second CV message
        
        systemCommonMessages.forEach { systemCommonMessage in
            let commonBytes = systemCommonMessage.key
            let commonEvent = systemCommonMessage.value
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C, 0x40] // full CV note on message
                        + commonBytes // real-time message
                        + [0x3D, 0x41] // CV running status data bytes
                ),
                
                [.noteOn(60, velocity: .midi1(64), channel: 0)]
                    + commonEvent
            )
        }
        
        // premise: a system common status byte should reset Running Status even if previous CV message was incomplete
        
        // test: incomplete CV message, then system common message starts
        // result: the incomplete CV message is discarded and the system common message succeeds
        
        systemCommonMessages.forEach { systemCommonMessage in
            let commonBytes = systemCommonMessage.key
            let commonEvent = systemCommonMessage.value
            
            XCTAssertEqual(
                parsedEvents(
                    bytes: [0x90, 0x3C] // first 2/3 bytes of CV note on message
                        + commonBytes   // full real-time message
                        + [0x40,        // byte 3/3 of first CV note on message
                           0x3D, 0x41]  // CV running status data bytes
                ),
                
                commonEvent
            )
        }
    }
    
    func testPacketData_parsedEvents_Malformed() {
        // template method
        
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            MIDIPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
        
        // tests
        
        // data bytes (< 0x80) are meaningless without a status byte or Running Status
        for byte: UInt8 in 0x00 ... 0x7F {
            XCTAssertEqual(parsedEvents(bytes: [byte]), [])
        }
        
        // note off
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0x80]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x80, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(
            parsedEvents(bytes: [0x80, 0x3C, 0x40, 0x3C]),
            [.noteOff(0x3C, velocity: .midi1(0x40), channel: 0)]
        )
        // valid running status
        XCTAssertEqual(
            parsedEvents(bytes: [0x80, 0x3C, 0x40, 0x3D, 0x41]),
            [.noteOff(0x3C, velocity: .midi1(0x40), channel: 0),
             .noteOff(0x3D, velocity: .midi1(0x41), channel: 0)]
        )
        
        // note on
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0x90]), [])
        XCTAssertEqual(parsedEvents(bytes: [0x90, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(
            parsedEvents(bytes: [0x90, 0x3C, 0x40, 0x3C]),
            [.noteOn(0x3C, velocity: .midi1(0x40), channel: 0)]
        )
        // valid running status
        XCTAssertEqual(
            parsedEvents(bytes: [0x90, 0x3C, 0x40, 0x3D, 0x41]),
            [.noteOn(0x3C, velocity: .midi1(0x40), channel: 0),
             .noteOn(0x3D, velocity: .midi1(0x41), channel: 0)]
        )
        
        // poly aftertouch
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0xA0]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xA0, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(
            parsedEvents(bytes: [0xA0, 0x3C, 0x40, 0x3C]),
            [.notePressure(note: 0x3C, amount: .midi1(0x40), channel: 0)]
        )
        // valid running status
        XCTAssertEqual(
            parsedEvents(bytes: [0xA0, 0x3C, 0x40, 0x3D, 0x41]),
            [.notePressure(note: 0x3C, amount: .midi1(0x40), channel: 0),
             .notePressure(note: 0x3D, amount: .midi1(0x41), channel: 0)]
        )
        
        // cc
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0xB0]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xB0, 0x3C]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(
            parsedEvents(bytes: [0xB0, 0x3C, 0x40, 0x3C]),
            [.cc(0x3C, value: .midi1(0x40), channel: 0)]
        )
        // valid running status
        XCTAssertEqual(
            parsedEvents(bytes: [0xB0, 0x3C, 0x40, 0x3D, 0x41]),
            [.cc(0x3C, value: .midi1(0x40), channel: 0),
             .cc(0x3D, value: .midi1(0x41), channel: 0)]
        )
        
        // program change
        // requires one data byte to follow
        XCTAssertEqual(parsedEvents(bytes: [0xC0]), [])
        // valid event
        XCTAssertEqual(
            parsedEvents(bytes: [0xC0, 0x3C]),
            [.programChange(program: 0x3C, channel: 0)]
        )
        // valid running status
        XCTAssertEqual(
            parsedEvents(bytes: [0xC0, 0x3C, 0x3D]),
            [.programChange(program: 0x3C, channel: 0),
             .programChange(program: 0x3D, channel: 0)]
        )
        
        // channel aftertouch
        // requires one data byte to follow
        XCTAssertEqual(parsedEvents(bytes: [0xD0]), [])
        // valid event
        XCTAssertEqual(
            parsedEvents(bytes: [0xD0, 0x3C]),
            [.pressure(amount: .midi1(0x3C), channel: 0)]
        )
        // valid running status
        XCTAssertEqual(
            parsedEvents(bytes: [0xD0, 0x3C, 0x3D]),
            [.pressure(amount: .midi1(0x3C), channel: 0),
             .pressure(amount: .midi1(0x3D), channel: 0)]
        )
        
        // pitch bend
        // requires two data bytes to follow
        XCTAssertEqual(parsedEvents(bytes: [0xE0]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xE0, 0x00]), [])
        // incomplete running status; should return only one event
        XCTAssertEqual(
            parsedEvents(bytes: [0xE0, 0x00, 0x40, 0x01]),
            [.pitchBend(value: .midi1(8192), channel: 0)]
        )
        // valid running status
        XCTAssertEqual(
            parsedEvents(bytes: [0xE0, 0x00, 0x40, 0x01, 0x40]),
            [.pitchBend(value: .midi1(8192), channel: 0),
             .pitchBend(value: .midi1(8193), channel: 0)]
        )
        
        // System Common - System Exclusive start
        // [0xF0, ... variable number of SysEx bytes]
        XCTAssertEqual(parsedEvents(bytes: [0xF0]), [])
        
        // System Common - Timecode quarter-frame
        // [0xF1, byte]
        XCTAssertEqual(parsedEvents(bytes: [0xF1]), [])
        
        // System Common - Song Position Pointer
        // [0xF2, lsb byte, msb byte]
        XCTAssertEqual(parsedEvents(bytes: [0xF2]), [])
        XCTAssertEqual(parsedEvents(bytes: [0xF2, 0x08]), [])
        // not technically compatible with Running Status
        XCTAssertEqual(
            parsedEvents(bytes: [0xF2, 0x08, 0x00, 0x09, 0x00]),
            [.songPositionPointer(midiBeat: 8)]
        )
        
        // System Common - Song Select
        // [0xF3, byte]
        XCTAssertEqual(parsedEvents(bytes: [0xF3]), [])
        // valid event
        XCTAssertEqual(
            parsedEvents(bytes: [0xF3, 0x3C]),
            [.songSelect(number: 0x3C)]
        )
        // not technically compatible with Running Status
        XCTAssertEqual(
            parsedEvents(bytes: [0xF3, 0x3C, 0x3D]),
            [.songSelect(number: 0x3C)]
        )
        
        // System Common - Undefined
        // [0xF4]
        // (undefined, not relevant to check in this test)
        
        // System Common - Undefined
        // [0xF5]
        // (undefined, not relevant to check in this test)
        
        // System Common - Tune Request
        // [0xF6]
        // single status byte message, not relevant to check in this test
        
        // System Common - System Exclusive End (EOX / End Of Exclusive)
        // [0xF7]
        // on its own without context, it's meaningless/invalid
        XCTAssertEqual(parsedEvents(bytes: [0xF7]), [])
        
        // System Real-Time - Timing Clock
        // [0xF8]
        // single status byte message, not relevant to check in this test
        
        // Real-Time - Undefined
        // [0xF9]
        // (undefined, not relevant to check in this test)
        
        // System Real-Time - Start
        // [0xFA]
        // single status byte message, not relevant to check in this test
        
        // System Real-Time - Continue
        // [0xFB]
        // single status byte message, not relevant to check in this test
        
        // System Real-Time - Stop
        // [0xFC]
        // single status byte message, not relevant to check in this test
        
        // System Real-Time - Undefined
        // [0xFD]
        // (undefined, not relevant to check in this test)
        
        // System Real-Time - Active Sensing
        // [0xFE]
        // single status byte message, not relevant to check in this test
        
        // System Real-Time - System Reset
        // [0xFF]
        // single status byte message, not relevant to check in this test
    }
    
    func testPacketData_parsedEvents_SysEx() throws {
        // template method
        
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            MIDIPacketData(bytes: bytes, timeStamp: .zero)
                .parsedEvents()
        }
        
        // tests
        
        // test SysEx termination conditions:
        // - 0xF7
        // - no termination byte
        // - new status byte
        
        // 0xF7 termination byte
        XCTAssertEqual(
            parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34, 0xF7]),
            try [.sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34], group: 0)]
        )
        
        // no termination byte
        XCTAssertEqual(
            parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34]),
            try [.sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34], group: 0)]
        )
        
        // new status byte (non-realtime)
        XCTAssertEqual(
            parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34,
                                 0x90, 0x3C, 0x40]),
            try [.sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34], group: 0),
                 .noteOn(60, velocity: .midi1(64), channel: 0, group: 0)]
        )
        
        // system real-time events are not a SysEx terminator, as the parser does not
        // look ahead and assumes the SysEx could continue to receive data bytes
        XCTAssertEqual(
            parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x34,
                                 0xFE]),
            try [.activeSensing(group: 0),
                 .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34], group: 0)]
        )
        
        // multiple SysEx messages in a single packet
        XCTAssertEqual(
            parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x02, 0xF7,   // 0xF7 termination
                                 0xF0, 0x42, 0x03, 0x04, 0xF7]), // 0xF7 termination
            try [.sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x02], group: 0),
                 .sysEx7(manufacturer: .oneByte(0x42), data: [0x03, 0x04], group: 0)]
        )
        
        // multiple SysEx messages in a single packet
        XCTAssertEqual(
            parsedEvents(bytes: [0xF0, 0x41, 0x01, 0x02,   // no 0xF7 termination
                                 0xF0, 0x42, 0x03, 0x04]), // 0xF0 acts as termination to 1st sysex
            try [.sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x02], group: 0),
                 .sysEx7(manufacturer: .oneByte(0x42), data: [0x03, 0x04], group: 0)]
        )
    }
    
    func testTranslateNoteOnZeroVelocityToNoteOff() {
        // template method
    
        let parser = MIDI1Parser()
    
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            parser.parsedEvents(in: bytes, umpGroup: 0)
        }
    
        // on - default
        // note on with velocity 0 should return a note off event
        XCTAssertTrue(parser.translateNoteOnZeroVelocityToNoteOff)
        XCTAssertEqual(
            parsedEvents(bytes: [0x90, 0x3C, 0x00]),
            [.noteOff(60, velocity: .midi1(0), channel: 0, group: 0)]
        )
    
        // off
        // should return a note on event, exactly as received
        parser.translateNoteOnZeroVelocityToNoteOff = false
        XCTAssertEqual(
            parsedEvents(bytes: [0x90, 0x3C, 0x00]),
            [.noteOn(60, velocity: .midi1(0), channel: 0, group: 0)]
        )
    }
    
    func testNRPN_SinglePacket() {
        // template method
        
        let parser = MIDI1Parser()
        
        func parsedEvents(bytes: [UInt8]) -> [MIDIEvent] {
            parser.parsedEvents(in: bytes, umpGroup: 0)
        }
        
        // TODO: this test will pass if RPN/NRPN bundling is added to MIDI1Parser
        // XCTAssertEqual(
        //     parsedEvents(bytes: [
        //         0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
        //         0x62, 0x41, // running status CC 98 value 0x41
        //         0x06, 0x10]), // data entry MSB value 0x10
        //     [.nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 0x02)]
        // )
        
        // TODO: this test will pass if RPN/NRPN bundling is added to MIDI1Parser
        // XCTAssertEqual(
        //     parsedEvents(bytes: [
        //         0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
        //         0x62, 0x41, // running status CC 98 value 0x41
        //         0x06, 0x10, // data entry MSB value 0x10
        //         0x26, 0x20]), // data entry LSB value 0x20
        //     [.nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 0x02)]
        // )
        
        // default parsing style: separate CC events are received in sequence
        XCTAssertEqual(
            parsedEvents(bytes: [
                0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
                0x62, 0x41, // running status CC 98 value 0x41
                0x06, 0x10]), // data entry MSB value 0x10
            [
                .cc(0x63, value: .midi1(0x40), channel: 0x02),
                .cc(0x62, value: .midi1(0x41), channel: 0x02),
                .cc(0x06, value: .midi1(0x10), channel: 0x02)
            ]
        )
        
        //  default parsing style: separate CC events are received in sequence
        XCTAssertEqual(
            parsedEvents(bytes: [
                0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
                0x62, 0x41, // running status CC 98 value 0x41
                0x06, 0x10, // data entry MSB value 0x10
                0x26, 0x20]), // data entry LSB value 0x20
            [
                .cc(0x63, value: .midi1(0x40), channel: 0x02),
                .cc(0x62, value: .midi1(0x41), channel: 0x02),
                .cc(0x06, value: .midi1(0x10), channel: 0x02),
                .cc(0x26, value: .midi1(0x20), channel: 0x02)
            ]
        )
    }
}
#endif
