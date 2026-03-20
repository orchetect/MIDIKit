//
//  Track Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct Chunk_Track_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func emptyEvents() async throws {
        let events: [MIDIFileEvent] = []
        
        let track = MIDIFile.AnyChunk.Track(events: events)
        
        #expect(track.events == events)
        
        let bytes: [UInt8] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
            0x00,                   // delta time prior to chunk end
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let timebase: MIDIFile.Timebase = .musical(ticksPerQuarterNote: 960)
        let generatedData: Data = try track.midi1SMFRawBytes(using: timebase)
        
        #expect(generatedData.toUInt8Bytes() == bytes)
        
        // parse raw bytes
        
        let parsedTrackA = try? MIDIFile.AnyChunk.Track(
            midi1SMFRawBytesStream: generatedData,
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackA == track)
        
        let parsedTrackB = try? MIDIFile.AnyChunk.Track(
            midi1SMFRawBytes: generatedData[8...], // exclude header and length
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackB == track)
    }
    
    @Test
    func withEvents() async throws {
        let events: [MIDIFileEvent] = [
            .noteOn(delta: .none, note: 60, velocity: .midi1(64), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(20), channel: 1)
        ]
        
        let track = MIDIFile.AnyChunk.Track(events: events)
        
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
        
        let timebase: MIDIFile.Timebase = .musical(ticksPerQuarterNote: 960)
        let generatedData: Data = try track.midi1SMFRawBytes(using: timebase)
        
        #expect(generatedData.toUInt8Bytes() == bytes)
        
        // parse raw bytes
        
        let parsedTrackA = try? MIDIFile.AnyChunk.Track(
            midi1SMFRawBytesStream: generatedData,
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackA == track)
        
        let parsedTrackB = try? MIDIFile.AnyChunk.Track(
            midi1SMFRawBytes: generatedData[8...], // exclude header and length
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true)
        )
        #expect(parsedTrackB == track)
    }
    
    @Test
    func eventsAtQuarterNotePositions() async throws {
        let ppq: UInt16 = 480
        var midiFile = MIDIFile(timebase: .musical(ticksPerQuarterNote: UInt16(ppq)))
        
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
                    frRate: .fps29_97d
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
        
        let eventsAtBeatPositions = trackOne.eventsAtQuarterNotePositions(atPPQ: ppq)
        
        #expect(eventsAtBeatPositions.count == 11)
        
        #expect(eventsAtBeatPositions[0].beat == 0.0) // text
        #expect(eventsAtBeatPositions[1].beat == 0.0) // smpte
        #expect(eventsAtBeatPositions[2].beat == 0.0) // time sig
        #expect(eventsAtBeatPositions[3].beat == 0.0) // tempo
        #expect(eventsAtBeatPositions[4].beat == 1.0) // cc
        #expect(eventsAtBeatPositions[5].beat == 2.0) // cc
        #expect(eventsAtBeatPositions[6].beat == 3.0) // cc
        #expect(eventsAtBeatPositions[7].beat == 4.0) // cc
        #expect(eventsAtBeatPositions[8].beat == 5.0) // cc
        #expect(eventsAtBeatPositions[9].beat == 5.5) // cc
        #expect(eventsAtBeatPositions[10].beat == 5.625) // cc
    }
    
    @Test
    func maxEventCount() async throws {
        let events: [MIDIFileEvent] = [
            .noteOn(delta: .none, note: 60, velocity: .midi1(64), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(20), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(40), channel: 0),
            .noteOff(delta: .none, note: 60, velocity: .midi1(0), channel: 0)
        ]
        
        let track = MIDIFile.AnyChunk.Track(events: events)
        
        // generate raw bytes
        
        let timebase: MIDIFile.Timebase = .musical(ticksPerQuarterNote: 960)
        let generatedData: Data = try track.midi1SMFRawBytes(using: timebase)
        
        // create comparison track
        
        let limitedTrack = MIDIFile.AnyChunk.Track(events: events[0 ... 1])
        
        // parse raw bytes and check event count
        
        let parsedTrackA = try? MIDIFile.AnyChunk.Track(
            midi1SMFRawBytesStream: generatedData,
            timebase: timebase,
            options: .init(bundleRPNAndNRPNEvents: true, maxEventCount: 2)
        )
        #expect(parsedTrackA == limitedTrack)
        
        let parsedTrackB = try? MIDIFile.AnyChunk.Track(
            midi1SMFRawBytes: generatedData[8...], // exclude header and length
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
        let textEvent: MIDIFileEvent = .text(delta: .none, event: textEventPayload)
        
        // sequencer-specific event
        let seqSpecificByteCount = Int.random(in: 10000 ... 20000)
        let seqSpecificData: [UInt8] = (0 ..< seqSpecificByteCount)
            .map { _ in UInt8.random(in: UInt8.min ... UInt8.max) }
        #expect(seqSpecificData.count == seqSpecificByteCount)
        let seqSpecificEventPayload: MIDIFileEvent.SequencerSpecific = .init(data: seqSpecificData)
        let seqSpecificEvent: MIDIFileEvent = .sequencerSpecific(delta: .none, event: seqSpecificEventPayload)
        
        // author MIDI file
        let events: [MIDIFileEvent] = [textEvent, seqSpecificEvent]
        let track = MIDIFile.AnyChunk.Track(events: events)
        let midiFile = MIDIFile(format: .singleTrack, timebase: .musical(ticksPerQuarterNote: 480), chunks: [.track(track)])
        
        // encode and decode
        let midiFileData = try await midiFile.rawData()
        let decodedMIDIFile = try await MIDIFile(data: midiFileData)
        
        // compare events
        let decodedTrack = try #require(decodedMIDIFile.tracks.first)
        try #require(decodedTrack.events.count == 2)
        
        // extract events
        let decodedTextEventPayload: MIDIFileEvent.Text = try #require(
            decodedTrack.events[0].smfUnwrappedEvent.event as? MIDIFileEvent.Text
        )
        let decodedSeqSpecificEventPayload: MIDIFileEvent.SequencerSpecific = try #require(
            decodedTrack.events[1].smfUnwrappedEvent.event as? MIDIFileEvent.SequencerSpecific
        )
        
        // compare events
        #expect(decodedTextEventPayload == textEventPayload)
        #expect(decodedSeqSpecificEventPayload == seqSpecificEventPayload)
    }
}
