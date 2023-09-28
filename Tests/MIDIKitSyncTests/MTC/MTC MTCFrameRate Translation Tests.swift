//
//  MTC MTCFrameRate Translation Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSync
import TimecodeKit
import XCTest

final class MTC_MTCFrameRate_Translation_Tests: XCTestCase {
    func testMTC_MTCFrameRate_derivedFrameRates() {
        // these tests may be pedantic, but we'll put them in any way
        // since this acts as our source of truth
        
        // ensure all four MTC frame rate families return the correct
        // matching derived timecode frame rates
        
        // MTC: 24
        
        XCTAssertEqual(
            MTCFrameRate.mtc24.derivedFrameRates,
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
        
        XCTAssertEqual(
            MTCFrameRate.mtc25.derivedFrameRates,
            [
                .fps25,
                .fps50,
                .fps100
            ]
        )
        
        // MTC: drop
        
        XCTAssertEqual(
            MTCFrameRate.mtc2997d.derivedFrameRates,
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
        
        XCTAssertEqual(
            MTCFrameRate.mtc30.derivedFrameRates,
            [
                .fps29_97,
                .fps30,
                .fps59_94,
                .fps60,
                .fps119_88,
                .fps120
            ]
        )
    }
}

#endif
