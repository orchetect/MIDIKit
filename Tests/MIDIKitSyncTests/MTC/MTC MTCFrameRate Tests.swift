//
//  MTC MTCFrameRate Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite struct MTC_MTCFrameRate_Tests {
    @Test
    func mtcFrameRate_Init_TimecodeFrameRate() {
        // test is pedantic, but worth having
        
        for item in TimecodeFrameRate.allCases {
            #expect(MTCFrameRate(item) == item.mtcFrameRate)
        }
    }
}
