//
//  SysEx7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct SysEx7_Tests {
    @Test
    func SysEx7RawBytes_Typical() throws {
        let sourceRawBytes: [UInt8] = [0xF0, 0x41, 0x01, 0x34, 0xF7]
        
        let event = try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        guard case let .sysEx7(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.manufacturer == .oneByte(0x41))
        #expect(innerEvent.data == [0x01, 0x34])
        #expect(innerEvent.group == 0)
        
        #expect(event.midi1RawBytes() == sourceRawBytes)
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [[0x3003_4101, 0x3400_0000]]
        )
    }
    
    @Test
    func SysEx7RawBytes_EmptyMessageBytes_WithMfr_WithEndByte() throws {
        let sourceRawBytes: [UInt8] = [0xF0, 0x41, 0xF7]
        
        let event = try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        guard case let .sysEx7(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.manufacturer == .oneByte(0x41))
        #expect(innerEvent.data == [])
        #expect(innerEvent.group == 0)
        
        #expect(event.midi1RawBytes() == sourceRawBytes)
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [[0x3001_4100, 0x0000_0000]]
        )
    }
    
    @Test
    func SysEx7RawBytes_EmptyMessageBytes_WithMfr() throws {
        let sourceRawBytes: [UInt8] = [0xF0, 0x41]
        
        let event = try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        guard case let .sysEx7(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.manufacturer == .oneByte(0x41))
        #expect(innerEvent.data == [])
        #expect(innerEvent.group == 0)
        
        #expect(event.midi1RawBytes() == [0xF0, 0x41, 0xF7])
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [[0x3001_4100, 0x0000_0000]]
        )
    }
    
    @Test
    func SysEx7RawBytes_EmptyMessageBytes_WithEndByte() {
        let sourceRawBytes: [UInt8] = [0xF0, 0xF7]
        
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawBytes: sourceRawBytes)
        }
    }
    
    @Test
    func SysEx7RawBytes_MaxSize() {
        // valid - maximum byte length (256 bytes)
        #expect(throws: Never.self) {
            try MIDIEvent.sysEx7(
                rawBytes: [0xF0, 0x41]
                    + [UInt8](repeating: 0x20, count: 256 - 3)
                    + [0xF7]
            )
        }
        
        // valid - length is larger than default 256 bytes (257 bytes)
        #expect(throws: Never.self) {
            try MIDIEvent.sysEx7(
                rawBytes: [0xF0, 0x41]
                    + [UInt8](repeating: 0x20, count: 256 - 2)
                    + [0xF7]
            )
        }
    }
    
    @Test
    func SysEx7RawBytes_Malformed() {
        // empty raw bytes - invalid
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawBytes: [])
        }
        
        // start byte only - invalid
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawBytes: [0xF0])
        }
        
        // end byte only - invalid
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawBytes: [0xF7])
        }
        
        // start and end bytes only - invalid
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawBytes: [0xF0, 0xF7])
        }
        
        // correct start byte, valid length, but incorrect end byte
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF6])
        }
    }
    
    @Test
    func SysEx7RawHexString_Typical() throws {
        // space delimiter
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 34 F7") ==
                .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
        
        // compact
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0410134F7") ==
                .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
        
        // variable spacing
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 0134 F7") ==
                .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
        
        // space delimiter - no trailing F7
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 34") ==
                .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
        
        // compact - no trailing F7
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0410134") ==
                .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
        
        // lowercase - no trailing F7
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "f0410134") ==
                .sysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        )
    }
    
    @Test
    func SysEx7RawHexString_Malformed() throws {
        // wrong leading and trailing bytes
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "F7 41 01 34 F0")
        }
        
        // missing leading byte
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "41 01 34 F0")
        }
        
        // invalid hex characters
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 ZZ F7")
        }
        
        // uneven number of hex characters (should be in pairs)
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "F0 41 01 34 F")
        }
    }
    
    @Test
    func SysEx7_midi1RawHexString() throws {
        let sysEx7 = try MIDIEvent.SysEx7(manufacturer: .oneByte(0x41), data: [0x01, 0x34])
        
        #expect(
            sysEx7.midi1RawHexString() ==
                "F0 41 01 34 F7"
        )
        
        #expect(
            sysEx7.midi1RawHexString(leadingF0: false, trailingF7: false) ==
                "41 01 34"
        )
        
        #expect(
            sysEx7.midi1RawHexString(separator: nil) ==
                "F0410134F7"
        )
        
        #expect(
            sysEx7.midi1RawHexString(separator: ", ") ==
                "F0, 41, 01, 34, F7"
        )
    }
    
    @Test
    func UniversalSysEx7RawHexString_Typical() throws {
        // space delimiter
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 01 34 56 10 11 F7") ==
                .universalSysEx7(
                    universalType: .realTime,
                    deviceID: 0x01,
                    subID1: 0x34,
                    subID2: 0x56,
                    data: [0x10, 0x11]
                )
        )
        
        // compact
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F07F0134561011F7") ==
                .universalSysEx7(
                    universalType: .realTime,
                    deviceID: 0x01,
                    subID1: 0x34,
                    subID2: 0x56,
                    data: [0x10, 0x11]
                )
        )
        
        // variable spacing
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 013456 1011 F7") ==
                .universalSysEx7(
                    universalType: .realTime,
                    deviceID: 0x01,
                    subID1: 0x34,
                    subID2: 0x56,
                    data: [0x10, 0x11]
                )
        )
        
        // space delimiter - no trailing F7
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 0134 56 10 11") ==
                .universalSysEx7(
                    universalType: .realTime,
                    deviceID: 0x01,
                    subID1: 0x34,
                    subID2: 0x56,
                    data: [0x10, 0x11]
                )
        )
        
        // compact - no trailing F7
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "F07F0134561011") ==
                .universalSysEx7(
                    universalType: .realTime,
                    deviceID: 0x01,
                    subID1: 0x34,
                    subID2: 0x56,
                    data: [0x10, 0x11]
                )
        )
        
        // lowercase
        #expect(
            try MIDIEvent.sysEx7(rawHexString: "f0 7f 01 34 56 10 11 f7") ==
                .universalSysEx7(
                    universalType: .realTime,
                    deviceID: 0x01,
                    subID1: 0x34,
                    subID2: 0x56,
                    data: [0x10, 0x11]
                )
        )
    }
    
    @Test
    func UniversalSysEx7RawHexString_Malformed() throws {
        // wrong leading and trailing bytes
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "F7 7F 01 34 56 10 11 F0")
        }
        
        // missing leading byte
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "7F 01 34 56 10 11")
        }
        
        // invalid hex characters
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 01 34 56 ZZ 11 F7")
        }
        
        // uneven number of hex characters (should be in pairs)
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx7(rawHexString: "F0 7F 01 34 56 10 11 F")
        }
    }
    
    @Test
    func Equatable() throws {
        // ensure instances equate correctly
        
        let event1A = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
        let event1B = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
        
        let event2 = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x64, 0xF7])
        
        #expect(event1A == event1B)
        
        #expect(event1A != event2)
    }
    
    @Test
    func Hashable() throws {
        // ensure instances hash correctly
        
        let event1A = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
        let event1B = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x34, 0xF7])
        
        let event2 = try MIDIEvent.sysEx7(rawBytes: [0xF0, 0x41, 0x01, 0x64, 0xF7])
        
        let set1: Set<MIDIEvent> = [event1A, event1B]
        
        let set2: Set<MIDIEvent> = [event1A, event2]
        
        #expect(set1.count == 1)
        
        #expect(set2.count == 2)
    }
}
