//
//  Track Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF
import OTCore

final class Chunk_Track_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    func testEmptyEvents() throws {
        let events: [MIDIFileEvent] = []
        
        let track = MIDIFile.Chunk.Track(events: events)
        
        XCTAssertEqual(track.events, events)
        
        let bytes: [Byte] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
            0x00,                   // delta time prior to chunk end
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let generatedData: Data = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        )
        
        XCTAssertEqual(generatedData.bytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk.Track(midi1SMFRawBytesStream: generatedData)
        
        XCTAssertEqual(parsedTrack, parsedTrack)
    }
    
    func testWithEvents() throws {
        let events: [MIDIFileEvent] = [
            .noteOn(delta: .none, note: 60, velocity: .midi1(64), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(20), channel: 1)
        ]
        
        let track = MIDIFile.Chunk.Track(events: events)
        
        XCTAssertEqual(track.events, events)
        
        let bytes: [Byte] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x0D, // length: 13 bytes to follow
            0x00,                   // delta time
            0x90, 0x3C, 0x40,       // note on event
            0x81, 0x70,             // delta time
            0xB1, 0x0B, 0x14,       // cc event
            0x00,                   // delta time prior to chunk end
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let generatedData: Data = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        )
        
        XCTAssertEqual(generatedData.bytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk.Track(midi1SMFRawBytesStream: generatedData)
        
        XCTAssertEqual(parsedTrack, parsedTrack)
    }
    
    // MARK: - Edge Cases
}

#endif
