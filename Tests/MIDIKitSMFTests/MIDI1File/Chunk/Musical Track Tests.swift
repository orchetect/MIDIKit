//
//  Musical Track Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct Musical_Track_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func emptyEvents() async throws {
        let events: [MusicalMIDI1File.Track.Event] = []
        
        let track = MusicalMIDI1File.Track(events: events)
        
        #expect(track.events == events)
        
        let bytes: [UInt8] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
            0x00,                   // delta time prior to chunk end
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let timebase: MusicalMIDI1File.Timebase = .musical(ticksPerQuarterNote: 960)
        let generatedData: Data = try track.midi1FileRawBytes(using: timebase)
        
        #expect(generatedData.toUInt8Bytes() == bytes)
        
        // parse raw bytes
        
        let parsedTrackA = try? MusicalMIDI1File.Track(
            midi1FileRawBytesStream: generatedData,
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackA == track)
        
        let parsedTrackB = try? MusicalMIDI1File.Track(
            midi1FileRawBytes: generatedData[8...], // exclude header and length
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackB == track)
    }
    
    @Test
    func withEvents() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .init(delta: .none, event: .noteOn(note: 60, velocity: .midi1(64), channel: 0)),
            .init(delta: .ticks(240), event: .cc(controller: .expression, value: .midi1(20), channel: 1))
        ]
        
        let track = MIDI1File.Track(events: events)
        
        #expect(track.events == events)
        
        let bytes: [UInt8] = [
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
        
        let timebase: MusicalMIDI1File.Timebase = .musical(ticksPerQuarterNote: 960)
        let generatedData: Data = try track.midi1FileRawBytes(using: timebase)
        
        #expect(generatedData.toUInt8Bytes() == bytes)
        
        // parse raw bytes
        
        let parsedTrackA = try? MusicalMIDI1File.Track(
            midi1FileRawBytesStream: generatedData,
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackA == track)
        
        let parsedTrackB = try? MusicalMIDI1File.Track(
            midi1FileRawBytes: generatedData[8...], // exclude header and length
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackB == track)
    }
    
    /// Encode and decode non-zero delta time before end-of-track bytes.
    @Test
    func deltaTimeBeforeEndOfTrack() async throws {
        let events: [MusicalMIDI1File.Track.Event] = []
        
        var track = MusicalMIDI1File.Track(events: events)
        track.deltaTimeBeforeEndOfTrack = .ticks(960)
        
        #expect(track.events == events)
        
        let bytes: [UInt8] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x05, // length: 5 bytes to follow
            0x87, 0x40,             // delta time prior to chunk end (960 ticks)
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let timebase: MusicalMIDI1File.Timebase = .musical(ticksPerQuarterNote: 960)
        let generatedData: Data = try track.midi1FileRawBytes(using: timebase)
        
        #expect(generatedData.toUInt8Bytes() == bytes)
        
        // parse raw bytes
        
        let parsedTrackA = try? MusicalMIDI1File.Track(
            midi1FileRawBytesStream: generatedData,
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackA == track)
        
        let parsedTrackB = try? MusicalMIDI1File.Track(
            midi1FileRawBytes: generatedData[8...], // exclude header and length
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackB == track)
    }
    
    /// This tests both `eventsAtBeatPositions()` and `eventsAtStart()` using the same source data.
    @Test
    func eventsAtBeatPositions_eventsAtStart() async throws {
        let ppq: UInt16 = 480
        let timebase: MusicalMIDI1File.Timebase = .musical(ticksPerQuarterNote: ppq)
        var midiFile = MusicalMIDI1File(timebase: timebase)
        
        midiFile.chunks = [
            .track([
                .text(
                    delta: .none,
                    type: .trackOrSequenceName,
                    string: "Seq-1"
                ),
                .smpteOffset(
                    delta: .none,
                    hr: 0,
                    min: 0,
                    sec: 0,
                    fr: 0,
                    subFr: 0,
                    rate: .fps29_97d
                ),
                .timeSignature(
                    delta: .none,
                    numerator: 4,
                    denominator: 2
                ),
                .tempo(
                    delta: .none,
                    bpm: 120.0
                ),
                .cc(delta: .ticks(480), controller: 11, value: .midi1(20)),
                .cc(delta: .ticks(480), controller: 11, value: .midi1(21)),
                .cc(delta: .ticks(480), controller: 11, value: .midi1(22)),
                .cc(delta: .ticks(480), controller: 11, value: .midi1(23)), // 1 bar
                .cc(delta: .ticks(480), controller: 11, value: .midi1(24)), // 1 bar + 1 beat
                .cc(delta: .ticks(240), controller: 11, value: .midi1(25)), // 1 bar + 1 beat + 8th note
                .cc(delta: .ticks(60), controller: 11, value: .midi1(26))   // 1 bar + 1 beat + 8th note + 32nd note
            ])
        ]
        
        let trackOne = try #require(midiFile.tracks.first)
        
        // eventsAtBeatPositions
        do {
            let events = trackOne.eventsAtBeatPositions(using: timebase)
            
            #expect(events.count == 11)
            
            #expect(events[0].beat == 0.0) // text
            #expect(events[1].beat == 0.0) // smpte offset
            #expect(events[2].beat == 0.0) // time sig
            #expect(events[3].beat == 0.0) // tempo
            #expect(events[4].beat == 1.0) // cc
            #expect(events[5].beat == 2.0) // cc
            #expect(events[6].beat == 3.0) // cc
            #expect(events[7].beat == 4.0) // cc
            #expect(events[8].beat == 5.0) // cc
            #expect(events[9].beat == 5.5) // cc
            #expect(events[10].beat == 5.625) // cc
            
            // just test a couple events to ensure they are as expected
            #expect(events[0].event == .text(type: .trackOrSequenceName, string: "Seq-1"))
            #expect(events[10].event == .cc(controller: 11, value: .midi1(26)))
        }
        
        // eventsAtStart
        do {
            let events = trackOne.eventsAtStart
            
            #expect(events.count == 4)
            
            #expect(events[0] == .text(type: .trackOrSequenceName, string: "Seq-1")) // text
            #expect(events[1] == .smpteOffset(hr: 0, min: 0, sec: 0, fr: 0, subFr: 0, rate: .fps29_97d)) // smpte offset
            #expect(events[2] == .timeSignature(numerator: 4, denominator: 2)) // time sig
            #expect(events[3] == .tempo(bpm: 120.0)) // tempo
        }
    }
    
    @Test
    func maxEventCount() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .noteOn(delta: .none, note: 60, velocity: .midi1(64), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(20), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(40), channel: 0),
            .noteOff(delta: .none, note: 60, velocity: .midi1(0), channel: 0)
        ]
        
        let track = MusicalMIDI1File.Track(events: events)
        
        // generate raw bytes
        
        let timebase: MusicalMIDI1File.Timebase = .musical(ticksPerQuarterNote: 960)
        let generatedData: Data = try track.midi1FileRawBytes(using: timebase)
        
        // create comparison track
        
        let limitedTrack = MusicalMIDI1File.Track(events: events[0 ... 1])
        
        // parse raw bytes and check event count
        
        let parsedTrackA = try? MusicalMIDI1File.Track(
            midi1FileRawBytesStream: generatedData,
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true, maxEventCount: 2)
        )
        #expect(parsedTrackA == limitedTrack)
        
        let parsedTrackB = try? MusicalMIDI1File.Track(
            midi1FileRawBytes: generatedData[8...], // exclude header and length
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true, maxEventCount: 2)
        )
        #expect(parsedTrackB == limitedTrack)
    }
    
    /// Regression test: Test authoring and parsing a Standard MIDI File with very large events.
    @Test(
        .bug(
            "https://github.com/orchetect/MIDIKit/issues/268",
            "Read-ahead buffer truncates large meta/sequencer-specific events"
        )
    )
    func largeEvents() async throws {
        // text event
        let textCharCount = Int.random(in: 10000 ... 20000)
        let textString: String = String(
            (0 ..< textCharCount)
                .map { _ in "ABCDEFabcdef1234567890-_ ".randomElement()! }
        )
        #expect(textString.count == textCharCount)
        let textEventPayload: MIDIFileEvent.Text = .init(text: textString)
        let textEvent: MusicalMIDI1File.Track.Event = .init(delta: .none, event: textEventPayload.asMIDIFileEvent())
        
        // sequencer-specific event
        let seqSpecificByteCount = Int.random(in: 10000 ... 20000)
        let seqSpecificData: [UInt8] = (0 ..< seqSpecificByteCount)
            .map { _ in UInt8.random(in: UInt8.min ... UInt8.max) }
        #expect(seqSpecificData.count == seqSpecificByteCount)
        let seqSpecificEventPayload: MIDIFileEvent.SequencerSpecific = .init(data: seqSpecificData)
        let seqSpecificEvent: MusicalMIDI1File.Track.Event = .init(delta: .none, event: seqSpecificEventPayload.asMIDIFileEvent())
        
        // author MIDI file
        let events: [MusicalMIDI1File.Track.Event] = [textEvent, seqSpecificEvent]
        let track = MusicalMIDI1File.Track(events: events)
        let midiFile = MusicalMIDI1File(format: .singleTrack, timebase: .musical(ticksPerQuarterNote: 480), chunks: [.track(track)])
        
        // encode and decode
        let midiFileData = try await midiFile.rawData()
        let decodedMIDIFile = try await MusicalMIDI1File(data: midiFileData)
        
        // compare events
        let decodedTrack = try #require(decodedMIDIFile.tracks.first)
        try #require(decodedTrack.events.count == 2)
        
        // extract events
        let decodedTextEventPayload: MIDIFileEvent.Text = try #require(
            decodedTrack.events[0].event.wrapped as? MIDIFileEvent.Text
        )
        let decodedSeqSpecificEventPayload: MIDIFileEvent.SequencerSpecific = try #require(
            decodedTrack.events[1].event.wrapped as? MIDIFileEvent.SequencerSpecific
        )
        
        // compare events
        #expect(decodedTextEventPayload == textEventPayload)
        #expect(decodedSeqSpecificEventPayload == seqSpecificEventPayload)
    }
    
    @Test
    func initialTempo_emptyTrack() async throws {
        let track = MusicalMIDI1File.Track(events: [])
        #expect(track.initialTempo == nil)
    }
    
    @Test
    func initialTempo_eventsWithoutTempo() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0)
        ]
        
        let track = MusicalMIDI1File.Track(events: events)
        #expect(track.initialTempo == nil)
    }
    
    @Test
    func initialTempo_eventsWithTempoAtStart() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .tempo(delta: .none, bpm: 160.0),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0)
        ]
        
        let track = MusicalMIDI1File.Track(events: events)
        #expect(track.initialTempo == .init(bpm: 160.0))
    }
    
    @Test
    func initialTempo_eventsWithTempoAfterStart() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0),
            .tempo(delta: .none, bpm: 160.0)
        ]
        
        let track = MusicalMIDI1File.Track(events: events)
        #expect(track.initialTempo == .init(bpm: 160.0))
    }
    
    @Test
    func initialTempo_eventsWithMultipleTempoEvents() async throws {
        let events: [MusicalMIDI1File.Track.Event] = [
            .keySignature(delta: .none, key: .bMajor),
            .timeSignature(delta: .none, numerator: 2, denominator: 2),
            .tempo(delta: .none, bpm: 140.0),
            .cc(delta: .note8th, controller: 1, value: .midi1(127), channel: 0),
            .tempo(delta: .none, bpm: 160.0)
        ]
        
        let track = MusicalMIDI1File.Track(events: events)
        #expect(track.initialTempo == .init(bpm: 140.0))
    }
}
