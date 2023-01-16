//
//  Header Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF
import MIDIKitInternals

final class Chunk_Header_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    func testInit_Type0() throws {
        let header = MIDIFile.Chunk.Header(
            format: .singleTrack,
            timeBase: .musical(ticksPerQuarterNote: 720)
        )
        
        XCTAssertEqual(header.format, .singleTrack)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        
        XCTAssertEqual(try header.midi1SMFRawBytes(withChunkCount: 1).bytes, rawData)
    }
    
    func testInit_Type0_rawData() throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        
        let header = try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        XCTAssertEqual(header.format, .singleTrack)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
    }
    
    func testInit_Type1() throws {
        let header = MIDIFile.Chunk.Header(
            format: .multipleTracksSynchronous,
            timeBase: .musical(ticksPerQuarterNote: 720)
        )
        
        XCTAssertEqual(header.format, .multipleTracksSynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x01, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        XCTAssertEqual(try header.midi1SMFRawBytes(withChunkCount: 2).bytes, rawData)
    }
    
    func testInit_Type1_rawData() throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x01, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        let header = try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        XCTAssertEqual(header.format, .multipleTracksSynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
    }
    
    func testInit_Type2() throws {
        let header = MIDIFile.Chunk.Header(
            format: .multipleTracksAsynchronous,
            timeBase: .musical(ticksPerQuarterNote: 720)
        )
        
        XCTAssertEqual(header.format, .multipleTracksAsynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        XCTAssertEqual(try header.midi1SMFRawBytes(withChunkCount: 2).bytes, rawData)
    }
    
    func testInit_Type2_rawData() throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x02, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0] // timebase
        
        let header = try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        XCTAssertEqual(header.format, .multipleTracksAsynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
    }
    
    // MARK: - Edge Cases
    
    func testInit_LengthIntTooShort() {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x05, // length (wrong)
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        XCTAssertThrowsError(
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        )
    }
    
    func testInit_LengthIntTooLong() {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x07, // length (wrong)
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0] // timebase
        XCTAssertThrowsError(
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        )
    }
    
    func testInit_LengthTooShort() {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02] // timebase, but too few bytes (wrong)
        
        XCTAssertThrowsError(
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        )
    }
    
    func testInit_MoreBytesThanExpected() {
        // valid header chunk, with an additional unexpected subsequent byte
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x01, // track count
                                0x02, 0xD0, // timebase
                                0x01] // an extra unexpected byte
        
        // since the header is always a known total number of bytes,
        // init will succeed and ignore any additional subsequent bytes
        XCTAssertNoThrow(
            try MIDIFile.Chunk.Header(midi1SMFRawBytes: rawData.data)
        )
    }
}

#endif
