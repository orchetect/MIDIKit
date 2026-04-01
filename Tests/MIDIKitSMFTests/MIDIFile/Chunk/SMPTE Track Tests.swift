//
//  SMPTE Track Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct SMPTE_Track_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    @Test
    func eventsAtTimecodeLocations() async throws {
        let tpf: UInt8 = 40
        let timebase: SMPTEMIDIFile.Timebase = .smpte(frameRate: .fps25, ticksPerFrame: tpf)
        var midiFile = SMPTEMIDIFile(timebase: timebase)
        
        midiFile.chunks = [
            .track([
                .text(
                    delta: .none,
                    type: .trackOrSequenceName,
                    string: "Seq-1"
                ),
                .smpteOffset(
                    delta: .none,
                    hr: 1,
                    min: 0,
                    sec: 0,
                    fr: 0,
                    subFr: 0,
                    rate: .fps25
                ),
                .cc(delta: .ticks(500), controller: 11, value: .midi1(20)),
                .cc(delta: .ticks(500), controller: 11, value: .midi1(21)),
                .cc(delta: .ticks(500), controller: 11, value: .midi1(22)),
                .cc(delta: .ticks(500), controller: 11, value: .midi1(23)),
                .cc(delta: .ticks(160), controller: 11, value: .midi1(24)), // 4 frames
                .cc(delta: .ticks(840), controller: 11, value: .midi1(25)), // 21 frames
                .cc(delta: .ticks(1000 * 60 * 60), controller: 11, value: .midi1(26)) // 1 hour of timecode
            ])
        ]
        
        let trackOne = try #require(midiFile.tracks.first)
        
        // note that by default, this method checks for a SMPTE Offset event at time==0 (start of the track)
        // and uses it as the track's origin (offset) with which to offset all track event timecodes
        let e = trackOne.eventsAtTimecodeLocations(using: timebase)
        
        #expect(e.count == 9)
        
        #expect(try e[0].timecode == Timecode(.components(h: 01, m: 00, s: 00, f: 00, sf: 00), at: .fps25)) // text
        #expect(try e[1].timecode == Timecode(.components(h: 01, m: 00, s: 00, f: 00, sf: 00), at: .fps25)) // smpte offset
        #expect(try e[2].timecode == Timecode(.components(h: 01, m: 00, s: 00, f: 12, sf: 50), at: .fps25)) // cc
        #expect(try e[3].timecode == Timecode(.components(h: 01, m: 00, s: 01, f: 00, sf: 00), at: .fps25)) // cc
        #expect(try e[4].timecode == Timecode(.components(h: 01, m: 00, s: 01, f: 12, sf: 50), at: .fps25)) // cc
        #expect(try e[5].timecode == Timecode(.components(h: 01, m: 00, s: 02, f: 00, sf: 00), at: .fps25)) // cc
        #expect(try e[6].timecode == Timecode(.components(h: 01, m: 00, s: 02, f: 04, sf: 00), at: .fps25)) // cc
        #expect(try e[7].timecode == Timecode(.components(h: 01, m: 00, s: 03, f: 00, sf: 00), at: .fps25)) // cc
        #expect(try e[8].timecode == Timecode(.components(h: 02, m: 00, s: 03, f: 00, sf: 00), at: .fps25)) // cc
        
        // just test a couple events to ensure they are as expected
        #expect(e[0].event == .text(type: .trackOrSequenceName, string: "Seq-1"))
        #expect(e[8].event == .cc(controller: 11, value: .midi1(26)))
    }
}
