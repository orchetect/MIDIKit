//
//  HUITimeDisplayCharacter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// HUI time display character set.
public enum HUITimeDisplayCharacter: UInt7, CaseIterable {
    case num0        = 0x00
    case num1        = 0x01
    case num2        = 0x02
    case num3        = 0x03
    
    case num4        = 0x04
    case num5        = 0x05
    case num6        = 0x06
    case num7        = 0x07
    
    case num8        = 0x08
    case num9        = 0x09
    case A           = 0x0A
    case B           = 0x0B
    
    case C           = 0x0C
    case D           = 0x0D
    case E           = 0x0E
    case F           = 0x0F
    
    case num0dot     = 0x10
    case num1dot     = 0x11
    case num2dot     = 0x12
    case num3dot     = 0x13
    
    case num4dot     = 0x14
    case num5dot     = 0x15
    case num6dot     = 0x16
    case num7dot     = 0x17
    
    case num8dot     = 0x18
    case num9dot     = 0x19
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
}

extension HUITimeDisplayCharacter: Sendable { }

extension HUITimeDisplayCharacter: _HUICharacter {
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
}

extension HUITimeDisplayCharacter: HUICharacter {
    public static func `default`() -> Self {
        .space
    }
    
    public static func unknown() -> Self {
        .unknown0x21 // just a random '?' character
    }
}

// MARK: - Additional methods

extension HUITimeDisplayCharacter {
    /// Returns `true` if the character has a trailing dot (decimal).
    public var hasDot: Bool {
        switch self {
        case .num0, .num1, .num2, .num3, .num4,
             .num5, .num6, .num7, .num8, .num9,
             .A, .B, .C, .D, .E, .F:
            return false
            
        case .num0dot, .num1dot, .num2dot, .num3dot, .num4dot,
             .num5dot, .num6dot, .num7dot, .num8dot, .num9dot,
             .Adot, .Bdot, .Cdot, .Ddot, .Edot, .Fdot:
            return true
            
        case .space,
             .unknown0x21, .unknown0x22, .unknown0x23,
             .unknown0x24, .unknown0x25, .unknown0x26, .unknown0x27,
             .unknown0x28, .unknown0x29, .unknown0x2A, .unknown0x2B,
             .unknown0x2C, .unknown0x2D, .unknown0x2E, .unknown0x2F:
            return false
            
        case .spaceDot:
            return true
        }
    }
}
