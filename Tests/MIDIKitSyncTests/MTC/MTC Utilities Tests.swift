//
//  MTC Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSync
import TimecodeKitCore
import XCTest

final class MTC_Utilities_Tests: XCTestCase {
    func testMTCIsEqual() {
        XCTAssertFalse(
            mtcIsEqual(nil, nil)
        )
        
        // test all MTC rates
        MTCFrameRate.allCases.forEach {
            XCTAssertFalse(
                mtcIsEqual(
                    (mtcComponents: .init(), mtcFrameRate: $0),
                    nil
                )
            )
            
            XCTAssertFalse(
                mtcIsEqual(
                    nil,
                    (mtcComponents: .init(), mtcFrameRate: $0)
                )
            )
            
            // == components, == frame rate
            XCTAssertTrue(
                mtcIsEqual(
                    (mtcComponents: .init(), mtcFrameRate: $0),
                    (mtcComponents: .init(), mtcFrameRate: $0)
                )
            )
            
            // == components, == frame rate
            XCTAssertTrue(
                mtcIsEqual(
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0)
                )
            )
            
            // != components, == frame rate
            XCTAssertFalse(
                mtcIsEqual(
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: $0),
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 05), mtcFrameRate: $0)
                )
            )
        }
        
        // == components, != frame rate
        XCTAssertFalse(
            mtcIsEqual(
                (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc24),
                (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc25)
            )
        )
    }
}

#endif
