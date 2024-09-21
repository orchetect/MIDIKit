//
//  Character and LED Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitControlSurfaces
import XCTest

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
    
    /// Test padding/truncation validation
    func testHUILargeDisplayString_SetChars() {
        var str = HUILargeDisplayString(lossy: "AB 9")
        
        str.chars = []
        XCTAssertEqual(
            str.chars,
            .init(repeating: .space, count: 40)
        )
        
        str.chars = [.A, .B, .space, .num9]
        XCTAssertEqual(
            str.chars,
            [.A, .B, .space, .num9] + .init(repeating: .space, count: 36)
        )
        
        str.chars = .init(repeating: .A, count: 40)
        XCTAssertEqual(
            str.chars,
            .init(repeating: .A, count: 40)
        )
        
        str.chars = .init(repeating: .A, count: 40) + [.num1, .num2, .num3, .num4]
        XCTAssertEqual(
            str.chars,
            .init(repeating: .A, count: 40)
        )
    }
    
    func testHUILargeDisplayString_UpdateSlice_IsDifferent() {
        var str = HUILargeDisplayString()
        
        str = .init(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        XCTAssertTrue(str.update(slice: 0, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z]))
        XCTAssertEqual(str.stringValue, "ZZZZZZZZZZCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        
        str = .init(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        str.update(slice: 1, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z])
        XCTAssertEqual(str.stringValue, "AAAAABBBBBZZZZZZZZZZEEEEEFFFFFGGGGGHHHHH")
        
        str = .init(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        XCTAssertTrue(str.update(slice: 2, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z]))
        XCTAssertEqual(str.stringValue, "AAAAABBBBBCCCCCDDDDDZZZZZZZZZZGGGGGHHHHH")
        
        str = .init(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        XCTAssertTrue(str.update(slice: 3, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z]))
        XCTAssertEqual(str.stringValue, "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFZZZZZZZZZZ")
    }
    
    func testHUILargeDisplayString_UpdateSlice_IsNotDifferent() {
        var str = HUILargeDisplayString()
        
        str = .init(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        XCTAssertFalse(str.update(slice: 0, newChars: [.A, .A, .A, .A, .A, .B, .B, .B, .B, .B]))
        XCTAssertEqual(str.stringValue, "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        
        str = .init(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        XCTAssertFalse(str.update(slice: 3, newChars: [.G, .G, .G, .G, .G, .H, .H, .H, .H, .H]))
        XCTAssertEqual(str.stringValue, "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
    }
    
    func testHUILargeDisplayString_UpdateSlice_SliceIndexOutOfBounds() {
        var str = HUILargeDisplayString()
        
        str = .init(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        XCTAssertFalse(str.update(slice: 4, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z]))
        XCTAssertEqual(str.stringValue, "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
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
    
    /// Test padding/truncation validation
    func testHUITimeDisplayString_SetChars() {
        var str = HUITimeDisplayString(lossy: "12345678")
        
        str.chars = []
        XCTAssertEqual(str.stringValue, "        ")
        
        str.chars = [.A, .B]
        XCTAssertEqual(str.stringValue, "AB      ")
        
        str.chars = [.A, .B, .C, .D, .E, .F, .num1, .num2]
        XCTAssertEqual(str.stringValue, "ABCDEF12")
        
        str.chars = [.A, .B, .C, .D, .E, .F, .num1, .num2, .num3, .num4]
        XCTAssertEqual(str.stringValue, "ABCDEF12")
    }
    
    func testHUITimeDisplayString_Update_Empty() {
        var str = HUITimeDisplayString(lossy: "12345678")
        XCTAssertFalse(str.update(charsRightToLeft: []))
        XCTAssertEqual(str.stringValue, "12345678")
    }
    
    func testHUITimeDisplayString_Update_Partial_IsDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        XCTAssertTrue(str.update(charsRightToLeft: [.A, .B]))
        XCTAssertEqual(str.stringValue, "123456BA")
    }
    
    func testHUITimeDisplayString_Update_Partial_IsNotDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        XCTAssertFalse(str.update(charsRightToLeft: [.num8, .num7]))
        XCTAssertEqual(str.stringValue, "12345678")
    }
    
    func testHUITimeDisplayString_Update_Full_IsDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        XCTAssertTrue(str.update(charsRightToLeft: [.A, .B, .C, .D, .E, .F, .num1, .num2]))
        XCTAssertEqual(str.stringValue, "21FEDCBA")
    }
    
    func testHUITimeDisplayString_Update_Full_IsNotDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        XCTAssertFalse(
            str
                .update(charsRightToLeft: [.num8, .num7, .num6, .num5, .num4, .num3, .num2, .num1])
        )
        XCTAssertEqual(str.stringValue, "12345678")
    }
    
    // MARK: - HUIVPotDisplay
    
    func testHUIVPotDisplayAndLEDState() {
        let vp = HUIVPotDisplay(leds: .center(to: .L5), lowerLED: true)
        
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
        XCTAssertEqual(vp.leds, .center(to: .L5))
        XCTAssertFalse(vp.lowerLED)
    }
    
    func testHUIVPotDisplay_Init_RawIndex_LowerLED() {
        let vp = HUIVPotDisplay(rawIndex: 0x11 + 0x40)
        XCTAssertEqual(vp.leds, .center(to: .L5))
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
    
    func testHUIVPotDisplay_LEDState_InitRawValue() {
        // without lower LED
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x00),
            .allOff
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x01),
            .single(.L5)
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x11),
            .center(to: .L5)
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x21),
            .left(to: .L5)
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x31),
            .centerRadius(radius: .C)
        )
        
        // with lower LED
        // (n/a for LEDState but it should be able to parse it)
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x00 + 0x40),
            .allOff
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x01 + 0x40),
            .single(.L5)
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x11 + 0x40),
            .center(to: .L5)
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x21 + 0x40),
            .left(to: .L5)
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x31 + 0x40),
            .centerRadius(radius: .C)
        )
        
        // edge cases
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState(rawValue: 0x1F), // unused
            .allOff
        )
        
        XCTAssertNil(
            HUIVPotDisplay.LEDState(rawValue: 0x90) // out of bounds
        )
    }
    
    func testHUIVPotDisplay_LEDState_rawValue() {
        XCTAssertEqual(
            HUIVPotDisplay.LEDState.allOff.rawValue,
            0x00
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState.single(.L5).rawValue,
            0x01
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState.center(to: .L5).rawValue,
            0x11
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState.left(to: .L5).rawValue,
            0x21
        )
        
        XCTAssertEqual(
            HUIVPotDisplay.LEDState.centerRadius(radius: .C).rawValue,
            0x31
        )
    }
    
    func testHUIVPotDisplay_LEDState_Equatable() {
        let allOff: HUIVPotDisplay.LEDState = .allOff
        XCTAssertEqual(allOff, .allOff)
        XCTAssertNotEqual(allOff, .single(.L5))
        
        let single: HUIVPotDisplay.LEDState = .single(.L5)
        XCTAssertEqual(single, .single(.L5))
        XCTAssertNotEqual(single, .single(.L4))
        XCTAssertNotEqual(single, .center(to: .L5))
        
        let centerTo: HUIVPotDisplay.LEDState = .center(to: .L5)
        XCTAssertEqual(centerTo, .center(to: .L5))
        XCTAssertNotEqual(centerTo, .center(to: .L4))
        XCTAssertNotEqual(centerTo, .left(to: .L5))
        
        let leftTo: HUIVPotDisplay.LEDState = .left(to: .L5)
        XCTAssertEqual(leftTo, .left(to: .L5))
        XCTAssertNotEqual(leftTo, .left(to: .L4))
        XCTAssertNotEqual(leftTo, .centerRadius(radius: .L1))
        
        let centerRad: HUIVPotDisplay.LEDState = .centerRadius(radius: .L1)
        XCTAssertEqual(centerRad, .centerRadius(radius: .L1))
        XCTAssertNotEqual(centerRad, .centerRadius(radius: .L2))
        XCTAssertNotEqual(centerRad, .single(.L5))
    }
    
    func testHUIVPotDisplay_LEDState_Bounds() {
        XCTAssertNil(HUIVPotDisplay.LEDState.allOff.bounds)
        
        XCTAssertEqual(HUIVPotDisplay.LEDState.single(.L5).bounds, .L5 ... .L5)
        XCTAssertEqual(HUIVPotDisplay.LEDState.single(.C).bounds, .C ... .C)
        
        XCTAssertEqual(HUIVPotDisplay.LEDState.center(to: .L5).bounds, .L5 ... .C)
        XCTAssertEqual(HUIVPotDisplay.LEDState.center(to: .C).bounds, .C ... .C)
        XCTAssertEqual(HUIVPotDisplay.LEDState.center(to: .R5).bounds, .C ... .R5)
        
        XCTAssertEqual(HUIVPotDisplay.LEDState.left(to: .L5).bounds, .L5 ... .L5)
        XCTAssertEqual(HUIVPotDisplay.LEDState.left(to: .C).bounds, .L5 ... .C)
        XCTAssertEqual(HUIVPotDisplay.LEDState.left(to: .R5).bounds, .L5 ... .R5)
        
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .L5).bounds, .L5 ... .R5)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .L4).bounds, .L4 ... .R4)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .L3).bounds, .L3 ... .R3)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .L2).bounds, .L2 ... .R2)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .L1).bounds, .L1 ... .R1)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .C).bounds, .C ... .C)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .R1).bounds, .L1 ... .R1)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .R2).bounds, .L2 ... .R2)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .R3).bounds, .L3 ... .R3)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .R4).bounds, .L4 ... .R4)
        XCTAssertEqual(HUIVPotDisplay.LEDState.centerRadius(radius: .R5).bounds, .L5 ... .R5)
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
        let padded: [HUILargeDisplayCharacter] = [.A, .B] +
            .init(repeating: .default(), count: staticCount - 2)
        
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
