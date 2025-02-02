//
//  MTC MTCFrameRate Translation Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite struct MTC_MTCFrameRate_Translation_Tests {
    @Test
    func mtcFrameRate_derivedFrameRates() {
        // these tests may be pedantic, but we'll put them in any way
        // since this acts as our source of truth
        
        // ensure all four MTC frame rate families return the correct
        // matching derived timecode frame rates
        
        // MTC: 24
        
        #expect(
            MTCFrameRate.mtc24.derivedFrameRates ==
                [
                    .fps23_976,
                    .fps24,
                    .fps24_98,
                    .fps47_952,
                    .fps48,
                    .fps95_904,
                    .fps96
                ]
        )
        
        // MTC: 25
        
        #expect(
            MTCFrameRate.mtc25.derivedFrameRates ==
                [
                    .fps25,
                    .fps50,
                    .fps100
                ]
        )
        
        // MTC: drop
        
        #expect(
            MTCFrameRate.mtc2997d.derivedFrameRates ==
                [
                    .fps29_97d,
                    .fps30d,
                    .fps59_94d,
                    .fps60d,
                    .fps119_88d,
                    .fps120d
                ]
        )
        
        // MTC: drop
        
        #expect(
            MTCFrameRate.mtc30.derivedFrameRates ==
                [
                    .fps29_97,
                    .fps30,
                    .fps59_94,
                    .fps60,
                    .fps90,
                    .fps119_88,
                    .fps120
                ]
        )
    }
}
