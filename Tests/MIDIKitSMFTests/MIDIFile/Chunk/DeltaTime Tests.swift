//
//  DeltaTime Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
@testable import MIDIKitSMF
import Testing

@Suite struct DeltaTime_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    /// Test the Musical timebase-specific static constructors on `DeltaTime`.
    @Test
    func musicalStaticConstructors() async throws {
        typealias Delta = MusicalMIDIFile.TrackChunk.DeltaTime
        
        #expect(Delta.noteWhole(ppq: 240).ticks == 960)
        #expect(Delta.noteHalf(ppq: 240).ticks == 480)
        #expect(Delta.noteQuarter(ppq: 240).ticks == 240)
        #expect(Delta.note8th(ppq: 240).ticks == 120)
        #expect(Delta.note16th(ppq: 240).ticks == 60)
        #expect(Delta.note32nd(ppq: 240).ticks == 30)
        #expect(Delta.note64th(ppq: 240).ticks == 15)
        #expect(Delta.note128th(ppq: 240).ticks == 8) // note: 7.5 aliased (rounded)
        #expect(Delta.note256th(ppq: 240).ticks == 4) // note: 3.75 aliased (rounded)
        
        #expect(Delta.noteWhole(ppq: 480).ticks == 1920)
        #expect(Delta.noteHalf(ppq: 480).ticks == 960)
        #expect(Delta.noteQuarter(ppq: 480).ticks == 480)
        #expect(Delta.note8th(ppq: 480).ticks == 240)
        #expect(Delta.note16th(ppq: 480).ticks == 120)
        #expect(Delta.note32nd(ppq: 480).ticks == 60)
        #expect(Delta.note64th(ppq: 480).ticks == 30)
        #expect(Delta.note128th(ppq: 480).ticks == 15)
        #expect(Delta.note256th(ppq: 480).ticks == 8) // note: 7.5 aliased (rounded)
        
        #expect(Delta.noteWhole(ppq: 960).ticks == 3840)
        #expect(Delta.noteHalf(ppq: 960).ticks == 1920)
        #expect(Delta.noteQuarter(ppq: 960).ticks == 960)
        #expect(Delta.note8th(ppq: 960).ticks == 480)
        #expect(Delta.note16th(ppq: 960).ticks == 240)
        #expect(Delta.note32nd(ppq: 960).ticks == 120)
        #expect(Delta.note64th(ppq: 960).ticks == 60)
        #expect(Delta.note128th(ppq: 960).ticks == 30)
        #expect(Delta.note256th(ppq: 960).ticks == 15)
        
        #expect(Delta.beats(-1.0, ppq: 480).ticks == 0)
        #expect(Delta.beats(0.0, ppq: 480).ticks == 0)
        #expect(Delta.beats(0.25, ppq: 480).ticks == 120)
        #expect(Delta.beats(0.5, ppq: 480).ticks == 240)
        #expect(Delta.beats(1.0, ppq: 480).ticks == 480)
        #expect(Delta.beats(4.0, ppq: 480).ticks == 1920)
    }
    
    @Test
    func musicalStaticConstructors_edgeCases() async throws {
        typealias Delta = MusicalMIDIFile.TrackChunk.DeltaTime
        
        #expect(Delta.ticks(UInt32.min).ticks == UInt32.min)
        #expect(Delta.ticks(UInt32.max).ticks == UInt32.max)
        
        #expect(Delta.noteWhole(ppq: 0).ticks == 0)
        #expect(Delta.noteWhole(ppq: 1).ticks == 4)
        #expect(Delta.noteWhole(ppq: UInt16.max).ticks == 4 * UInt32(UInt16.max))
        
        #expect(Delta.note256th(ppq: 0).ticks == 0)
        #expect(Delta.note256th(ppq: UInt16.max).ticks == 1024) // 1023.984375 rounded
    }
    
    /// Test the SMPTE timebase-specific static constructors on `DeltaTime`.
    @Test
    func smpteStaticConstructors() async throws {
        typealias Delta = SMPTEMIDIFile.TrackChunk.DeltaTime
        
        // MIDIFileTrackEvent.SMPTEOffset
        
        #expect(Delta.offset(MIDIFileTrackEvent.SMPTEOffset(hr: 00, min: 00, sec: 00, fr: 00, rate: .fps25), ticksPerFrame: 20).ticks == 0)
        #expect(Delta.offset(MIDIFileTrackEvent.SMPTEOffset(hr: 00, min: 01, sec: 20, fr: 10, rate: .fps25), ticksPerFrame: 20).ticks == 40_200)
        #expect(Delta.offset(MIDIFileTrackEvent.SMPTEOffset(hr: 01, min: 01, sec: 20, fr: 10, rate: .fps25), ticksPerFrame: 20).ticks == 1_840_200)
        
        #expect(Delta.offset(MIDIFileTrackEvent.SMPTEOffset(hr: 00, min: 00, sec: 00, fr: 00, rate: .fps25), ticksPerFrame: 40).ticks == 0)
        #expect(Delta.offset(MIDIFileTrackEvent.SMPTEOffset(hr: 00, min: 01, sec: 20, fr: 10, rate: .fps25), ticksPerFrame: 40).ticks == 80_400)
        #expect(Delta.offset(MIDIFileTrackEvent.SMPTEOffset(hr: 01, min: 01, sec: 20, fr: 10, rate: .fps25), ticksPerFrame: 40).ticks == 3_680_400)
        
        // offset(hr:min:sec:fr:subFr:rate:ticksPerFrame:)
        
        #expect(Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, rate: .fps25, ticksPerFrame: 20).ticks == 0)
        #expect(Delta.offset(hr: 00, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 20).ticks == 40_200)
        #expect(Delta.offset(hr: 01, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 20).ticks == 1_840_200)
        
        #expect(Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, rate: .fps25, ticksPerFrame: 40).ticks == 0)
        #expect(Delta.offset(hr: 00, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 40).ticks == 80_400)
        #expect(Delta.offset(hr: 01, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 40).ticks == 3_680_400)
    }
    
    @Test
    func smpteStaticConstructors_edgeCases() async throws {
        typealias Delta = SMPTEMIDIFile.TrackChunk.DeltaTime
        
        #expect(Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, rate: .fps25, ticksPerFrame: 0).ticks == 0)
        #expect(Delta.offset(hr: 00, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 0).ticks == 0)
        #expect(Delta.offset(hr: 01, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 0).ticks == 0)
        
        #expect(Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, rate: .fps25, ticksPerFrame: 1).ticks == 0)
        #expect(Delta.offset(hr: 00, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 1).ticks == 2010)
        #expect(Delta.offset(hr: 01, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: 1).ticks == 92_010)
        
        #expect(Delta.offset(hr: 00, min: 00, sec: 00, fr: 00, rate: .fps25, ticksPerFrame: UInt8.max).ticks == 0)
        #expect(Delta.offset(hr: 00, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: UInt8.max).ticks == 512_550)
        #expect(Delta.offset(hr: 01, min: 01, sec: 20, fr: 10, rate: .fps25, ticksPerFrame: UInt8.max).ticks == 23_462_550)
    }
}
