//
//  MTC MTCFrameRate Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSync
import TimecodeKitCore
import XCTest

final class MTC_MTCFrameRate_Tests: XCTestCase {
    func testMTC_MTCFrameRate_Init_TimecodeFrameRate() {
        // test is pedantic, but worth having
        
        TimecodeFrameRate.allCases.forEach {
            XCTAssertEqual(MTCFrameRate($0), $0.mtcFrameRate)
        }
    }
}

#endif
