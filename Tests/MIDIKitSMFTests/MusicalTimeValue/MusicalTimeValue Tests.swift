//
//  MusicalTimeValue Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class MusicalTimeValueTests: XCTestCase {
    func testEmpty() throws {
        let ppq = 480
        
        let mt = MusicalTimeValue(elapsedTicks: 0, beatsPerBar: 4, divisionsPerBeat: 0, ppq: ppq)
        
        XCTAssertEqual(mt.bar, 0)
        XCTAssertEqual(mt.beat, 0)
        XCTAssertEqual(mt.beatDivision, 0)
        XCTAssertEqual(mt.ticks, 0)
        
        XCTAssertEqual(mt.elapsedTicks(), 0)
        XCTAssertEqual(mt.elapsedBeats(), 0.0)
        XCTAssertFalse(mt.isNegative)
    }
    
    func testEighth() throws {
        let ppq = 480
        
        let mt = MusicalTimeValue(elapsedTicks: 240, beatsPerBar: 4, divisionsPerBeat: 0, ppq: ppq)
        
        XCTAssertEqual(mt.bar, 0)
        XCTAssertEqual(mt.beat, 0)
        XCTAssertEqual(mt.beatDivision, 0)
        XCTAssertEqual(mt.ticks, 240)
        
        XCTAssertEqual(mt.elapsedTicks(), 240)
        XCTAssertEqual(mt.elapsedBeats(), 0.5)
        XCTAssertFalse(mt.isNegative)
    }
    
    /// 0 beatsPerBar (invalid), but it internally clamps to 1
    func test0BeatsPerBar() throws {
        let ppq = 480
        
        let mt = MusicalTimeValue(elapsedTicks: ppq * 8, beatsPerBar: 0, divisionsPerBeat: 0, ppq: ppq)
        
        XCTAssertEqual(mt.bar, 8)
        XCTAssertEqual(mt.beat, 0)
        XCTAssertEqual(mt.beatDivision, 0)
        XCTAssertEqual(mt.ticks, 00)
        
        XCTAssertEqual(mt.elapsedTicks(), ppq * 8)
        XCTAssertEqual(mt.elapsedBeats(), 8.0)
        XCTAssertFalse(mt.isNegative)
    }
    
    /// 1 beatsPerBar (valid)
    func test1BeatsPerBar() throws {
        let ppq = 480
        
        let elapsedTicks = (ppq * 9) + 240 + 60
        let mt = MusicalTimeValue(elapsedTicks: elapsedTicks, beatsPerBar: 1, divisionsPerBeat: 0, ppq: ppq)
        
        XCTAssertEqual(mt.bar, 9)
        XCTAssertEqual(mt.beat, 0)
        XCTAssertEqual(mt.beatDivision, 0)
        XCTAssertEqual(mt.ticks, 300)
        
        XCTAssertEqual(mt.elapsedTicks(), elapsedTicks)
        XCTAssertEqual(mt.elapsedBeats(), 9.625)
        XCTAssertFalse(mt.isNegative)
    }
    
    func testNegativeElapsedTicks() throws {
        let ppq = 480
        
        let elapsedTicks = -((ppq * 9) + 240 + 60)
        let mt = MusicalTimeValue(elapsedTicks: elapsedTicks, beatsPerBar: 4, divisionsPerBeat: 4, ppq: ppq)
        
        XCTAssertEqual(mt.bar, 2)
        XCTAssertEqual(mt.beat, 1)
        XCTAssertEqual(mt.beatDivision, 2)
        XCTAssertEqual(mt.ticks, 60)
        
        XCTAssertEqual(mt.elapsedTicks(), elapsedTicks)
        XCTAssertEqual(mt.elapsedBeats(), -9.625)
        XCTAssertTrue(mt.isNegative)
    }
    
    func testElapsedTicks() throws {
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
                    frRate: ._2997dfps
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
        
        let trackOne = try XCTUnwrap(midiFile.tracks.first)
        
        let deltaTimes = trackOne.events.map {
            $0.delta.ticksValue(using: .musical(ticksPerQuarterNote: UInt16(ppq)))
        }
        
        let deltaSum = Int(deltaTimes.reduce(into: 0, +=))
        
        // 4 divisions per beat
        do {
            let mt = MusicalTimeValue(elapsedTicks: deltaSum, beatsPerBar: 4, divisionsPerBeat: 4, ppq: ppq)
            
            XCTAssertEqual(mt.bar, 1)
            XCTAssertEqual(mt.beat, 1)
            XCTAssertEqual(mt.beatDivision, 2)
            XCTAssertEqual(mt.ticks, 60)
            
            XCTAssertEqual(mt.elapsedTicks(), deltaSum)
            XCTAssertEqual(mt.elapsedBeats(), 5.625)
            XCTAssertFalse(mt.isNegative)
        }
        
        // 8 divisions per beat
        do {
            let mt = MusicalTimeValue(elapsedTicks: deltaSum, beatsPerBar: 4, divisionsPerBeat: 8, ppq: ppq)
            
            XCTAssertEqual(mt.bar, 1)
            XCTAssertEqual(mt.beat, 1)
            XCTAssertEqual(mt.beatDivision, 5)
            XCTAssertEqual(mt.ticks, 0)
            
            XCTAssertEqual(mt.elapsedTicks(), deltaSum)
            XCTAssertEqual(mt.elapsedBeats(), 5.625)
            XCTAssertFalse(mt.isNegative)
        }
        
        // 0 divisions per beat
        do {
            let mt = MusicalTimeValue(elapsedTicks: deltaSum, beatsPerBar: 4, divisionsPerBeat: 0, ppq: ppq)
            
            XCTAssertEqual(mt.bar, 1)
            XCTAssertEqual(mt.beat, 1)
            XCTAssertEqual(mt.beatDivision, 0)
            XCTAssertEqual(mt.ticks, 300)
            
            XCTAssertEqual(mt.elapsedTicks(), deltaSum)
            XCTAssertEqual(mt.elapsedBeats(), 5.625)
            XCTAssertFalse(mt.isNegative)
        }
    }
}

#endif
