//
//  SysEx8 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct SysEx8_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    @Test
    func SysEx8_SingleUMP() throws {
        let sourceRawBytes: [UInt8] = [0x00, // stream ID
                                       0x00, 0x7D, // sysEx ID
                                       0x01, 0x34, 0xE6] // data bytes
        
        let event = try MIDIEvent.sysEx8(rawBytes: sourceRawBytes)
        guard case let .sysEx8(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.manufacturer == .oneByte(0x7D))
        #expect(innerEvent.data == [0x01, 0x34, 0xE6])
        #expect(innerEvent.group == 0)
        
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [
                    [0x5006_0000,
                     0x7D01_34E6,
                     0x0000_0000,
                     0x0000_0000]
                ]
        )
    }
    
    @Test
    func SysEx8_2Part_UMP() throws {
        let event = MIDIEvent.sysEx8(
            manufacturer: .threeByte(byte2: 0x00, byte3: 0x66),
            data: [0x01, 0x02, 0x03, 0x01,
                   0x02, 0x03, 0x04, 0x05,
                   0x06, 0x07, 0x08, 0x09,
                   0x0A, 0x0B, 0x0C, 0xE6],
            group: 0
        )
        
        guard case let .sysEx8(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.manufacturer == .threeByte(byte2: 0x00, byte3: 0x66))
        #expect(innerEvent.data == [0x01, 0x02, 0x03, 0x01,
                                    0x02, 0x03, 0x04, 0x05,
                                    0x06, 0x07, 0x08, 0x09,
                                    0x0A, 0x0B, 0x0C, 0xE6])
        #expect(innerEvent.group == 0)
        
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [
                    [0x501E_0080,
                     0x6601_0203,
                     0x0102_0304,
                     0x0506_0708],
                    [0x5036_0009,
                     0x0A0B_0CE6,
                     0x0000_0000,
                     0x0000_0000]
                ]
        )
    }
    
    @Test
    func SysEx8_3Part_UMP() throws {
        let event = MIDIEvent.sysEx8(
            manufacturer: .threeByte(byte2: 0x21, byte3: 0x09),
            data: [0x01, 0x02, 0x03, 0x01,
                   0x02, 0x03, 0x04, 0x05,
                   0x06, 0x07, 0x08, 0x09,
                   0x0A, 0x0B, 0x0C, 0x0D,
                   0x0E, 0x0F, 0x10, 0x11,
                   0x12, 0x13, 0x14, 0x15,
                   0x16, 0x17, 0x18, 0x19,
                   0xE6],
            group: 0
        )
        
        guard case let .sysEx8(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.manufacturer == .threeByte(byte2: 0x21, byte3: 0x09))
        #expect(innerEvent.data == [0x01, 0x02, 0x03, 0x01,
                                    0x02, 0x03, 0x04, 0x05,
                                    0x06, 0x07, 0x08, 0x09,
                                    0x0A, 0x0B, 0x0C, 0x0D,
                                    0x0E, 0x0F, 0x10, 0x11,
                                    0x12, 0x13, 0x14, 0x15,
                                    0x16, 0x17, 0x18, 0x19,
                                    0xE6])
        #expect(innerEvent.group == 0)
        
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [
                    [0x501E_00A1,
                     0x0901_0203,
                     0x0102_0304,
                     0x0506_0708],
                    [0x502E_0009,
                     0x0A0B_0C0D,
                     0x0E0F_1011,
                     0x1213_1415],
                    [0x5036_0016,
                     0x1718_19E6,
                     0x0000_0000,
                     0x0000_0000]
                ]
        )
    }
    
    @Test
    func UniversalSysEx8_SingleUMP() throws {
        let event = MIDIEvent.universalSysEx8(
            universalType: .realTime,
            deviceID: 0x01,
            subID1: 0x02,
            subID2: 0x03,
            data: [0x01, 0x02, 0x03, 0x04,
                   0x05, 0x06, 0x07, 0xE6]
        )
        
        guard case let .universalSysEx8(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.universalType == .realTime)
        #expect(innerEvent.deviceID == 0x01)
        #expect(innerEvent.subID1 == 0x02)
        #expect(innerEvent.subID2 == 0x03)
        #expect(innerEvent.data == [0x01, 0x02, 0x03, 0x04,
                                    0x05, 0x06, 0x07, 0xE6])
        #expect(innerEvent.group == 0)
        
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [
                    [0x500E_0000,
                     0x7F01_0203,
                     0x0102_0304,
                     0x0506_07E6]
                ]
        )
    }
    
    @Test
    func UniversalSysEx8_2Part_UMP() throws {
        let event = MIDIEvent.universalSysEx8(
            universalType: .realTime,
            deviceID: 0x01,
            subID1: 0x02,
            subID2: 0x03,
            data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                   0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                   0xE6]
        )
        
        guard case let .universalSysEx8(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.universalType == .realTime)
        #expect(innerEvent.deviceID == 0x01)
        #expect(innerEvent.subID1 == 0x02)
        #expect(innerEvent.subID2 == 0x03)
        #expect(innerEvent.data == [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                    0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                                    0xE6])
        #expect(innerEvent.group == 0)
        
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [
                    [0x501E_0000,
                     0x7F01_0203,
                     0x0102_0304,
                     0x0506_0708],
                    [0x5036_0009,
                     0x0A0B_0CE6,
                     0x0000_0000,
                     0x0000_0000]
                ]
        )
    }
    
    @Test
    func UniversalSysEx8_3Part_UMP() throws {
        let event = MIDIEvent.universalSysEx8(
            universalType: .nonRealTime,
            deviceID: 0x01,
            subID1: 0x02,
            subID2: 0x03,
            data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                   0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                   0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12,
                   0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
                   0x19, 0xE6]
        )
        
        guard case let .universalSysEx8(innerEvent) = event
        else { Issue.record(); return }
        
        #expect(innerEvent.universalType == .nonRealTime)
        #expect(innerEvent.deviceID == 0x01)
        #expect(innerEvent.subID1 == 0x02)
        #expect(innerEvent.subID2 == 0x03)
        #expect(innerEvent.data == [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                                    0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                                    0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12,
                                    0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
                                    0x19, 0xE6])
        #expect(innerEvent.group == 0)
        
        #expect(
            event.umpRawWords(protocol: .midi2_0) ==
                [
                    [0x501E_0000,
                     0x7E01_0203,
                     0x0102_0304,
                     0x0506_0708],
                    [0x502E_0009,
                     0x0A0B_0C0D,
                     0x0E0F_1011,
                     0x1213_1415],
                    [0x5036_0016,
                     0x1718_19E6,
                     0x0000_0000,
                     0x0000_0000]
                ]
        )
    }
    
    @Test
    func SysEx8RawBytes_Malformed() {
        // empty raw bytes - invalid
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx8(rawBytes: [])
        }
        
        // start byte only - invalid when in a complete SysEx8 UMP message
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx8(rawBytes: [0x00])
        }
        
        // invalid sysEx ID
        #expect(throws: (any Error).self) {
            try MIDIEvent.sysEx8(rawBytes: [0x00, // stream ID
                                            0x00, 0x80, // sysEx ID -- invalid
                                            0x01, 0x34, 0xE6]) // data bytes
        }
    }
    
    @Test
    func Equatable() throws {
        // ensure instances equate correctly
        
        let event1A = try MIDIEvent.sysEx8(rawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        let event1B = try MIDIEvent.sysEx8(rawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        
        let event2 = try MIDIEvent.sysEx8(rawBytes: [0x00, // stream ID
                                                     0x00, 0x42, // sysEx ID
                                                     0x01, 0x34, 0xE5]) // data bytes)
        
        #expect(event1A == event1B)
        
        #expect(event1A != event2)
    }
    
    @Test
    func Hashable() throws {
        // ensure instances hash correctly
        
        let event1A = try MIDIEvent.sysEx8(rawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        let event1B = try MIDIEvent.sysEx8(rawBytes: [0x00, // stream ID
                                                      0x00, 0x41, // sysEx ID
                                                      0x01, 0x34, 0xE6]) // data bytes)
        
        let event2 = try MIDIEvent.sysEx8(rawBytes: [0x00, // stream ID
                                                     0x00, 0x42, // sysEx ID
                                                     0x01, 0x34, 0xE5]) // data bytes)
        
        let set1: Set<MIDIEvent> = [event1A, event1B]
        
        let set2: Set<MIDIEvent> = [event1A, event2]
        
        #expect(set1.count == 1)
        
        #expect(set2.count == 2)
    }
}
