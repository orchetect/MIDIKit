//
//  CharacterAndLEDTests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitControlSurfaces

final class CharacterAndLEDTests: XCTestCase {
    // MARK: - HUILargeDisplayCharacter
    
    /// Ensure each character's string can reform the character enum case.
    func testHUILargeDisplayCharacter_InitFromString() {
        // 0x00 ... 0x0F are empty/control characters that we can't test
        HUILargeDisplayCharacter.allCases.dropFirst(0x10)
            .forEach { char in
                let str = char.string
                let charFromStr = HUILargeDisplayCharacter(str)
                XCTAssertEqual(charFromStr, char)
            }
    }
    
    func testHUILargeDisplayCharacter_Sequence_StringValue() {
        let chars: [HUILargeDisplayCharacter] = [.A, .B, .space, .num9]
        XCTAssertEqual(chars.stringValue, "AB 9")
    }
    
    // MARK: - HUILargeDisplayString
    
    func testHUILargeDisplayString_Init_Chars_StringValue() {
        // pad to 40 chars
        XCTAssertEqual(
            HUILargeDisplayString(chars: [.A, .B, .space, .num9]).stringValue,
            "AB 9" + .init(repeating: " ", count: 36)
        )
        
        // trim to 40 chars
        XCTAssertEqual(
            HUILargeDisplayString(chars: .init(repeating: .A, count: 45)).stringValue,
            .init(repeating: "A", count: 40)
        )
    }
    
    func testHUILargeDisplayString_Init_LossyString() {
        // pad to 40 chars
        XCTAssertEqual(
            HUILargeDisplayString(lossy: "AB 9").chars,
            [.A, .B, .space, .num9] + .init(repeating: .space, count: 36)
        )
        
        // trim to 40 chars
        XCTAssertEqual(
            HUILargeDisplayString(lossy: String(repeating: "A", count: 45)).chars,
            .init(repeating: .A, count: 40)
        )
    }
    
    func testHUILargeDisplayString_Slices() {
        let str = HUILargeDisplayString(chars: [.A, .B, .space, .num9])
        XCTAssertEqual(
            str.slices,
            [
                [.A, .B, .space, .num9] + .init(repeating: .space, count: 6),
                .init(repeating: .space, count: 10),
                .init(repeating: .space, count: 10),
                .init(repeating: .space, count: 10)
            ]
        )
    }
    
    // MARK: - HUISmallDisplayCharacter
    
    /// Ensure each character's string can reform the character enum case.
    func testHUISmallDisplayCharacter_InitFromString() {
        HUISmallDisplayCharacter.allCases
            .forEach { char in
                let str = char.string
                let charFromStr = HUISmallDisplayCharacter(str)
                XCTAssertEqual(charFromStr, char)
            }
    }
    
    func testHUISmallDisplayCharacter_Sequence_StringValue() {
        let chars: [HUISmallDisplayCharacter] = [.A, .B, .space, .num9]
        XCTAssertEqual(chars.stringValue, "AB 9")
    }
    
    // MARK: - HUISmallDisplayString
    
    func testHUISmallDisplayString_Init_Chars_StringValue() {
        let str = HUISmallDisplayString(chars: [.A, .B, .num9])
        XCTAssertEqual(str.stringValue, "AB9 ")
    }
    
    func testHUISmallDisplayString_Init_LossyString() {
        // pad to 4 chars
        XCTAssertEqual(
            HUISmallDisplayString(lossy: "AB9").chars,
            [.A, .B, .num9, .space]
        )
        
        // trim to 4 chars
        XCTAssertEqual(
            HUISmallDisplayString(lossy: "AB9123").chars,
            [.A, .B, .num9, .num1]
        )
    }
    
    // MARK: - HUITimeDisplayCharacter
    
    /// Ensure each character's string can reform the character enum case.
    func testHUITimeDisplayCharacter_InitFromString() {
        // omit characters that are unknown or duplicate
        var chars = HUITimeDisplayCharacter.allCases
        chars.removeSubrange(0x21 ... 0x2F)
        chars.forEach { char in
            let str = char.string
            let charFromStr = HUITimeDisplayCharacter(str)
            XCTAssertEqual(charFromStr, char)
        }
    }
    
    /// Random spot-check for `hasDot` property.
    func testHUITimeDisplayCharacter_hasDot() {
        XCTAssertFalse(HUITimeDisplayCharacter.A.hasDot)
        XCTAssertTrue(HUITimeDisplayCharacter.Adot.hasDot)
    }
    
    func testHUITimeDisplayCharacter_Sequence_StringValue() {
        let chars: [HUITimeDisplayCharacter] = [.A, .B, .Cdot, .spaceDot, .num9]
        XCTAssertEqual(chars.stringValue, "ABC. .9")
    }
    
    // MARK: - HUITimeDisplayString
    
    func testHUITimeDisplayString_Init_Chars_StringValue() {
        let str = HUITimeDisplayString(chars: [.A, .B, .space, .num9])
        XCTAssertEqual(str.stringValue, "AB 9    ")
    }
    
    func testHUITimeDisplayString_Init_LossyString() {
        // pad to 4 chars
        XCTAssertEqual(
            HUITimeDisplayString(lossy: "AB9").chars,
            [.A, .B, .num9, .space, .space, .space, .space, .space]
        )
        
        // trim to 4 chars
        XCTAssertEqual(
            HUITimeDisplayString(lossy: "1234567890").chars,
            [.num1, .num2, .num3, .num4, .num5, .num6, .num7, .num8]
        )
        
        // recognize characters that have trailing dots
        XCTAssertEqual(
            HUITimeDisplayString(lossy: "A.B9.CD").chars,
            [.Adot, .B, .num9dot, .C, .D, .space, .space, .space]
        )
    }
    
    // MARK: - HUIVPotDisplay
    
    func testHUIVPotDisplayAndLEDState() {
        let vp = HUIVPotDisplay(leds: .fromCenterToL5, lowerLED: true)
        
        XCTAssertTrue(vp.lowerLED)
        XCTAssertEqual(vp.leds.rawValue, 0x11)
        XCTAssertEqual(vp.leds.boolArray, [
            true, true, true, true, true, true, false, false, false, false, false
        ])
        XCTAssertEqual(vp.leds.bitPattern, 0b111_11100000)
        XCTAssertEqual(vp.leds.stringValue(activeChar: "*", inactiveChar: " "), "******     ")
    }
    
    func testHUIVPotDisplay_Init_RawIndex_NoLowerLED() {
        let vp = HUIVPotDisplay(rawIndex: 0x11)
        XCTAssertEqual(vp.leds, .fromCenterToL5)
        XCTAssertFalse(vp.lowerLED)
    }
    
    func testHUIVPotDisplay_Init_RawIndex_LowerLED() {
        let vp = HUIVPotDisplay(rawIndex: 0x11 + 0x40)
        XCTAssertEqual(vp.leds, .fromCenterToL5)
        XCTAssertTrue(vp.lowerLED)
    }
    
    func testHUIVPotDisplay_Init_RawIndex_AllOff() {
        let vp = HUIVPotDisplay(rawIndex: 0)
        XCTAssertEqual(vp.leds, .allOff)
        XCTAssertFalse(vp.lowerLED)
    }
    
    func testHUIVPotDisplay_Init_RawIndex_OutOfBounds() {
        let vp = HUIVPotDisplay(rawIndex: 0x80)
        XCTAssertEqual(vp.leds, .allOff)
        XCTAssertFalse(vp.lowerLED)
    }
    
    // MARK: - pad
    
    func testPad_Empty() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = []
        let padded: [HUILargeDisplayCharacter] = .init(repeating: .default(), count: staticCount)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        XCTAssertEqual(p1, padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        XCTAssertEqual(p2, padded)
    }
    
    func testPad_FewerChars() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = [.A, .B]
        let padded: [HUILargeDisplayCharacter] = [.A, .B] + .init(repeating: .default(), count: staticCount - 2)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        XCTAssertEqual(p1, padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        XCTAssertEqual(p2, padded)
    }
    
    func testPad_ExactCharCount() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount)
        let padded: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        XCTAssertEqual(p1, padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        XCTAssertEqual(p2, padded)
    }
    
    func testPad_TooManyChars() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount + 5)
        let padded: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        XCTAssertEqual(p1, padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        XCTAssertEqual(p2, padded)
    }
}

#endif