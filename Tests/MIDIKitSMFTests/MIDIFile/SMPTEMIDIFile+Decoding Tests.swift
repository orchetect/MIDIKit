//
//  SMPTEMIDIFile+Decoding Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct SMPTEMIDIFile_Decoding_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func midiFileDecodeEncode() async throws {
        let midiFile = try await SMPTEMIDIFile(data: kMIDIFile.smpte)
        let encodedData = try await midiFile.rawData()
        #expect(encodedData.toUInt8Bytes() == kMIDIFile.smpte)
    }
    
    @Test
    func midiFile_CheckContents() async throws {
        let track1 = SMPTEMIDIFile.TrackChunk(events: [
            .cc(delta: .ticks(1000), controller: 1, value: .midi1(0x40), channel: 0)
        ])
        let track2 = SMPTEMIDIFile.TrackChunk(events: [
            .cc(delta: .ticks(2500), controller: 2, value: .midi1(0x46), channel: 0),
            .cc(delta: .ticks(500), controller: 2, value: .midi1(0x4B), channel: 0),
        ])
        let track3 = SMPTEMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x30, velocity: .midi1(0x05), channel: 0)
        ])
        let tracks = [track1, track2, track3]
        
        // decode
        
        let midiFile = try await SMPTEMIDIFile(data: kMIDIFile.smpte)
        
        try #require(midiFile.header.additionalBytes == nil)
        try #require(midiFile.chunks.count == 3)
        try #require(midiFile.tracks.count == 3)
        
        #expect(midiFile.tracks == tracks)
    }
}
