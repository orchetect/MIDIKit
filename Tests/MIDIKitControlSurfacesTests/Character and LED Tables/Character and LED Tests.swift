//
//  Character and LED Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import Testing

@Suite struct CharacterAndLEDTests {
    // MARK: - HUILargeDisplayCharacter
    
    /// Ensure each character's string can reform the character enum case.
    @Test
    func huiLargeDisplayCharacter_InitFromString() {
        // 0x00 ... 0x0F are empty/control characters that we can't test
        for char in HUILargeDisplayCharacter.allCases.dropFirst(0x10) {
            let str = char.string
            let charFromStr = HUILargeDisplayCharacter(str)
            #expect(charFromStr == char)
        }
    }
    
    @Test
    func huiLargeDisplayCharacter_Sequence_StringValue() {
        let chars: [HUILargeDisplayCharacter] = [.A, .B, .space, .num9]
        #expect(chars.stringValue == "AB 9")
    }
    
    // MARK: - HUILargeDisplayString
    
    @Test
    func huiLargeDisplayString_Init_Chars_StringValue() {
        // pad to 40 chars
        #expect(
            HUILargeDisplayString(chars: [.A, .B, .space, .num9]).stringValue ==
                "AB 9" + .init(repeating: " ", count: 36)
        )
        
        // trim to 40 chars
        #expect(
            HUILargeDisplayString(chars: .init(repeating: .A, count: 45)).stringValue ==
                .init(repeating: "A", count: 40)
        )
    }
    
    @Test
    func huiLargeDisplayString_Init_LossyString() {
        // pad to 40 chars
        #expect(
            HUILargeDisplayString(lossy: "AB 9").chars ==
                [.A, .B, .space, .num9] + .init(repeating: .space, count: 36)
        )
        
        // trim to 40 chars
        #expect(
            HUILargeDisplayString(lossy: String(repeating: "A", count: 45)).chars ==
                .init(repeating: .A, count: 40)
        )
    }
    
    @Test
    func huiLargeDisplayString_Slices() {
        let str = HUILargeDisplayString(chars: [.A, .B, .space, .num9])
        #expect(
            str.slices() ==
                [
                    [.A, .B, .space, .num9] + .init(repeating: .space, count: 6),
                    .init(repeating: .space, count: 10),
                    .init(repeating: .space, count: 10),
                    .init(repeating: .space, count: 10)
                ]
        )
    }
    
    /// Test padding/truncation validation
    @Test
    func huiLargeDisplayString_SetChars() {
        var str = HUILargeDisplayString(lossy: "AB 9")
        
        str.chars = []
        #expect(
            str.chars ==
                .init(repeating: .space, count: 40)
        )
        
        str.chars = [.A, .B, .space, .num9]
        #expect(
            str.chars ==
                [.A, .B, .space, .num9] + .init(repeating: .space, count: 36)
        )
        
        str.chars = .init(repeating: .A, count: 40)
        #expect(
            str.chars ==
                .init(repeating: .A, count: 40)
        )
        
        str.chars = .init(repeating: .A, count: 40) + [.num1, .num2, .num3, .num4]
        #expect(
            str.chars ==
                .init(repeating: .A, count: 40)
        )
    }
    
    @Test
    func huiLargeDisplayString_UpdateSlice_IsDifferent() {
        do {
            var str = HUILargeDisplayString(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
            let result = str.update(slice: 0, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z])
            #expect(result)
            #expect(str.stringValue == "ZZZZZZZZZZCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        }
        
        do {
            var str = HUILargeDisplayString(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
            let result = str.update(slice: 1, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z])
            #expect(result)
            #expect(str.stringValue == "AAAAABBBBBZZZZZZZZZZEEEEEFFFFFGGGGGHHHHH")
        }
        
        do {
            var str = HUILargeDisplayString(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
            let result = str.update(slice: 2, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z])
            #expect(result)
            #expect(str.stringValue == "AAAAABBBBBCCCCCDDDDDZZZZZZZZZZGGGGGHHHHH")
        }
        
        do {
            var str = HUILargeDisplayString(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
            let result = str.update(slice: 3, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z])
            #expect(result)
            #expect(str.stringValue == "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFZZZZZZZZZZ")
        }
    }
    
    @Test
    func huiLargeDisplayString_UpdateSlice_IsNotDifferent() {
        do {
            var str = HUILargeDisplayString(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
            let result = str.update(slice: 0, newChars: [.A, .A, .A, .A, .A, .B, .B, .B, .B, .B])
            #expect(!result)
            #expect(str.stringValue == "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        }
        
        do {
            var str = HUILargeDisplayString(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
            let result = str.update(slice: 3, newChars: [.G, .G, .G, .G, .G, .H, .H, .H, .H, .H])
            #expect(!result)
            #expect(str.stringValue == "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        }
    }
    
    @Test
    func huiLargeDisplayString_UpdateSlice_SliceIndexOutOfBounds() {
        var str = HUILargeDisplayString(lossy: "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
        let result = str.update(slice: 4, newChars: [.Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z, .Z])
        #expect(!result)
        #expect(str.stringValue == "AAAAABBBBBCCCCCDDDDDEEEEEFFFFFGGGGGHHHHH")
    }
    
    // MARK: - HUISmallDisplayCharacter
    
    /// Ensure each character's string can reform the character enum case.
    @Test
    func huiSmallDisplayCharacter_InitFromString() {
        for char in HUISmallDisplayCharacter.allCases {
            let str = char.string
            let charFromStr = HUISmallDisplayCharacter(str)
            #expect(charFromStr == char)
        }
    }
    
    @Test
    func huiSmallDisplayCharacter_Sequence_StringValue() {
        let chars: [HUISmallDisplayCharacter] = [.A, .B, .space, .num9]
        #expect(chars.stringValue == "AB 9")
    }
    
    // MARK: - HUISmallDisplayString
    
    @Test
    func huiSmallDisplayString_Init_Chars_StringValue() {
        let str = HUISmallDisplayString(chars: [.A, .B, .num9])
        #expect(str.stringValue == "AB9 ")
    }
    
    @Test
    func huiSmallDisplayString_Init_LossyString() {
        // pad to 4 chars
        #expect(
            HUISmallDisplayString(lossy: "AB9").chars ==
                [.A, .B, .num9, .space]
        )
        
        // trim to 4 chars
        #expect(
            HUISmallDisplayString(lossy: "AB9123").chars ==
                [.A, .B, .num9, .num1]
        )
    }
    
    // MARK: - HUITimeDisplayCharacter
    
    /// Ensure each character's string can reform the character enum case.
    @Test
    func huiTimeDisplayCharacter_InitFromString() {
        // omit characters that are unknown or duplicate
        var chars = HUITimeDisplayCharacter.allCases
        chars.removeSubrange(0x21 ... 0x2F)
        for char in chars {
            let str = char.string
            let charFromStr = HUITimeDisplayCharacter(str)
            #expect(charFromStr == char)
        }
    }
    
    /// Random spot-check for `hasDot` property.
    @Test
    func huiTimeDisplayCharacter_hasDot() {
        #expect(!HUITimeDisplayCharacter.A.hasDot)
        #expect(HUITimeDisplayCharacter.Adot.hasDot)
    }
    
    @Test
    func huiTimeDisplayCharacter_Sequence_StringValue() {
        let chars: [HUITimeDisplayCharacter] = [.A, .B, .Cdot, .spaceDot, .num9]
        #expect(chars.stringValue == "ABC. .9")
    }
    
    // MARK: - HUITimeDisplayString
    
    @Test
    func huiTimeDisplayString_Init_Chars_StringValue() {
        let str = HUITimeDisplayString(chars: [.A, .B, .space, .num9])
        #expect(str.stringValue == "AB 9    ")
    }
    
    @Test
    func huiTimeDisplayString_Init_LossyString() {
        // pad to 4 chars
        #expect(
            HUITimeDisplayString(lossy: "AB9").chars ==
                [.A, .B, .num9, .space, .space, .space, .space, .space]
        )
        
        // trim to 4 chars
        #expect(
            HUITimeDisplayString(lossy: "1234567890").chars ==
                [.num1, .num2, .num3, .num4, .num5, .num6, .num7, .num8]
        )
        
        // recognize characters that have trailing dots
        #expect(
            HUITimeDisplayString(lossy: "A.B9.CD").chars ==
                [.Adot, .B, .num9dot, .C, .D, .space, .space, .space]
        )
    }
    
    /// Test padding/truncation validation
    @Test
    func huiTimeDisplayString_SetChars() {
        var str = HUITimeDisplayString(lossy: "12345678")
        
        str.chars = []
        #expect(str.stringValue == "        ")
        
        str.chars = [.A, .B]
        #expect(str.stringValue == "AB      ")
        
        str.chars = [.A, .B, .C, .D, .E, .F, .num1, .num2]
        #expect(str.stringValue == "ABCDEF12")
        
        str.chars = [.A, .B, .C, .D, .E, .F, .num1, .num2, .num3, .num4]
        #expect(str.stringValue == "ABCDEF12")
    }
    
    @Test
    func huiTimeDisplayString_Update_Empty() {
        var str = HUITimeDisplayString(lossy: "12345678")
        let result = str.update(charsRightToLeft: [])
        #expect(!result)
        #expect(str.stringValue == "12345678")
    }
    
    @Test
    func huiTimeDisplayString_Update_Partial_IsDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        let result = str.update(charsRightToLeft: [.A, .B])
        #expect(result)
        #expect(str.stringValue == "123456BA")
    }
    
    @Test
    func huiTimeDisplayString_Update_Partial_IsNotDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        let result = str.update(charsRightToLeft: [.num8, .num7])
        #expect(!result)
        #expect(str.stringValue == "12345678")
    }
    
    @Test
    func huiTimeDisplayString_Update_Full_IsDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        let result = str.update(charsRightToLeft: [.A, .B, .C, .D, .E, .F, .num1, .num2])
        #expect(result)
        #expect(str.stringValue == "21FEDCBA")
    }
    
    @Test
    func huiTimeDisplayString_Update_Full_IsNotDifferent() {
        var str = HUITimeDisplayString(lossy: "12345678")
        let result = str.update(charsRightToLeft: [.num8, .num7, .num6, .num5, .num4, .num3, .num2, .num1])
        #expect(!result)
        #expect(str.stringValue == "12345678")
    }
    
    // MARK: - HUIVPotDisplay
    
    @Test
    func huiVPotDisplayAndLEDState() {
        let vp = HUIVPotDisplay(leds: .center(to: .L5), lowerLED: true)
        
        #expect(vp.lowerLED)
        #expect(vp.leds.rawValue == 0x11)
        #expect(vp.leds.boolArray == [
            true, true, true, true, true, true, false, false, false, false, false
        ])
        #expect(vp.leds.bitPattern == 0b111_11100000)
        #expect(vp.leds.stringValue(activeChar: "*", inactiveChar: " ") == "******     ")
    }
    
    @Test
    func huiVPotDisplay_Init_RawIndex_NoLowerLED() {
        let vp = HUIVPotDisplay(rawIndex: 0x11)
        #expect(vp.leds == .center(to: .L5))
        #expect(!vp.lowerLED)
    }
    
    @Test
    func huiVPotDisplay_Init_RawIndex_LowerLED() {
        let vp = HUIVPotDisplay(rawIndex: 0x11 + 0x40)
        #expect(vp.leds == .center(to: .L5))
        #expect(vp.lowerLED)
    }
    
    @Test
    func huiVPotDisplay_Init_RawIndex_AllOff() {
        let vp = HUIVPotDisplay(rawIndex: 0)
        #expect(vp.leds == .allOff)
        #expect(!vp.lowerLED)
    }
    
    @Test
    func huiVPotDisplay_Init_RawIndex_OutOfBounds() {
        let vp = HUIVPotDisplay(rawIndex: 0x80)
        #expect(vp.leds == .allOff)
        #expect(!vp.lowerLED)
    }
    
    @Test
    func huiVPotDisplay_LEDState_InitRawValue() {
        // without lower LED
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x00) ==
                .allOff
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x01) ==
                .single(.L5)
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x11) ==
                .center(to: .L5)
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x21) ==
                .left(to: .L5)
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x31) ==
                .centerRadius(radius: .C)
        )
        
        // with lower LED
        // (n/a for LEDState but it should be able to parse it)
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x00 + 0x40) ==
                .allOff
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x01 + 0x40) ==
                .single(.L5)
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x11 + 0x40) ==
                .center(to: .L5)
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x21 + 0x40) ==
                .left(to: .L5)
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x31 + 0x40) ==
                .centerRadius(radius: .C)
        )
        
        // edge cases
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x1F) == // unused
                .allOff
        )
        
        #expect(
            HUIVPotDisplay.LEDState(rawValue: 0x90) == nil // out of bounds
        )
    }
    
    @Test
    func huiVPotDisplay_LEDState_rawValue() {
        #expect(
            HUIVPotDisplay.LEDState.allOff.rawValue ==
                0x00
        )
        
        #expect(
            HUIVPotDisplay.LEDState.single(.L5).rawValue ==
                0x01
        )
        
        #expect(
            HUIVPotDisplay.LEDState.center(to: .L5).rawValue ==
                0x11
        )
        
        #expect(
            HUIVPotDisplay.LEDState.left(to: .L5).rawValue ==
                0x21
        )
        
        #expect(
            HUIVPotDisplay.LEDState.centerRadius(radius: .C).rawValue ==
                0x31
        )
    }
    
    @Test
    func huiVPotDisplay_LEDState_Equatable() {
        let allOff: HUIVPotDisplay.LEDState = .allOff
        #expect(allOff == .allOff)
        #expect(allOff != .single(.L5))
        
        let single: HUIVPotDisplay.LEDState = .single(.L5)
        #expect(single == .single(.L5))
        #expect(single != .single(.L4))
        #expect(single != .center(to: .L5))
        
        let centerTo: HUIVPotDisplay.LEDState = .center(to: .L5)
        #expect(centerTo == .center(to: .L5))
        #expect(centerTo != .center(to: .L4))
        #expect(centerTo != .left(to: .L5))
        
        let leftTo: HUIVPotDisplay.LEDState = .left(to: .L5)
        #expect(leftTo == .left(to: .L5))
        #expect(leftTo != .left(to: .L4))
        #expect(leftTo != .centerRadius(radius: .L1))
        
        let centerRad: HUIVPotDisplay.LEDState = .centerRadius(radius: .L1)
        #expect(centerRad == .centerRadius(radius: .L1))
        #expect(centerRad != .centerRadius(radius: .L2))
        #expect(centerRad != .single(.L5))
    }
    
    @Test
    func huiVPotDisplay_LEDState_Bounds() {
        #expect(HUIVPotDisplay.LEDState.allOff.bounds == nil)
        
        #expect(HUIVPotDisplay.LEDState.single(.L5).bounds == .L5 ... .L5)
        #expect(HUIVPotDisplay.LEDState.single(.C).bounds == .C ... .C)
        
        #expect(HUIVPotDisplay.LEDState.center(to: .L5).bounds == .L5 ... .C)
        #expect(HUIVPotDisplay.LEDState.center(to: .C).bounds == .C ... .C)
        #expect(HUIVPotDisplay.LEDState.center(to: .R5).bounds == .C ... .R5)
        
        #expect(HUIVPotDisplay.LEDState.left(to: .L5).bounds == .L5 ... .L5)
        #expect(HUIVPotDisplay.LEDState.left(to: .C).bounds == .L5 ... .C)
        #expect(HUIVPotDisplay.LEDState.left(to: .R5).bounds == .L5 ... .R5)
        
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .L5).bounds == .L5 ... .R5)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .L4).bounds == .L4 ... .R4)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .L3).bounds == .L3 ... .R3)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .L2).bounds == .L2 ... .R2)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .L1).bounds == .L1 ... .R1)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .C).bounds == .C ... .C)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .R1).bounds == .L1 ... .R1)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .R2).bounds == .L2 ... .R2)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .R3).bounds == .L3 ... .R3)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .R4).bounds == .L4 ... .R4)
        #expect(HUIVPotDisplay.LEDState.centerRadius(radius: .R5).bounds == .L5 ... .R5)
    }
    
    // MARK: - pad
    
    @Test
    func pad_Empty() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = []
        let padded: [HUILargeDisplayCharacter] = .init(repeating: .default(), count: staticCount)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        #expect(p1 == padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        #expect(p2 == padded)
    }
    
    @Test
    func pad_FewerChars() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = [.A, .B]
        let padded: [HUILargeDisplayCharacter] = [.A, .B] +
            .init(repeating: .default(), count: staticCount - 2)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        #expect(p1 == padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        #expect(p2 == padded)
    }
    
    @Test
    func pad_ExactCharCount() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount)
        let padded: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        #expect(p1 == padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        #expect(p2 == padded)
    }
    
    @Test
    func pad_TooManyChars() {
        let staticCount = 40
        
        let chars: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount + 5)
        let padded: [HUILargeDisplayCharacter] = .init(repeating: .A, count: staticCount)
        
        // category method
        let p1 = chars.pad(count: staticCount, with: .default())
        #expect(p1 == padded)
        
        // global method
        let p2 = pad(chars: chars, for: HUILargeDisplayString.self)
        #expect(p2 == padded)
    }
}
