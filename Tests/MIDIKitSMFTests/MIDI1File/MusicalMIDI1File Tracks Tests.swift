//
//  MusicalMIDI1File Tracks Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitSMF
import Testing

@Suite struct MusicalMIDI1File_Tracks_Tests {
    @Test
    func tracksProperty_NoOtherChunksPresent() async throws {
        let trackA = MusicalMIDI1File.Track(events: [
            .noteOn(note: 60, velocity: .midi1(64))
        ])
        
        let trackB = MusicalMIDI1File.Track(events: [
            .noteOn(note: 61, velocity: .midi1(75))
        ])
        
        let trackC = MusicalMIDI1File.Track(events: [
            .noteOn(note: 62, velocity: .midi1(80))
        ])
        
        var midiFile = MusicalMIDI1File()
        
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
        let trackA = MusicalMIDI1File.Track(events: [
            .noteOn(note: 60, velocity: .midi1(64))
        ])
        
        let trackB = MusicalMIDI1File.Track(events: [
            .noteOn(note: 61, velocity: .midi1(75))
        ])
        
        let trackC = MusicalMIDI1File.Track(events: [
            .noteOn(note: 62, velocity: .midi1(80))
        ])
        
        let trackD = MusicalMIDI1File.Track(events: [
            .noteOn(note: 63, velocity: .midi1(85))
        ])
        
        let chunkA = MusicalMIDI1File.UndefinedChunk(identifier: .undefined(identifier: "ABCD")!, data: Data([0x01]))
        let chunkB = MusicalMIDI1File.UndefinedChunk(identifier: .undefined(identifier: "EFGH")!, data: Data([0x02, 0x03]))
        
        var midiFile = MusicalMIDI1File(chunks: [
            .undefined(chunkA), .track(trackA), .undefined(chunkB)
        ])
        
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackA])
        
        // modify array
        midiFile.tracks.append(trackB)
        #expect(midiFile.tracks.count == 2)
        #expect(midiFile.tracks == [trackA, trackB])
        #expect(midiFile.chunks.count == 4)
        #expect(midiFile.chunks == [.undefined(chunkA), .track(trackA), .undefined(chunkB), .track(trackB)])
        
        // insert into array
        midiFile.tracks.insert(trackC, at: 0)
        #expect(midiFile.tracks.count == 3)
        #expect(midiFile.tracks == [trackC, trackA, trackB])
        #expect(midiFile.chunks.count == 5)
        #expect(midiFile.chunks == [.undefined(chunkA), .track(trackC), .undefined(chunkB), .track(trackA), .track(trackB)])
        
        // replace with fewer tracks
        midiFile.tracks = [trackD]
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackD])
        #expect(midiFile.chunks.count == 3)
        #expect(midiFile.chunks == [.undefined(chunkA), .track(trackD), .undefined(chunkB)])
        
        // modify array
        midiFile.tracks.append(trackB)
        #expect(midiFile.tracks.count == 2)
        #expect(midiFile.tracks == [trackD, trackB])
        #expect(midiFile.chunks.count == 4)
        #expect(midiFile.chunks == [.undefined(chunkA), .track(trackD), .undefined(chunkB), .track(trackB)])
        
        // replace with more tracks
        midiFile.tracks = [trackA, trackB, trackC]
        #expect(midiFile.tracks.count == 3)
        #expect(midiFile.tracks == [trackA, trackB, trackC])
        #expect(midiFile.chunks.count == 5)
        #expect(midiFile.chunks == [.undefined(chunkA), .track(trackA), .undefined(chunkB), .track(trackB), .track(trackC)])
        
        // replace with empty array
        midiFile.tracks = []
        #expect(midiFile.tracks.isEmpty)
        #expect(midiFile.tracks == [])
        #expect(midiFile.chunks.count == 2)
        #expect(midiFile.chunks == [.undefined(chunkA), .undefined(chunkB)])
        
        // modify array
        midiFile.tracks.append(trackB)
        #expect(midiFile.tracks.count == 1)
        #expect(midiFile.tracks == [trackB])
        #expect(midiFile.chunks.count == 3)
        #expect(midiFile.chunks == [.undefined(chunkA), .undefined(chunkB), .track(trackB)])
    }
    
    @Test
    func initialTempo_noTracks() async throws {
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 480),
            tracks: []
        )
        #expect(midiFile.initialTempo == nil)
    }
    
    @Test
    func initialTempo_oneTrack_emptyTrack() async throws {
        let track = MusicalMIDI1File.Track(events: [])
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 480),
            tracks: [track]
        )
        #expect(midiFile.initialTempo == nil)
    }
    
    @Test
    func initialTempo_oneTrack_eventsWithoutTempo() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0)
        ]
        let track = MusicalMIDI1File.Track(events: events)
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 480),
            tracks: [track]
        )
        #expect(midiFile.initialTempo == nil)
    }
    
    @Test
    func initialTempo_oneTrack_eventsWithTempoAtStart() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .tempo(delta: .none, bpm: 160.0),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0)
        ]
        let track = MusicalMIDI1File.Track(events: events)
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 480),
            tracks: [track]
        )
        #expect(midiFile.initialTempo == .init(bpm: 160.0))
    }
    
    @Test
    func initialTempo_oneTrack_eventsWithTempoAfterStart() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0),
            .tempo(delta: .none, bpm: 160.0)
        ]
        let track = MusicalMIDI1File.Track(events: events)
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 480),
            tracks: [track]
        )
        #expect(midiFile.initialTempo == nil)
    }
    
    @Test
    func initialTempo_oneTrack_eventsWithMultipleTempoEvents() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .tempo(delta: .none, bpm: 140.0),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0),
            .tempo(delta: .none, bpm: 160.0)
        ]
        let track = MusicalMIDI1File.Track(events: events)
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 480),
            tracks: [track]
        )
        #expect(midiFile.initialTempo == .init(bpm: 140.0))
    }
    
    @Test
    func initialTempo_multipleTracks_eventsWithMultipleTempoEvents() async throws {
        let track0Events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0),
        ]
        let track0 = MusicalMIDI1File.Track(events: track0Events)
        
        let track1Events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .tempo(delta: .none, bpm: 140.0),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0),
            .tempo(delta: .none, bpm: 160.0)
        ]
        let track1 = MusicalMIDI1File.Track(events: track1Events)
        
        let midiFile = MusicalMIDI1File(
            format: .multipleTracksSynchronous,
            timebase: .musical(ticksPerQuarterNote: 480),
            tracks: [track0, track1]
        )
        #expect(midiFile.initialTempo == .init(bpm: 140.0))
    }
}
