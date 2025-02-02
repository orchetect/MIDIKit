//
//  MIDIPacket Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
import MIDIKitInternals
@testable import MIDIKitIO
import Testing

@Suite struct MIDIPacket_Tests {
    @Test
    func emptyBytes256Length() throws {
        let testPacket = kMIDIPacket.emptyBytes256Length
        
        #expect(testPacket.rawBytes == [UInt8](repeating: 0x00, count: 256))
        #expect(testPacket.rawTimeStamp == 123_456_789)
    }
    
    @Test
    func noteOn60Vel65Chan1() throws {
        let testPacket = kMIDIPacket.noteOn60Vel65Chan1
        
        #expect(testPacket.rawBytes == [0x90, 0x3C, 0x41])
        #expect(testPacket.rawTimeStamp == 123_456_789)
    }
    
    @Test
    func noteOn60Vel65Chan1_CC12Val105Chan1() throws {
        let testPacket = kMIDIPacket.noteOn60Vel65Chan1_CC12Val105Chan1
        
        #expect(testPacket.rawBytes == [0x90, 0x3C, 0x41, 0xB0, 0x08, 0x69])
        #expect(testPacket.rawTimeStamp == 987_654_321)
    }
    
    @Test
    func full256Bytes() throws {
        let testPacket = kMIDIPacket.full256Bytes
        
        #expect(testPacket.rawBytes == kMIDIPacket.full256Bytes_rawBytes)
        #expect(testPacket.rawTimeStamp == UInt64.max)
    }
}

#endif
