//
//  MTC MTCFrameRate Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSync
import TimecodeKit

final class MTC_MTCFrameRate_Tests: XCTestCase {
    func testMTC_MTCFrameRate_Init_TimecodeFrameRate() {
        // test is pedantic, but worth having
        
        TimecodeFrameRate.allCases.forEach {
            XCTAssertEqual(MTCFrameRate($0), $0.mtcFrameRate)
        }
    }
}

#endif
