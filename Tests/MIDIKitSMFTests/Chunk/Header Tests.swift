//
//  Header Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct Chunk_Header_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func init_Type0() throws {
        let header = MIDIFile.Chunk.Header(
            format: .singleTrack,
            timeBase: .musical(ticksPerQuarterNote: 720)
        )
        
        #expect(header.format == .singleTrack)
        #expect(header.timeBase == .musical(ticksPerQuarterNote: 720))
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        
        #expect(try header.midi1SMFRawBytes(withChunkCount: 1).bytes == rawData)
    }
    
    @Test
    func init_Type0_rawData() throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        
        let header = try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        #expect(header.format == .singleTrack)
        #expect(header.timeBase == .musical(ticksPerQuarterNote: 720))
    }
    
    @Test
    func init_Type1() throws {
        let header = MIDIFile.Chunk.Header(
            format: .multipleTracksSynchronous,
            timeBase: .musical(ticksPerQuarterNote: 720)
        )
        
        #expect(header.format == .multipleTracksSynchronous)
        #expect(header.timeBase == .musical(ticksPerQuarterNote: 720))
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x01, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        #expect(try header.midi1SMFRawBytes(withChunkCount: 2).bytes == rawData)
    }
    
    @Test
    func init_Type1_rawData() throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x01, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        let header = try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        #expect(header.format == .multipleTracksSynchronous)
        #expect(header.timeBase == .musical(ticksPerQuarterNote: 720))
    }
    
    @Test
    func init_Type2() throws {
        let header = MIDIFile.Chunk.Header(
            format: .multipleTracksAsynchronous,
            timeBase: .musical(ticksPerQuarterNote: 720)
        )
        
        #expect(header.format == .multipleTracksAsynchronous)
        #expect(header.timeBase == .musical(ticksPerQuarterNote: 720))
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        #expect(try header.midi1SMFRawBytes(withChunkCount: 2).bytes == rawData)
    }
    
    @Test
    func init_Type2_rawData() throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        let header = try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        #expect(header.format == .multipleTracksAsynchronous)
        #expect(header.timeBase == .musical(ticksPerQuarterNote: 720))
    }
    
    // MARK: - Edge Cases
    
    @Test
    func init_LengthIntTooShort() {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x05, // length (wrong)
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        #expect(throws: (any Error).self) {
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        }
    }
    
    @Test
    func init_LengthIntTooLong() {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x07, // length (wrong)
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        #expect(throws: (any Error).self) {
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        }
    }
    
    @Test
    func init_LengthTooShort() {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02] // timebase, but too few bytes (wrong)
        
        #expect(throws: (any Error).self) {
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        }
    }
    
    @Test
    func init_MoreBytesThanExpected() {
        // valid header chunk, with an additional unexpected subsequent byte
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0, // timebase
                                0x01] // an extra unexpected byte
        
        // since the header is always a known total number of bytes,
        // init will succeed and ignore any additional subsequent bytes
        #expect(throws: Never.self) {
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        }
    }
}
