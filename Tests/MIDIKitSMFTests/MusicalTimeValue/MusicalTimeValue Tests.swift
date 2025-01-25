//
//  MusicalTimeValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct MusicalTimeValueTests {
    @Test
    func empty() throws {
        let ppq = 480
        
        let mt = MusicalTimeValue(elapsedTicks: 0, beatsPerBar: 4, divisionsPerBeat: 0, ppq: ppq)
        
        #expect(mt.bar == 0)
        #expect(mt.beat == 0)
        #expect(mt.beatDivision == 0)
        #expect(mt.ticks == 0)
        
        #expect(mt.elapsedTicks() == 0)
        #expect(mt.elapsedBeats() == 0.0)
        #expect(!mt.isNegative)
    }
    
    @Test
    func eighth() throws {
        let ppq = 480
        
        let mt = MusicalTimeValue(elapsedTicks: 240, beatsPerBar: 4, divisionsPerBeat: 0, ppq: ppq)
        
        #expect(mt.bar == 0)
        #expect(mt.beat == 0)
        #expect(mt.beatDivision == 0)
        #expect(mt.ticks == 240)
        
        #expect(mt.elapsedTicks() == 240)
        #expect(mt.elapsedBeats() == 0.5)
        #expect(!mt.isNegative)
    }
    
    /// 0 beatsPerBar (invalid), but it internally clamps to 1
    @Test
    func zeroBeatsPerBar() throws {
        let ppq = 480
        
        let mt = MusicalTimeValue(
            elapsedTicks: ppq * 8,
            beatsPerBar: 0,
            divisionsPerBeat: 0,
            ppq: ppq
        )
        
        #expect(mt.bar == 8)
        #expect(mt.beat == 0)
        #expect(mt.beatDivision == 0)
        #expect(mt.ticks == 00)
        
        #expect(mt.elapsedTicks() == ppq * 8)
        #expect(mt.elapsedBeats() == 8.0)
        #expect(!mt.isNegative)
    }
    
    /// 1 beatsPerBar (valid)
    @Test
    func oneBeatsPerBar() throws {
        let ppq = 480
        
        let elapsedTicks = (ppq * 9) + 240 + 60
        let mt = MusicalTimeValue(
            elapsedTicks: elapsedTicks,
            beatsPerBar: 1,
            divisionsPerBeat: 0,
            ppq: ppq
        )
        
        #expect(mt.bar == 9)
        #expect(mt.beat == 0)
        #expect(mt.beatDivision == 0)
        #expect(mt.ticks == 300)
        
        #expect(mt.elapsedTicks() == elapsedTicks)
        #expect(mt.elapsedBeats() == 9.625)
        #expect(!mt.isNegative)
    }
    
    @Test
    func negativeElapsedTicks() throws {
        let ppq = 480
        
        let elapsedTicks = -((ppq * 9) + 240 + 60)
        let mt = MusicalTimeValue(
            elapsedTicks: elapsedTicks,
            beatsPerBar: 4,
            divisionsPerBeat: 4,
            ppq: ppq
        )
        
        #expect(mt.bar == 2)
        #expect(mt.beat == 1)
        #expect(mt.beatDivision == 2)
        #expect(mt.ticks == 60)
        
        #expect(mt.elapsedTicks() == elapsedTicks)
        #expect(mt.elapsedBeats() == -9.625)
        #expect(mt.isNegative)
    }
    
    @Test
    func elapsedTicks() throws {
        let ppq = 480
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
        
        let deltaTimes = trackOne.events.map {
            $0.delta.ticksValue(using: .musical(ticksPerQuarterNote: UInt16(ppq)))
        }
        
        let deltaSum = Int(deltaTimes.reduce(into: 0, +=))
        
        // 4 divisions per beat
        do {
            let mt = MusicalTimeValue(
                elapsedTicks: deltaSum,
                beatsPerBar: 4,
                divisionsPerBeat: 4,
                ppq: ppq
            )
            
            #expect(mt.bar == 1)
            #expect(mt.beat == 1)
            #expect(mt.beatDivision == 2)
            #expect(mt.ticks == 60)
            
            #expect(mt.elapsedTicks() == deltaSum)
            #expect(mt.elapsedBeats() == 5.625)
            #expect(!mt.isNegative)
        }
        
        // 8 divisions per beat
        do {
            let mt = MusicalTimeValue(
                elapsedTicks: deltaSum,
                beatsPerBar: 4,
                divisionsPerBeat: 8,
                ppq: ppq
            )
            
            #expect(mt.bar == 1)
            #expect(mt.beat == 1)
            #expect(mt.beatDivision == 5)
            #expect(mt.ticks == 0)
            
            #expect(mt.elapsedTicks() == deltaSum)
            #expect(mt.elapsedBeats() == 5.625)
            #expect(!mt.isNegative)
        }
        
        // 0 divisions per beat
        do {
            let mt = MusicalTimeValue(
                elapsedTicks: deltaSum,
                beatsPerBar: 4,
                divisionsPerBeat: 0,
                ppq: ppq
            )
            
            #expect(mt.bar == 1)
            #expect(mt.beat == 1)
            #expect(mt.beatDivision == 0)
            #expect(mt.ticks == 300)
            
            #expect(mt.elapsedTicks() == deltaSum)
            #expect(mt.elapsedBeats() == 5.625)
            #expect(!mt.isNegative)
        }
    }
}
