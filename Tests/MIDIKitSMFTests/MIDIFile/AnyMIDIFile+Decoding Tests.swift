//
//  AnyMIDIFile+Decoding Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitSMF
import Testing

@Suite struct AnyMIDIFile_Decoding_Tests {
    @Test
    func musicalTimebase() async throws {
        let anyMIDIFile = try await AnyMIDIFile(data: kMIDIFile.dp8Markers)
        
        #expect(anyMIDIFile.format == .multipleTracksSynchronous)
        #expect(anyMIDIFile.timebase == .musical(ticksPerQuarterNote: 480))
        
        guard case let .musical(midiFile) = anyMIDIFile else {
            Issue.record()
            return
        }
        
        #expect(midiFile.chunks.count == 3)
        #expect(midiFile.tracks.count == 3)
    }
    
    @Test
    func smpteTimebase() async throws {
        let anyMIDIFile = try await AnyMIDIFile(data: kMIDIFile.smpte)
        
        #expect(anyMIDIFile.format == .multipleTracksSynchronous)
        #expect(anyMIDIFile.timebase == .smpte(frameRate: .fps30, ticksPerFrame: 40))
        
        guard case let .smpte(midiFile) = anyMIDIFile else {
            Issue.record()
            return
        }
        
        #expect(midiFile.chunks.count == 3)
        #expect(midiFile.tracks.count == 3)
    }
}
