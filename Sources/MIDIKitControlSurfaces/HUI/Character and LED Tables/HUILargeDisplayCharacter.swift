//
//  HUILargeDisplayCharacter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI large text display character set.
public enum HUILargeDisplayCharacter: UInt8, CaseIterable {
    case empty0x00 = 0x00
    case empty0x01 = 0x01
    case empty0x02 = 0x02
    case empty0x03 = 0x03
    
    case empty0x04 = 0x04
    case empty0x05 = 0x05
    case empty0x06 = 0x06
    case empty0x07 = 0x07
    
    case empty0x08 = 0x08
    case empty0x09 = 0x09
    case empty0x0A = 0x0A
    case empty0x0B = 0x0B
    
    case empty0x0C = 0x0C
    case empty0x0D = 0x0D
    case empty0x0E = 0x0E
    case empty0x0F = 0x0F
    
    case num11 = 0x10
    case num12 = 0x11
    case num13 = 0x12
    case num14 = 0x13
    
    case full = 0x14
    case r4 = 0x15
    case r3 = 0x16
    case r2 = 0x17
    
    case r1 = 0x18
    case musicNote = 0x19
    case degreesCelsius = 0x1A
    case degreesFahrenheit = 0x1B
    
    case solidDownArrow = 0x1C
    case solidRightArrow = 0x1D
    case solidLeftArrow = 0x1E
    case solidUpArrow = 0x1F
    
    case space = 0x20
    case exclamationPoint = 0x21
    /// `"`
    case doubleQuote = 0x22
    /// `#` - Pound sign, a.k.a. number sign, a.k.a hashtag.
    case hash = 0x23
    
    case dollar = 0x24
    case percent = 0x25
    case ampersand = 0x26
    case apostrophe = 0x27
    
    case openParens = 0x28
    case closeParens = 0x29
    case asterisk = 0x2A
    case plus = 0x2B
    
    case comma = 0x2C
    /// `-` - Minus sign, a.k.a. hyphen, a.k.a. dash.
    case minus = 0x2D
    case period = 0x2E
    /// `/`
    case forwardSlash = 0x2F
    
    case num0 = 0x30
    case num1 = 0x31
    case num2 = 0x32
    case num3 = 0x33
    
    case num4 = 0x34
    case num5 = 0x35
    case num6 = 0x36
    case num7 = 0x37
    
    case num8 = 0x38
    case num9 = 0x39
    case colon = 0x3A
    case semicolon = 0x3B
    
    case leftAngleBracket = 0x3C
    case equal = 0x3D
    case rightAngleBracket = 0x3E
    case question = 0x3F
    
    /// `@`
    case at = 0x40
    case A = 0x41
    case B = 0x42
    case C = 0x43
    
    case D = 0x44
    case E = 0x45
    case F = 0x46
    case G = 0x47
    
    case H = 0x48
    case I = 0x49
    case J = 0x4A
    case K = 0x4B
    
    case L = 0x4C
    case M = 0x4D
    case N = 0x4E
    case O = 0x4F
    
    case P = 0x50
    case Q = 0x51
    case R = 0x52
    case S = 0x53
    
    case T = 0x54
    case U = 0x55
    case V = 0x56
    case W = 0x57
    
    case X = 0x58
    case Y = 0x59
    case Z = 0x5A
    case leftSquareBracket = 0x5B
    
    /// `\`
    case backSlash = 0x5C
    case rightSquareBracket = 0x5D
    case caret = 0x5E
    case underscore = 0x5F
    
    /// `
    case backtick = 0x60
    case a = 0x61
    case b = 0x62
    case c = 0x63
    
    case d = 0x64
    case e = 0x65
    case f = 0x66
    case g = 0x67
    
    case h = 0x68
    case i = 0x69
    case j = 0x6A
    case k = 0x6B
    
    case l = 0x6C
    case m = 0x6D
    case n = 0x6E
    case o = 0x6F
    
    case p = 0x70
    case q = 0x71
    case r = 0x72
    case s = 0x73
    
    case t = 0x74
    case u = 0x75
    case v = 0x76
    case w = 0x77
    
    case x = 0x78
    case y = 0x79
    case z = 0x7A
    case leftBrace = 0x7B
    
    case pipe = 0x7C
    case rightBrace = 0x7D
    case rightArrow = 0x7E
    case leftArrow = 0x7F
    
    /// Returns the user-facing display string of the character.
    public var string: String {
        Self.stringTable[Int(rawValue)]
    }
    
    /// Initialize from the user-facing display string of the character.
    public init?<S: StringProtocol>(_ string: S) {
        guard let idx = Self.stringTable.firstIndex(of: String(string))
        else { return nil }
        self.init(rawValue: UInt8(idx))
    }
    
    // swiftformat:options --wrapcollections preserve
    // swiftformat:options --maxwidth none
    static let stringTable = [
        "",   "",   "",   "",     // 0x00 ...
        "",   "",   "",   "",     //
        "",   "",   "",   "",     //
        "",   "",   "",   "",     //      ... 0x0F
        "11",   "12", "13", "14", // 0x10 ...
        "full", "r4", "r3", "r2", //
        "r1",    "♪", "°C", "°F", //
        "▼",     "▶︎",  "◀︎",  "▲", //      ... 0x1F
        " ",  "!",  "\"", "#",    // 0x20 ...
        "$",  "%",  "&",  "'",    //
        "(",  ")",  "*",  "+",    //
        ",",  "-",  ".",  "/",    //      ... 0x2F
        "0",  "1",  "2",  "3",    // 0x30 ...
        "4",  "5",  "6",  "7",    //
        "8",  "9",  ":",  ";",    //
        "<",  "=",  ">",  "?",    //      ... 0x3F
        "@",  "A",  "B",  "C",    // 0x40 ...
        "D",  "E",  "F",  "G",    //
        "H",  "I",  "J",  "K",    //
        "L",  "M",  "N",  "O",    //      ... 0x4F
        "P",  "Q",  "R",  "S",    // 0x50 ...
        "T",  "U",  "V",  "W",    //
        "X",  "Y",  "Z",  "[",    //
        "\\", "]",  "^",  "_",    //      ... 0x5F
        "`",  "a",  "b",  "c",    // 0x60 ...
        "d",  "e",  "f",  "g",    //
        "h",  "i",  "j",  "k",    //
        "l",  "m",  "n",  "o",    //      ... 0x6F
        "p",  "q",  "r",  "s",    // 0x70 ...
        "t",  "u",  "v",  "w",    //
        "x",  "y",  "z",  "{",    //
        "|",  "}",  "→",  "←"     //      ... 0x7F
    ]
    
    /// Suitable default case for use as a default/neutral character.
    public static func `default`() -> Self {
        .space
    }
    
    /// Suitable default case for use as a substitute for an unknown character.
    public static func unknown() -> Self {
        .question
    }
}

// MARK: - CustomStringConvertible

extension HUILargeDisplayCharacter: CustomStringConvertible {
    public var description: String {
        string
    }
}

// MARK: - Sequence Category Methods

extension Sequence where Element == HUILargeDisplayCharacter {
    /// Returns the HUI character sequence as a single concatenated string of characters.
    public var stringValue: String {
        map { $0.string }.joined()
    }
}

extension [HUILargeDisplayCharacter] {
    /// Default text slice.
    public static let defaultSlice: Self = .init(repeating: .default(), count: 10)
}

extension [[HUILargeDisplayCharacter]] {
    /// Default text slices.
    public static let defaultSlices: Self = .init(repeating: .defaultSlice, count: 8)
}
