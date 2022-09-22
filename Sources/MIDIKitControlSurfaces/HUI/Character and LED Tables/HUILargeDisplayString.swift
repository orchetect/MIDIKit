//
//  HUILargeDisplayString.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// HUI large text display 40-character string.
public struct HUILargeDisplayString: HUIStringProtocol, Equatable, Hashable {
    public typealias Element = HUILargeDisplayCharacter
    
    public static let staticCount = 40
    
    @HUIStringCharsValidation<Self>
    public var chars: [Element]
    
    public init() {
        chars = Self.defaultChars
    }
}

// MARK: - Additional Methods

extension HUILargeDisplayString {
    /// Internal:
    /// Returns the 40-character sequence as four 10-character slices.
    var slices: [[HUILargeDisplayCharacter]] {
        chars.split(every: 10).map { Array($0) }
    }
    
    /// Internal:
    /// Updates a portion of the 40-char string.
    ///
    /// - Parameters:
    ///   - slice: Slice index (`0 ... 3`)
    ///   - chars: 10 character array
    /// - Returns: `true` if characters were different and replaced with new characters.
    @discardableResult
    mutating func update(slice: UInt4, newChars: [Element]) -> Bool {
        guard newChars.count == 10 else { return false }
        guard (0 ... 3).contains(slice) else { return false }
        
        let lBound = max((slice * 10) - 1, 0)
        let uBound = (slice * 10) + 10 - 1
        let range = lBound.intValue ... uBound.intValue
        
        if !(chars[range].elementsEqual(newChars)) {
            chars.replaceSubrange(range, with: newChars)
            return true
        } else {
            return false
        }
    }
}
