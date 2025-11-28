//
//  MTC Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import SwiftTimecodeCore

@Suite struct MTC_Utilities_Tests {
    @Test
    func global_mtcIsEqual() {
        #expect(
            !mtcIsEqual(nil, nil)
        )
        
        // test all MTC rates
        for fRate in MTCFrameRate.allCases {
            #expect(
                !mtcIsEqual(
                    (mtcComponents: .init(), mtcFrameRate: fRate),
                    nil
                )
            )
            
            #expect(
                !mtcIsEqual(
                    nil,
                    (mtcComponents: .init(), mtcFrameRate: fRate)
                )
            )
            
            // == components, == frame rate
            #expect(
                mtcIsEqual(
                    (mtcComponents: .init(), mtcFrameRate: fRate),
                    (mtcComponents: .init(), mtcFrameRate: fRate)
                )
            )
            
            // == components, == frame rate
            #expect(
                mtcIsEqual(
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: fRate),
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: fRate)
                )
            )
            
            // != components, == frame rate
            #expect(
                !mtcIsEqual(
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: fRate),
                    (mtcComponents: .init(h: 1, m: 02, s: 03, f: 05), mtcFrameRate: fRate)
                )
            )
        }
        
        // == components, != frame rate
        #expect(
            !mtcIsEqual(
                (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc24),
                (mtcComponents: .init(h: 1, m: 02, s: 03, f: 04), mtcFrameRate: .mtc25)
            )
        )
    }
}
