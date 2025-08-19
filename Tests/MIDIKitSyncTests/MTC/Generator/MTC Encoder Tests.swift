//
//  MTC Encoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
@testable import TimecodeKitCore

@Suite struct MTC_Generator_Encoder_Tests {
    @Test
    func mtcEncoder_Default() {
        // defaults
        
        let mtcEnc = MTCEncoder()
        
        #expect(mtcEnc.mtcComponents == .init(h: 0, m: 0, s: 0, f: 0))
        
        let tc = mtcEnc.timecode
        #expect(tc.components == .init(h: 0, m: 0, s: 0, f: 0))
        
        #expect(mtcEnc.localFrameRate == tc.frameRate)
    }
    
    @Test
    func mtcEncoder_FrameRate() {
        // ensure MTC FrameRate is being updated correctly when localFrameRate is set
        
        var mtcEnc: MTCEncoder!
        
        for item in TimecodeFrameRate.allCases {
            mtcEnc = MTCEncoder()
            mtcEnc.setLocalFrameRate(item)
            
            #expect(mtcEnc.mtcFrameRate == item.mtcFrameRate)
        }
    }
    
    @Test
    func mtcEncoder_Timecode_NominalRates() {
        // perform a spot-check to ensure the .timecode property is returning
        // expected Timecode for nominal (non-scaling) frame rates
        
        var mtcEnc: MTCEncoder!
        
        // basic test
        
        mtcEnc = MTCEncoder()
        mtcEnc.setLocalFrameRate(.fps30)
        
        mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 20, s: 32, f: 10))
        
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 10))
        
        // quarter frames
        
        mtcEnc = MTCEncoder()
        mtcEnc.setLocalFrameRate(.fps30)
        mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 20, s: 32, f: 10))
        
        mtcEnc.mtcQuarterFrame = 0
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 10))
        
        mtcEnc.mtcQuarterFrame = 1
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 10))
        
        mtcEnc.mtcQuarterFrame = 2
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 10))
        
        mtcEnc.mtcQuarterFrame = 3
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 10))
        
        mtcEnc.mtcQuarterFrame = 4
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 11)) // next frame
        
        mtcEnc.mtcQuarterFrame = 5
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 11))
        
        mtcEnc.mtcQuarterFrame = 6
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 11))
        
        mtcEnc.mtcQuarterFrame = 7
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 11))
    }
    
    @Test
    func mtcEncoder_Timecode_ScalingRates() {
        // perform a spot-check to ensure the .timecode property is scaling to localFrameRate
        
        var mtcEnc: MTCEncoder!
        
        // basic test
        
        mtcEnc = MTCEncoder()
        mtcEnc.setLocalFrameRate(.fps60)
        mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 20, s: 32, f: 10))
        
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 20))
        #expect(mtcEnc.timecode.frameRate == .fps60)
        
        // quarter frames
        
        mtcEnc = MTCEncoder()
        mtcEnc.setLocalFrameRate(.fps60)
        mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 20, s: 32, f: 10))
        
        #expect(mtcEnc.timecode.frameRate == .fps60)
        
        mtcEnc.mtcQuarterFrame = 0
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 20))
        
        mtcEnc.mtcQuarterFrame = 1
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 20))
        
        mtcEnc.mtcQuarterFrame = 2
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 21)) // next frame
        
        mtcEnc.mtcQuarterFrame = 3
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 21))
        
        mtcEnc.mtcQuarterFrame = 4
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 22)) // next frame
        
        mtcEnc.mtcQuarterFrame = 5
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 22))
        
        mtcEnc.mtcQuarterFrame = 6
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 23)) // next frame
        
        mtcEnc.mtcQuarterFrame = 7
        #expect(mtcEnc.timecode.components == .init(h: 1, m: 20, s: 32, f: 23))
    }
    
    @Test
    func mtcEncoder_LocateTo() {
        // perform a spot-check to ensure .locate(to:) functions as expected
        
        var mtcEnc: MTCEncoder!
        
        // nominal (non-scaling) SMPTE frame rates
        
        // 24fps
        
        mtcEnc = MTCEncoder()
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 10), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps24)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 10)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 10)
        )
        #expect(mtcEnc.mtcQuarterFrame == 0)
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 11), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps24)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 11)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 10)
        )
        #expect(mtcEnc.mtcQuarterFrame == 4)
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 12), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps24)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 12)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 12)
        )
        #expect(mtcEnc.mtcQuarterFrame == 0)
        
        // scaling frame rates
        
        // 60fps
        
        mtcEnc = MTCEncoder()
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 20), at: .fps60, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps60)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 20)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 10)
        ) // mtc-30 fps
        #expect(mtcEnc.mtcQuarterFrame == 0)
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 21), at: .fps60, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps60)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 21)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 10)
        ) // mtc-30 fps
        #expect(mtcEnc.mtcQuarterFrame == 2)
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 22), at: .fps60, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps60)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 22)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 10)
        ) // mtc-30 fps
        #expect(mtcEnc.mtcQuarterFrame == 4)
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 23), at: .fps60, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps60)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 23)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 10)
        ) // mtc-30 fps
        #expect(mtcEnc.mtcQuarterFrame == 6)
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 20, s: 32, f: 24), at: .fps60, by: .allowingInvalid))
        #expect(mtcEnc.localFrameRate == .fps60)
        #expect(
            mtcEnc.timecode.components ==
                .init(h: 1, m: 20, s: 32, f: 24)
        )
        #expect(
            mtcEnc.mtcComponents ==
                .init(h: 1, m: 20, s: 32, f: 12)
        ) // mtc-30 fps
        #expect(mtcEnc.mtcQuarterFrame == 0)
    }
    
    @Test
    func mtcEncoder_Increment() {
        // test to ensure increment behavior is consistent across timecode frame rates
        
        var mtcEnc: MTCEncoder!
        
        for item in TimecodeFrameRate.allCases {
            mtcEnc = MTCEncoder()
            mtcEnc.setLocalFrameRate(item)
            mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 20, s: 32, f: 10))
            
            // initial state
            
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
            
            mtcEnc.increment() // doesn't increment; sends first quarter-frame
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
            
            mtcEnc.increment() // now it increments to QF 1
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    1,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    2,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    3,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    4,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    5,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    6,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    7,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 12),
                "at: \(item)"
            ) // next even frame
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
        }
    }
    
    @Test
    func mtcEncoder_Increment_DropFrame() {
        // spot-check: drop-frame rates
        
        var mtcEnc: MTCEncoder!
        
        for item in TimecodeFrameRate.allDrop {
            mtcEnc = MTCEncoder()
            mtcEnc.setLocalFrameRate(item)
            
            // round raw MTC frame number down to an even number, as per MTC spec
            let originFrame: Int
            
            // (include non-drop rates in switch case even though they won't be
            // traversed, for sake of being exhaustive)
            switch item {
            case .fps23_976, .fps24, .fps24_98, .fps25, .fps29_97, .fps29_97d, .fps30, .fps30d:
                // 1x multiplier
                originFrame = item.maxFrameNumberDisplayable - (item.maxFrameNumberDisplayable % 2)
                
            case .fps47_952, .fps48, .fps50, .fps59_94, .fps59_94d, .fps60, .fps60d:
                // 2x multiplier
                let previousEvenFrame = item
                    .maxFrameNumberDisplayable - (item.maxFrameNumberDisplayable % 2)
                let diff = item.maxFrames - previousEvenFrame
                originFrame = item.maxFrames - (diff * 2)
                
            case .fps90:
                // 3x multiplier
                let previousEvenFrame = item
                    .maxFrameNumberDisplayable - (item.maxFrameNumberDisplayable % 2)
                let diff = item.maxFrames - previousEvenFrame
                originFrame = item.maxFrames - (diff * 3)
                
            case .fps95_904, .fps96, .fps100, .fps119_88, .fps119_88d, .fps120, .fps120d:
                // 4x multiplier
                let previousEvenFrame = item
                    .maxFrameNumberDisplayable - (item.maxFrameNumberDisplayable % 2)
                let diff = item.maxFrames - previousEvenFrame
                originFrame = item.maxFrames - (diff * 4)
            }
            
            mtcEnc.locate(to: .init(h: 1, m: 00, s: 59, f: originFrame))
            
            let expectedFrameA = switch mtcEnc.mtcFrameRate {
            case .mtc24:
                22
            case .mtc25:
                24
            case .mtc2997d, .mtc30:
                28
            }
            
            let expectedFrameB = 2
            
            // initial state
            
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
            
            mtcEnc.increment() // doesn't increment; sends first quarter-frame
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
            
            mtcEnc.increment() // now it increments to QF 1
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    1,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    2,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    3,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    4,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    5,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    6,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 59, f: expectedFrameA),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    7,
                "at: \(item)"
            )
            
            mtcEnc.increment()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 01, s: 00, f: expectedFrameB), // next even frame
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
        }
    }
    
    @Test
    func mtcEncoder_Increment_25FPS() {
        // MTC-25 fps based frame rates (25, 50, 100 fps)
        
        var mtcEnc: MTCEncoder!
        
        for derivedFrameRate in MTCFrameRate.mtc25.derivedFrameRates {
            let frMult: Int
            switch derivedFrameRate {
            case .fps25:  frMult = 1
            case .fps50:  frMult = 2
            case .fps100: frMult = 4
            default:
                Issue.record("Encountered unhandled frame rate: \(derivedFrameRate)")
                continue // skips to next forEach iteration
            }
            
            // -----------------------------
            // Scenario 1: Starting on even frame number
            // -----------------------------
            
            mtcEnc = MTCEncoder()
            mtcEnc.setLocalFrameRate(derivedFrameRate)
            
            mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 00, s: 00, f: 24))
            mtcEnc.mtcQuarterFrame = 0
            
            #expect(mtcEnc.mtcQuarterFrame == 0, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 00, f: 24),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 00, f: 24 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
            
            mtcEnc.increment() // sends qf 0
            #expect(mtcEnc.mtcQuarterFrame == 0, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 1
            #expect(mtcEnc.mtcQuarterFrame == 1, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 2
            #expect(mtcEnc.mtcQuarterFrame == 2, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 3
            #expect(mtcEnc.mtcQuarterFrame == 3, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 4
            #expect(mtcEnc.mtcQuarterFrame == 4, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 00, f: 24),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 01, f: 00 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
            
            mtcEnc.increment() // increments to qf 5
            #expect(mtcEnc.mtcQuarterFrame == 5, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 6
            #expect(mtcEnc.mtcQuarterFrame == 6, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 7
            #expect(mtcEnc.mtcQuarterFrame == 7, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 0
            #expect(mtcEnc.mtcQuarterFrame == 0, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 01, f: 01),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 01, f: 01 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
            
            // ----------------------------
            // Scenario 2: Starting on odd frame number
            // ----------------------------
            
            mtcEnc = MTCEncoder()
            mtcEnc.setLocalFrameRate(derivedFrameRate)
            
            mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 00, s: 00, f: 23))
            mtcEnc.mtcQuarterFrame = 0
            
            #expect(mtcEnc.mtcQuarterFrame == 0, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 00, f: 23),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 00, f: 23 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
            
            mtcEnc.increment() // sends qf 0
            #expect(mtcEnc.mtcQuarterFrame == 0, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 1
            #expect(mtcEnc.mtcQuarterFrame == 1, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 2
            #expect(mtcEnc.mtcQuarterFrame == 2, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 3
            #expect(mtcEnc.mtcQuarterFrame == 3, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 4
            #expect(mtcEnc.mtcQuarterFrame == 4, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 00, f: 23),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 00, f: 24 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
            
            mtcEnc.increment() // increments to qf 5
            #expect(mtcEnc.mtcQuarterFrame == 5, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 6
            #expect(mtcEnc.mtcQuarterFrame == 6, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 7
            #expect(mtcEnc.mtcQuarterFrame == 7, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 0
            #expect(mtcEnc.mtcQuarterFrame == 0, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 01, f: 00),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 01, f: 00 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
            
            mtcEnc.increment() // increments to qf 1
            #expect(mtcEnc.mtcQuarterFrame == 1, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 2
            #expect(mtcEnc.mtcQuarterFrame == 2, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 3
            #expect(mtcEnc.mtcQuarterFrame == 3, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 4
            #expect(mtcEnc.mtcQuarterFrame == 4, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 01, f: 00),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 01, f: 01 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
            
            mtcEnc.increment() // increments to qf 5
            #expect(mtcEnc.mtcQuarterFrame == 5, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 6
            #expect(mtcEnc.mtcQuarterFrame == 6, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 7
            #expect(mtcEnc.mtcQuarterFrame == 7, "at: \(derivedFrameRate)")
            
            mtcEnc.increment() // increments to qf 0
            #expect(mtcEnc.mtcQuarterFrame == 0, "at: \(derivedFrameRate)")
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 00, s: 01, f: 02),
                "at: \(derivedFrameRate)"
            )
            #expect(
                mtcEnc.timecode ==
                    Timecode(
                        .components(h: 1, m: 00, s: 01, f: 02 * frMult),
                        at: derivedFrameRate,
                        by: .allowingInvalid
                    ),
                "at: \(derivedFrameRate)"
            )
        }
    }
    
    @Test
    func mtcEncoder_Decrement() {
        // test to ensure decrement behavior is consistent across timecode frame rates
        
        var mtcEnc: MTCEncoder!
        
        for item in TimecodeFrameRate.allCases {
            mtcEnc = MTCEncoder()
            mtcEnc.setLocalFrameRate(item)
            mtcEnc.setMTCComponents(mtc: .init(h: 1, m: 20, s: 32, f: 10))
            
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
            
            mtcEnc.decrement() // doesn't decrement; sends first quarter-frame
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 10),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
            
            mtcEnc.decrement() // now it decrements to QF 7
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    7,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    6,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    5,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    4,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    3,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    2,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    1,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 08),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    0,
                "at: \(item)"
            )
            
            mtcEnc.decrement()
            #expect(
                mtcEnc.mtcComponents ==
                    .init(h: 1, m: 20, s: 32, f: 06),
                "at: \(item)"
            )
            #expect(
                mtcEnc.mtcQuarterFrame ==
                    7,
                "at: \(item)"
            )
        }
    }
    
    
    @Test
    func mtcEncoder_Handlers_FullFrameMessage() async throws {
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // testing vars
        
        final actor Receiver {
            var events: [MIDIEvent]?
            func set(events: [MIDIEvent]?) { self.events = events }
        }
        let receiver = Receiver()
        
        let mtcEnc = MTCEncoder { [weak receiver] midiEvents in
            // MTCEncoder does not use Task or internal dispatch queues
            Task {
                await receiver?.set(events: midiEvents)
            }
        }
        
        // default / initial state
        
        #expect(await receiver.events == nil)
        
        // full-frame MTC messages
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 02, s: 03, f: 4), at: .fps24, by: .allowingInvalid))
        
        try await wait(require: {
            await receiver.events == [kMIDIEvent.MTC_FullFrame._01_02_03_04_at_24fps]
        }, timeout: 1.0)
        
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 11, s: 17, f: 20), at: .fps25, by: .allowingInvalid))
        
        try await wait(require: {
            await receiver.events == [kMIDIEvent.MTC_FullFrame._02_11_17_20_at_25fps]
        }, timeout: 1.0)
    }
    
    @Test @MainActor // using main actor just for simplicity, otherwise we need to do a bunch of async waiting
    func mtcEncoder_Handlers_QFMessages() async throws {
        // ensure expected callbacks are happening when they should,
        // and that they carry the data that they should
        
        // testing vars
        
        @MainActor final class Receiver {
            var events: [MIDIEvent]?
        }
        let receiver = Receiver()
        
        let mtcEnc = MTCEncoder { [weak receiver] midiEvents in
            // MTCEncoder does not use Task or internal dispatch queues
            MainActor.assumeIsolated {
                receiver?.events = midiEvents
            }
        }
        
        // default / initial state
        
        #expect(receiver.events == nil)
        
        // 24fps QFs starting at 02:03:04:06, locking at 02:03:04:08 (+ 2 MTC frame offset)
        
        // start by locating to a timecode
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 03, s: 04, f: 06), at: .fps24, by: .allowingInvalid))
        #expect(mtcEnc.mtcQuarterFrame == 0)
        
        mtcEnc.increment() // doesn't increment; sends first quarter-frame
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b00000110)]) // QF 0
        
        mtcEnc.increment() // now it increments to QF 1
        #expect(mtcEnc.mtcQuarterFrame == 1)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b00010000)]) // QF 1
        
        mtcEnc.increment()
        #expect(mtcEnc.mtcQuarterFrame == 2)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b00100100)]) // QF 2
        
        mtcEnc.increment()
        #expect(mtcEnc.mtcQuarterFrame == 3)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b00110000)]) // QF 3
        
        mtcEnc.increment()
        #expect(mtcEnc.mtcQuarterFrame == 4)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b01000011)]) // QF 4
        
        mtcEnc.increment()
        #expect(mtcEnc.mtcQuarterFrame == 5)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b01010000)]) // QF 5
        
        mtcEnc.increment()
        #expect(mtcEnc.mtcQuarterFrame == 6)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b01100010)]) // QF 6
        
        mtcEnc.increment()
        #expect(mtcEnc.mtcQuarterFrame == 7)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 06))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b01110000)]) // QF 7
        
        mtcEnc.increment()
        #expect(mtcEnc.mtcQuarterFrame == 0)
        #expect(mtcEnc.mtcComponents == .init(h: 2, m: 03, s: 04, f: 08))
        #expect(receiver.events == [.timecodeQuarterFrame(dataByte: 0b00001000)]) // QF 0
    }
    
    @Test
    func mtcEncoder_FullFrameMIDIMessage() {
        var mtcEnc: MTCEncoder
        
        // test each of the four MTC SMPTE base frame rates
        // and spot-check some arbitrary timecode values
        
        // non-scaling frame rates
        
        mtcEnc = MTCEncoder()
        mtcEnc.locate(to: Timecode(.zero, at: .fps24))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 0, m: 00, s: 00, f: 00)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000000, // 0rrh_hhhh
                    0x00, // M
                    0x00, // S
                    0x00, // F
                    0xF7
                ]
        )
        
        mtcEnc = MTCEncoder()
        mtcEnc.locate(to: Timecode(.zero, at: .fps25))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 0, m: 00, s: 00, f: 00)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00100000, // 0rrh_hhhh
                    0x00, // M
                    0x00, // S
                    0x00, // F
                    0xF7
                ]
        )
        
        mtcEnc = MTCEncoder()
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 1, m: 02, s: 03, f: 04)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b01000001, // 0rrh_hhhh
                    0x02, // M
                    0x03, // S
                    0x04, // F
                    0xF7
                ]
        )
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 02, s: 03, f: 05), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 1, m: 02, s: 03, f: 05)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b01000001, // 0rrh_hhhh
                    0x02, // M
                    0x03, // S
                    0x05, // F
                    0xF7
                ]
        )
        
        mtcEnc = MTCEncoder()
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 08), at: .fps30, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 08)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b01100010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x08, // F
                    0xF7
                ]
        )
        
        // scaling frame rates
        
        mtcEnc = MTCEncoder()
        
        // scales to MTC-24 fps
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 08), at: .fps48, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 04)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x04, // F
                    0xF7
                ]
        )
        
        // scales to MTC-24 fps
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 09), at: .fps48, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 04)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x04, // F -- rounds down to 4 from 4.5 from scaling
                    0xF7
                ]
        )
        
        // scales to MTC-24 fps
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 10), at: .fps48, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 05)
        )
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().event.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x05, // F
                    0xF7
                ]
        )
    }
    
    @Test @MainActor // using main actor just for simplicity, otherwise we need to do a bunch of async waiting
    func mtcEncoder_LocateBehavior() {
        var mtcEnc: MTCEncoder
        
        @MainActor final class Receiver {
            var events: [MIDIEvent]?
        }
        let receiver = Receiver()
        
        func initNewEnc() -> MTCEncoder {
            MTCEncoder { [weak receiver] midiEvents in
                // MTCEncoder does not use Task or internal dispatch queues
                MainActor.assumeIsolated {
                    receiver?.events = midiEvents
                }
            }
        }
        
        mtcEnc = initNewEnc()
        mtcEnc.locate(to: Timecode(.zero, at: .fps24))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 0, m: 00, s: 00, f: 00)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000000, // 0rrh_hhhh
                    0x00, // M
                    0x00, // S
                    0x00, // F
                    0xF7
                ]
        )
        
        mtcEnc = initNewEnc()
        mtcEnc.locate(to: Timecode(.zero, at: .fps25))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 0, m: 00, s: 00, f: 00)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00100000, // 0rrh_hhhh
                    0x00, // M
                    0x00, // S
                    0x00, // F
                    0xF7
                ]
        )
        
        mtcEnc = initNewEnc()
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 1, m: 02, s: 03, f: 04)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b01000001, // 0rrh_hhhh
                    0x02, // M
                    0x03, // S
                    0x04, // F
                    0xF7
                ]
        )
        
        mtcEnc.locate(to: Timecode(.components(h: 1, m: 02, s: 03, f: 05), at: .fps29_97d, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 1, m: 02, s: 03, f: 05)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b01000001, // 0rrh_hhhh
                    0x02, // M
                    0x03, // S
                    0x05, // F
                    0xF7
                ]
        )
        
        mtcEnc = initNewEnc()
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 08), at: .fps30, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 08)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b01100010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x08, // F
                    0xF7
                ]
        )
        
        // scaling frame rates
        
        mtcEnc = initNewEnc()
        
        // scales to MTC-24 fps
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 08), at: .fps48, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 04)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x04, // F
                    0xF7
                ]
        )
        
        // scales to MTC-24 fps
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 09), at: .fps48, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 04)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x04, // F -- rounds down to 4 from 4.5 from scaling
                    0xF7
                ]
        )
        
        // scales to MTC-24 fps
        mtcEnc.locate(to: Timecode(.components(h: 2, m: 04, s: 06, f: 10), at: .fps48, by: .allowingInvalid))
        
        #expect(
            mtcEnc.generateFullFrameMIDIMessage().components ==
                .init(h: 2, m: 04, s: 06, f: 05)
        )
        #expect(
            receiver.events?.first?.midi1RawBytes() ==
                [
                    0xF0, 0x7F, 0x7F, 0x01, 0x01,
                    0b00000010, // 0rrh_hhhh
                    0x04, // M
                    0x06, // S
                    0x05, // F
                    0xF7
                ]
        )
    }
    
    @Test
    func mtcEncoder_QFMIDIMessage() {
        let mtcEnc = MTCEncoder()
        
        // test an arbitrary timecode in all timecode frame rates
        // while covering all four MTC SMPTE base frame rates
        
        for item in TimecodeFrameRate.allCases {
            mtcEnc.locate(to: Timecode(.components(h: 2, m: 4, s: 6, f: 0), at: item, by: .allowingInvalid))
            mtcEnc.mtcComponents.frames = 8
            
            mtcEnc.mtcQuarterFrame = 0
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, 0b00001000]
            )
            
            mtcEnc.mtcQuarterFrame = 1
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, 0b00010000]
            )
            
            mtcEnc.mtcQuarterFrame = 2
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, 0b00100110]
            )
            
            mtcEnc.mtcQuarterFrame = 3
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, 0b00110000]
            )
            
            mtcEnc.mtcQuarterFrame = 4
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, 0b01000100]
            )
            
            mtcEnc.mtcQuarterFrame = 5
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, 0b01010000]
            )
            
            mtcEnc.mtcQuarterFrame = 6
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, 0b01100010]
            )
            
            mtcEnc.mtcQuarterFrame = 7
            let dataByte: UInt8 = switch item.mtcFrameRate {
            case .mtc24:    0b01110000
            case .mtc25:    0b01110010
            case .mtc2997d: 0b01110100
            case .mtc30:    0b01110110
            }
            #expect(
                mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                    [0xF1, dataByte]
            )
        }
        
        // edge cases
        
        // test large numbers, but still within spec
        
        mtcEnc.locate(to: Timecode(.components(h: 23, m: 59, s: 58, f: 28), at: .fps30, by: .allowingInvalid))
        
        mtcEnc.mtcQuarterFrame = 0
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b00001100]
        )
        
        mtcEnc.mtcQuarterFrame = 1
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b00010001]
        )
        
        mtcEnc.mtcQuarterFrame = 2
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b00101010]
        )
        
        mtcEnc.mtcQuarterFrame = 3
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b00110011]
        )
        
        mtcEnc.mtcQuarterFrame = 4
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b01001011]
        )
        
        mtcEnc.mtcQuarterFrame = 5
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b01010011]
        )
        
        mtcEnc.mtcQuarterFrame = 6
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b01100111]
        )
        
        mtcEnc.mtcQuarterFrame = 7
        #expect(
            mtcEnc.generateQuarterFrameMIDIMessage().midi1RawBytes() ==
                [0xF1, 0b01110111]
        )
    }
}
