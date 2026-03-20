//
//  MIDI File Tracks Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitSMF
import Testing

@Suite struct MIDIFileTracksTests {
    @Test
    func tracksProperty_NoOtherChunksPresent() async throws {
        let trackA = MIDIFile.TrackChunk(events: [
            .noteOn(note: 60, velocity: .midi1(64))
        ])
        
        let trackB = MIDIFile.TrackChunk(events: [
            .noteOn(note: 61, velocity: .midi1(75))
        ])
        
        let trackC = MIDIFile.TrackChunk(events: [
            .noteOn(note: 62, velocity: .midi1(80))
        ])
        
        var midiFile = MIDIFile()
        
        #expect(midiFile.tracks.isEmpty)
        
        // modify array
        midiFile.tracks.append(trackA)
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackA])
        
        // insert into array
        midiFile.tracks.insert(trackB, at: 0)
        #expect(midiFile.tracks.count == 2)
        #expect(midiFile.tracks == [trackB, trackA])
        
        // replace with fewer tracks
        midiFile.tracks = [trackC]
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackC])
        
        // replace with empty array
        midiFile.tracks = []
        #expect(midiFile.tracks.isEmpty)
        #expect(midiFile.tracks == [])
    }
    
    @Test
    func tracksProperty_WithOtherChunksPresent() async throws {
        let trackA = MIDIFile.TrackChunk(events: [
            .noteOn(note: 60, velocity: .midi1(64))
        ])
        
        let trackB = MIDIFile.TrackChunk(events: [
            .noteOn(note: 61, velocity: .midi1(75))
        ])
        
        let trackC = MIDIFile.TrackChunk(events: [
            .noteOn(note: 62, velocity: .midi1(80))
        ])
        
        let trackD = MIDIFile.TrackChunk(events: [
            .noteOn(note: 63, velocity: .midi1(85))
        ])
        
        let chunkA = MIDIFile.UnrecognizedChunk(identifier: .unrecognized(identifier: "ABCD")!, data: Data([0x01]))
        let chunkB = MIDIFile.UnrecognizedChunk(identifier: .unrecognized(identifier: "EFGH")!, data: Data([0x02, 0x03]))
        
        var midiFile = MIDIFile(chunks: [
            .unrecognized(chunkA), .track(trackA), .unrecognized(chunkB)
        ])
        
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackA])
        
        // modify array
        midiFile.tracks.append(trackB)
        #expect(midiFile.tracks.count == 2)
        #expect(midiFile.tracks == [trackA, trackB])
        #expect(midiFile.chunks.count == 4)
        #expect(midiFile.chunks == [.unrecognized(chunkA), .track(trackA), .unrecognized(chunkB), .track(trackB)])
        
        // insert into array
        midiFile.tracks.insert(trackC, at: 0)
        #expect(midiFile.tracks.count == 3)
        #expect(midiFile.tracks == [trackC, trackA, trackB])
        #expect(midiFile.chunks.count == 5)
        #expect(midiFile.chunks == [.unrecognized(chunkA), .track(trackC), .unrecognized(chunkB), .track(trackA), .track(trackB)])
        
        // replace with fewer tracks
        midiFile.tracks = [trackD]
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackD])
        #expect(midiFile.chunks.count == 3)
        #expect(midiFile.chunks == [.unrecognized(chunkA), .track(trackD), .unrecognized(chunkB)])
        
        // modify array
        midiFile.tracks.append(trackB)
        #expect(midiFile.tracks.count == 2)
        #expect(midiFile.tracks == [trackD, trackB])
        #expect(midiFile.chunks.count == 4)
        #expect(midiFile.chunks == [.unrecognized(chunkA), .track(trackD), .unrecognized(chunkB), .track(trackB)])
        
        // replace with more tracks
        midiFile.tracks = [trackA, trackB, trackC]
        #expect(midiFile.tracks.count == 3)
        #expect(midiFile.tracks == [trackA, trackB, trackC])
        #expect(midiFile.chunks.count == 5)
        #expect(midiFile.chunks == [.unrecognized(chunkA), .track(trackA), .unrecognized(chunkB), .track(trackB), .track(trackC)])
        
        // replace with empty array
        midiFile.tracks = []
        #expect(midiFile.tracks.isEmpty)
        #expect(midiFile.tracks == [])
        #expect(midiFile.chunks.count == 2)
        #expect(midiFile.chunks == [.unrecognized(chunkA), .unrecognized(chunkB)])
        
        // modify array
        midiFile.tracks.append(trackB)
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackB])
        #expect(midiFile.chunks.count == 3)
        #expect(midiFile.chunks == [.unrecognized(chunkA), .unrecognized(chunkB), .track(trackB)])
    }
}
