//
//  SMPTEMIDI1File+Decoding Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct SMPTEMIDI1File_Decoding_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func midiFileDecodeEncode() async throws {
        let midiFile = try await SMPTEMIDI1File(data: kMIDI1File.smpte)
        let encodedData = try await midiFile.rawData()
        #expect(encodedData.toUInt8Bytes() == kMIDI1File.smpte)
    }
    
    @Test
    func midiFile_CheckContents() async throws {
        let track1 = SMPTEMIDI1File.Track(events: [
            .cc(delta: .ticks(1000), controller: 1, value: .midi1(0x40), channel: 0)
        ])
        let track2 = SMPTEMIDI1File.Track(events: [
            .cc(delta: .ticks(2500), controller: 2, value: .midi1(0x46), channel: 0),
            .cc(delta: .ticks(500), controller: 2, value: .midi1(0x4B), channel: 0),
        ])
        let track3 = SMPTEMIDI1File.Track(events: [
            .noteOn(delta: .none, note: 0x30, velocity: .midi1(0x05), channel: 0)
        ])
        let tracks = [track1, track2, track3]
        
        // decode
        
        let midiFile = try await SMPTEMIDI1File(data: kMIDI1File.smpte)
        
        try #require(midiFile.header.additionalBytes == nil)
        try #require(midiFile.chunks.count == 3)
        try #require(midiFile.tracks.count == 3)
        
        #expect(midiFile.tracks == tracks)
    }
    
    @Test
    func midiFile_eventsAtTimecodeLocations() async throws {
        let track1 = SMPTEMIDI1File.Track(events: [
            .cc(delta: .ticks(1000), controller: 1, value: .midi1(0x40), channel: 0)
        ])
        let track2 = SMPTEMIDI1File.Track(events: [
            .cc(delta: .ticks(2500), controller: 2, value: .midi1(0x46), channel: 0),
            .cc(delta: .ticks(500), controller: 2, value: .midi1(0x4B), channel: 0),
        ])
        let track3 = SMPTEMIDI1File.Track(events: [
            .noteOn(delta: .none, note: 0x30, velocity: .midi1(0x05), channel: 0)
        ])
        let tracks = [track1, track2, track3]
        
        // decode
        
        let midiFile = try await SMPTEMIDI1File(data: kMIDI1File.smpte)
        
        try #require(midiFile.header.additionalBytes == nil)
        try #require(midiFile.chunks.count == 3)
        try #require(midiFile.tracks.count == 3)
        
        #expect(midiFile.tracks == tracks)
    }
}

@Suite struct SMPTEMIDI1File_DeltaTime_Tests {
    typealias Offset = MIDIFileEvent.SMPTEOffset
    typealias Delta = SMPTEMIDI1File.Track.DeltaTime
    
    @Test
    func deltaTime_25fps_40tpf() async throws {
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, subFr: 00, rate: .fps25)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 40))
                == 0
        )
        
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 01, fr: 00, subFr: 00, rate: .fps25)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 40))
                == 1000
        )
        
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 02, fr: 00, subFr: 00, rate: .fps25)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 40))
                == 2000
        )
    }
    
    @Test
    func deltaTime_25fps_20tpf() async throws {
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, subFr: 00, rate: .fps25)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 20))
                == 0
        )
        
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 01, fr: 00, subFr: 00, rate: .fps25)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 20))
                == 500
        )
        
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 02, fr: 00, subFr: 00, rate: .fps25)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 20))
                == 1000
        )
    }
    
    @Test
    func deltaTime_30fps_100tpf() async throws {
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, subFr: 00, rate: .fps30)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 100))
                == 0
        )
        
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 01, fr: 00, subFr: 00, rate: .fps30)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 100))
                == 3000
        )
        
        #expect(
            Delta.offset(hr: 00, min: 00, sec: 02, fr: 00, subFr: 00, rate: .fps30)
                .ticks(using: .smpte(frameRate: .fps25, ticksPerFrame: 100))
                == 6000
        )
    }
}
