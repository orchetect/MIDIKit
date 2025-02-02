//
//  MTC Direction Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite struct MTC_Direction_Tests {
    @Test
    func mtc_Direction() {
        // ensure direction infer produces expected direction states
        
        // identical values produces ambiguous state
        for bits in UInt8(0b000) ... UInt8(0b111) {
            #expect(MTCDirection(previousQF: bits, newQF: bits) == .ambiguous)
        }
        
        // sequential ascending values produces forwards
        #expect(MTCDirection(previousQF: 0b000, newQF: 0b001) == .forwards)
        #expect(MTCDirection(previousQF: 0b001, newQF: 0b010) == .forwards)
        #expect(MTCDirection(previousQF: 0b010, newQF: 0b011) == .forwards)
        #expect(MTCDirection(previousQF: 0b011, newQF: 0b100) == .forwards)
        #expect(MTCDirection(previousQF: 0b100, newQF: 0b101) == .forwards)
        #expect(MTCDirection(previousQF: 0b101, newQF: 0b110) == .forwards)
        #expect(MTCDirection(previousQF: 0b110, newQF: 0b111) == .forwards)
        #expect(MTCDirection(previousQF: 0b111, newQF: 0b000) == .forwards) // wraps
        
        // sequential ascending values produces backwards
        #expect(MTCDirection(previousQF: 0b111, newQF: 0b110) == .backwards)
        #expect(MTCDirection(previousQF: 0b110, newQF: 0b101) == .backwards)
        #expect(MTCDirection(previousQF: 0b101, newQF: 0b100) == .backwards)
        #expect(MTCDirection(previousQF: 0b100, newQF: 0b011) == .backwards)
        #expect(MTCDirection(previousQF: 0b011, newQF: 0b010) == .backwards)
        #expect(MTCDirection(previousQF: 0b010, newQF: 0b001) == .backwards)
        #expect(MTCDirection(previousQF: 0b001, newQF: 0b000) == .backwards)
        #expect(MTCDirection(previousQF: 0b000, newQF: 0b111) == .backwards) // wraps
        
        // non-sequential values produces ambiguous state
        #expect(MTCDirection(previousQF: 0b000, newQF: 0b010) == .ambiguous)
        #expect(MTCDirection(previousQF: 0b010, newQF: 0b000) == .ambiguous)
        #expect(MTCDirection(previousQF: 0b000, newQF: 0b101) == .ambiguous)
        #expect(MTCDirection(previousQF: 0b101, newQF: 0b000) == .ambiguous)
        
        // edge cases: internal UInt8 underflow/overflow failsafe test
        #expect(MTCDirection(previousQF: 255, newQF: 0b000) == .ambiguous)
        #expect(MTCDirection(previousQF: 255, newQF: 0b001) == .ambiguous)
        #expect(MTCDirection(previousQF: 255, newQF: 0b111) == .ambiguous)
    }
}
