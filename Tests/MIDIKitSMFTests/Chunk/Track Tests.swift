//
//  Track Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import MIDIKitSMF
import Testing

@Suite struct Chunk_Track_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    /// Ensure that event decode order contains all event types and that there are no duplicates.
    @Test
    func eventDecodeOrder() {
        // check count matches since an array can contain more than one of the same identical element
        #expect(
            Set(MIDIFile.Chunk.Track.eventDecodeOrder).count ==
            MIDIFileEventType.allCases.count
        )
        
        // ensure order contains all cases
        for eventType in MIDIFileEventType.allCases {
            #expect(MIDIFile.Chunk.Track.eventDecodeOrder.filter { $0 == eventType }.count == 1)
        }
    }
    
    @Test
    func emptyEvents() throws {
        let events: [MIDIFileEvent] = []
        
        let track = MIDIFile.Chunk.Track(events: events)
        
        #expect(track.events == events)
        
        let bytes: [UInt8] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
            0x00,                   // delta time prior to chunk end
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let generatedData: Data = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        )
        
        #expect(generatedData.bytes == bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk.Track(midi1SMFRawBytesStream: generatedData)
        
        #expect(parsedTrack == parsedTrack)
    }
    
    @Test
    func withEvents() throws {
        let events: [MIDIFileEvent] = [
            .noteOn(delta: .none, note: 60, velocity: .midi1(64), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(20), channel: 1)
        ]
        
        let track = MIDIFile.Chunk.Track(events: events)
        
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
        
        let generatedData: Data = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        )
        
        #expect(generatedData.bytes == bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDIFile.Chunk.Track(midi1SMFRawBytesStream: generatedData)
        
        #expect(parsedTrack == parsedTrack)
    }
    
    // MARK: - Events
    
    @Test
    func eventsAtBeatPositions() throws {
        let ppq: UInt16 = 480
        var midiFile = MIDIFile(timeBase: .musical(ticksPerQuarterNote: UInt16(ppq)))
        
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
        
        let eventsAtBeatPositions = trackOne.eventsAtBeatPositions(ppq: ppq)
        
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
}
