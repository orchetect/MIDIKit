//
//  HUISmallDisplayCharacter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI small text display character set.
public enum HUISmallDisplayCharacter: UInt8, CaseIterable {
    case ì = 0x00
    case upArrow = 0x01
    case rightArrow = 0x02
    case downArrow = 0x03
    case leftArrow = 0x04
    case invertedQuestion = 0x05
    case à = 0x06
    case Ø = 0x07
    
    case ø = 0x08
    case ò = 0x09
    case ù = 0x0A
    case Ň = 0x0B
    case Ç = 0x0C
    case ê = 0x0D
    case É = 0x0E
    case é = 0x0F
    
    case è = 0x10
    case Æ = 0x11
    case æ = 0x12
    case Å = 0x13
    
    case å = 0x14
    case Ä = 0x15
    case ä = 0x16
    case Ö = 0x17
    
    case ö = 0x18
    case Ü = 0x19
    case ü = 0x1A
    /// Degrees Celsius.
    case ℃ = 0x1B
    
    /// Degrees Fahrenheit.
    case ℉ = 0x1C
    case ß = 0x1D
    /// `£` - Pound currency symbol.
    case pound = 0x1E
    case yen = 0x1F
    
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
    case tilde = 0x7E
    case shadedSquare = 0x7F
    
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
    
    static let stringTable = [
        "ì",  "↑",  "→",  "↓",  "←",  "¿",  "à",  "Ø", // 0x00 ...
        "ø",  "ò",  "ù",  "Ň",  "Ç",  "ê",  "É",  "é", //      ... 0x0F
        "è",  "Æ",  "æ",  "Å",  "å",  "Ä",  "ä",  "Ö", // 0x10 ...
        "ö",  "Ü",  "ü",  "℃",  "℉",  "ß",  "£",  "¥", //      ... 0x1F
        " ",  "!", "\"",  "#",  "$",  "%",  "&",  "'", // 0x20 ...
        "(",  ")",  "*",  "+",  ",",  "-",  ".",  "/", //      ... 0x2F
        "0",  "1",  "2",  "3",  "4",  "5",  "6",  "7", // 0x30 ...
        "8",  "9",  ":",  ";",  "<",  "=",  ">",  "?", //      ... 0x3F
        "@",  "A",  "B",  "C",  "D",  "E",  "F",  "G", // 0x40 ...
        "H",  "I",  "J",  "K",  "L",  "M",  "N",  "O", //      ... 0x4F
        "P",  "Q",  "R",  "S",  "T",  "U",  "V",  "W", // 0x50 ...
        "X",  "Y",  "Z",  "[", "\\",  "]",  "^",  "_", //      ... 0x5F
        "`",  "a",  "b",  "c",  "d",  "e",  "f",  "g", // 0x60 ...
        "h",  "i",  "j",  "k",  "l",  "m",  "n",  "o", //      ... 0x6F
        "p",  "q",  "r",  "s",  "t",  "u",  "v",  "w", // 0x70 ...
        "x",  "y",  "z",  "{",  "|",  "}",  "~",  "░"  //      ... 0x7F
    ]
    
    /// Suitable default case for use as a default/neutral character.
    public static func `default`() -> Self {
        .space
    }
    
    /// Suitable default case for use as a substitute for an unknown character.
    public static func unknown() -> Self {
        .question // just a random '?' character
    }
}

// MARK: - CustomStringConvertible

extension HUISmallDisplayCharacter: CustomStringConvertible {
    public var description: String {
        string
    }
}

// MARK: - Sequence Category Methods

extension Sequence where Element == HUISmallDisplayCharacter {
    /// Returns the HUI character sequence as a single concatenated string of characters.
    public var stringValue: String {
        map { $0.string }.joined()
    }
}
