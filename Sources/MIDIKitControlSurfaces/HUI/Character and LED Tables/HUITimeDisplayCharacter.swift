//
//  HUITimeDisplayCharacter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI time display character set.
public enum HUITimeDisplayCharacter: UInt8, CaseIterable {
    case _0          = 0x00
    case _1          = 0x01
    case _2          = 0x02
    case _3          = 0x03
    
    case _4          = 0x04
    case _5          = 0x05
    case _6          = 0x06
    case _7          = 0x07
    
    case _8          = 0x08
    case _9          = 0x09
    case A           = 0x0A
    case B           = 0x0B
    
    case C           = 0x0C
    case D           = 0x0D
    case E           = 0x0E
    case F           = 0x0F
    
    case _0dot       = 0x10
    case _1dot       = 0x11
    case _2dot       = 0x12
    case _3dot       = 0x13
    
    case _4dot       = 0x14
    case _5dot       = 0x15
    case _6dot       = 0x16
    case _7dot       = 0x17
    
    case _8dot       = 0x18
    case _9dot       = 0x19
    case Adot        = 0x1A
    case Bdot        = 0x1B
    
    case Cdot        = 0x1C
    case Ddot        = 0x1D
    case Edot        = 0x1E
    case Fdot        = 0x1F
    
    /// Empty space.
    case space       = 0x20
    case unknown0x21 = 0x21
    case unknown0x22 = 0x22
    case unknown0x23 = 0x23
    
    case unknown0x24 = 0x24
    case unknown0x25 = 0x25
    case unknown0x26 = 0x26
    case unknown0x27 = 0x27
    
    case unknown0x28 = 0x28
    case unknown0x29 = 0x29
    case unknown0x2A = 0x2A
    case unknown0x2B = 0x2B
    
    case unknown0x2C = 0x2C
    case unknown0x2D = 0x2D
    case unknown0x2E = 0x2E
    case unknown0x2F = 0x2F
    
    /// Empty space with a trailing dot.
    case spaceDot    = 0x30
    
    /// Returns `true` if the character has a trailing dot (decimal).
    public var hasDot: Bool {
        switch self {
        case ._0, ._1, ._2, ._3, ._4, ._5, ._6, ._7, ._8, ._9, .A, .B, .C, .D, .E, .F:
            return false
        
        case ._0dot, ._1dot, ._2dot, ._3dot, ._4dot, ._5dot, ._6dot, ._7dot, ._8dot, ._9dot, .Adot, .Bdot, .Cdot, .Ddot, .Edot, .Fdot:
            return true
            
        case .space, .unknown0x21, .unknown0x22, .unknown0x23, .unknown0x24, .unknown0x25, .unknown0x26, .unknown0x27, .unknown0x28, .unknown0x29, .unknown0x2A, .unknown0x2B, .unknown0x2C, .unknown0x2D, .unknown0x2E, .unknown0x2F:
            return false
            
        case .spaceDot:
            return true
        }
    }
    
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
    
    // TODO: There are potentially more values to this table - need to discover what they are. (Pro Tools uses index values upwards of 0x30, maybe beyond)
    static let stringTable = [
        "0",  "1",  "2",  "3",    // 0x00 ...
        "4",  "5",  "6",  "7",    //
        "8",  "9",  "A",  "B",    //
        "C",  "D",  "E",  "F",    //      ... 0x0F
        "0.", "1.", "2.", "3.",   // 0x10 ...
        "4.", "5.", "6.", "7.",   //
        "8.", "9.", "A.", "B.",   //
        "C.", "D.", "E.", "F.",   //      ... 0x1F
        " ",                      // 0x20 - this is a guess; I think it's an empty space, or an empty string
        "?",  "?",  "?",  "?",    // 0x21 ...
        "?",  "?",  "?",  "?",    //
        "?",  "?",  "?",  "?",    //
        "?",  "?",  "?",          // 0x2F - placeholders, not sure about these; put in question marks for now
        " ."                      // 0x30 - this is a guess; I think it's an empty space with a period
    ]
    
    /// Suitable default case for use as a default/neutral character.
    public static func `default`() -> Self {
        .space
    }
    
    /// Suitable default case for use as a substitute for an unknown character.
    public static func unknown() -> Self {
        .unknown0x21 // just a random '?' character
    }
}

// MARK: - CustomStringConvertible

extension HUITimeDisplayCharacter: CustomStringConvertible {
    public var description: String {
        string
    }
}

// MARK: - Sequence Category Methods

extension Sequence where Element == HUITimeDisplayCharacter {
    /// Returns the HUI character sequence as a single concatenated string of characters.
    public var stringValue: String {
        map { $0.string }.joined()
    }
}
