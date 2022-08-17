//
//  MTC Utilities Tests.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSync
import TimecodeKit

final class MTC_Utilities_Tests: XCTestCase {
    func testMTCIsEqual() {
        XCTAssertFalse(
            mtcIsEqual(nil, nil)
        )
        
        // test all MTC rates
        MTCFrameRate.allCases.forEach {
            XCTAssertFalse(
                mtcIsEqual(
                    (mtcComponents: TCC(), mtcFrameRate: $0),
                    nil
                )
            )
            
            XCTAssertFalse(
                mtcIsEqual(
                    nil,
                    (mtcComponents: TCC(), mtcFrameRate: $0)
                )
            )
            
            // == components, == frame rate
            XCTAssertTrue(
                mtcIsEqual(
                    (mtcComponents: TCC(), mtcFrameRate: $0),
                    (mtcComponents: TCC(), mtcFrameRate: $0)
                )
            )
            
            // == components, == frame rate
            XCTAssertTrue(
                mtcIsEqual(
                    (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
                    (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0)
                )
            )
            
            // != components, == frame rate
            XCTAssertFalse(
                mtcIsEqual(
                    (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
                    (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 05), mtcFrameRate: $0)
                )
            )
        }
        
        // == components, != frame rate
        XCTAssertFalse(
            mtcIsEqual(
                (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc24),
                (mtcComponents: TCC(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc25)
            )
        )
    }
}

#endif
