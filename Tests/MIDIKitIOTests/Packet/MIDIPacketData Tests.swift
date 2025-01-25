//
//  MIDIPacketData Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite struct MIDIPacketData_Tests {
    @Test
    func emptyBytes256Length() throws {
        var testPacket = kMIDIPacket.emptyBytes256Length
        let data = MIDIPacketData(&testPacket, refCon: nil, refConKnown: false)
        
        #expect(data.bytes == [UInt8](repeating: 0x00, count: 256))
        #expect(data.timeStamp == 123_456_789)
    }
    
    @Test
    func noteOn60Vel65Chan1() throws {
        var testPacket = kMIDIPacket.noteOn60Vel65Chan1
        let data = MIDIPacketData(&testPacket, refCon: nil, refConKnown: false)
        
        #expect(data.bytes == [0x90, 0x3C, 0x41])
        #expect(data.timeStamp == 123_456_789)
    }
    
    @Test
    func noteOn60Vel65Chan1_CC12Val105Chan1() throws {
        var testPacket = kMIDIPacket.noteOn60Vel65Chan1_CC12Val105Chan1
        let data = MIDIPacketData(&testPacket, refCon: nil, refConKnown: false)
        
        #expect(data.bytes == [0x90, 0x3C, 0x41, 0xB0, 0x08, 0x69])
        #expect(data.timeStamp == 987_654_321)
    }
    
    @Test
    func full256Bytes() throws {
        var testPacket = kMIDIPacket.full256Bytes
        let data = MIDIPacketData(&testPacket, refCon: nil, refConKnown: false)
        
        #expect(data.bytes == kMIDIPacket.full256Bytes_rawBytes)
        #expect(data.timeStamp == UInt64.max)
    }
}

#endif
