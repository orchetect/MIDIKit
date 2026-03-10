//
//  MIDI File decode Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
import MIDIKitSMF
import Testing

@Suite struct MIDIFileDecodeTests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    /// Test parsing using NON-ASYNC method.
    /// Just ensure file parses successfully. Not testing contents in-depth.
    @Test
    func midiFileParse_NonAsync() /* NOT ASYNC! */ throws {
        // Note: It's ok if this throws a deprecation warning. We need to test this specific method.
        let midiFile = try /* NOT AWAIT! */ MIDIFile(rawData: kMIDIFile.dp8Markers)
        
        try #require(midiFile.chunks.count == 3)
        
        let encodedData = try midiFile.rawData()
        #expect(encodedData.toUInt8Bytes() == kMIDIFile.dp8Markers)
    }
    
    /// Test parsing using ASYNC method.
    /// Just ensure file parses successfully. Not testing contents in-depth.
    @Test
    func midiFileParse_Async() async throws { // MUST BE MARKED ASYNC!!!
        let midiFile = try await MIDIFile(rawData: kMIDIFile.dp8Markers)
        
        try #require(midiFile.chunks.count == 3)
        
        let encodedData = try midiFile.rawData()
        #expect(encodedData.toUInt8Bytes() == kMIDIFile.dp8Markers)
    }
    
    /// Test parsing a MIDI file that contains an unrecognized chunk.
    @Test
    func customChunk() async throws {
        let midiFile = try await MIDIFile(rawData: kMIDIFile.customChunk)
        
        try #require(midiFile.chunks.count == 2)
        
        // chunk 1 - track
        
        guard case let .track(track1) = midiFile.chunks[0] else {
            Issue.record()
            return
        }
        
        #expect(track1.events.count == 6)
        
        // chunk 2 - unknown chunk
        
        guard case let .other(unknownChunk) = midiFile.chunks[1] else {
            Issue.record()
            return
        }
        
        #expect(unknownChunk.identifier == "Kdoc")
        
        #expect(unknownChunk.rawData.count == 35)
        #expect(
            unknownChunk.rawData.toUInt8Bytes() ==
                [0x0D, 0x00, 0x00, 0x80, 0x3F, 0x10, 0x01, 0x22,
                 0x14, 0x0D, 0x00, 0x00, 0xF0, 0x41, 0x15, 0x00,
                 0x00, 0x48, 0x42, 0x1D, 0x00, 0x00, 0xA0, 0x41,
                 0x25, 0x00, 0x00, 0x20, 0x42, 0x30, 0x02, 0x38,
                 0x16, 0x40, 0x5A]
        )
    }
    
    // MARK: - DecodeOptions & Predicate
    
    @Test
    func decodeOptions_maxTrackEventCount() /* NOT ASYNC! */ throws {
        let options = MIDIFile.DecodeOptions(maxTrackEventCount: 1)
        // Note: It's ok if this throws a deprecation warning. We need to test this specific method.
        let midiFile = try /* NOT AWAIT! */ MIDIFile(rawData: kMIDIFile.dp8Markers, options: options)
        try #require(midiFile.chunks.count == 3)
        try #require(midiFile.tracks.count == 3)
        for track in midiFile.tracks {
            #expect(track.events.count == 1)
        }
    }
    
    @Test
    func decodeOptions_maxTrackEventCount_async() async throws {
        let options = MIDIFile.DecodeOptions(
            maxTrackEventCount: 1
        )
        let midiFile = try await MIDIFile(rawData: kMIDIFile.dp8Markers, options: options)
        try #require(midiFile.chunks.count == 3)
        try #require(midiFile.tracks.count == 3)
        for track in midiFile.tracks {
            #expect(track.events.count == 1)
        }
    }
    
    @Test
    func predicate() /* NOT ASYNC! */ throws {
        // Note: It's ok if this throws a deprecation warning. We need to test this specific method.
        let midiFile = try /* NOT AWAIT! */ MIDIFile(rawData: kMIDIFile.dp8Markers) { chunkType, chunkIndex in
            chunkType == .track && chunkIndex == 1
        }
        try #require(midiFile.chunks.count == 1)
        let track = midiFile.tracks[0]
        #expect(track.events.count == 3) // check if the correct track was included
    }
    
    @Test
    func predicate_async() async throws {
        let midiFile = try await MIDIFile(rawData: kMIDIFile.dp8Markers) { chunkType, chunkIndex in
            chunkType == .track && chunkIndex == 1
        }
        try #require(midiFile.chunks.count == 1)
        let track = midiFile.tracks[0]
        #expect(track.events.count == 3) // check if the correct track was included
    }
    
    @Test
    func decodeOptions_bundleRPNAndNRPNEvents() async throws {
        let rpnEvent = MIDIEvent.RPN(
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: 0x07),
            channel: 2
        )
        let event: MIDIFileEvent = .rpn(delta: .none, event: rpnEvent)
        let events: [MIDIFileEvent] = [event]
        
        let track = MIDIFile.Chunk.Track(events: events)
        let midiFile = MIDIFile(chunks: [.track(track)])
        
        let rawData = try midiFile.rawData()
        
        // decode without bundleRPNAndNRPNEvents
        do {
            let options = MIDIFile.DecodeOptions(bundleRPNAndNRPNEvents: false)
            let decodedMIDIFile = try await MIDIFile(rawData: rawData, options: options)
            #expect(decodedMIDIFile.tracks.count == 1)
            let decodedTrack = decodedMIDIFile.tracks[0]
            #expect(decodedTrack.events.count == 4)
            #expect(decodedTrack.events == [
                .cc(delta: .none, event: .init(controller: .rpnMSB, value: .midi1(0x05), channel: 2)),
                .cc(delta: .none, event: .init(controller: .rpnLSB, value: .midi1(0x10), channel: 2)),
                .cc(delta: .none, event: .init(controller: .dataEntry, value: .midi1(0x08), channel: 2)),
                .cc(delta: .none, event: .init(controller: .lsb(for: .dataEntry), value: .midi1(0x07), channel: 2))
            ])
        }
        
        // decode with bundleRPNAndNRPNEvents
        do {
            let options = MIDIFile.DecodeOptions(bundleRPNAndNRPNEvents: true)
            let decodedMIDIFile = try await MIDIFile(rawData: rawData, options: options)
            #expect(decodedMIDIFile.tracks.count == 1)
            let decodedTrack = decodedMIDIFile.tracks[0]
            #expect(decodedTrack.events.count == 1)
            #expect(decodedTrack.events == events)
        }
    }
}
