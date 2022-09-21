//
//  HUITimeDisplayString.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI time display string, comprised of 8 digits.
///
/// The time display consists of eight 7-segment displays (called digits). Every digit except the last (rightmost) has the ability to show a trailing decimal point (dot).
public struct HUITimeDisplayString: HUIStringProtocol, Equatable, Hashable {
    public typealias Element = HUITimeDisplayCharacter
    
    public static let staticCount = 8
    
    @HUIStringCharsValidation<Self>
    public var chars: [Element]
    
    public init() {
        chars = Self.defaultChars
    }
    
    // we override default implementation of this init
    // because it requires special handling
    public init<S: StringProtocol>(lossy source: S) {
        var chars: [Element] = []
        
        // ensure there's at least one character in the source string
        guard var idx = source.indices.first else {
            self.chars = .defaultChars
            return
        }
        
        repeat {
            var charStr = String(source[idx])
            idx = source.index(after: idx)
            
            if idx != source.endIndex,
               source[idx] == "."
            {
                charStr += "."
                if idx != source.indices.last {
                    idx = source.index(after: idx)
                }
            }
            
            let char = Element(charStr) ?? .default()
            chars.append(char)
        } while idx < source.endIndex
            && chars.count < Self.staticCount
        
        self.chars = chars
    }
}

extension Array where Element == HUITimeDisplayCharacter {
    /// Empty display digits.
    /// Equivalent to: "        "
    public static let blankChars: [HUITimeDisplayCharacter] = [
        .space,
        .space,
        .space,
        .space,
        .space,
        .space,
        .space,
        .space
    ]
    
    /// Default display digits.
    /// Equivalent to: "00.00.00.00"
    public static let defaultChars: [HUITimeDisplayCharacter] = [
        .num0,
        .num0dot,
        .num0,
        .num0dot,
        .num0,
        .num0dot,
        .num0,
        .num0
    ]
}
