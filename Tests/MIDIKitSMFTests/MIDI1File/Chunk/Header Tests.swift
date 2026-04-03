//
//  Header Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct Chunk_Header_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func init_Type0() async throws {
        let header = MusicalMIDI1File.HeaderChunk(
            format: .singleTrack,
            timebase: .musical(ticksPerQuarterNote: 720)
        )
        
        #expect(header.format == .singleTrack)
        #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
        #expect(header.additionalBytes == nil)
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        
        #expect(try header.midi1FileRawBytes(withTrackCount: 1).toUInt8Bytes() == rawData)
    }
    
    @Test
    func init_Type0_rawData() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        
        // note track count is NOT total chunk count; non-track chunks are not included in the number
        let (header, trackCount) = try MusicalMIDI1File.HeaderChunk.decode(
            midi1FileRawBytes: rawData,
            allowMultiTrackFormat0: false
        )
        
        #expect(header.format == .singleTrack)
        #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
        #expect(header.additionalBytes == nil)
        #expect(trackCount == 1)
    }
    
    @Test
    func init_Type1() async throws {
        let header = MusicalMIDI1File.HeaderChunk(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 720)
        )
        
        #expect(header.format == .multipleTracksSynchronous)
        #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
        #expect(header.additionalBytes == nil)
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x01, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        #expect(try header.midi1FileRawBytes(withTrackCount: 2).toUInt8Bytes() == rawData)
    }
    
    @Test
    func init_Type1_rawData() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x01, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        // note track count is NOT total chunk count; non-track chunks are not included in the number
        let (header, trackCount) = try MusicalMIDI1File.HeaderChunk.decode(
            midi1FileRawBytes: rawData,
            allowMultiTrackFormat0: false
        )
        
        #expect(header.format == .multipleTracksSynchronous)
        #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
        #expect(header.additionalBytes == nil)
        #expect(trackCount == 2)
    }
    
    @Test
    func init_Type2() async throws {
        let header = MusicalMIDI1File.HeaderChunk(
            format: .multipleTracksAsynchronous,
            timebase: .musical(ticksPerQuarterNote: 720)
        )
        
        #expect(header.format == .multipleTracksAsynchronous)
        #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
        #expect(header.additionalBytes == nil)
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        #expect(try header.midi1FileRawBytes(withTrackCount: 2).toUInt8Bytes() == rawData)
    }
    
    @Test
    func initFrom_midi1FileRawBytes_Type2_rawData() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        // note track count is NOT total chunk count; non-track chunks are not included in the number
        let (header, trackCount) = try MusicalMIDI1File.HeaderChunk.decode(
            midi1FileRawBytes: rawData,
            allowMultiTrackFormat0: false
        )
        
        #expect(header.format == .multipleTracksAsynchronous)
        #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
        #expect(header.additionalBytes == nil)
        #expect(trackCount == 2)
    }
    
    @Test
    func initFrom_midi1FileRawBytesStream_Type2_rawData() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        // note track count is NOT total chunk count; non-track chunks are not included in the number
        let (header, trackCount, bufferLength) = try MusicalMIDI1File.HeaderChunk.decode(
            midi1FileRawBytesStream: rawData,
            allowMultiTrackFormat0: false
        )
        
        #expect(header.format == .multipleTracksAsynchronous)
        #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
        #expect(header.additionalBytes == nil)
        #expect(trackCount == 2)
        #expect(bufferLength == 14)
    }
    
    @Test
    func initFrom_midi1FileRawBytesStream_Type2_rawData_nonStandardLength() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x08, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0, // timebase
                                0x17, 0x18] // extra (non-standard) bytes
        
        // decode
        do {
            // note track count is NOT total chunk count; non-track chunks are not included in the number
            let (header, trackCount, bufferLength) = try MusicalMIDI1File.HeaderChunk.decode(
                midi1FileRawBytesStream: rawData,
                allowMultiTrackFormat0: false
            )
            
            #expect(header.format == .multipleTracksAsynchronous)
            #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(header.additionalBytes?.toUInt8Bytes() == [0x17, 0x18])
            #expect(trackCount == 2)
            #expect(bufferLength == 16)
        }
        
        // encode
        do {
            let header = MusicalMIDI1File.HeaderChunk(
                format: .multipleTracksAsynchronous,
                timebase: .musical(ticksPerQuarterNote: 720),
                additionalBytes: [0x17, 0x18]
            )
            let headerBytes = try header.midi1FileRawBytes(as: [UInt8].self, withTrackCount: 2)
            #expect(headerBytes == rawData)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test
    func init_LengthIntTooShort() async {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x05, // length (wrong)
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        #expect(throws: (any Error).self) {
            _ = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: false)
        }
    }
    
    @Test
    func init_LengthIntTooLong() async {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x07, // length (wrong)
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        #expect(throws: (any Error).self) {
            _ = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: false)
        }
    }
    
    @Test
    func init_LengthTooShort() async {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02] // timebase, but too few bytes (wrong)
        
        #expect(throws: (any Error).self) {
            _ = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: false)
        }
    }
    
    @Test
    func init_MoreBytesThanExpected() async {
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
            _ = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: false)
        }
    }
    
    /// Test that track count is encoded in the file header (and not total chunk count instead).
    @Test
    func trackCount() async throws {
        let chunk1: MusicalMIDI1File.TrackChunk = .init(events: [])
        let chunk2: MusicalMIDI1File.UndefinedChunk = .init(identifier: .undefined(identifier: "ABCD")!, data: Data([0x01, 0x02]))
        let chunk3: MusicalMIDI1File.TrackChunk = .init(events: [])
        let chunks: [MusicalMIDI1File.AnyChunk] = [.track(chunk1), .undefined(chunk2), .track(chunk3)]
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 720),
            chunks: chunks
        )
        
        // note track count is NOT total chunk count; non-track chunks are not included in the number
        // track count should be 2 even though there are 3 chunks that follow the header
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x01, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0, // timebase
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00,       // chunk end
                                
                                0x41, 0x42, 0x43, 0x44, // ABCD
                                0x00, 0x00, 0x00, 0x02, // length: 2 bytes to follow
                                0x01, 0x02,             // data bytes
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00        // chunk end
        ]
        
        #expect(try await midiFile.rawData().toUInt8Bytes() == rawData)
    }
    
    @Test
    func format0_ZeroTrackCount() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x00, // track count
                                0x02, 0xD0, // timebase
        ]
        
        // not allowed
        #expect(throws: MIDIFileDecodeError.self) {
            let _ = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: false)
        }
        
        // allowed
        do {
            let (header, trackCount) = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: true)
            #expect(header.format == .singleTrack)
            #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(trackCount == 0)
        }
    }
    
    @Test
    func format0_MultipleTrackCount() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0, // timebase
        ]
        
        // not allowed
        #expect(throws: MIDIFileDecodeError.self) {
            let _ = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: false)
        }
        
        // allowed
        do {
            let (header, trackCount) = try MusicalMIDI1File.HeaderChunk.decode(midi1FileRawBytes: rawData, allowMultiTrackFormat0: true)
            #expect(header.format == .singleTrack)
            #expect(header.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(trackCount == 2)
        }
    }
}
