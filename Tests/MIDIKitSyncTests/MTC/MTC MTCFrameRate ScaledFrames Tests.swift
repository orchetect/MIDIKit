//
//  MTC MTCFrameRate ScaledFrames Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import TimecodeKitCore
import XCTest

final class MTC_MTCFrameRate_ScaledFrames_Tests: XCTestCase {
    // Local Constants
    
    fileprivate var mtc24: MTCFrameRate { .mtc24 }
    fileprivate var mtc25: MTCFrameRate { .mtc25 }
    fileprivate var mtcDF: MTCFrameRate { .mtc2997d }
    fileprivate var mtc30: MTCFrameRate { .mtc30 }
    
    func testMTC_MTCFrameRate_ScaledFrames() {
        // we iterate on allCases here so that the compiler will
        // throw an error in future if additional frame rates get added to TimecodeKit,
        // prompting us to add unit test cases for them below
        
        // (reminder: MTC SMPTE frame numbers should only ever be even numbers,
        // as this is how the MTC spec functions)
        
        for realRate in TimecodeFrameRate.allCases {
            let mtcRate = realRate.mtcFrameRate
            
            // avoid testing incompatible frame rates which will fail any way
            guard mtcRate.directEquivalentFrameRate.isCompatible(with: realRate)
            else { continue }
            
            switch realRate {
            case .fps23_976, .fps24:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 0.25)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 12,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        12 + (Double(qf) * 0.25)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 22,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        22 + (Double(qf) * 0.25)
                    )
                }
                
            case .fps24_98:
                // MTC 24 -> realRate
                // this one is the odd duck; Cubase transmits 24.98 as MTC 24
                
                XCTAssertEqual(
                    mtcRate.scaledFrames(
                        fromRawMTCFrames: 0,
                        quarterFrames: 0,
                        to: realRate
                    ),
                    0
                )
                XCTAssertEqual(
                    mtcRate.scaledFrames(
                        fromRawMTCFrames: 12,
                        quarterFrames: 0,
                        to: realRate
                    ),
                    12.5
                )
                XCTAssertEqual(
                    mtcRate.scaledFrames(
                        fromRawMTCFrames: 22,
                        quarterFrames: 0,
                        to: realRate
                    ) ?? 0.0,
                    22.916666,
                    accuracy: 0.00001
                )
                XCTAssertEqual(
                    mtcRate.scaledFrames(
                        fromRawMTCFrames: 24,
                        quarterFrames: 0,
                        to: realRate
                    ) ?? 0.0,
                    24.98
                )
                
            case .fps25:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 0.25)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 12,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        12 + (Double(qf) * 0.25)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 24,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        24 + (Double(qf) * 0.25)
                    )
                }
                
            case .fps29_97, .fps29_97d, .fps30, .fps30d:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 0.25)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 14,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        14 + (Double(qf) * 0.25)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 28,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        28 + (Double(qf) * 0.25)
                    )
                }
                
            case .fps47_952, .fps48:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 0.5)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 12,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        24 + (Double(qf) * 0.5)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 22,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        44 + (Double(qf) * 0.5)
                    )
                }
                
            case .fps50:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 0.5)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 12,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        24 + (Double(qf) * 0.5)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 24,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        48 + (Double(qf) * 0.5)
                    )
                }
                
            case .fps59_94, .fps59_94d, .fps60, .fps60d:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 0.5)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 14,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        28 + (Double(qf) * 0.5)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 28,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        56 + (Double(qf) * 0.5)
                    )
                }
                
            case .fps95_904, .fps96:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 1.0)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 12,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        48 + (Double(qf) * 1.0)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 22,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        88 + (Double(qf) * 1.0)
                    )
                }
                
            case .fps100:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0  + (Double(qf) * 1.0)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 12,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        48 + (Double(qf) * 1.0)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 24,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        96 + (Double(qf) * 1.0)
                    )
                }
                
            case .fps119_88, .fps119_88d, .fps120, .fps120d:
                for qf in UInt8(0) ... 7 {
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 0,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        0   + (Double(qf) * 1.0)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 14,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        56  + (Double(qf) * 1.0)
                    )
                    XCTAssertEqual(
                        mtcRate.scaledFrames(
                            fromRawMTCFrames: 28,
                            quarterFrames: qf,
                            to: realRate
                        ),
                        112 + (Double(qf) * 1.0)
                    )
                }
            }
        }
    }
    
    func testMTC_MTCFrameRate_Scale_EdgeCases() {
        // frames underflow clamped to 0
        XCTAssertEqual(
            mtc30.scaledFrames(
                fromRawMTCFrames: -1,
                quarterFrames: 0,
                to: .fps30
            ),
            0
        )
        
        // frames overflow allowed, even though it's not practical
        XCTAssertEqual(
            mtc30.scaledFrames(
                fromRawMTCFrames: 60,
                quarterFrames: 0,
                to: .fps30
            ),
            60
        )
        
        // quarter-frames > 7 clamped to 7
        XCTAssertEqual(
            mtc30.scaledFrames(
                fromRawMTCFrames: 0,
                quarterFrames: 8,
                to: .fps30
            ),
            0.25 * 7
        )
    }
    
    func testMTC_TimecodeFrameRate_ScaledFrames() {
        // zero
        
        for realRate in TimecodeFrameRate.allCases {
            let scaled = realRate.scaledFrames(fromTimecodeFrames: 0.0)
            
            XCTAssertEqual(
                scaled.rawMTCFrames,
                0,
                "at: \(realRate)"
            )
            XCTAssertEqual(
                scaled.rawMTCQuarterFrames,
                0,
                "at: \(realRate)"
            )
        }
        
        // spot-check
        
        for realRate in TimecodeFrameRate.allCases {
            switch realRate {
            case .fps23_976, .fps24:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 12 + (Double(qf) * 0.25))
                    XCTAssertEqual(scaled.rawMTCFrames, 12)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 22 + (Double(qf) * 0.25))
                    XCTAssertEqual(scaled.rawMTCFrames, 22)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps24_98:
                // MTC 24 -> realRate
                // this one is the odd duck; Cubase transmits 24.98 as MTC 24
                // just do a spot-check, as testing all 8 quarter-frames is tricky
                
                let scaled1 = realRate.scaledFrames(fromTimecodeFrames: 12.5)
                XCTAssertEqual(scaled1.rawMTCFrames, 12)
                XCTAssertEqual(scaled1.rawMTCQuarterFrames, 0)
                
                let scaled2 = realRate.scaledFrames(fromTimecodeFrames: 22.916667)
                XCTAssertEqual(scaled2.rawMTCFrames, 22)
                XCTAssertEqual(scaled2.rawMTCQuarterFrames, 0)
                
                // due to the strange nature of 24.98fps, this rounds down to the previous QF
                let scaled3 = realRate.scaledFrames(fromTimecodeFrames: 24.98)
                XCTAssertEqual(scaled3.rawMTCFrames, 24)
                XCTAssertEqual(scaled3.rawMTCQuarterFrames, 0)
                
            case .fps25:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 12 + (Double(qf) * 0.25))
                    XCTAssertEqual(scaled.rawMTCFrames, 12)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 24 + (Double(qf) * 0.25))
                    XCTAssertEqual(scaled.rawMTCFrames, 24)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps29_97, .fps29_97d, .fps30, .fps30d:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 14 + (Double(qf) * 0.25))
                    XCTAssertEqual(scaled.rawMTCFrames, 14)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 28 + (Double(qf) * 0.25))
                    XCTAssertEqual(scaled.rawMTCFrames, 28)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps47_952, .fps48:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 24 + (Double(qf) * 0.5))
                    XCTAssertEqual(scaled.rawMTCFrames, 12)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 44 + (Double(qf) * 0.5))
                    XCTAssertEqual(scaled.rawMTCFrames, 22)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps50:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 24 + (Double(qf) * 0.5))
                    XCTAssertEqual(scaled.rawMTCFrames, 12)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 48 + (Double(qf) * 0.5))
                    XCTAssertEqual(scaled.rawMTCFrames, 24)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps59_94, .fps59_94d, .fps60, .fps60d:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 28 + (Double(qf) * 0.5))
                    XCTAssertEqual(scaled.rawMTCFrames, 14)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 56 + (Double(qf) * 0.5))
                    XCTAssertEqual(scaled.rawMTCFrames, 28)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps95_904, .fps96:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 48 + (Double(qf) * 1.0))
                    XCTAssertEqual(scaled.rawMTCFrames, 12)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 88 + (Double(qf) * 1.0))
                    XCTAssertEqual(scaled.rawMTCFrames, 22)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps100:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 48 + (Double(qf) * 1.0))
                    XCTAssertEqual(scaled.rawMTCFrames, 12)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 96 + (Double(qf) * 1.0))
                    XCTAssertEqual(scaled.rawMTCFrames, 24)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                
            case .fps119_88, .fps119_88d, .fps120, .fps120d:
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 56 + (Double(qf) * 1.0))
                    XCTAssertEqual(scaled.rawMTCFrames, 14)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
                for qf in UInt8(0) ... 7 {
                    let scaled = realRate.scaledFrames(fromTimecodeFrames: 112 + (Double(qf) * 1.0))
                    XCTAssertEqual(scaled.rawMTCFrames, 28)
                    XCTAssertEqual(scaled.rawMTCQuarterFrames, qf)
                }
            }
        }
    }
    
    func testMTC_RoundTrip_ScaledFrames() {
        for realRate in TimecodeFrameRate.allCases {
            // zero
            do {
                let scaledToMTC = realRate.scaledFrames(fromTimecodeFrames: 0.0)
                
                XCTAssertEqual(scaledToMTC.rawMTCFrames, 0)
                XCTAssertEqual(scaledToMTC.rawMTCQuarterFrames, 0)
                
                let scaledToTimecode = realRate.mtcFrameRate
                    .scaledFrames(
                        fromRawMTCFrames: scaledToMTC.rawMTCFrames,
                        quarterFrames: scaledToMTC.rawMTCQuarterFrames,
                        to: realRate
                    )
                
                XCTAssertEqual(scaledToTimecode, 0.0)
            }
            
            // test each frame round-trip scaled to MTC+QF and back to timecode frames
            do {
                for frame in 0 ... realRate.maxFrameNumberDisplayable {
                    let scaledToMTC = realRate.scaledFrames(fromTimecodeFrames: Double(frame))
                    
                    let scaledToTimecode = realRate.mtcFrameRate
                        .scaledFrames(
                            fromRawMTCFrames: scaledToMTC.rawMTCFrames,
                            quarterFrames: scaledToMTC.rawMTCQuarterFrames,
                            to: realRate
                        )!
                    
                    XCTAssertEqual(Int(scaledToTimecode), frame, "at: \(realRate)")
                }
            }
        }
    }
}
