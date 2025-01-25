//
//  Event SysEx7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_SysEx7_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    // MARK: - MIDIEvent.sysEx7(midi1SMFRawBytes:)
    
    @Test
    func midiEventSysEx7_midi1SMFRawBytes_Empty() {
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(midi1SMFRawBytes: [])
        }
    }
    
    @Test
    func midiEventSysEx7_midi1SMFRawBytes_EmptyOrShort() throws {
        // 0xF7 termination byte is required in SMF for all syntactically complete sysex messages
        
        // not syntactically complete, but could be valid in multi-part sysex context
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(midi1SMFRawBytes: [
                0xF0,  // start byte
                0x00   // length: 0 bytes to follow
            ])
        }
        
        // invalid length
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(midi1SMFRawBytes: [
                0xF0,  // start byte
                0x00,  // length: 0 bytes to follow (wrong)
                0xF7   // termination byte
            ])
        }
        
        // not valid sysex (should contain at least one internal byte - the manufacturer ID)
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(midi1SMFRawBytes: [
                0xF0,  // start byte
                0x01,  // length: 1 byte to follow
                0xF7   // termination byte
            ])
        }
    }
    
    @Test
    func midiEventSysEx7_midi1SMFRawBytes_WrongLength() {
        // length must include data length and termination byte
        
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(midi1SMFRawBytes: [
                0xF0,  // start byte
                0x01,  // length: 1 byte to follow (wrong)
                0x7D,  // manufacturer ID
                0xF7   // termination byte
            ])
        }
    }
    
    @Test
    func midiEventSysEx7_midi1SMFRawBytes_SysEx_EmptyData() throws {
        let sysEx = try MIDIEvent.sysEx7(midi1SMFRawBytes: [
            0xF0,  // start byte
            0x02,  // length: 2 bytes to follow
            0x7D,  // manufacturer ID
            0xF7   // termination byte
        ])
        
        guard case let .sysEx7(event) = sysEx else {
            Issue.record(); return
        }
        
        #expect(event.manufacturer == .oneByte(0x7D))
        #expect(event.data == [])
    }
    
    @Test
    func midiEventSysEx7_midi1SMFRawBytes_SysEx_WithData() throws {
        let sysEx = try MIDIEvent.sysEx7(midi1SMFRawBytes: [
            0xF0,  // start byte
            0x04,  // length: 4 bytes to follow
            0x7D,  // manufacturer ID
            0x12,  // data byte 1
            0x34,  // data byte 2
            0xF7   // termination byte
        ])
        
        guard case let .sysEx7(event) = sysEx else {
            Issue.record(); return
        }
        
        #expect(event.manufacturer == .oneByte(0x7D))
        #expect(event.data == [0x12, 0x34])
    }
    
    @Test
    func midiEventSysEx7_midi1SMFRawBytes_UniversalSysEx_EmptyData() throws {
        let sysEx = try MIDIEvent.sysEx7(midi1SMFRawBytes: [
            0xF0,  // start byte
            0x05,  // length: 5 bytes to follow
            0x7F,  // realtime universal sysex
            0x01,  // device ID
            0x02,  // subID 1
            0x03,  // subID 2
            0xF7   // termination byte
        ])
        
        guard case let .universalSysEx7(event) = sysEx else {
            Issue.record(); return
        }
        
        #expect(event.universalType == .realTime)
        #expect(event.deviceID == 0x01)
        #expect(event.subID1 == 0x02)
        #expect(event.subID2 == 0x03)
        #expect(event.data == [])
    }
    
    @Test
    func midiEventSysEx7_midi1SMFRawBytes_UniversalSysEx_WithData() throws {
        let sysEx = try MIDIEvent.sysEx7(midi1SMFRawBytes: [
            0xF0,  // start byte
            0x07,  // length: 7 bytes to follow
            0x7E,  // non-realtime universal sysex
            0x7F,  // device ID
            0x00,  // subID 1
            0x00,  // subID 2
            0x12,  // data byte 1
            0x34,  // data byte 2
            0xF7   // termination byte
        ])
        
        guard case let .universalSysEx7(event) = sysEx else {
            Issue.record(); return
        }
        
        #expect(event.universalType == .nonRealTime)
        #expect(event.deviceID == 0x7F)
        #expect(event.subID1 == 0x00)
        #expect(event.subID2 == 0x00)
        #expect(event.data == [0x12, 0x34])
    }
    
    // MARK: - MIDIFileEvent.SysEx7
    
    @Test
    func sysEx7_midi1SMFRawBytes_EmptyData() throws {
        let sysEx = try MIDIFileEvent.SysEx7(
            manufacturer: .oneByte(0x7D),
            data: []
        )
        
        let bytes: [UInt8] = sysEx.midi1SMFRawBytes()
        
        #expect(bytes == [
            0xF0,  // start byte
            0x02,  // length: 2 bytes to follow
            0x7D,  // manufacturer ID
            0xF7   // termination byte
        ])
    }
    
    @Test
    func sysEx7_midi1SMFRawBytes_WithData() throws {
        let sysEx = try MIDIFileEvent.SysEx7(
            manufacturer: .oneByte(0x7D),
            data: [0x12, 0x34]
        )
        
        let bytes: [UInt8] = sysEx.midi1SMFRawBytes()
        
        #expect(bytes == [
            0xF0,  // start byte
            0x04,  // length: 4 bytes to follow
            0x7D,  // manufacturer ID
            0x12,  // data byte 1
            0x34,  // data byte 2
            0xF7   // termination byte
        ])
    }
    
    @Test
    func sysEx7_midi1SMFRawBytes_128Bytes() throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 128 - 2)
        
        let sysEx = try MIDIFileEvent.SysEx7(
            manufacturer: .oneByte(0x7D),
            data: data
        )
        
        let bytes: [UInt8] = sysEx.midi1SMFRawBytes()
        
        #expect(
            bytes ==
                [
                    0xF0,       // start byte
                    0x81, 0x00, // length: 128 bytes to follow
                    0x7D        // manufacturer ID
                ]
                + data      // data bytes
                + [0xF7]    // termination byte
        )
    }
    
    // MARK: - MIDIFileEvent.UniversalSysEx7
    
    @Test
    func universalSysEx7_midi1SMFRawBytes_EmptyData() throws {
        let sysEx = try MIDIFileEvent.UniversalSysEx7(
            universalType: .realTime,
            deviceID: 0x01,
            subID1: 0x02,
            subID2: 0x03,
            data: []
        )
        
        let bytes: [UInt8] = sysEx.midi1SMFRawBytes()
        
        #expect(bytes == [
            0xF0,  // start byte
            0x05,  // length: 5 bytes to follow
            0x7F,  // realtime universal sysex
            0x01,  // device ID
            0x02,  // subID 1
            0x03,  // subID 2
            0xF7   // termination byte
        ])
    }
    
    @Test
    func universalSysEx7_midi1SMFRawBytes_WithData() throws {
        let sysEx = try MIDIFileEvent.UniversalSysEx7(
            universalType: .nonRealTime,
            deviceID: 0x7F,
            subID1: 0x00,
            subID2: 0x00,
            data: [0x12, 0x34]
        )
        
        let bytes: [UInt8] = sysEx.midi1SMFRawBytes()
        
        #expect(bytes == [
            0xF0,  // start byte
            0x07,  // length: 7 bytes to follow
            0x7E,  // non-realtime universal sysex
            0x7F,  // device ID
            0x00,  // subID 1
            0x00,  // subID 2
            0x12,  // data byte 1
            0x34,  // data byte 2
            0xF7   // termination byte
        ])
    }
    
    @Test
    func universalSysEx7_midi1SMFRawBytes_128Bytes() throws {
        let data: [UInt8] = .init(repeating: 0x12, count: 128 - 5)
        
        let sysEx = try MIDIFileEvent.UniversalSysEx7(
            universalType: .nonRealTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x02,
            data: data
        )
        
        let bytes: [UInt8] = sysEx.midi1SMFRawBytes()
        
        #expect(
            bytes ==
                [
                    0xF0,       // start byte
                    0x81, 0x00, // length: 128 bytes to follow
                    0x7E,       // non-realtime universal sysex
                    0x7F,       // device ID
                    0x01,       // subID 1
                    0x02        // subID 2
                ]
                + data      // data bytes
                + [0xF7]    // termination byte
        )
    }
    
    // MARK: - Edge Cases
    
    // see RP-001_v1-0_Standard_MIDI_Files_Specification_96-1-4.pdf pages 6-7
    // TODO: SysEx7 0xF7 escape message handling
}
